package portal 
{
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.objects.Mesh;
	import alternsector.physics.adaptors.alternativa3d.ccd.SectorPhysics;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	use namespace alternativa3d;
	/**
	 * Example bare-bones class in AS3 for Alternativa3D context.
	 * 
	 * @author Glenn Ko
	 */
	public class Sector 
	{
		public var physics:SectorPhysics;
		public var collisionTarget:Object3D;
		
		public var container:Object3DContainer; // not being used atm
		
		public function Sector() 
		{
			
		
		}

	}
	

}