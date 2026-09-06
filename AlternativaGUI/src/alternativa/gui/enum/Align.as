package alternativa.gui.enum {
	
	/**
	 * Задает выравнивание элементов в контейнерах.
	 * 
	 */	
	public class Align {
		
		/**
		 * Задает выравнивание по левой границе.
		 */		
		public static const LEFT:Align = new Align(0);
		
		/**
		 * Задает горизонтальное выравнивание по центру.
		 */
		public static const CENTER:Align = new Align(1);
		
		/**
		 * Задает выравнивание по правой границе.
		 */
		public static const RIGHT:Align = new Align(2);

		/**
		 * Задает выравнивание по верхней границе.
		 */		
		public static const TOP:Align = new Align(3);

		/**
		 * Задает вертикальное выравнивание по центру.
		 */
		public static const MIDDLE:Align = new Align(4);
		
		/**
		 * Задает выравнивание по нижней границе.
		 */
		public static const BOTTOM:Align = new Align(5);
		
		/**
		 * Задает выравнивание по левому верхнему углу. 
		 */		
		public static const TOP_LEFT:Align = new Align(6);

		/**
		 * Задает выравнивание по правому верхнему углу. 
		 */		
		public static const TOP_RIGHT:Align = new Align(7);
		
		/**
		 * Задает выравнивание по левому нижнему углу. 
		 */		
		public static const BOTTOM_LEFT:Align = new Align(8);
		
		/**
		 * Задает выравнивание по правому нижнему углу. 
		 */		
		public static const BOTTOM_RIGHT:Align = new Align(9);
		
		
		public var value:int;
		
		public function Align(value:int) {
			this.value = value;
		}

	}
}