package alternativa.gui.controls.text {

    import alternativa.gui.base.GUIobject;
    import alternativa.gui.controls.scrollBar.ScrollBar;
    import alternativa.gui.event.ScrollBarEvent;

    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

    import alternativa.gui.alternativagui;
    use namespace alternativagui;
	
	/**
	 * Базовый класс многострочного текстового поля с возможностью скролла с помощью Scrollbar.
	 * 
	 * @see LabelTF
	 * @see TextInput
	 * @see Label
	 * 
	 */	
    public class TextArea extends GUIobject {
		
		/**
		 * Текстовое поле. 
		 */		
        public var textInput:TextInput;
		
		/**
		 * Скроллбар. 
		 */		
        public var scrollBar:ScrollBar;
		
		/**
		 *  
		 */		
        protected var index:int = 0;
		
		/**
		 * Внутренний отступ.
		 */
        protected var _padding:int = 5;
		
		/**
		 * Ширина скроллбара.
		 */
        protected var scrollBarWidth:int;
		
		/**
		 * Максимальная позиция scrollPosition. 
		 */
        protected var maxScrollPosition:Number = 0;
		
		/**
		 * Флаг фокуса на тексте. 
		 */
        protected var textFocus:Boolean = false;
		
		/**
		 * Флаг наведенения мыщи на скроллбар. 
		 */
        protected var scrollBarOver:Boolean = false;

        public function TextArea() {
            textInput = new TextInput();
            textInput.multiline = true;
            textInput.tf.addEventListener(FocusEvent.FOCUS_IN, focusInTextField);
            textInput.tf.addEventListener(FocusEvent.FOCUS_OUT, focusOutTextField);
            textInput.tf.addEventListener(MouseEvent.MOUSE_OVER, mouseOverTextField);
            textInput.tf.addEventListener(MouseEvent.MOUSE_OUT, mouseOutTextField);
            textInput.tf.addEventListener(KeyboardEvent.KEY_DOWN, keyDownTextField);
            textInput.tf.addEventListener(KeyboardEvent.KEY_UP, keyUpTextField);
            addChild(textInput);
        }
		
		/**
		 * Содержимое текстового поля. 
		 * 
		 */		
        public function get text():String {
            return textInput.text;
        }
        public function set text(value:String):void {
            textInput.text = value;
            draw();
        }
		
		/**
		 * Возможность выделения текста. 
		 * 
		 */		
        public function get selectable():Boolean {
            return textInput.tf.selectable;
        }
        public function set selectable(value:Boolean):void {
            textInput.selectable = value;
            draw();
        }
		
		/**
		 * Создание слушателей скроллбара. 
		 * 
		 */		
        protected function configureScrollBarListeners(_scrollBar:ScrollBar):void {
            _scrollBar.addEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
            _scrollBar.addEventListener(MouseEvent.MOUSE_OVER, mouseOverScrollBar);
            _scrollBar.addEventListener(MouseEvent.MOUSE_OUT, mouseOutScrollBar);
        }
		
		/**
		 * @inheritDoc 
		 * 
		 */		
        override protected function draw():void {
			super.draw();
			redrawGraphiсs();
			if (textInput.tf.length > 0) {
				changeTextField();
			}
		}

		/**
		 *  
		 * Мышь находится на скроллбаре: отключаются слушатели у текстового поля и включаются слушатели скроллбара.
		 * 
		 */		
		protected function mouseOverScrollBar(e:MouseEvent):void {
			scrollBarOver = true;
			if (textFocus) {
				if (!scrollBar.hasEventListener(ScrollBarEvent.SCROLL_CHANGE)) {
					scrollBar.addEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
				}
				if(textInput.tf.hasEventListener(Event.CHANGE)) {
					textInput.tf.removeEventListener(Event.CHANGE, changeTextField);
				}
				if(textInput.tf.hasEventListener(Event.SCROLL)) {
					textInput.tf.removeEventListener(Event.SCROLL, scrollTextField);
				}
			}
		}

		/**
		 *  
		 * Мышь ушла со скроллбара: отключаются слушатели скроллбара и включаются слушатели текстового поля. 
		 * 
		 */
		protected function mouseOutScrollBar(e:MouseEvent):void {
			scrollBarOver = false;
			if (textFocus) {
				if (scrollBar.hasEventListener(ScrollBarEvent.SCROLL_CHANGE)) {
					scrollBar.removeEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
				}
				if(!textInput.tf.hasEventListener(Event.CHANGE)) {
					textInput.tf.addEventListener(Event.CHANGE, changeTextField);
				}
				if(!textInput.tf.hasEventListener(Event.SCROLL)) {
					textInput.tf.addEventListener(Event.SCROLL, scrollTextField);
				}
			}
		}

		/**
		 *  
		 * Мышь находится на текстовом поле: отключаем слушатели скроллбара и включаем слушатель скролла у текстового поля.
		 * 
		 */
		protected function mouseOverTextField(e:MouseEvent):void {
			if(!textFocus) {
				textInput.tf.addEventListener(Event.SCROLL, scrollTextField);
				if (scrollBar.hasEventListener(ScrollBarEvent.SCROLL_CHANGE)) {
					scrollBar.removeEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
				}
			}
		}

		/**
		 * 
		 * Мышь ушла с текстового поля: отключаем слушатель скролла у текстового поля и включаем слушатель скроллбара.
		 * 
		 */		
		protected function mouseOutTextField(e:MouseEvent):void {
			if(!textFocus) {
				if (textInput.tf.hasEventListener(Event.SCROLL)) {
					textInput.tf.removeEventListener(Event.SCROLL, scrollTextField);
				}
				if (!scrollBar.hasEventListener(ScrollBarEvent.SCROLL_CHANGE)) {
					scrollBar.addEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
				}
			}
		}
		
		/**
		 *  
		 * Если фокус на текстовом поле, отключаем слушатели скроллбара. Включаем слушатели текстового пола.
		 * <p><code>textFocus = true</code></p>
		 * 
		 */		
		protected function focusInTextField(e:FocusEvent):void {
			textFocus = true;
			scrollBar.removeEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
			textInput.tf.addEventListener(Event.CHANGE, changeTextField);
			textInput.tf.addEventListener(Event.SCROLL, scrollTextField);
		}

		/**
		 *  
		 * Если убрали фокус с текстового поля, включаем слушатели скроллбара. Отключаем слушатели текстового пола.
		 * <p><code>textFocus = false</code></p>
		 * 
		 */		
		protected function focusOutTextField(e:FocusEvent):void {
			textFocus = false;
			scrollBar.addEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
			textInput.tf.removeEventListener(Event.CHANGE, changeTextField);
			textInput.tf.removeEventListener(Event.SCROLL, scrollTextField);
		}

		/**
		 * 
		 * Если мышь находится над скроллбаром, тогда отключаем слушатели скроллбара и скроллер зависит от позиции курсора в текстовом поле. 
		 * 
		 */	
		protected function keyDownTextField(e:KeyboardEvent):void {
			if (scrollBarOver) {
				if (scrollBar.hasEventListener(ScrollBarEvent.SCROLL_CHANGE)) {
					scrollBar.removeEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
				}
				if(!textInput.tf.hasEventListener(Event.CHANGE)) {
					textInput.tf.removeEventListener(Event.CHANGE, changeTextField);
				}
				if(!textInput.tf.hasEventListener(Event.SCROLL)) {
					textInput.tf.removeEventListener(Event.SCROLL, scrollTextField);
				}
				scrollTextField();
			}
		}
		
		/**
		 * 
		 * Если мышь находится над скроллбаром, тогда отключаем слушатели скроллбара и скроллер зависит от позиции курсора в текстовом поле. 
		 * 
		 */		
		protected function keyUpTextField(e:KeyboardEvent):void {
			if (scrollBarOver) {
				scrollTextField();
				if(textInput.tf.hasEventListener(Event.CHANGE)) {
					textInput.tf.removeEventListener(Event.CHANGE, changeTextField);
				}
				if(textInput.tf.hasEventListener(Event.SCROLL)) {
					textInput.tf.removeEventListener(Event.SCROLL, scrollTextField);
				}
				if (!scrollBar.hasEventListener(ScrollBarEvent.SCROLL_CHANGE)) {
					scrollBar.addEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollText);
				}
			}
		}

		/**
		 * Вызывается при скролировании текстового поля. 
		 * 
		 */		
		protected function scrollTextField(e:Event = null):void {
			var visStrings:int = textInput.tf.bottomScrollV - textInput.tf.scrollV + 1;
			var scrollPosition:int = (textInput.tf.scrollV - 1) * scrollBar.maxScrollPosition / (textInput.tf.numLines - visStrings);
			scrollBar.scrollPosition = scrollPosition;
		}

		/**
		 * 
		 * Вызывается при изменении в текстовом поле.
		 * 
		 */		
		protected function changeTextField(e:Event = null):void {
			maxScrollPosition = textInput.tf.textHeight - textInput.height;

			if (maxScrollPosition >= 0) {
				scrollBar.maxScrollPosition = maxScrollPosition;
			}
			if (textInput.tf.scrollV == textInput.tf.maxScrollV) {
				redrawGraphiсs();
			}
		}

		/**
		 * Прокрутка текста скроллбаром.
		 * 
		 */		
		protected function changeScrollText(e:Event):void {
			var visStrings:int = textInput.tf.bottomScrollV - textInput.tf.scrollV + 1;
			var line:int = scrollBar.scrollPosition * (textInput.tf.numLines - visStrings) / scrollBar.maxScrollPosition;
			textInput.tf.scrollV = line + 1;
		}

		/**
		 * Перерисовка графики: текстовое поле, скроллбар. 
		 * 
		 */		
		protected function redrawGraphiсs():void {

		}
    }
}
