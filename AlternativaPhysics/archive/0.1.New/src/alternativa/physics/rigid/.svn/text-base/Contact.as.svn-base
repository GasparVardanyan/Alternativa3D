package alternativa.physics.rigid {
	
	import alternativa.types.Point3D;
	
	/**
	 * Класс описывает контакт между телами. Контакты могут составлять однонаправленный список.
	 */
	public class Contact {
		
		// Индекс контакта в списке. Используется для внутренних целей.
		public var index:int;
		// Следующий контакт в списке
		public var next:Contact;
		// Первое тело, к которому относится контакт
		public var body1:Body;
		// Второе тело, к которому относится контакт (nullable)
		public var body2:Body;
		// Координаты точки контакта
		public var pos:Point3D = new Point3D();
		// Нормаль контакта. Нормаль направлена от второго тела к первому. В локальной системе
		// координат контакта нормаль является базисным вектором, задающим направление оси X.
		public var normal:Point3D = new Point3D();
		// Глубина проникновения в точке контакта
		public var penetration:Number;
		// Служебная переменная для отслеживания времени жизни контакта
		public var timeStamp:int;
		// Минимальная скорость разделения контакта на текущем шаге
		public var minSepVelocity:Number;
		
		/**
		 * Создаёт новый экземпляр.
		 * 
		 * @param index индекс контакта в списке
		 */
		public function Contact(index:int) {
			this.index = index;
		}
		
		
		private var _v1:Point3D = new Point3D();
		private var _v2:Point3D = new Point3D();
		private var _r:Point3D = new Point3D();
		/**
		 * 
		 * @return 
		 */
		public function getSepVelocity():Number {
			// sepVel = (V1 - V2)*normal
			
			// V1 = V1_c + w1%r1
			_r.difference(pos, body1.state.pos);
			_v1.copy(body1.state.rotation);
			_v1.cross(_r);
			_v1.add(body1.state.velocity);

			if (body2 != null) {
				// V2 = V2_c + w2%r2
				_r.difference(pos, body2.state.pos);
				_v2.copy(body2.state.rotation);
				_v2.cross(_r);
				_v2.add(body2.state.velocity);
				
				_v1.subtract(_v2);
			}
			return _v1.dot(normal);
		}
		
		private var _v:Point3D = new Point3D();
		/**
		 * 
		 * @param forceInelastic
		 */
		public function resolve(forceInelastic:Boolean, dt:Number):void {
			var restitution:Number;
			if (forceInelastic) {
				restitution = 0;
			} else {
				restitution = body1.material.restitution;
				if ((body2 != null) && (body2.material.restitution < restitution)) {
					restitution = body2.material.restitution;
				}
			}
			// TODO: optimize getSepVelocity()
			var sepVel:Number = getSepVelocity();
			if (sepVel > minSepVelocity) {
//				trace("ret", sepVel);
				return;
			}
			var velAfterBounce:Number = -restitution*sepVel;
			if (velAfterBounce < minSepVelocity) {
				velAfterBounce = minSepVelocity;
			}
			var deltaVel:Number = velAfterBounce - sepVel;
			
			// Находим изменение скорости сближения под действием единичного импульса вдоль нормали
			
			var deltaVelByUnitImpulse:Number = body1.invMass;
			// {[invInertiaWorld * (r % n)] % r} * n
			_r.difference(pos, body1.state.pos);
			_v.cross2(_r, normal);
			_v.deltaTransform(body1.invInertiaWorld);
			_v.cross(_r);
			deltaVelByUnitImpulse += _v.dot(normal);

			if (body2 != null) {
				deltaVelByUnitImpulse += body2.invMass;
				
				_r.difference(pos, body2.state.pos);
				_v.cross2(_r, normal);
				_v.deltaTransform(body2.invInertiaWorld);
				_v.cross(_r);
				deltaVelByUnitImpulse += _v.dot(normal);
			}
			
			// Вычисляем требуемый импульс вдоль нормали
			var normalImpulse:Number = deltaVel/deltaVelByUnitImpulse;
			
			// Применяем импульс к телам
			
			var d:Number = normalImpulse*body1.invMass;
			body1.state.velocity.x += normal.x*d;
			body1.state.velocity.y += normal.y*d;
			body1.state.velocity.z += normal.z*d;
			
			_r.difference(pos, body1.state.pos);
			_v.cross2(_r, normal);
			_v.multiply(normalImpulse);
			_v.deltaTransform(body1.invInertiaWorld);
			body1.state.rotation.add(_v);
			
			if (body2 != null) {
				d = normalImpulse*body2.invMass;
				body2.state.velocity.x -= normal.x*d;
				body2.state.velocity.y -= normal.y*d;
				body2.state.velocity.z -= normal.z*d;
				
				_r.difference(pos, body2.state.pos);
				_v.cross2(_r, normal);
				_v.multiply(-normalImpulse);
				_v.deltaTransform(body2.invInertiaWorld);
				body2.state.rotation.add(_v);
			}
		}
		
	}
}
