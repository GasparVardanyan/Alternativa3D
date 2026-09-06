package flat.listbox {
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import flat.CustomTextureMaterial;
		
	/**
	 * Листбокс с текстурами.
	 */ 
	public class TextureListBox extends Sprite {	
		
		protected const SLOT_WIDTH:Number = 75;
		protected const SLOT_HEIGHT:Number = 75;	
		// Отступ от края бокса	
		private const BOUND_WIDTH:int = 5;
		// Отступ от края слота	
		private const SLOT_BOUND_WIDTH:int = 5;
		// Материал, вызвавший листбокс
		private var currentMaterial:CustomTextureMaterial;
		// Индикатор клика
		private var flgSlotClick:Boolean = false;
		// Битмап по выделенный элемент
		private var selectBitmap:Bitmap = new bmpSelect();
		// Список слотов 
		protected var slots:Array = new Array();
			
		[Embed(source="textures/window.png")] private static const bmpBackground:Class;
		private var backgroundBitmap:Bitmap = new bmpBackground();
		[Embed(source="textures/frame.png")] private static const bmpSelect:Class;
		
			
		public function TextureListBox() {
			addChild(backgroundBitmap);
			
			backgroundBitmap.x = 0;
			backgroundBitmap.y = 0;

			// Заготовим 9 слотов
			createSlots();
			visible = false;

			// Битмап под выделенный элемент
			selectBitmap.width = SLOT_WIDTH + 2*BOUND_WIDTH;
			selectBitmap.height = SLOT_HEIGHT + 2*BOUND_WIDTH;
			selectBitmap.visible = false;
			addChild(selectBitmap);
			selectBitmap.blendMode = BlendMode.MULTIPLY;
		}
		
		/**
		 * Создание слотов.
		 */
		private function createSlots():void {
			
			for (var i:int = 0; i < 9; i++){
				var slot:Sprite = new Sprite();
				
				var div:int = i/3;
				var mod:int = i - 3*div;
				
				switch (div){
					case 0:
						slot.y = BOUND_WIDTH + SLOT_BOUND_WIDTH;		
						break;
					case 1:
						slot.y = BOUND_WIDTH + 3*SLOT_BOUND_WIDTH + SLOT_HEIGHT; 
						break;
					case 2:
						slot.y = BOUND_WIDTH + 5*SLOT_BOUND_WIDTH + 2*SLOT_HEIGHT  
						break;			
				}
				
				switch (mod){
					case 0:
						slot.x = BOUND_WIDTH + SLOT_BOUND_WIDTH;		
						break;
					case 1:
						slot.x = BOUND_WIDTH + 3*SLOT_BOUND_WIDTH + SLOT_WIDTH; 
						break;
					case 2:
						slot.x = BOUND_WIDTH + 5*SLOT_BOUND_WIDTH + 2*SLOT_WIDTH;  
						break;			
				}
				// Установка необходимых обработчиков
				slot.addEventListener(MouseEvent.MOUSE_UP, onSlotMouseUp);
				slot.addEventListener(MouseEvent.MOUSE_MOVE, onSlotMouseMove);
				slot.addEventListener(MouseEvent.MOUSE_DOWN, onSlotMouseDown);
				
				addChild(slot);
				slots[i] =  slot;
				
			}
						
		}
	
		/**
		 * Обработка клика на слот 
		 */		
		private function onSlotMouseUp(event:MouseEvent):void {
			
			// Проверка на клик
			if (flgSlotClick) { 
				if ((event.target as Sprite).numChildren > 0) {
					// Определяем выбранную дифузу
					var child:Bitmap = (event.target as Sprite).getChildAt(0) as Bitmap;
					// Обновляем материал
					currentMaterial.updateDiffuse(child.bitmapData);
				}
			}
			
		}
		private function onSlotMouseMove(event:MouseEvent):void {
			
			flgSlotClick = false;
		}
		
		private function onSlotMouseDown(event:MouseEvent): void {
			
			flgSlotClick = true;
		}
		
		/**
		 *  Показать листбокс.
		 * @param material материал, для которого выбирается дифуза
		 */		 
		public function show(material:CustomTextureMaterial):void {
			
			// Выделим слот с дифузой материала
			var len:int = slots.length;
			for (var i:int = 0; i < len; i++) {
				if (slots[i].numChildren > 0) {
					var child:Bitmap = slots[i].getChildAt(0) as Bitmap;
					if (child.bitmapData == material.diffuse) {
						select(i);
						break;						
					}
				}
			}
			//
			currentMaterial = material;
			visible = true;
					
		}
		
		/**
		 * Выделить слот.
		 * @param index - индекс слота в списке слотов 
		 */ 		
		public function select(index:int):void {
			
			selectBitmap.visible = true;
			selectBitmap.x = slots[index].x - BOUND_WIDTH;
			selectBitmap.y = slots[index].y - BOUND_WIDTH;	
				
		}
		
		/**
		 *  Скрыть листбокс.
		 */ 
		public function hide():void {
			
			visible = false;
			selectBitmap.visible = false;

		}

	}
}