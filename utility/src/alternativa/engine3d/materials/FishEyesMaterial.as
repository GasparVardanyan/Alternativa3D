package alternativa.engine3d.materials 
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Renderer;
	import alternativa.engine3d.core.Transform3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.materials.A3DUtils;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.ShaderProgram;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
 
	import avmplus.getQualifiedClassName;
 
	import alternativa.adobe.utils.AGALMiniAssembler;
 
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
 
	use namespace alternativa3d;
	public class FishEyesMaterial extends Material {
		//первая текстура
		public var diffuseMap:TextureResource;
		//вершинный шейдер
		private var _vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		//фрагментный шейдер
		private var _fragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		//шейдер-программа
		private var program : ShaderProgram;
		//контекст, для загрузки ресурсов
		private var context:Context3D;
 
		public function FishEyesMaterial(diffuseMap:TextureResource) {
			this.context = context;
			this.diffuseMap = diffuseMap;
			program = new ShaderProgram(null, null);
			_vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
				//нормаль вершины
				"m44 op, va0, vc0\n" +
				"mov v0, va1\n" +
				"mov v1, va2\n" +
				"sub v2, vc4, va0\n" +
				"sub v3, va0, vc5"
			);
 
			_fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
				//Текстура
				"mov ft0, fc0.xxxz\n" +
				"nrm ft1.xyz, v1\n" +
				"nrm ft2.xyz, v2\n" +
				"nrm ft3.xyz, v3\n" +
				//расчёт вектора отражения reflect(-viewVec, normal)
				"dp3 ft4.x, ft1.xyz ft3.xyz\n" +				// ft4 = dot(normal, viewVec)
				"mul ft4, ft1.xyz, ft4.x\n" +					// ft4 *= normal
				"add ft4, ft4, ft4\n" +							// ft4 *= 2
				"sub ft4, ft3.xyz, ft4\n" +						// reflect ft4 = viewVec - ft4
				//вычисляем текстурную координату uv = ( xy / sqrt(x^2 + y^2 + (z + 1)^2) ) * 0.5 + 0.5
				"add ft6, ft4, fc0.xxz\n" + 					// ft6 = reflect (x, y, z + 1)
				"dp3 ft6.x, ft6, ft6\n" + 						// ft6 = ft6^2
				"rsq ft6.x, ft6.x\n" + 							// ft6 = 1 / sqrt(ft6)
				"mul ft6, ft4, ft6.x\n" +						// ft6 = reflect / ft6
				"mul ft6, ft6, fc0.y\n" +						// ft6 *= 0.5
				"add ft6, ft6, fc0.y\n" +						// ft6 += 0.5
				"tex ft0, ft6.xy, fs0 <2d,nearest>\n" + // color = reflect(ft6)
				//"add ft0, ft0, fc0.y\n" +
				"mov oc, ft0"
			);

		}
		//переопределяем метод заливки ресурсов в видео-карту
		alternativa3d override function fillResources(resources : Dictionary, resourceType : Class) : void {
			//super.fillResources(resources, resourceType);
			//текстура №1
			if (diffuseMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(diffuseMap)) as Class, resourceType)) {
				resources[diffuseMap] = true;
			}			
			//шейдерная программа
			//program.program = context.createProgram();// Main2.instance.stage.stage3Ds[0].context3D.createProgram();
			//program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);
		}
 
		//отрисовка сурфейсов
		override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, useShadow:Boolean, objectRenderPriority:int = -1):void {
		
			if (program.program == null)    
            {    
                //шейдерная программа
				program.program = camera.context3D.createProgram();    
                program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);  
            } 
		
			//получаем ссылку на объект через его сурфейсу
			var object : Object3D = surface.object;
			//буфер позиции
			var positionBuffer : VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			//буфер uv-координат
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);			
			//буфер нормалей
			var normalsBuffer : VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.NORMAL);

 
			var drawUnit : DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);
			//для вершинного шейдера загружаем буфер позиции и нормалей
			//при этом указываем их формат float3, float3 и смещения 0,5
			drawUnit.setVertexBufferAt(0, positionBuffer, geometry._attributesOffsets[VertexAttributes.POSITION], "float3");
			drawUnit.setVertexBufferAt(1, uvBuffer, geometry._attributesOffsets[VertexAttributes.TEXCOORDS[0]], "float2");
			drawUnit.setVertexBufferAt(2, normalsBuffer, geometry._attributesOffsets[VertexAttributes.NORMAL], "float3");
		
			//передаем матрицу проекции
			drawUnit.setProjectionConstants(camera, 0, object.localToCameraTransform);
			drawUnit.setVertexConstantsFromNumbers(4, 8000, 0, 200, 2); //Свет
			
			//передаем позицию камеры в локальном пространстве объекта
			var cameraToLocalTransform : Transform3D = object.cameraToLocalTransform;
			//cameraToLocalTransform.invert();
			//object.
			drawUnit.setVertexConstantsFromNumbers(5, cameraToLocalTransform.d, cameraToLocalTransform.h, cameraToLocalTransform.l);			
			//drawUnit.setVertexConstantsFromNumbers(5, camera.x, camera.y, camera.z, 1); //Камера
			drawUnit.setFragmentConstantsFromNumbers(0, 0.0, 0.5, 1.0, 2.0);
			drawUnit.setFragmentConstantsFromNumbers(1, 0.2, 0.2, 0.2, 1.0);//ambient:Vector.<Number> = Vector.<Number>([0.2, 0.2, 0.2, 1.0]),
			drawUnit.setFragmentConstantsFromNumbers(2, 1.0, 1.0, 1.0, 16.0);//specular:Vector.<Number> = Vector.<Number>([1.0, 1.0, 1.0, 16.0])
			drawUnit.setTextureAt(0, diffuseMap._texture);
			//добавляем сурфейс на отрисовку
			camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority:Renderer.OPAQUE);
		}
	}
}

