package alternativa.physics.collision {
	import alternativa.physics.types.Vector3;
	
	public class CollisionPoint {
		
		public var pos:Vector3 = new Vector3();
		public var penetration:Number;
		
		public var feature1:int;
		public var feature2:int;
		
		// Величины, расчитываемые перед началом фазы решения контактов
		
		// Требуемая проекция конечной скорости на нормаль для упругого контакта 
		public var normalVel:Number;
		// Минимальная скорость разделения неупругого контакта
		public var minSepVel:Number;
		// Изменение проекции скорости на единицу нормального импульса
		public var velByUnitImpulseN:Number;
		
		// Радиус-вектор точки контакта относительно центра первого тела
		public var r1:Vector3 = new Vector3();
		// Радиус-вектор точки контакта относительно центра второго тела
		public var r2:Vector3 = new Vector3();
		
		// Величины, накапливаемые во время фазы решения контактов
		
		// Накопленный импульс, применяемый для получения требуемой относительной скорости в точке контакта
		public var accumImpulseN:Number;
		// Накопленный импульс, применяемый для разделения тел в точке контакта. Не создаёт момента.
//		public var accumSepImpulse:Number;
	}
}