package alternativa.engine3d.materials {

	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Renderer;
	import alternativa.engine3d.core.Transform3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.A3DUtils;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.ShaderProgram;
	import alternativa.engine3d.materials.compiler.Linker;
	import alternativa.engine3d.materials.compiler.Procedure;
	import alternativa.engine3d.materials.compiler.VariableType;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;

	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	use namespace alternativa3d;

	public class VisibleLightMaterial extends Material {

		public static var fadeRadius:Number = 100;
		public static var spotAngle:Number = 0;
		public static var fallofAngle:Number = Math.PI*85/90;

		private static var _programs:Dictionary = new Dictionary();

		// inputs : position, normal
		private static const passColorProcedure:Procedure = new Procedure([
			"#a0=aUV",
			"#v0=vUV",
			"#v1=vCameraPos",
			"#v2=vNormal",
			"#c0=cCameraPos",
			"mov v0, a0",
			// Угол между направлением камеры и нормалью
			"sub v1, c0, i0",
			"mov v2, i1"
		], "passColor");

		private static const outputProcedure:Procedure = new Procedure([
			"#v0=vUV",
			"#v1=vCameraPos",
			"#v2=vNormal",
			"#c0=cZone",
			"#s0=sTexture",
			// Считаем расстояние до камеры
			"dp3 t1.w, v1, v1",
			"rsq t1.w, t1.w",
			// normalize
			"mul t0.xyz, v1.xyz, t1.w",
			"nrm t1.xyz, v2",
			"dp3 t1.x, t0.xyz, t1.xyz",

			"add t1.x, t1.x, c0.z",
			"mul t1.x, t1.x, c0.y",
			"sat t1.x, t1.x",

			// square
			"div t1.w, c0.x, t1.w",
			"sat t1.w, t1.w",
			"mul t1.x, t1.x, t1.w",

			"tex t0, v0, s0 <2d, clamp, linear, miplinear>",
			"mul t0, t0.xyzw, t1.x",

			"mov o0, t0"
		], "output");

		public var texture:TextureResource;

		public function VisibleLightMaterial(texture:TextureResource) {
			this.texture = texture;
		}

		/**
		 * @private
		 */
		override alternativa3d function fillResources(resources:Dictionary, resourceType:Class):void {
			super.fillResources(resources, resourceType);

			if (texture != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(texture)) as Class, resourceType)) {
				resources[texture] = true;
			}
		}


		private function setupProgram(targetObject:Object3D):ShaderProgram {
			var vertexLinker:Linker = new Linker(Context3DProgramType.VERTEX);
			var fragmentLinker:Linker = new Linker(Context3DProgramType.FRAGMENT);

			var positionVar:String = "aPosition";
			vertexLinker.declareVariable(positionVar, VariableType.ATTRIBUTE);
			if (targetObject.transformProcedure != null) {
				positionVar = appendPositionTransformProcedure(targetObject.transformProcedure, vertexLinker);
			}
			vertexLinker.addProcedure(_projectProcedure);
			vertexLinker.setInputParams(_projectProcedure, positionVar);

			var normalVar:String = "aNormal";
			vertexLinker.declareVariable(normalVar, VariableType.ATTRIBUTE);

			if (targetObject.deltaTransformProcedure != null) {
				vertexLinker.declareVariable("tTransformedNormal");
				vertexLinker.addProcedure(targetObject.deltaTransformProcedure);
				vertexLinker.setInputParams(targetObject.deltaTransformProcedure, normalVar);
				vertexLinker.setOutputParams(targetObject.deltaTransformProcedure, "tTransformedNormal");
				normalVar = "tTransformedNormal";
			}
			vertexLinker.addProcedure(passColorProcedure);
			vertexLinker.setInputParams(passColorProcedure, positionVar, normalVar);
			
			fragmentLinker.addProcedure(outputProcedure);

			fragmentLinker.varyings = vertexLinker.varyings;
			return new ShaderProgram(vertexLinker, fragmentLinker);
		}

		/**
		 * @private
		 */
		alternativa3d override function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, useShadow:Boolean, objectRenderPriority:int = -1):void {
			if (texture == null || texture._texture == null) return;

			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);
			var normalsBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.NORMAL);

			if (positionBuffer == null || uvBuffer == null || normalsBuffer == null) return;

			var object:Object3D = surface.object;
			var program:ShaderProgram = _programs[object.transformProcedure];
			if (program == null) {
				program = setupProgram(object);
				program.upload(camera.context3D);
				_programs[object.transformProcedure] = program;
			}

			var drawUnit:DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);
			// Установка стримов
			drawUnit.setVertexBufferAt(program.vertexShader.getVariableIndex("aPosition"), positionBuffer, geometry._attributesOffsets[VertexAttributes.POSITION], VertexAttributes.FORMATS[VertexAttributes.POSITION]);
			drawUnit.setVertexBufferAt(program.vertexShader.getVariableIndex("aUV"), uvBuffer, geometry._attributesOffsets[VertexAttributes.TEXCOORDS[0]], VertexAttributes.FORMATS[VertexAttributes.TEXCOORDS[0]]);
			drawUnit.setVertexBufferAt(program.vertexShader.getVariableIndex("aNormal"), normalsBuffer, geometry._attributesOffsets[VertexAttributes.NORMAL], VertexAttributes.FORMATS[VertexAttributes.NORMAL]);

			// Установка констант
			object.setTransformConstants(drawUnit, surface, program.vertexShader, camera);
			drawUnit.setProjectionConstants(camera, program.vertexShader.getVariableIndex("cProjMatrix") << 2, object.localToCameraTransform);

			var tm:Transform3D = object.cameraToLocalTransform;

			drawUnit.setVertexConstantsFromNumbers(program.vertexShader.getVariableIndex("cCameraPos"), tm.d, tm.h, tm.l);
			var offset:Number = Math.cos(fallofAngle/2);
			var mul:Number = Math.cos(spotAngle/2) - offset;
			if (mul < 0.00001) mul = 0.00001;
			drawUnit.setFragmentConstantsFromNumbers(program.fragmentShader.getVariableIndex("cZone"), 1/fadeRadius, (1 - offset)/mul, -offset);

			drawUnit.setTextureAt(program.fragmentShader.getVariableIndex("sTexture"), texture._texture);

			drawUnit.blendSource = Context3DBlendFactor.ONE;
			drawUnit.blendDestination = Context3DBlendFactor.ONE;
			camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority : Renderer.TRANSPARENT_SORT);
		}

		override public function clone():Material {
			var res:VisibleLightMaterial = new VisibleLightMaterial(texture);
			return res;
		}

	}
}
