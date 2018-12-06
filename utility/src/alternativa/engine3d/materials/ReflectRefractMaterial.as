package alternativa.engine3d.materials {
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.RenderPriority;
	import alternativa.engine3d.core.Transform3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.A3DUtils;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.ShaderProgram;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;

	import avmplus.getQualifiedClassName;

	import com.adobe.utils.AGALMiniAssembler;

	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	use namespace alternativa3d;
	public class ReflectRefractMaterial extends Material {
		alternativa3d var _cubeTexture : TextureResource;
		private var _vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		private var _fragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		private var program : ShaderProgram;
		public var reflectionPower: Number = 0.5;
		private var refractionIndex : Number = 6;
		private var alpha : Number = 1;
		private var rotatedObject:Object3D;
		public function ReflectRefractMaterial(cubeTexture : TextureResource = null) {
			_cubeTexture = cubeTexture;
			program = new ShaderProgram(null, null);
			_vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
			"mov vt0, va1\n"+
			"m33 vt0.xyz, vt0.xyz, vc6\n"+
			"sub vt1, vc4, va0\n"+
			"m33 vt1.xyz, vt1.xyz, vc6\n"+
			"dp3 vt2, vt1, vt0\n"+
			"add vt2, vt2, vt2\n"+
			"mul vt2, vt0, vt2\n"+
			"sub vt2, vt1, vt2\n"+
			"neg vt2, vt2\n"+
			"nrm vt2.xyz, vt2.xyz\n"+
			"mov v0, vt2\n"+
			"dp3 vt3, vt1, vt0\n"+
			"mul vt3, vt3, vt0\n"+
			"sub vt3, vt3, vt1\n"+
			"mul vt3, vt3, vc5.y\n"+
			"dp3 vt4, vt1, vt0\n"+
			"mul vt4, vt4, vt4\n"+
			"sub vt4, vc5.x, vt4\n"+
			"mul vt4, vc5.z, vt4\n"+
			"sub vt4, vc5.x, vt4\n"+
			"sqt vt4, vt4\n"+
			"mul vt4, vt4, vt0\n"+
			"sub vt4, vt3, vt4\n"+
			"nrm vt4.xyz, vt4.xyz\n"+
			"mov v1, vt4\n"+
			"m44 op, va0, vc0");
			
			_fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			"mov ft4.xyz, v0.yzx\n"+
			"neg ft4.z, ft4.z\n"+
			"m33 ft4.xyz, ft4.xyz, fc1\n"+
			"tex ft0,ft4.xyz,fs0 <cube,clamp,linear>\n"+
			"mov ft5.xyz, v1.yzx\n"+
			"neg ft5.z, ft5.z\n"+
			"m33 ft5.xyz, ft5.xyz, fc1\n"+
			"tex ft1,ft5.xyz,fs0 <cube,clamp,linear>\n"+
			"sub ft3, ft0, ft1\n"+
			"mul ft3, ft3, fc0\n"+
			"add ft3, ft3, ft1\n"+
			"mov ft3.w, fc0.w\n"+
			"mov oc, ft3"
			);
			
			rotatedObject = new Object3D();
			rotatedObject.rotationY = -Math.PI/2;
			rotatedObject.composeTransforms();
			Main.instance.rootContainer.addChild(rotatedObject);
		}
		alternativa3d override function fillResources(resources : Dictionary, resourceType : Class) : void {
			if (_cubeTexture != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(_cubeTexture)) as Class, resourceType)) {
				resources[_cubeTexture] = true;
			}
			program.program = Main.instance.stage.stage3Ds[0].context3D.createProgram();
			program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);
		}
		
		override alternativa3d function collectDraws(camera : Camera3D, surface : Surface, geometry : Geometry, lights : Vector.<Light3D>, lightsLength : int, objectRenderPriority : int = -1) : void {
			var object : Object3D = surface.object;
			var positionBuffer : VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var normalsBuffer : VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.NORMAL);
			var drawUnit : DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);
			drawUnit.setVertexBufferAt(0, positionBuffer, 0, "float3");
			drawUnit.setVertexBufferAt(1, normalsBuffer, 5, "float3");
			drawUnit.setProjectionConstants(camera, 0, object.localToCameraTransform);
			var cameraToLocalTransform : Transform3D = object.cameraToLocalTransform;
			drawUnit.setVertexConstantsFromNumbers(4, cameraToLocalTransform.d, cameraToLocalTransform.h, cameraToLocalTransform.l);
			var refraction:Number = refractionIndex/1000;
			drawUnit.setVertexConstantsFromNumbers(5, 1, refraction, refraction*refraction, 1);
			var globalTransform : Transform3D = new Transform3D();
			globalTransform.copy(object.localToCameraTransform);
			globalTransform.append(camera.localToGlobalTransform);
			drawUnit.setVertexConstantsFromTransform(6, globalTransform);
			drawUnit.setFragmentConstantsFromNumbers(0,reflectionPower,reflectionPower,reflectionPower,alpha);
			drawUnit.setFragmentConstantsFromTransform(1, rotatedObject.inverseTransform);
			drawUnit.setTextureAt(0, _cubeTexture._texture);
			camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority : RenderPriority.OPAQUE);
		}
	}
}