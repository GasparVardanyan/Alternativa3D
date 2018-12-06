package
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.resources.TextureResource;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.core.Light3D;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import alternativa.engine3d.alternativa3d; 
	use namespace alternativa3d;
	
	public class MovieMaterial extends TextureMaterial
	{
		protected var mc:MovieClip;
		protected var bd:BitmapData;
	
		public function MovieMaterial(clip:MovieClip):void
		{
			mc = clip;
			this.diffuseMap = getDiffuse();
			this.alpha = 1;
			super(diffuseMap,null,alpha);
			mc.addEventListener(Event.ENTER_FRAME, updateTexture);
		}
		
		private function getDiffuse():TextureResource {
			bd = new BitmapData (mc.width, mc.height, true);
			return new BitmapTextureResource(bd);
		}
		
		protected function updateTexture(e:Event = null):void {
			if(mc) { bd.draw(mc); }
		}
		
		override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, objectRenderPriority:int = -1):void 
		{
			if(diffuseMap) { diffuseMap.upload(camera.context3D); }
			super.collectDraws(camera, surface, geometry, lights, lightsLength, objectRenderPriority);
		}
	}
}