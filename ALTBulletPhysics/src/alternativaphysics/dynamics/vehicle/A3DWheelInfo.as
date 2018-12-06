package alternativaphysics.dynamics.vehicle {
	import alternativa.engine3d.core.Object3D;

	import alternativaphysics.A3DBase;
	import alternativaphysics.math.A3DTransform;
	import alternativaphysics.math.A3DVector3;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * Настройки подвески и колеса.
	 * @public 
	 */
	public class A3DWheelInfo extends A3DBase {

		private var m_skin : Object3D;
		private var m_raycastInfo : A3DRaycastInfo;
		private var m_worldTransform : A3DTransform;
		private var m_chassisConnectionPointCS : A3DVector3;
		private var m_wheelDirectionCS : A3DVector3;
		private var m_wheelAxleCS : A3DVector3;
		private var _transform:Matrix3D = new Matrix3D();


		/** 
		* Конструктор
		* @public 
		* @param ptr 
		* @param _skin Скин колеса
		*/
		public function A3DWheelInfo(ptr : uint, _skin : Object3D = null) {
			pointer = ptr;
			m_skin = _skin;

			m_raycastInfo = new A3DRaycastInfo(ptr);
			m_worldTransform = new A3DTransform(ptr + 92);
			m_chassisConnectionPointCS = new A3DVector3(ptr + 156);
			m_wheelDirectionCS = new A3DVector3(ptr + 172);
			m_wheelAxleCS = new A3DVector3(ptr + 188);
			
		}


		/** 
		* 
		* @public (getter) 
		* @return Object3D 
		*/
		public function get skin() : Object3D {
			return m_skin;
		}
		

		/** 
		* 
		* @public (setter) 
		* @param value 
		* @return void 
		*/
		public function set skin(value:Object3D):void {
			m_skin = value;
		}


		/** 
		* 
		* @public (getter) 
		* @return A3DRaycastInfo 
		*/
		public function get raycastInfo() : A3DRaycastInfo {
			return m_raycastInfo;
		}


		/** 
		* 
		* @public (setter) 
		* @param pos 
		* @return void 
		*/
		public function set worldPosition(pos : Vector3D) : void {
			m_worldTransform.position = pos;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get worldPosition() : Vector3D {
			return m_worldTransform.position;
		}


		/** 
		* 
		* @public (setter) 
		* @param rot 
		* @return void 
		*/
		public function set worldRotation(rot : Vector3D) : void {
			m_worldTransform.rotation = rot;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get worldRotation() : Vector3D {
			return m_worldTransform.rotation;
		}


		/** 
		* 
		* @public 
		* @return void 
		*/
		public function updateTransform() : void {
			if (!m_skin) return;
			
			_transform.identity();
			_transform.appendScale(m_skin.scaleX, m_skin.scaleY, m_skin.scaleZ);
			_transform.append(m_worldTransform.transform);
			
			m_skin.matrix = _transform;
		}


		/** 
		* Стартовая точка луча, там где подвеска соединяется с шасси (пространство шасси)
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get chassisConnectionPointCS() : Vector3D {
			return m_chassisConnectionPointCS.sv3d;
		}


		/** 
		* Стартовая точка луча, там где подвеска соединяется с шасси (пространство шасси)
		* @public (setter) 
		* @param v Координаты точки
		* @return void 
		*/
		public function set chassisConnectionPointCS(v : Vector3D) : void {
			m_chassisConnectionPointCS.sv3d = v;
		}


		/** 
		* Направление рейкастинга (пространство шасси)
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get wheelDirectionCS() : Vector3D {
			return m_wheelDirectionCS.v3d;
		}


		/** 
		* Направление рейкастинга (пространство шасси)
		* @public (setter) 
		* @param v Вектор направления рейкастинга
		* @return void 
		*/
		public function set wheelDirectionCS(v : Vector3D) : void {
			m_wheelDirectionCS.v3d = v;
		}


		/** 
		* Ось вокруг которой вращается колеса
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get wheelAxleCS() : Vector3D {
			return m_wheelAxleCS.v3d;
		}


		/** 
		* Ось вокруг которой вращается колесо
		* @public (setter) 
		* @param v  Направление оси
		* @return void 
		*/
		public function set wheelAxleCS(v : Vector3D) : void {
			m_wheelAxleCS.v3d = v;
		}


		/** 
		* Максимальная длина подвески (в метрах)
		* @public (getter) 
		* @return Number 
		*/
		public function get suspensionRestLength1() : Number {
			return memUser._mrf(pointer + 204) * _scaling;
		}


		/** 
		* Максимальная длина подвески (в метрах)
		* @public (setter) 
		* @param v Длина подвески
		* @return void 
		*/
		public function set suspensionRestLength1(v : Number) : void {
			memUser._mwf(pointer + 204, v / _scaling);
		}


		/** 
		* Максимальная дистанция на которою может сжаться подвеска
		* @public (getter) 
		* @return Number 
		*/
		public function get maxSuspensionTravelCm() : Number {
			return memUser._mrf(pointer + 208);
		}


		/** 
		* Максимальная дистанция на которою может сжаться подвеска
		* @public (setter) 
		* @param v Дистанция подвески
		* @return void 
		*/
		public function set maxSuspensionTravelCm(v : Number) : void {
			memUser._mwf(pointer + 208, v);
		}


		/** 
		* Радиус колеса
		* @public (getter) 
		* @return Number 
		*/
		public function get wheelsRadius() : Number {
			return memUser._mrf(pointer + 212) * _scaling;
		}


		/** 
		* Радиус колеса
		* @public (setter) 
		* @param v  Радиус колеса
		* @return void 
		*/
		public function set wheelsRadius(v : Number) : void {
			memUser._mwf(pointer + 212, v / _scaling);
		}


		/** 
		* Жесткость подвески. 10.0 - багги, 50.0 - спортивная машина, 200 - F1 Машина
		* @public (getter) 
		* @return Number 
		*/
		public function get suspensionStiffness() : Number {
			return memUser._mrf(pointer + 216);
		}


		/** 
		* Жесткость подвески. 10.0 - багги, 50.0 - спортивная машина, 200 - F1 Машина
		* @public (setter) 
		* @param v Жесткость подвески
		* @return void 
		*/
		public function set suspensionStiffness(v : Number) : void {
			memUser._mwf(pointer + 216, v);
		}


		/** 
		* Коэффицент ослабления сжатия подвески. При 0.0 сжатие не ослабляется, при 1.0 критическое сжатие.
		* Значения от 0.1 до 0.3 являются наилучшим выбором.
		* @public (getter) 
		* @return Number 
		*/
		public function get wheelsDampingCompression() : Number {
			return memUser._mrf(pointer + 220);
		}


		/** 
		* Коэффицент ослабления сжатия подвески. При 0.0 сжатие не ослабляется, при 1.0 критическое сжатие.
		* Значения от 0.1 до 0.3 являются наилучшим выбором.
		* @public (setter) 
		* @param v Коэффицент ослабления сжатия подвески.
		* @return void 
		*/
		public function set wheelsDampingCompression(v : Number) : void {
			memUser._mwf(pointer + 220, v);
		}


		/** 
		* Коэффицент ослабления разжимания подвески. Лучше если это значение будет немножко больше чем wheelsDampingCompression.
		* Лучшие значения от 0.2 до 0.5.
		* @public (getter) 
		* @return Number 
		*/
		public function get wheelsDampingRelaxation() : Number {
			return memUser._mrf(pointer + 224);
		}


		/** 
		* Коэффицент ослабления разжимания подвески. Лучше если это значение будет немножко больше чем wheelsDampingCompression.
		* Лучшие значения от 0.2 до 0.5.
		* @public (setter) 
		* @param v Коэффицент ослабления разжимания подвески
		* @return void 
		*/
		public function set wheelsDampingRelaxation(v : Number) : void {
			memUser._mwf(pointer + 224, v);
		}


		/** 
		* Коэффициент трения между покрышкой и землей. Для симуляции реалистичного поведения машин, должно быть около 0.8, но так же
		* может быть увеличено для лучшей управляемости. Самое больщое значение (10000.0) для карт гонщиков.
		* @public (getter) 
		* @return Number 
		*/
		public function get frictionSlip() : Number {
			return memUser._mrf(pointer + 228);
		}


		/** 
		* Коэффициент трения между покрышкой и землей. Для симуляции реалистичного поведения машин, должно быть около 0.8, но так же
		* может быть увеличено для лучшей управляемости. Самое больщое значение (10000.0) для карт гонщиков.
		* @public (setter) 
		* @param v Коэффициент трения между покрышкой и землей.
		* @return void 
		*/
		public function set frictionSlip(v : Number) : void {
			memUser._mwf(pointer + 228, v);
		}


		/** 
		* Угол поворота колес относительно транспортного средства.
		* @public (getter) 
		* @return Number 
		*/
		public function get steering() : Number {
			return memUser._mrf(pointer + 232);
		}


		/** 
		* Угол поворота колес относительно транспортного средства.
		* @public (setter) 
		* @param v Угол поворота колес. (в радианах)
		* @return void 
		*/
		public function set steering(v : Number) : void {
			memUser._mwf(pointer + 232, v);
		}


		/** 
		* Угол поворота колеса вокруг своей оси.
		* @public (getter) 
		* @return Number 
		*/
		public function get rotation() : Number {
			return memUser._mrf(pointer + 236);
		}


		/** 
		* Угол поворота колеса вокруг своей оси.
		* @public (setter) 
		* @param v Угол поворота колеса. (Возвратит значение в радианах)
		* @return void 
		*/
		public function set rotation(v : Number) : void {
			memUser._mwf(pointer + 236, v);
		}


		/** 
		* Величина угла поворота колеса вокруг своей оси в текущем кадре.
		* @public (getter) 
		* @return Number 
		*/
		public function get deltaRotation() : Number {
			return memUser._mrf(pointer + 240);
		}


		/** 
		* Величина угла поворота колеса вокруг своей оси в текущем кадре.
		* @public (setter) 
		* @param v Величина угла поворота колеса (в радианах)
		* @return void 
		*/
		public function set deltaRotation(v : Number) : void {
			memUser._mwf(pointer + 240, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get rollInfluence() : Number {
			return memUser._mrf(pointer + 244);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set rollInfluence(v : Number) : void {
			memUser._mwf(pointer + 244, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get maxSuspensionForce() : Number {
			return memUser._mrf(pointer + 248);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set maxSuspensionForce(v : Number) : void {
			memUser._mwf(pointer + 248, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get engineForce() : Number {
			return memUser._mrf(pointer + 252);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set engineForce(v : Number) : void {
			memUser._mwf(pointer + 252, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get brake() : Number {
			return memUser._mrf(pointer + 256);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set brake(v : Number) : void {
			memUser._mwf(pointer + 256, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get bIsFrontWheel() : Boolean {
			return memUser._mru8(pointer + 260) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set bIsFrontWheel(v : Boolean) : void {
			memUser._mw8(pointer + 260, v ? 1 : 0);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get suspensionRelativeVelocity() : Number {
			return memUser._mrf(pointer + 272);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get wheelsSuspensionForce() : Number {
			return memUser._mrf(pointer + 276);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get skidInfo() : Number {
			return memUser._mrf(pointer + 280);
		}
	}
}