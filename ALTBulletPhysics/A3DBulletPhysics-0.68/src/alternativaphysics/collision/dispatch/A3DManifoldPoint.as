package alternativaphysics.collision.dispatch {
	import alternativaphysics.A3DBase;
	import alternativaphysics.math.A3DVector3;

	import flash.geom.Vector3D;


	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DManifoldPoint extends A3DBase {

		private var m_localPointA : A3DVector3;
		private var m_localPointB : A3DVector3;
		private var m_normalWorldOnB : A3DVector3;


		/** 
		* 
		* @public 
		* @param ptr 
		*/
		public function A3DManifoldPoint(ptr : uint) {
			pointer = ptr;

			m_localPointA = new A3DVector3(ptr + 0);
			m_localPointB = new A3DVector3(ptr + 16);
			m_normalWorldOnB = new A3DVector3(ptr + 64);
		}

		/**
		 *get the collision position in objectA's local coordinates
		 */
		public function get localPointA() : Vector3D {
			return m_localPointA.sv3d;
		}

		/**
		 *get the collision position in objectB's local coordinates
		 */
		public function get localPointB() : Vector3D {
			return m_localPointB.sv3d;
		}

		/**
		 *get the collision normal in world coordinates
		 */
		public function get normalWorldOnB() : Vector3D {
			return m_normalWorldOnB.v3d;
		}

		/**
		 *get the value of collision impulse
		 */
		public function get appliedImpulse() : Number {
			return memUser._mrf(pointer + 112);
		}
	}
}