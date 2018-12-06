package alternativa.engine3d.materials 
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DebugMaterialsRenderer;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Transform3D;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapCubeTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.core.Renderer;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.compiler.Linker;
	import alternativa.engine3d.materials.compiler.Procedure;
	import alternativa.engine3d.materials.compiler.VariableType;
	import alternativa.engine3d.resources.TextureResource;
	import flash.display3D.textures.Texture;
	import flash.geom.Vector3D;
	
	import avmplus.getQualifiedClassName;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import alternativa.engine3d.alternativa3d;
	use namespace alternativa3d;
	
	/**
	 * ...
	 * @author David E Jones
	 */
	public class RefractMaterial3 extends Material 
	{
		private static var caches:Dictionary = new Dictionary(true);
		private var cachedContext3D:Context3D;
		private var programsCache:Dictionary;
		
		static alternativa3d const getDiffuseVProcedure:Procedure = new Procedure([
			"#a0=aPosition",
			"#a1=aNormal",
			"#c4=cLocalCamera",
			"#c5=cGlobalTransform",
			"#v0=vNormal",
			"#v1=vViewVec",
			//vertex normal
			"mov t0, a1",
			//normal from local to global
			"m33 t0.xyz, t0.xyz, c5",
			//viewVec
			"sub t1, c4, a0",
			//viewVec from local to global
			"m33 t1.xyz, t1.xyz, c5",	
			//normalize
			"nrm t0.xyz, t0",
			"nrm t1.xyz, t1",
			//pass to frag
			"mov v0, t0",
			"mov v1, t1",			
		], "getDiffuseVProcedure");
		
		// Fragment procedure
		static alternativa3d const getDiffuseFProcedure:Procedure = new Procedure([
			"#v0=vNormal",
			"#v1=vViewVec",
			"#s0=sCubeMap",
			"#c0=cChromaticDispersion",
			"#c1=cChromaticDispersionSquared",
			"#c2=cFresnel",
			
			//reflect
			"dp3 t0, v1, v0",
			"add t0, t0, t0",
			"mul t0, v0, t0",
			"sub t0, v1, t0",
			"neg t0, t0",
			"nrm t0.xyz, t0",
			
			"tex t0, t0, s0 <cube,clamp,linear,nomip>",
			
			//refract R
			"dp3 t2, v1, v0",
			"mul t2, t2, v0",
			"sub t2, t2, v1",
			"mul t2, t2, c0.x",
			
			"dp3 t1, v1, v0",
			"mul t1, t1, t1",
			"sub t1, c0.w, t1",
			"mul t1, c1.x, t1", 
			"sub t1, c0.w, t1",
			"sqt t1, t1",
			"mul t1, t1, v0",
			"sub t1, t2, t1",
			//"nrm t1.xyz, t1",
			
			"tex t3, t1, s0 <cube,clamp,linear,nomip>",
			
			//refract G
			"dp3 t2, v1, v0",
			"mul t2, t2, v0",
			"sub t2, t2, v1",
			"mul t2, t2, c0.y",
			
			"dp3 t1, v1, v0",
			"mul t1, t1, t1",
			"sub t1, c0.w, t1",
			"mul t1, c1.y, t1", 
			"sub t1, c0.w, t1",
			"sqt t1, t1",
			"mul t1, t1, v0",
			"sub t1, t2, t1",
			//"nrm t1.xyz, t1",
			
			"tex t4, t1, s0 <cube,clamp,linear,nomip>",
			
			//refract B
			"dp3 t2, v1, v0",
			"mul t2, t2, v0",
			"sub t2, t2, v1",
			"mul t2, t2, c0.z",
			
			"dp3 t1, v1, v0",
			"mul t1, t1, t1",
			"sub t1, c0.w, t1",
			"mul t1, c1.z, t1", 
			"sub t1, c0.w, t1",
			"sqt t1, t1",
			"mul t1, t1, v0",
			"sub t1, t2, t1",
			//"nrm t1.xyz, t1",
			
			"tex t5, t1, s0 <cube,clamp,linear,nomip>",
			
			//combine rgb
			"mov t1.x, t3.x",
			"mov t1.y, t4.y",
			"mov t1.z, t5.z",
			"mov t1.w, c0.w",
			
			//rfac = bias + scale * pow(1.0 + dot(incident, vNormal), power);
			"dp3 t6, v1, v0", //dot(incident, vNormal)
			"add t6, t6, c2.w", //(1.0 + dot(incident, vNormal)
			"pow t6, t6, c2.z", //pow()
			"mul t6, t6, c2.y", //scale * pow()
			"add t6, t6, c2.x", // + bias		
			
			//gl_FragColor = ret * rfac + ref * (1.0 - rfac);
			"sub t4, c0.w, t6", //(1.0 - rfac)
			"mul t4, t0, t4", //ref * (1.0 - rfac)
			"mul t5, t1, t6", //ret * rfac
			"add t4, t4, t5", // add both together
			
			//lerp
			//"sub t2, t0, t1",
			//"mul t2, t2, v2",
			//"add t2, t2, t1",
			
			//output color
			"mov o0, t4"
		], "getDiffuseFProcedure");
		
		public var alphaThreshold:Number = 0;
		public var alpha : Number = 1;
		
		public var chromaticDispersion:Vector3D = new Vector3D(0.9, 0.97, 1.04, 1);
		public var fresnelBias:Number = 0.9;
		public var fresnelScale:Number = 0.7;
		public var fresnelPower:Number = 1.1;
		
		static alternativa3d const _passUVProcedure:Procedure = new Procedure(["#v0=vUV", "#a0=aUV", "mov v0, a0"], "passUVProcedure");
		static alternativa3d const _passNormProcedure:Procedure = new Procedure(["#v0=vNormal", "#a1=aNormal", "mov v0, a1"], "passNormProcedure");
		
		private var localToGlobalTransform:Transform3D = new Transform3D();
		
		private var cubetexture:TextureResource;
		
		public function RefractMaterial3(cubetexture:TextureResource) 
		{
			this.cubetexture = cubetexture;
			super();
		}
		
		override alternativa3d function fillResources(resources:Dictionary, resourceType:Class):void {
			super.fillResources(resources, resourceType);
			if (cubetexture != null &#038;&#038; A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(cubetexture)) as Class, resourceType)) {
				resources[cubetexture] = true;
			}
		}
		
		private function getProgram(object:Object3D, programs:Vector.<DiffuseMaterialProgram>, camera:Camera3D, alphaTest:int):DiffuseMaterialProgram {
			var key:int = 0;
			var program:DiffuseMaterialProgram = programs[key];
			if (program == null) {
				
				var vertexLinker:Linker = new Linker(Context3DProgramType.VERTEX);
				var positionVar:String = "aPosition";
				var normalVar:String = "aNormal";
				vertexLinker.declareVariable(positionVar, VariableType.ATTRIBUTE);
				vertexLinker.declareVariable(normalVar, VariableType.ATTRIBUTE);
				
				if (object.transformProcedure != null) {
					positionVar = appendPositionTransformProcedure(object.transformProcedure, vertexLinker);
				}
				vertexLinker.addProcedure(_projectProcedure);
				vertexLinker.setInputParams(_projectProcedure, positionVar);
				vertexLinker.addProcedure(getDiffuseVProcedure);
				//vertexLinker.addProcedure(_passNormProcedure);
		
				// Pixel shader
				var fragmentLinker:Linker = new Linker(Context3DProgramType.FRAGMENT);
				var outProcedure:Procedure = getDiffuseFProcedure;
				fragmentLinker.addProcedure(outProcedure);
				
				/*
				if (alphaTest > 0) {
					fragmentLinker.declareVariable("tColor");
					fragmentLinker.setOutputParams(outProcedure, "tColor");
					if (alphaTest == 1) {
						fragmentLinker.addProcedure(thresholdOpaqueAlphaProcedure, "tColor");
					} else {
						fragmentLinker.addProcedure(thresholdTransparentAlphaProcedure, "tColor");
					}
				}*/
				
				fragmentLinker.varyings = vertexLinker.varyings;

				program = new DiffuseMaterialProgram(vertexLinker, fragmentLinker);

				program.upload(camera.context3D);
				programs[key] = program;
			}
			return program;
		}
		
		private function getDrawUnit(program:DiffuseMaterialProgram, camera:Camera3D, surface:Surface, geometry:Geometry):DrawUnit {
			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var normalsBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.NORMAL);
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);

			var object:Object3D = surface.object;

			// Draw call
			var drawUnit:DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);

			// Streams
			// a0, a1
			drawUnit.setVertexBufferAt(program.aPosition, positionBuffer, geometry._attributesOffsets[VertexAttributes.POSITION], VertexAttributes.FORMATS[VertexAttributes.POSITION]);
			drawUnit.setVertexBufferAt(program.aNormal, normalsBuffer, geometry._attributesOffsets[VertexAttributes.NORMAL], VertexAttributes.FORMATS[VertexAttributes.NORMAL]);
			//drawUnit.setVertexBufferAt(program.aNormal, uvBuffer, geometry._attributesOffsets[VertexAttributes.TEXCOORDS[0]], VertexAttributes.FORMATS[VertexAttributes.TEXCOORDS[0]]);
			
			//Constants
			object.setTransformConstants(drawUnit, surface, program.vertexShader, camera);
			drawUnit.setProjectionConstants(camera, program.cProjMatrix, object.localToCameraTransform); //cProjMatrix c0;
			
			//local-space camera position
			var cameraToLocalTransform : Transform3D = object.cameraToLocalTransform;
			drawUnit.setVertexConstantsFromNumbers(program.cLocalCamera, cameraToLocalTransform.d, cameraToLocalTransform.h, cameraToLocalTransform.l);
			
			//calculating local to global transform
			localToGlobalTransform.combine(camera.localToGlobalTransform, object.localToCameraTransform);
			drawUnit.setVertexConstantsFromTransform(program.cGlobalTransform, localToGlobalTransform);

			drawUnit.setTextureAt(program.sCubeMap, cubetexture._texture);
			
			drawUnit.setFragmentConstantsFromNumbers(program.cChromaticDispersion, chromaticDispersion.x, chromaticDispersion.y, chromaticDispersion.z, 1);
			drawUnit.setFragmentConstantsFromNumbers(program.cChromaticDispersionSquared, chromaticDispersion.x * chromaticDispersion.x, chromaticDispersion.y * chromaticDispersion.y, chromaticDispersion.z * chromaticDispersion.z, 1);
			drawUnit.setFragmentConstantsFromNumbers(program.cFresnel, fresnelBias, fresnelScale, fresnelPower, 1);
			
			drawUnit.blendSource = Context3DBlendFactor.SOURCE_ALPHA;
			drawUnit.blendDestination = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;


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
			if (positionBuffer == null || normalsBuffer == null) return;

			// Refresh program cache for this context
			if (camera.context3D != cachedContext3D) {
				cachedContext3D = camera.context3D;
				programsCache = caches[cachedContext3D];
				if (programsCache == null) {
					programsCache = new Dictionary();
					caches[cachedContext3D] = programsCache;
				}
			}
			var optionsPrograms:Vector.<DiffuseMaterialProgram> = programsCache[object.transformProcedure];
			if(optionsPrograms == null) {
				optionsPrograms = new Vector.<DiffuseMaterialProgram>(5, true);
				programsCache[object.transformProcedure] = optionsPrograms;
			}
			
			var program:DiffuseMaterialProgram;
			var drawUnit:DrawUnit;
						
			if (alphaThreshold > 0) {
				program = getProgram(object, optionsPrograms, camera, 1);
				drawUnit = getDrawUnit(program, camera, surface, geometry);
			} else {
				program = getProgram(object, optionsPrograms, camera, 0);
				drawUnit = getDrawUnit(program, camera, surface, geometry);
			}
			// Use z-buffer within DrawCall, draws without blending
			camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority : Renderer.OPAQUE);
			//camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority : Renderer.TRANSPARENT_SORT);
			
		}
		
	}

}


import alternativa.engine3d.materials.ShaderProgram;
import alternativa.engine3d.materials.compiler.Linker;

import flash.display3D.Context3D;

class DiffuseMaterialProgram extends ShaderProgram {

	public var aPosition:int = -1;
	public var aNormal:int = -1;
	public var cProjMatrix:int = -1;	
	public var cLocalCamera:int = -1;	
	public var cGlobalTransform:int = -1;
	public var cTempV:int = -1;
	
	
	public var sCubeMap:int = -1;
	public var cChromaticDispersion:int = -1;
	public var cChromaticDispersionSquared:int = -1;
	public var cFresnel:int = -1;

	public function DiffuseMaterialProgram(vertex:Linker, fragment:Linker) {
		super(vertex, fragment);
	}

	override public function upload(context3D:Context3D):void {
		super.upload(context3D);

		aPosition = vertexShader.findVariable("aPosition");
		aNormal = vertexShader.findVariable("aNormal");
		cProjMatrix = vertexShader.findVariable("cProjMatrix");
		cLocalCamera = vertexShader.findVariable("cLocalCamera");
		cGlobalTransform = vertexShader.findVariable("cGlobalTransform");
		cTempV = vertexShader.findVariable("cTempV");
		
		
		sCubeMap = fragmentShader.findVariable("sCubeMap");
		cChromaticDispersion = fragmentShader.findVariable("cChromaticDispersion");
		cChromaticDispersionSquared = fragmentShader.findVariable("cChromaticDispersionSquared");
		cFresnel = fragmentShader.findVariable("cFresnel");
		
	}

}