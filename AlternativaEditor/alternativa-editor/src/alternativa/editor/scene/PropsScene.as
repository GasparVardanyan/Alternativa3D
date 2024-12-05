package alternativa.editor.scene {
	import alternativa.editor.prop.Bonus;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.Tile;
	import alternativa.editor.prop.TileSprite3D;
	import alternativa.engine3d.events.MouseEvent3D;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	import alternativa.utils.MathUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import gui.events.PropListEvent;
	
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.controls.CheckBox;
	
	/**
	 * Главная сцена. 
	 * @author danilova
	 */	
	public class PropsScene extends EditorScene {
		
		public var selectedProp:Prop;
		// Выделенные пропы
		public var selectedProps:Set;
		// Индикатор нажатия на проп
		public var propMouseDown:Boolean = false;
		// Индикатор изменений на сцене
		protected var _changed:Boolean = false;
		// Индикатор режима выравнивания по сетке
		public var snapMode:Boolean = true;
		
		private var _texturePanel:TexturePanel;
		private var _propertyPanel:Panel;
		private var bonusPanel:HBox;
		private var checkTypeMap:Map;
		
		private var currentBitmaps:Map;
		
		protected var hideProps:Array = [];
		
		public var allowSelectingTypes:Set = new Set();
		
		public function PropsScene() {
			super();
			occupyMap = new OccupyMap();
			selectedProps = new Set();
			allowSelectingTypes.add("Tile");
			allowSelectingTypes.add("TileSprite3D");
			allowSelectingTypes.add("Spawn");
			allowSelectingTypes.add("Prop");
			allowSelectingTypes.add("Bonus");
			allowSelectingTypes.add("Flag");
			
			
		}
		
		public function get isTexturePanel():Boolean {
			return (_texturePanel.visible && _texturePanel.selectedItem);
		}
		
		/**
		 * @param value
		 */		
		public function set propertyPanel(value:Panel):void {
			_propertyPanel = value;
			createBonusTypePanel();
			_texturePanel = new TexturePanel();
			_texturePanel.addEventListener(PropListEvent.SELECT, onTexturePanelSelect);
			_propertyPanel.addChild(_texturePanel);
			_texturePanel.visible = false;
			_propertyPanel.addChild(bonusPanel);
		}
		
		
		/**
		 * 
		 */		
		public function createBonusTypePanel():void {
			bonusPanel = new HBox();
			bonusPanel.percentWidth = 100;
			bonusPanel.visible = false;
			checkTypeMap = new Map();
			
			var damage:CheckBox = new CheckBox();
			damage.label = "damageup";
			damage.addEventListener(Event.CHANGE, onBonusTypeChange);
			bonusPanel.addChild(damage);
			checkTypeMap.add(damage.label, damage);

			var armor:CheckBox = new CheckBox();
			armor.label = "armorup";
			armor.addEventListener(Event.CHANGE, onBonusTypeChange);
			bonusPanel.addChild(armor);	
			checkTypeMap.add(armor.label, armor);

			var nitro:CheckBox = new CheckBox();
			nitro.label = "nitro";
			nitro.addEventListener(Event.CHANGE, onBonusTypeChange);
			bonusPanel.addChild(nitro);	
			checkTypeMap.add(nitro.label, nitro);
			
			var repkit:CheckBox = new CheckBox();
			repkit.label = "repkit";
			repkit.addEventListener(Event.CHANGE, onBonusTypeChange);
			bonusPanel.addChild(repkit);	
			checkTypeMap.add(repkit.label, repkit);

			var check:CheckBox = new CheckBox();
			check.label = "medkit";
			check.addEventListener(Event.CHANGE, onBonusTypeChange);
			bonusPanel.addChild(check);	
			checkTypeMap.add(check.label, check);
			
			check = new CheckBox();
			check.label = "money";
			check.addEventListener(Event.CHANGE, onBonusTypeChange);
			bonusPanel.addChild(check);
			checkTypeMap.add(check.label, check);

			check = new CheckBox();
			check.label = "crystal";
			check.addEventListener(Event.CHANGE, onBonusTypeChange);
			bonusPanel.addChild(check);
			checkTypeMap.add(check.label, check);
			
		}
		
		public function get changed():Boolean {
			return _changed;
		}
		
		public function set changed(value:Boolean):void {
			_changed = value;
		}
			
		private function getClassName(qualifiedClassName:String):String {
			
			//alternativa.editor.prop::			
			return qualifiedClassName.substr(25);
		}	
		
		private function isAllowClassName(prop:Prop):Boolean {
			
			return allowSelectingTypes.has(getClassName(getQualifiedClassName(prop)));
		}
	
		/**
		 * 
		 */		
		public function getCameraSector():int {
			
			var sector:Number = camera.rotationZ/MathUtils.DEG90 % 4;
			if ((sector >= -0.5 && sector <= 0.5) || (sector <= -3.5)) {
				return 4;
			} else if ((sector >= 0.5 && sector <= 1.5)
				|| (sector >= -3.5 && sector <= -2.5) ) {
				return 1;
			} else if ((sector >= 1.5 && sector <= 2.5) ||
				(sector >= -2.5 && sector <= -1.5)) {
				return 2;
			} else {
				return 3;
			}
			 
		}
		
		/**
		 * Перемещение выделенных пропов. 
		 * @param verticalMoving индикатор вертикального движения
		 */			
		public function moveSelectedProps(verticalMoving:Boolean):void {

			if (selectedProp) {
				var viewPoint:Point = new Point(view.mouseX, view.mouseY);
				var point:Point3D;
				var p:*;
				
				// Стираем с карты
				for (p in selectedProps) {
					occupyMap.free(p as Prop);
				}
			
				var deltaX:Number = 0;
				var deltaY:Number = 0;
				var deltaZ:Number = 0;
					
				if (verticalMoving) {
					var sector:Number = getCameraSector();
					
					if (sector == 2 || sector == 4) {
						point = view.projectViewPointToPlane(viewPoint, ynormal, selectedProp.y);
						deltaX = point.x - selectedProp.x;
						selectedProp.x = point.x;
						
					} else {
						point = view.projectViewPointToPlane(viewPoint, xnormal, selectedProp.x);
						deltaY = point.y - selectedProp.y;
						selectedProp.y = point.y;
							
					}  
					deltaZ = point.z - selectedProp.z;
					selectedProp.z = point.z;
					
				} else {
					point = view.projectViewPointToPlane(viewPoint, znormal, selectedProp.z);
					
					deltaX = point.x - selectedProp.x;
					deltaY = point.y - selectedProp.y;
									
					selectedProp.x = point.x;
					selectedProp.y = point.y;
						
				}
				// Смещаем все выделенные пропы
				for (p in selectedProps) {
					var prop:Prop = p;
					if (prop != selectedProp) {
						prop.x += deltaX;
						prop.y += deltaY;
						prop.z += deltaZ;
					}
					if (snapMode || (prop is Tile && !(prop is TileSprite3D))) {	
						prop.snapCoords();
						occupyMap.occupy(prop);
					}  
				}
				
			}
		}
		
		
		
		/**
		 * Перемещение пропа стрелками. 
		 * @param prop проп
		 * @param keyCode код стрелки
		 * @param sector сектор, на который смотрит камера
		 */		
		override public function moveByArrows(keyCode:uint, sector:int):void {
			
			for (var p:* in selectedProps) {
				var prop:Prop = p;			
				occupyMap.free(prop);
				move(prop, keyCode, sector);
				if (snapMode) {
					prop.snapCoords();
					occupyMap.occupy(prop);
				}
			}
			
		}
		
		/**
		 * Вертикальное перемещение. 
		 * @param down
		 */		
		public function verticalMove(down:Boolean):void {
			var delta:Number = vBase;
			if (down) {
				delta = -delta;
			}
			
			for (var p:* in selectedProps) {
				var prop:Prop = p;
				occupyMap.free(prop);
				prop.z += delta;
				if (snapMode) {
					occupyMap.occupy(prop);
				}
			}
			
		}
		
		
		/**
		 * Клик на проп.  
		 */		
		public function onPropMouseDown(e:MouseEvent3D):void {
			if (!e.ctrlKey) {
				var downProp:Prop = e.object as Prop;
				if (isAllowClassName(downProp)) {
					var selected:Boolean = downProp.selected; 
					if (e.shiftKey) {
						if (e.altKey) {
							if (selected) {
								deselectProp(downProp);
							} 
						} else {
							if (!selected) {
								selectProp(downProp);
							}
						}
					} else {
						
						if (!selected) {
							deselectProps();
							selectProp(downProp);
						} else {
							selectedProp = downProp;
						}
					}
					
					propMouseDown = true;
				}
				
			}
			
		}
		
		private function onPropMouseOut(e:MouseEvent3D):void {

			view.useHandCursor = false;
		}
		
		
		private function onPropMouseOver(e:MouseEvent3D):void {

			view.useHandCursor = true;
		}
		
		
		/**
		 * Отменяет выделение пропов. 
		 */		
		public function deselectProps():void {
			for (var p:* in selectedProps) {
				(p as Prop).deselect();
			}
			selectedProps.clear();
			selectedProp = null;
			
			bonusPanel.visible = false;
			_texturePanel.visible = false;
			
		}
		
		public function deselectProp(prop:Prop):void {

			prop.deselect();
			selectedProps.remove(prop);
			if (prop == selectedProp) {
				selectedProp = null;
			} 
			
//			if (_texturePanel.visible && !noConflictBitmaps()) {
//				_texturePanel.visible = false;
//			} else
			bonusPanel.visible = oneBonusSelected();
			_texturePanel.visible = !bonusPanel.visible && noConflictBitmaps();
		}
		
		/**
		 * Выделение пропа. 
		 * @param prop
		 */		
		public function selectProps(props:Set):void {
			
			deselectProps();
			
			for (var p:* in props) {
				var prop:Prop = p;
				if (isAllowClassName(prop)) {
					prop.select();
					selectedProps.add(prop);
					selectedProp = prop;
				}
				
			}
			
			showPropertyPanel();
			
		}
		
		/**
		 * Выделить конфликтующие пропы. 
		 */		
		public function selectConflictProps():void {
			selectProps(occupyMap.getConflictProps());
		}
		
		public function selectProp(prop:Prop):void {
			if (isAllowClassName(prop)) {
				prop.select();
				selectedProps.add(prop);
				selectedProp = prop;
				showPropertyPanel();
			}
		}
		
		public function getPropsUnderRect(point:Point, dx:Number, dy:Number, select:Boolean):Set {
			var result:Set = new Set();
			for (var child:* in root.children) {
				var prop:Prop = child as Prop;
				if (prop && isAllowClassName(prop)) {
					var view_coords:Point3D = view.projectPoint(prop.coords);
					if (view_coords.x >= point.x && view_coords.x <= point.x + dx 
						&& view_coords.y >= point.y && view_coords.y <= point.y + dy) {
							if (select) { 
								if (!prop.selected) {
									prop.select();
								}
							} else {
								
								if (prop.selected) {
									prop.deselect();
								}
							}						
							result.add(prop);	
						} 
				}
			}
			return result;
			
		}
		
		
		/**
		 * Создание пропа.
		 * @param sourceProp прототип
		 */		
		public function addProp(sourceProp:Prop, coords:Point3D, rotation:Number, copy:Boolean = true, addToMap:Boolean = true):Prop {
			var prop:Prop;
			if (copy) {
				prop = sourceProp.clone() as Prop;
				prop.rotationZ = rotation;
			} else {
				prop = sourceProp;
			}
		
			root.addChild(prop);
			
			if (rotation != 0 && copy) {
				// Расчитывать надо после добавления на сцену
				prop.calculate(); 
			}
			
			// Определяем координаты
			prop.x = coords.x;
			prop.y = coords.y;
			prop.z = coords.z;
			
				
			prop.addEventListener(MouseEvent3D.MOUSE_DOWN, onPropMouseDown);
			prop.addEventListener(MouseEvent3D.MOUSE_OUT, onPropMouseOut);
			prop.addEventListener(MouseEvent3D.MOUSE_OVER, onPropMouseOver);
			_changed = true;
			
			if (snapMode && addToMap) { 
				occupyMap.occupy(prop);
			}
			return prop;
			
		}
		
		/**
		 * Удаление пропа. 
		 * @param prop
		 * @return проп
		 */		
		public function deleteProps(props:Set = null):Set {
				
			if (!props) {
				props = selectedProps;
				selectedProp = null;
			}	
		
			if (props) {
				var result:Set = props.clone();
				for (var p:* in props) {
					var prop:Prop = p;
					root.removeChild(prop);
					occupyMap.free(prop);
					if (selectedProps.has(prop)) {
						deselectProp(prop);
					}
				}
				
//				_propertyPanel.enabled = false;
				bonusPanel.visible = false;
				_texturePanel.visible = false;
				propMouseDown = false;
				_changed = true;
			}
			
			return 	result;
		}
		

		
		/**
		 * Очистка сцены.
		 */		
		public function clear():void {
		
			for (var child:* in root.children) {
				var prop:Prop = child as Prop;
				if (prop) {
					root.removeChild(prop);
				}
			}
			selectedProp = null;
			selectedProps.clear();			
			occupyMap.clear();
			view.interactive = true;
			
		}
		
		
		/**
		 * Смена текстуры.
		 */		
		public function onTexturePanelSelect(e:PropListEvent = null):void {
			
			for (var p:* in selectedProps) {
				var tile:Tile = p;
				if (tile && tile.bitmaps) {
					tile.textureName = _texturePanel.selectedItem;
				}
			} 
			
		}
		
		private function onBonusTypeChange(e:Event):void {
			
			var check:CheckBox = e.target as CheckBox; 
			for (var p:* in selectedProps) {
				var bonus:Bonus = p;
				if (check.selected) {
					bonus.types.add(check.label);
				} else {
					bonus.types.remove(check.label);
				}		
					
			}
			
			
		}	
		
		private function noConflictBitmaps():Map {
			
			var bitmaps:Map;
			for (var p:* in selectedProps) {
				var tile:Tile = p as Tile;
				if (tile && tile.bitmaps) {
					if (!bitmaps) {
						bitmaps = tile.bitmaps;
					} else {
						if (bitmaps != tile.bitmaps) {
							return null;
						} 
					
					}	
				}
			}
			
			return bitmaps;
		}
	
		private function oneBonusSelected():Boolean {
			
			if (selectedProps.length > 1) {
				return false;
			}
			
			var bonus:Bonus = selectedProps.peek() as Bonus;
			if (!bonus) {
				return false;	
			}
			
			return true;

		}	
		public function showPropertyPanel():void {
			
			bonusPanel.visible = oneBonusSelected();
			if (bonusPanel.visible) {
				var types:Set = (selectedProps.peek() as Bonus).types;
				
				for (var type:* in checkTypeMap) {
					(checkTypeMap[type] as CheckBox).selected = types.has(type);   
				}
				
			} else {
				var bitmaps:Map = noConflictBitmaps(); 
				if (bitmaps) {
					_texturePanel.visible = true;
					
					if (bitmaps != currentBitmaps) {
						_texturePanel.deleteAllProps();
						_texturePanel.selectedItem = null;
						for (var key:* in bitmaps) {
							var bitmapData:BitmapData = bitmaps[key];
							var bitmap:Bitmap = new Bitmap(bitmapData);
							_texturePanel.addItem(key, bitmap, key);
						} 
						currentBitmaps = bitmaps;
					}
				}
			
//				_texturePanel.visible = true;
			}
				
		}
		
		public function mirrorTextures():void {
			for (var p:* in selectedProps) {
				var tile:Tile = p as Tile;
				if (tile != null) tile.mirrorTexture();
			}
		}
	
		/**
		 * 
		 */		
		public function hideSelectedProps():void {
			
			var props:Set = selectedProps.clone();
			deselectProps();
			for (var p:* in props) {
				var prop:Prop = p;
				hideProps.push(prop);
				if (!prop.free) {
					occupyMap.free(prop);
					prop.free = true;
				}
				root.removeChild(prop);
				calculate();
			}
		}
		
		/**
		 * 
		 */		
		public function showAll():void {
			var len:int = hideProps.length;
			for (var i:int = 0; i < len; i++) {
				var prop:Prop = hideProps[i]; 
				root.addChild(prop);
				if (prop.free) {
					occupyMap.occupy(prop);
				}
				calculate();
			} 
			
			hideProps.length = 0;
		}
			
		
		
		override public function getCentrePropsGroup(props:Set = null):Point {
			if (!props) {
				props = selectedProps;
			} 
			
			 return super.getCentrePropsGroup(props);
			
		}
		
		override public function rotateProps(plus:Boolean, props:Set = null):void {
			if (!props) {
				props = selectedProps;
			} 
			
			var centre:Point = getCentrePropsGroup(props);
			
			for (var p:* in props) {
				var prop:Prop = p;
				occupyMap.free(prop);
				
				var x:Number = prop.x;
				var y:Number = prop.y;
				if (plus) {
					prop.x = y + centre.x - centre.y;
					prop.y = -x + centre.y + centre.x;
				} else {
					prop.x = -y + centre.x + centre.y;
					prop.y = x + centre.y - centre.x;
				} 
				
				prop.rotate(plus);
				if (snapMode) {
					prop.snapCoords();
					occupyMap.occupy(prop);
				}
			}
			
			_changed = true;
		}
		
		
	}
}