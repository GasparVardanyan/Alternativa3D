package strategy {
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.materials.SpriteTextureMaterial;
	import alternativa.types.Matrix3D;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;
	import alternativa.types.alternativatypes;
	
	import flash.display.BlendMode;
	
	use namespace alternativa3d;
	use namespace alternativatypes;
	
	/**
	 * Мультифазный материал для спрайта. 
	 */	
	public class MultiphaseSpriteMaterial extends SpriteTextureMaterial {
		// Список нормалей к фазам
		private var normals:Array = new Array();
		// Список текстур, соответствующий списку нормалей
		private var textures:Array = new Array();
		
		private var matrix:Matrix3D = new Matrix3D();
		private var vector:Point3D = new Point3D();
		
		public function MultiphaseSpriteMaterial(texture:Texture, alpha:Number=1, smooth:Boolean=false, blendMode:String=BlendMode.NORMAL, originX:Number=0.5, originY:Number=0.5) {
			super(texture, alpha, smooth, blendMode, originX, originY);
		}

		/**
		 * Назначает соответствующую углу зрения текстуру 
		 */		
		override alternativa3d function canDraw(camera:Camera3D):Boolean {
			
			var transform:Matrix3D = camera._transformation;
			vector.x = transform.c;
			vector.y = transform.g;
			vector.z = transform.k;
			
			var normal:Point3D;
			var texture:Texture;
			var maxDot:Number = Number.NEGATIVE_INFINITY;
			var dot:Number;
			var index:int;
			for (var i:int = normals.length - 1; i >= 0; i--) {
				normal = normals[i];
				dot = normal.x*vector.x + normal.y*vector.y + normal.z*vector.z;
				if (dot > maxDot) {
					maxDot = dot;
					index = i;
				}
			}
			
			this.texture = textures[index];				
			return super.canDraw(camera);
			
			
		}
		
		/**
		 * Добавляет новую фазу.
		 * @param normal нормаль
		 * @param texture текстура
		 */				
		public function addPhase(normal:Point3D, texture:Texture):void {
			
			normals.push(normal);
			textures.push(texture);
		}
		
		
		
		/**
		 * Поворачивает нормали. 
		 * @param cos косинус угла поворота
		 * @param sin синус угла поворота
		 */		
		public function rotateNormals(cos:Number, sin:Number):void {
			
			var len:int = normals.length;
			for (var i:int = 0; i < len; i++) {
				var normal:Point3D = normals[i];
				var x:Number = normal.x*cos - normal.y*sin;
				var y:Number = normal.x*sin + normal.y*cos;
				normal.x = x;
				normal.y = y;	
			}
		}
		
		/**
		 * Обновляет список текстур. 
		 * @param textures
		 */		
		public function updateTextures(textures:Array):void {
			
			this.textures = textures;
		}
			
		
	}
}
