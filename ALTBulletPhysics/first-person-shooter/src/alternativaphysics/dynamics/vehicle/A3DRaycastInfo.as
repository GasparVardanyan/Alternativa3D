package alternativaphysics.dynamics.vehicle {
	import alternativaphysics.A3DBase;
	import alternativaphysics.math.A3DVector3;

	import flash.geom.Vector3D;


	/** 
	* Этот класс содержит информацию для рейкастинга колеса.
	* @public 
	* @author redefy 
	*/
	public class A3DRaycastInfo extends A3DBase {

		private var m_contactNormalWS : A3DVector3;
		private var m_contactPointWS : A3DVector3;
		private var m_hardPointWS : A3DVector3;
		private var m_wheelDirectionWS : A3DVector3;
		private var m_wheelAxleWS : A3DVector3;


		/** 
		* Конструктор
		* @public 
		* @param ptr 
		*/
		public function A3DRaycastInfo(ptr : uint) {
			pointer = ptr;

			m_contactNormalWS = new A3DVector3(ptr + 0);
			m_contactPointWS = new A3DVector3(ptr + 16);
			m_hardPointWS = new A3DVector3(ptr + 36);
			m_wheelDirectionWS = new A3DVector3(ptr + 52);
			m_wheelAxleWS = new A3DVector3(ptr + 68);
		}


		/** 
		* Нормаль к точке контакта луча. (мировое пространство)
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get contactNormalWS() : Vector3D {
			return m_contactNormalWS.v3d;
		}


		/** 
		* Координаты контакта луча. (мировое пространство)
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get contactPointWS() : Vector3D {
			return m_contactPointWS.sv3d;
		}


		/** 
		* Стартовая точка для рейкастинга. Находится там где подвеска соединяется с шасси. (мировое пространство)
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get hardPointWS() : Vector3D {
			return m_hardPointWS.sv3d;
		}


		/** 
		* Направление рейкастинга. (в мировом пространстве).
		* Колесо движется относительно шасси в этом направлении, и на подвеску действует сила также вдоль этого направления.
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get wheelDirectionWS() : Vector3D {
			return m_wheelDirectionWS.v3d;
		}


		/** 
		* Направление оси колеса. Колесо вращается вокруг этой оси.
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get wheelAxleWS() : Vector3D {
			return m_wheelAxleWS.v3d;
		}


		/** 
		* Текущая длина подвески. (в метрах)
		* @public (getter) 
		* @return Number 
		*/
		public function get suspensionLength() : Number {
			return memUser._mrf(pointer + 32) * _scaling;
		}


		/** 
		* True если колесо контактирует с чем-нибудь.
		* @public (getter) 
		* @return Boolean 
		*/
		public function get isInContact() : Boolean {
			return memUser._mru8(pointer + 84) == 1;
		}
	}
}