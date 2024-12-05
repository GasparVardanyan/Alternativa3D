package alternativa.physics.collision {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.collision.types.BoundBox;

	public class CollisionKdNode {
		public var indices:Vector.<int>;
		public var splitIndices:Vector.<int>;
		public var boundBox:BoundBox;
		public var parent:CollisionKdNode;
		public var splitTree:CollisionKdTree2D;
		
		public var axis:int = -1; // 0 - x, 1 - y, 2 - z
		public var coord:Number;
		public var positiveNode:CollisionKdNode;
		public var negativeNode:CollisionKdNode;
	}
}