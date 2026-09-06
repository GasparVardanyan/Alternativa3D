package alternativaphysics.dynamics.vehicle {
	import alternativa.engine3d.core.Object3D;

	import alternativaphysics.A3DBase;
	import alternativaphysics.dynamics.A3DRigidBody;

	import flash.geom.Vector3D;

	/**
	 * Класс позволяет создавать и управлять поведением транспортного средства.
	 * @public 
	 */
	public class A3DRaycastVehicle extends A3DBase {

		private var m_chassisBody : A3DRigidBody;
		private var m_wheelInfo : Vector.<A3DWheelInfo>;

		public function A3DRaycastVehicle(tuning : A3DVehicleTuning, chassis : A3DRigidBody) {
			pointer = bullet.createVehicleMethod(tuning, chassis.pointer);

			m_chassisBody = chassis;
			m_wheelInfo = new Vector.<A3DWheelInfo>();
		}


		/** 
		* 
		* @public 
		* @return A3DRigidBody 
		*/
		public function getRigidBody() : A3DRigidBody {
			return m_chassisBody;
		}


		/** 
		* 
		* @public 
		* @return int 
		*/
		public function getNumWheels() : int {
			return m_wheelInfo.length;
		}


		/** 
		* 
		* @public 
		* @param index 
		* @return A3DWheelInfo 
		*/
		public function getWheelInfo(index : int) : A3DWheelInfo {
			if (index < m_wheelInfo.length) {
				return m_wheelInfo[index];
			}
			return null;
		}


		/** 
		* 
		* @public 
		* @param _skin 
		* @param connectionPointCS0 
		* @param wheelDirectionCS0 
		* @param wheelAxleCS 
		* @param suspensionRestLength 
		* @param wheelRadius 
		* @param tuning 
		* @param isFrontWheel 
		* @return void 
		*/
		public function addWheel(_skin : Object3D, connectionPointCS0 : Vector3D, wheelDirectionCS0 : Vector3D, wheelAxleCS : Vector3D, suspensionRestLength : Number, wheelRadius : Number, tuning : A3DVehicleTuning, isFrontWheel : Boolean) : void {
			var wp : uint = bullet.addVehicleWheelMethod(pointer, connectionPointCS0.x / _scaling, connectionPointCS0.y / _scaling, connectionPointCS0.z / _scaling, wheelDirectionCS0.x, wheelDirectionCS0.y, wheelDirectionCS0.z, wheelAxleCS.x, wheelAxleCS.y, wheelAxleCS.z, suspensionRestLength / _scaling, wheelRadius / _scaling, tuning, (isFrontWheel) ? 1 : 0);

			if (m_wheelInfo.length > 0) {
				var num : int = 0;
				for (var i : int = m_wheelInfo.length - 1; i >= 0; i-- ) {
					num += 1;
					m_wheelInfo[i] = new A3DWheelInfo(wp - 284 * num, m_wheelInfo[i].skin);
				}
			}

			m_wheelInfo.push(new A3DWheelInfo(wp, _skin));
		}


		/** 
		* 
		* @public 
		* @param force 
		* @param wheelIndex 
		* @return void 
		*/
		public function applyEngineForce(force : Number, wheelIndex : int) : void {
			m_wheelInfo[wheelIndex].engineForce = force;
		}


		/** 
		* 
		* @public 
		* @param brake 
		* @param wheelIndex 
		* @return void 
		*/
		public function setBrake(brake : Number, wheelIndex : int) : void {
			m_wheelInfo[wheelIndex].brake = brake;
		}


		/** 
		* 
		* @public 
		* @param steering 
		* @param wheelIndex 
		* @return void 
		*/
		public function setSteeringValue(steering : Number, wheelIndex : int) : void {
			m_wheelInfo[wheelIndex].steering = steering;
		}


		/** 
		* 
		* @public 
		* @param wheelIndex 
		* @return Number 
		*/
		public function getSteeringValue(wheelIndex : int) : Number {
			return m_wheelInfo[wheelIndex].steering;
		}


		/** 
		* 
		* @public 
		* @return void 
		*/
		public function updateWheelsTransform() : void {
			for each (var wheel:A3DWheelInfo in m_wheelInfo) {
				wheel.updateTransform();
			}
		}
	}
}