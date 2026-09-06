package entity{
	import alternativa.engine3d.objects.Mesh;
	import alternativaphysics.dynamics.A3DRigidBody;
	import entity.Entity;
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author redefy
	 */
	public class Level extends Entity {
		protected var startHeroPoint:Vector3D = new Vector3D();
		protected var startHeroRotation:Vector3D = new Vector3D();
		protected var childMesh:Mesh;
		protected var rigidBody:A3DRigidBody;
		
		public function get startPoint():Vector3D {
			return startHeroPoint;
		}
		
		public function get startRotation():Vector3D {
			return startHeroRotation;
		}
		
		protected function positionM(mesh:Mesh):Vector3D {
			return new Vector3D(mesh.x, mesh.y, mesh.z);
		}
		
		protected function rotationM(mesh:Mesh):Vector3D {
			return new Vector3D(mesh.rotationX, mesh.rotationY, mesh.rotationZ);
		}
	}
}