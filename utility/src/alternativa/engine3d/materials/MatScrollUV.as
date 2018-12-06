package  alternativa.engine3d.materials
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	//import alternativa.engine3d.core.RenderPriority;
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
	import flash.display3D.*;
 
	import avmplus.getQualifiedClassName;
 
	import com.adobe.utils.AGALMiniAssembler;
 
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
 
	use namespace alternativa3d;
	public class MatScrollUV extends Material {
		//Дифффузле текстура
		public var diffuseMap:TextureResource;	
		//вершинный шейдер
		private var _vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		//фрагментный шейдер
		private var _fragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		//шейдер-программа
		private var program : ShaderProgram;
		//контекст, для загрузки ресурсов
		private var context:Context3D;
		
		private var smx:Number;
		private var smy:Number;
		
		private var dsmx:Number = 0.0001;
		private var dsmy:Number = 0.0001;
		
		public function MatScrollUV(diffuseMap:TextureResource, du:Number=0.0001, dv:Number=0.0001) {
			this.diffuseMap = diffuseMap;
			smx = 0; smy = 0;
			dsmx = du;
			dsmy = dv;

			program = new ShaderProgram(null, null);
			_vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" +
				"mov v0, va1"			
			);
	
			
 
			_fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
				"mov ft1, v0\n" + // берем UV
				"add ft1, ft1, fc0\n"+ //добавляем к ним смешение smx smy из установленных констант
				"tex ft0, ft1, fs0 <2d,repeat,linear,miplinear>\n" +			
				"mov oc, ft0"
			);
		}
		
		//переопределяем метод заливки ресурсов в видео-карту
		alternativa3d override function fillResources(resources : Dictionary, resourceType : Class) : void {
			//super.fillResources(resources, resourceType);
			//текстура Материала
			if (diffuseMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(diffuseMap)) as Class, resourceType)) {
				resources[diffuseMap] = true;
			}	
		}
 
		//отрисовка сурфейсов
		override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, useShadow:Boolean, objectRenderPriority:int = -1):void {
			if (program.program == null)    
            {    
                //шейдерная программа
				program.program = camera.context3D.createProgram();    
                program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);  
            }  	

			smx += dsmx;
			smy += dsmy;			
			//получаем ссылку на объект через его сурфейсу
			var object : Object3D = surface.object;
			//буфер позиции
			var positionBuffer : VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			//буфер uv-координат
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);
 
			var drawUnit : DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);
			//для вершинного шейдера загружаем буфер позиции и нормалей
			//при этом указываем их формат float3, float3 и смещения 0,5
			drawUnit.setVertexBufferAt(0, positionBuffer, geometry._attributesOffsets[VertexAttributes.POSITION], "float3");
			drawUnit.setVertexBufferAt(1, uvBuffer, geometry._attributesOffsets[VertexAttributes.TEXCOORDS[0]], "float2");
			//передаем матрицу проекции
			drawUnit.setProjectionConstants(camera, 0, object.localToCameraTransform);
			//передаем смешение во фрагментный шейдер
			drawUnit.setFragmentConstantsFromNumbers(0, smx, smy, 0, 0);

			//устанавливаем кубическую текстуру	
			drawUnit.setTextureAt(0, diffuseMap._texture);
			//drawUnit.blendSource = Context3DBlendFactor.ONE;// Context3DBlendFactor.SOURCE_COLOR;
			//drawUnit.blendDestination = Context3DBlendFactor.ONE;
			
			//добавляем сурфейс на отрисовку
			camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority:Renderer.OPAQUE);
		}
	}
}
/*
 * / vertex
m44 op, va0, vc0
mov v0, va1
mov v1, va2
sub v2, vc4, va0
sub v3, va0, vc5
// fragment
tex ft0, v0, fs0 <2d,repeat,linear,miplinear>
nrm ft1.xyz, v1
nrm ft2.xyz, v2
nrm ft3.xyz, v3
dp3 ft4.x, ft1.xyz ft3.xyz
mul ft4, ft1.xyz, ft4.x
add ft4, ft4, ft4
sub ft4, ft3.xyz, ft4
dp3 ft5.x, ft1.xyz, ft2.xyz
max ft5.x, ft5.x, fc0.x
add ft5, fc1, ft5.x
mul ft0, ft0, ft5
dp3 ft6.x, ft2.xyz, ft4.xyz
max ft6.x, ft6.x, fc0.x
pow ft6.x, ft6.x, fc2.w
mul ft6, ft6.x, fc2.xyz
add ft0, ft0, ft6
mov oc, ft0*/
