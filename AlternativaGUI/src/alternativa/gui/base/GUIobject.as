package alternativa.gui.base {

	import alternativa.gui.alternativagui;
	
	import flash.display.Sprite;
	use namespace alternativagui;

	/**
	 * Базовый визуальный объект.
	 * 
	 */
	public class GUIobject extends Sprite {

		alternativagui var _width:int;
		alternativagui var _height:int;

		/**
		 * Флаг заморозки расчетов по высоте. 
		 */				
		protected var _freezeHeight:Boolean = false;
		/**
		 * Флаг заморозки расчетов по ширине. 
		 */
		protected var _freezeWidth:Boolean = false;
		
		
		public function GUIobject() {
			mouseEnabled = false;
			tabEnabled = false;
		}

		/**
		 * Позиционирование и задание размеров данному объекту и дочерним объектам.
		 * <p>Вызывается при обращении к width, height, resize</p>
		 * @see #width 
		 * @see #height 
		 * @see #resize 
		 */
		protected function draw():void {
		/*graphics.clear();
		graphics.beginFill(0x777777, 0.5);
		graphics.drawRect(0, 0, _width, _height);*/
		}
			
		/**
		 * Отрисовка визуальной части объекта. Данный метод вызывается из RedrawManager, после ресайза сцены. 
		 * <p>Все действия, связанные с отрисовкой: <code>beginFill()</code>, <code>beginBitmapFill()</code>, <code>beginGradientFill</code> и вычисление матриц, должны описываться в этом методе.</p> 
		 * 
		 */		
		public function drawGraphics():void {
			
		}
		
		
		/**
		 * Принудительная отрисовка самого объекта и дочерних объектов.
		 * <p>Вначале вызывается <code>drawGraphics()</code>, потом у дочерних объектов <code>drawChildren()</code>.</p> 
		 * 
		 */		
		public function drawChildren():void {
			drawGraphics();
			var object:GUIobject;
			var length:int = this.numChildren;
			for (var i:int = 0; i < length; i++) {
				object = this.getChildAt(i) as GUIobject;
				if (object != null) {
					object.drawChildren();
				}
			}
		}
		
		/**
		 * Вычисление ширины. 
		 * @param value
		 * @return Значение ширины.
		 * 
		 */		
		protected function calculateWidth(value:int):int {
			return value;
		}

		/**
		 * Вычисление высоты. 
		 * @param value
		 * @return Значение высоты.
		 * 
		 */		
		protected function calculateHeight(value:int):int {
			return value;
		}

		/**
		 * Указывает ширину объекта, после этого происходит вызов <code>calculateWidth</code>, затем <code>draw()</code>, если <code>freezeWidth = false</code>;
		 * @param value Ширина.
		 * @return
		 *
		 */
		override public function get width():Number {
			return _width;
		}
		override public function set width(value:Number):void {
			if (!_freezeWidth) {
				_width = calculateWidth(value);
				draw();
			}
		}

		/**
		 * Указывает высоту объекта, после этого происходит вызов <code>calculateHeight</code>, затем <code>draw()</code>, если <code>freezeHeight = false</code>;
		 * @param value Высота.
		 * @return
		 *
		 */
		override public function get height():Number {
			return _height;
		}
		override public function set height(value:Number):void {
			if (!_freezeHeight) {
				_height = calculateHeight(value);
				draw();
			}
		}

		/**
		 * Одновременное изменение размеров. Если freezeWidth=true и freezeHeight=true, то метод draw() не вызывается. 
		 * @param width Ширина.
		 * @param height Высота.
		 */
		public function resize(width:int, height:int):void {
			if (!_freezeWidth) {
				_width = calculateWidth(width);
			}
			if (!_freezeHeight) {
				_height = calculateHeight(height);
			}
			if (!_freezeWidth || !_freezeHeight) {
				draw();
			}
		}

		


		public function get freezeHeight():Boolean
		{
			return _freezeHeight;
		}
		/**
		 * Флаг заморозки расчетов по высоте. 
		 */
		public function set freezeHeight(value:Boolean):void
		{
			_freezeHeight = value;
		}

		public function get freezeWidth():Boolean
		{
			return _freezeWidth;
		}
		/**
		 * Флаг заморозки расчетов по ширине. 
		 */
		public function set freezeWidth(value:Boolean):void
		{
			_freezeWidth = value;
		}


	}
}
