package  alternativa.engine3d.materials
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Vector3D;
	import flash.media.Camera;
	import flash.geom.Matrix3D;
	import alternativa.engine3d.core.View;
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
	import alternativa.engine3d.utils.Object3DUtils;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
 
	import avmplus.getQualifiedClassName;
 
	import alternativa.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DBlendFactor; 
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
 
	use namespace alternativa3d;
	public class MatPlaneMirror extends Material {
		//Дифффузле текстура
		public var diffuseMap:TextureResource;
		//Нормал текстура
		public var mirrorMap : TextureResource;
		//Спектральная текстура
		alternativa3d var specTexture : TextureResource;
		//кубическая текстура
		alternativa3d var cubeTexture : TextureResource;		
		
		//вершинный шейдер
		private var _vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		//фрагментный шейдер
		private var _fragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
		//шейдер-программа
		private var program : ShaderProgram;
		//контекст, для загрузки ресурсов
		public var rcamera:Camera3D;
		public var alpha:Number = 1.0;
		public var reflection:Number = .7;
		public var newCamPos:Vector3D;
		public var newLookPos:Vector3D;
		public var size:Number = 256;
		
		public function MatPlaneMirror(diffuseMap:TextureResource, mirrorMap:TextureResource) {

			this.diffuseMap = diffuseMap;
			this.mirrorMap = mirrorMap;

			program = new ShaderProgram(null, null);
			_vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,  
                "m44 op, va0, vc0\n" +  
                "mov v0, va1\n" +  
				"m44 vt1, va0, vc0\n" +
				//"div vt1.xy, vt1.xy, vt1.ww\n" +
				//"neg vt1, vt1\n"+
                "mov v1, vt1"            
            );  
      
  
            _fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,  
                "mov ft2, v1\n" +  
				"div ft4.xy, ft2.xyzw ft2.wwxw\n"+
				"mul ft4.zw ft4.xxxy fc2.xxxy\n"+
				"add ft4.xy ft4.zwzw fc2.zzzz\n"+				
				//"mul ft2.xy, ft2.xy, fc0.yy\n" + 
				//"add ft2.xy, ft2.xy, fc0.yy\n" +
                "tex ft0,ft4.xyz,fs1 <2d,repeat,linear>\n" +  
                "tex ft1,v0,fs0 <2d,repeat,linear>\n" +  
                //смешиваем  
                "sub ft3, ft1, ft0\n"+  
                "mul ft3, ft3, fc1.yyy\n"+  
                "add ft3, ft3, ft0\n" +  
				"mul ft3.w, ft3.w, fc1.x\n"+ 
                //отправляем результат  
                "mov oc, ft3"  
            );               
        }  
        //переопределяем метод заливки ресурсов в видео-карту  
        alternativa3d override function fillResources(resources : Dictionary, resourceType : Class) : void {  
            //super.fillResources(resources, resourceType);  
            //текстура Материала  
            if (diffuseMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(diffuseMap)) as Class, resourceType)) {  
                resources[diffuseMap] = true;  
            }     
              
            if (mirrorMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(mirrorMap)) as Class, resourceType)) {  
                resources[mirrorMap] = true;  
            }                 
          
            //шейдерная программа  
           // program.program = context.createProgram();// Main2.instance.stage.stage3Ds[0].context3D.createProgram();  
            //program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);  
        }  
  
		
		
        //отрисовка сурфейсов  
        override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, useShadow:Boolean, objectRenderPriority:int = -1):void {  

			if (program.program == null)    
            {    
                //шейдерная программа
				program.program = camera.context3D.createProgram();    
                program.program.upload(_vertexShaderAssembler.agalcode, _fragmentShaderAssembler.agalcode);   
				mirrorMap._texture = camera.context3D.createTexture(size, size, Context3DTextureFormat.BGRA, true);
            }  			
			
			
            //получаем ссылку на объект через его сурфейсу  
            var object : Object3D = surface.object;  
            //буфер позиции  6
            var positionBuffer : VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);  
            //буфер нормалей  
            var normalsBuffer : VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.NORMAL);  
            //буфер uv-координат  
            var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);  
  
            var drawUnit : DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);  
            //для вершинного шейдера загружаем буфер позиции и нормалей  
            //при этом указываем их формат float3, float3 и смещения 0,5  
            drawUnit.setVertexBufferAt(0, positionBuffer, 0, "float3");  
            drawUnit.setVertexBufferAt(1, uvBuffer, geometry._attributesOffsets[VertexAttributes.TEXCOORDS[0]], "float2");  

            drawUnit.setProjectionConstants(camera, 0, object.localToCameraTransform);
			
			drawUnit.setFragmentConstantsFromNumbers(0, 0.0, 0.5, 1.0, 2.0);  
			drawUnit.setFragmentConstantsFromNumbers(1, alpha, reflection, 1.0, 2.0);
			drawUnit.setFragmentConstantsFromNumbers(2, 0.5, 0.5, 0.5, 0.5);

            drawUnit.setTextureAt(0, diffuseMap._texture);  
            drawUnit.setTextureAt(1, mirrorMap._texture);  
              
            //добавляем сурфейс на отрисовку
			//drawUnit.blendSource = Context3DBlendFactor.SOURCE_ALPHA;
			//drawUnit.blendDestination = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
            camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority:Renderer.OPAQUE);// Renderer.OPAQUE);  
		}
		
		private var lookVector:Vector3D;
		private var oldPosCam:Vector3D;
		private var mirrPos:Vector3D;
		private var mirrLookPos:Vector3D;
		
		
		private function RenderReflection(stage3D:Stage3D, camera:Camera3D, object:Object3D):void 
		{		
			//var mOld:Matrix3D = camera.matrix.clone();
			//var c:Matrix3D = camera.matrix.clone();
			//var o:Matrix3D = object.matrix.clone();
			//Matrix3D.interpolate(c, o, 100);
			//c.prependRotation(180, Vector3D.X_AXIS, new Vector3D(object.x,object.y,object.z));
			
			lookVector = camera.localToGlobal(new Vector3D(0, 0, 300));

			oldPosCam = new Vector3D(camera.x, camera.y, camera.z);
			mirrPos = object.globalToLocal(oldPosCam);
			mirrPos.z *= -1;
			newCamPos = object.globalToLocal(mirrPos);//new Vector3D(c.position.x,c.position.y,c.position.z)//			
			mirrLookPos = object.globalToLocal(lookVector);
			mirrLookPos.z *= -1;
			newLookPos = object.localToGlobal(mirrLookPos);			
			rcamera.x = newCamPos.x; rcamera.y = newCamPos.y; rcamera.z = newCamPos.z;
			lookAt(newLookPos, rcamera);
			var r:Number = ((camera.view.backgroundColor >> 16) & 0xff)/0xff;
			var g:Number = ((camera.view.backgroundColor >> 8) & 0xff)/0xff;
			var b:Number = (camera.view.backgroundColor & 0xff)/0xff;
			if (camera.view._canvas != null) {
				r *= camera.view.backgroundAlpha;
				g *= camera.view.backgroundAlpha;
				b *= camera.view.backgroundAlpha;
			}
			stage3D.context3D.clear(r, g, b, camera.view.backgroundAlpha);
			stage3D.context3D.setRenderToTexture(this.mirrorMap._texture, true);
			//stage3D.context3D.setStencilReferenceValue(2);
			//rcamera.matrix = c;
			//rcamera.rotationY = rcamera.rotationY * -1;
			rcamera.render(stage3D);
			//camera.matrix = mOld;
			stage3D.context3D.setRenderToBackBuffer();		
		}
		
		public function update(stage3D:Stage3D, camera:Camera3D, object:Object3D):void 
		{
			//rcamera.view.width = camera.view.width;
			//rcamera.view.height = camera.view.height;
			if (rcamera == null)
			{
				rcamera = new Camera3D(camera.nearClipping, camera.farClipping);
				rcamera.view = new View(camera.view.width, camera.view.height, true);
				camera.parent.addChild(rcamera);
				RenderReflection(stage3D, camera, object);
			}
			else 
			{
				RenderReflection(stage3D, camera, object);
			}
		}		
		
		private function lookAt(pt:Vector3D, c:Object3D):void 
		{
			var objectTransform:Vector.<Vector3D> = c.matrix.decompose();
			var v:Vector3D = objectTransform[0];
			var dx:Number = pt.x - v.x;
			var dy:Number = pt.y - v.y;
			var dz:Number = pt.z - v.z;
			v = objectTransform[1];
			v.x = Math.atan2(dz, Math.sqrt(dx * dx + dy * dy)) -0.5 * Math.PI;
			v.y = 0;
			v.z = -Math.atan2(dx, dy);
			var m:Matrix3D = c.matrix;
			m.recompose(objectTransform);
			c.matrix = m;
		}
		
	}
}
