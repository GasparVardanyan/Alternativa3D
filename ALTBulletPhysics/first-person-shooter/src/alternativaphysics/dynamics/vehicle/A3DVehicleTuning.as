package alternativaphysics.dynamics.vehicle {

	/** 
	* Класс-настроек транспортного средства.
	* @public 
	* @author redefy 
	*/
	public class A3DVehicleTuning {

		/** 
		* Жесткость подвески.
		* @public 
		*/
		public var suspensionStiffness : Number;

		/** 
		* Коэффицент ослабления сжатия подвески. ????
		* @public 
		*/
		public var suspensionCompression : Number;

		/** 
		* Коэффицент ослабления разжимания подвески. ?????
		* @public 
		*/
		public var suspensionDamping : Number;

		/** 
		* Максимальная дистанция на которою может сжаться подвеска.
		* @public 
		*/
		public var maxSuspensionTravelCm : Number;

		/** 
		* Коэффициент трения между покрышками и землей.
		* @public 
		*/
		public var frictionSlip : Number;

		/** 
		* 
		* @public 
		*/
		public var maxSuspensionForce : Number;


		/** 
		* Конструктор.
		* @public 
		*/
		public function A3DVehicleTuning() {
			suspensionStiffness = 5.88;
			suspensionCompression = 0.83;
			suspensionDamping = 0.88;
			maxSuspensionTravelCm = 500;
			frictionSlip = 10.5;
			maxSuspensionForce = 6000;
		}
	}
}