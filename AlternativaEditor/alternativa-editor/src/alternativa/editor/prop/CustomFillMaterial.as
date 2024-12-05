package alternativa.editor.prop {
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.PolyPrimitive;
	import alternativa.engine3d.display.Skin;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.types.Point3D;
	import alternativa.utils.ColorUtils;
	
	use namespace alternativa3d;

	public class CustomFillMaterial extends FillMaterial {
		
		private var center:Point3D = new Point3D();
		private var lightPoint:Point3D = new Point3D();
		private var normal:Point3D = new Point3D();
		
		public function CustomFillMaterial(lightPoint:Point3D, color:uint, alpha:Number=1, blendMode:String="normal", wireThickness:Number=-1, wireColor:uint=0) {
			super(color, alpha, blendMode, wireThickness, wireColor);
			this.lightPoint.copy(lightPoint);
		}
		
		override alternativa3d function draw(camera:Camera3D, skin:Skin, length:uint, points:Array):void {
			var poly:PolyPrimitive = skin.primitive;
			center.reset();
			for (var i:int = 0; i < poly.num; i++) {
				center.add(poly.points[i]);
			}
			center.multiply(1/poly.num);
			normal.difference(lightPoint, center);
			normal.normalize();
			var c:uint = _color;
			var k:Number = 0.5*(1 + normal.dot(poly.face.globalNormal));
			_color = ColorUtils.multiply(_color, k);
			super.draw(camera, skin, length, points);
			_color = c;
		}
		
		override public function clone():Material {
			return new CustomFillMaterial(lightPoint, color, alpha, blendMode, wireThickness, wireColor);
		}
		
	}
}