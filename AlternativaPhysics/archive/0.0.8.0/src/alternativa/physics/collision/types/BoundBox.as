package alternativa.physics.collision.types {
	
	/**
	 * Ограничивающий параллелепипед.
	 */
	public class BoundBox {
		
		public var minX:Number = 1e308;
		public var minY:Number = 1e308;
		public var minZ:Number = 1e308;
		public var maxX:Number = -1e308;
		public var maxY:Number = -1e308;
		public var maxZ:Number = -1e308;
		
		public function setSize(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void {
			this.minX = minX;
			this.minY = minY;
			this.minZ = minZ;
			this.maxX = maxX;
			this.maxY = maxY;
			this.maxZ = maxZ;
		}

		public function addBoundBox(boundBox:BoundBox):void {
			minX = (boundBox.minX < minX) ? boundBox.minX : minX;
			minY = (boundBox.minY < minY) ? boundBox.minY : minY;
			minZ = (boundBox.minZ < minZ) ? boundBox.minZ : minZ;
			maxX = (boundBox.maxX > maxX) ? boundBox.maxX : maxX;
			maxY = (boundBox.maxY > maxY) ? boundBox.maxY : maxY;
			maxZ = (boundBox.maxZ > maxZ) ? boundBox.maxZ : maxZ;
		}
		
		public function addPoint(x:Number, y:Number, z:Number):void {
			if (x < minX) minX = x;
			if (x > maxX) maxX = x;
			if (y < minY) minY = y;
			if (y > maxY) maxY = y;
			if (z < minZ) minZ = z;
			if (z > maxZ) maxZ = z;
		}
		
		public function infinity():void {
			minX = 1e308;
			minY = 1e308;
			minZ = 1e308;
			maxX = -1e308;
			maxY = -1e308;
			maxZ = -1e308;
		}
		
		public function intersects(bb:BoundBox, epsilon:Number):Boolean {
			return !(minX > bb.maxX + epsilon || maxX < bb.minX - epsilon || minY > bb.maxY + epsilon || maxY < bb.minY - epsilon || minZ > bb.maxZ + epsilon || maxZ < bb.minZ - epsilon);
		}
		
		public function copyFrom(boundBox:BoundBox):void {
			minX = boundBox.minX;
			minY = boundBox.minY;
			minZ = boundBox.minZ;
			maxX = boundBox.maxX;
			maxY = boundBox.maxY;
			maxZ = boundBox.maxZ;
		}
		
		public function clone():BoundBox {
			var clone:BoundBox = new BoundBox();
			clone.copyFrom(this); 
			return clone;
		}
		
		public function toString():String {
			return "BoundBox [" + minX + ", " + minY + ", " + minZ + " : " + maxX + ", " + maxY + ", " + maxZ + "]";
		}
		
	}
}