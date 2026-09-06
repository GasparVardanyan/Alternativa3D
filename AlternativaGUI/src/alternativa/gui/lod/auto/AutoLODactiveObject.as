package alternativa.gui.lod.auto {
	import alternativa.gui.base.ActiveObject;
	import alternativa.gui.lod.auto.IAutoLODobject;
	
	/**
	 * Лодируемый объект с поддержкой мышиных событий, выбирающий лод в зависимости от заданных ему размеров.
	 * 
	 */	
	public class AutoLODactiveObject extends ActiveObject implements IAutoLODobject {
		
		/**
		 * Границы вертикальных интервалов. 
		 */		
		protected var limitsV:Vector.<int>;
		
		/**
		 * Границы горизонтальных интервалов в зависимости от выбранного вертикального интервала. 
		 */		
		protected var limitsH:Vector.<Vector.<int>>;
		
		/**
		 * Индекс вертикального лода. 
		 */		
		protected var indexV:int;
		
		/**
		 * Индекс горизонтального лода. 
		 */		
		protected var indexH:int;
		
		import alternativa.gui.alternativagui;
		use namespace alternativagui;
		
		public function AutoLODactiveObject() {
			limitsV = new Vector.<int>();
			limitsH = new Vector.<Vector.<int>>();
		}
		
		/**
		 * Выбирается интервал, который попадает в заданный размер.
		 * @param limits Границы интервалов.
		 * @param value Размер. 
		 * @return Индекс интервала.
		 * 
		 */		
		protected function getIntervalIndex(limits:Vector.<int>, value:int):int {
			var index:int = 0;
			if (limits.length > 0) {
				if (value < limits[0]) {
					for (var i:int = limits.length-1; i >= 0; i--) {
						if (value < limits[i]) {
							index = i+1;
							break;
						}
					}
				}
			}
			return index;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set width(value:Number):void {
			_width = value;
			
			if (limitsH != null && limitsH.length > 0) {
				indexH = getIntervalIndex(limitsH[indexV], _width);
			}
			draw();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set height(value:Number):void {
			_height = value;
			
			if (limitsV != null && limitsV.length > 0) {
				indexV = getIntervalIndex(limitsV, _height);
				
				if (limitsH != null && limitsH.length > 0) {
				 	if (limitsH[indexV] != null) {
						indexH = getIntervalIndex(limitsH[indexV], _width);
					} else {
						indexH = 0;
					}
				}
			}
			draw();
		}
		
		//----- IAutoLODobject
		/**
		 * @inheritDoc
		 * 
		 */	
		public function get LODlimitsV():Vector.<int> {
			return limitsV;
		}
		public function set LODlimitsV(value:Vector.<int>):void {
			limitsV = value;
			draw();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */			
		public function get LODlimitsH():Vector.<Vector.<int>> {
			return limitsH;
		}
		public function set LODlimitsH(value:Vector.<Vector.<int>>):void {
			limitsH = value;
			draw();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */			
		public function get LODindexH():int {
			return indexH;
		}
		public function set LODindexH(index:int):void {
			indexH = index;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */	
		public function get LODindexV():int {
			return indexV;
		}
		public function set LODindexV(index:int):void {
			indexV = index;
		}

	}
}