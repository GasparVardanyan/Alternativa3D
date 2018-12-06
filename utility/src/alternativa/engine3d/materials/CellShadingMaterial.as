package alternativa.engine3d.materials
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.DebugDrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Renderer;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.compiler.Linker;
	import alternativa.engine3d.materials.compiler.Procedure;
	import alternativa.engine3d.materials.compiler.VariableType;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;

	import avmplus.getQualifiedClassName;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import alternativa.engine3d.lights.DirectionalLight;

	use namespace alternativa3d;
	
	public class CellShadingMaterial extends Material
	{		
		private static var caches:Dictionary = new Dictionary(true);
		private var cachedContext3D:Context3D;
		private var programsCache:Dictionary;
				
		// Vertex Procedure
		static alternativa3d const getCellVProcedure:Procedure = new Procedure([
			"#a0=aPosition",
			"#a1=aNormal",
			"m44 o0 a0 c0",
			"mov v1, a1"
		], "getCellVProcedure");
		
		// Fragment procedure
		static alternativa3d const getCellSProcedure:Procedure = new Procedure([
			"#c0=cLightdirection",
			"#s0=sDiffuse",
			"mov t0 c0",
			"nrm t2.xyz t0.xyz",
			"dp3 t1.x, v1.xyz, t2.xyz",   
			"tex t0, t1.xx, s0 <2d,nearest>",
			"mov o0, t0"
		], "getCellSProcedure");
		
		public var diffuseMap:TextureResource;
		
		public function CellShadingMaterial(diffuseMap:TextureResource)
		{
			this.diffuseMap = diffuseMap;
		}
		
		override alternativa3d function fillResources(resources:Dictionary, resourceType:Class):void {
			super.fillResources(resources, resourceType);
			if (diffuseMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(diffuseMap)) as Class, resourceType)) {
				resources[diffuseMap] = true;
			}
		}
		
		private function getProgram(object:Object3D, programs:Vector.<ToonMaterialProgram>, camera:Camera3D):ToonMaterialProgram {
			var key:int = 0;
			var program:ToonMaterialProgram = programs[key];
			if (program == null) {
				// Make program
				// Vertex shader
				var vertexLinker:Linker = new Linker(Context3DProgramType.VERTEX);

				var positionVar:String = "aPosition";
				var normalVar:String = "aNormal";
				vertexLinker.declareVariable(positionVar, VariableType.ATTRIBUTE);
				vertexLinker.declareVariable(normalVar, VariableType.ATTRIBUTE);
				getCellVProcedure.assignVariableName(VariableType.CONSTANT, 0, "cProjMatrix", 4);
				
				if (object.transformProcedure != null) {
					positionVar = appendPositionTransformProcedure(object.transformProcedure, vertexLinker);
				}
				vertexLinker.addProcedure(getCellVProcedure);
				vertexLinker.setInputParams(getCellVProcedure, positionVar);
				vertexLinker.setInputParams(getCellVProcedure, normalVar);


				// Pixel shader
				var fragmentLinker:Linker = new Linker(Context3DProgramType.FRAGMENT);
				var outProcedure:Procedure = getCellSProcedure;
				fragmentLinker.declareVariable("cLightdirection", VariableType.CONSTANT);
				fragmentLinker.addProcedure(outProcedure);
				fragmentLinker.setInputParams(outProcedure, "cLightdirection");
				fragmentLinker.varyings = vertexLinker.varyings;

				program = new ToonMaterialProgram(vertexLinker, fragmentLinker);

				program.upload(camera.context3D);
				programs[key] = program;
			}
			return program;
		}
		
		private function getDrawUnit(program:ToonMaterialProgram, camera:Camera3D, surface:Surface, geometry:Geometry, light:Light3D):DrawUnit {
			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var normalsBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.NORMAL);

			var object:Object3D = surface.object;

			// Draw call
			var drawUnit:DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);

			// Streams
			// a0, a1
			drawUnit.setVertexBufferAt(program.aPosition, positionBuffer, geometry._attributesOffsets[VertexAttributes.POSITION], VertexAttributes.FORMATS[VertexAttributes.POSITION]);
			drawUnit.setVertexBufferAt(program.aNormal, normalsBuffer, geometry._attributesOffsets[VertexAttributes.NORMAL], VertexAttributes.FORMATS[VertexAttributes.NORMAL]);
			
			//Constants
			object.setTransformConstants(drawUnit, surface, program.vertexShader, camera);
			drawUnit.setProjectionConstants(camera, program.cProjMatrix, object.localToCameraTransform); //cProjMatrix c0;
			
			//drawUnit.setFragmentConstantsFromVector(program.cLightdirection, new Vector.<Number>([light.x,light.y,light.z,0.0]), -1); //c0		
			drawUnit.setFragmentConstantsFromNumbers(program.cLightdirection, light.x,light.y,light.z, 1);

			// Textures
			drawUnit.setTextureAt(program.sDiffuse, diffuseMap._texture);
			return drawUnit;
		}
		
		override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, useShadow:Boolean, objectRenderPriority:int = -1):void {
			var object:Object3D = surface.object;
			var lightGroup:Vector.<Light3D> = new Vector.<Light3D>();
			var light:Light3D;

			// Buffers
			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var normalsBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.NORMAL);

			// Check validity
			if (positionBuffer == null || normalsBuffer == null || diffuseMap == null || diffuseMap._texture == null) return;

			// Refresh program cache for this context
			if (camera.context3D != cachedContext3D) {
				cachedContext3D = camera.context3D;
				programsCache = caches[cachedContext3D];
				if (programsCache == null) {
					programsCache = new Dictionary();
					caches[cachedContext3D] = programsCache;
				}
			}
			var optionsPrograms:Vector.<ToonMaterialProgram> = programsCache[object.transformProcedure];
			if(optionsPrograms == null) {
				optionsPrograms = new Vector.<ToonMaterialProgram>(5, true);
				programsCache[object.transformProcedure] = optionsPrograms;
			}
			
			
			for (var i:int = 0; i < lights.length; i++) {
				if(lights[i] is DirectionalLight) {
					light = lights[i];
				}
			}

			var program:ToonMaterialProgram;
			var drawUnit:DrawUnit;
			
			program = getProgram(object, optionsPrograms, camera);
			drawUnit = getDrawUnit(program, camera, surface, geometry, light);
			
			camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority : Renderer.OPAQUE);
		}
	}
}


import alternativa.engine3d.materials.ShaderProgram;
import alternativa.engine3d.materials.compiler.Linker;

import flash.display3D.Context3D;

class ToonMaterialProgram extends ShaderProgram {

	public var aPosition:int = -1;
	public var aNormal:int = -1;
	public var cProjMatrix:int = -1;
	
	public var cLightdirection:int = -1;
	public var sDiffuse:int = -1;

	public function ToonMaterialProgram(vertex:Linker, fragment:Linker) {
		super(vertex, fragment);
	}

	override public function upload(context3D:Context3D):void {
		super.upload(context3D);

		aPosition = vertexShader.findVariable("aPosition");
		aNormal = vertexShader.findVariable("aNormal");
		cProjMatrix = vertexShader.findVariable("cProjMatrix");
		
		cLightdirection = fragmentShader.findVariable("cLightdirection");
		sDiffuse = fragmentShader.findVariable("sDiffuse");
	}

}