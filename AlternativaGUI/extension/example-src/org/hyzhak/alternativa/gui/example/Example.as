package org.hyzhak.alternativa.gui.example
{
	import alternativa.gui.container.linear.HBox;
	import alternativa.gui.container.linear.VBox;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.MouseManager;
	import alternativa.gui.theme.defaulttheme.controls.buttons.Button;
	import alternativa.gui.theme.defaulttheme.init.DefaultTheme;
	import alternativa.gui.theme.defaulttheme.primitives.base.Hint;
	import alternativa.gui.theme.defaulttheme.skin.Cursors;
	import alternativa.init.GUI;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.hyzhak.alternativa.gui.extension.ExtendedTabPanel;
	
	
	/**
	 * 
	 * @project	Project AlternativaGUI Extension
	 * 
	 * @data	Mar 11, 2012 / 10:03:42 PM
	 * 
	 * @author	Eugene Krevents aka Hyzhak 
	 * 
	 */
	
	public class Example extends Sprite
	{
		
		//----------------------------------
		//  constants
		//----------------------------------
		
		//----------------------------------
		//  params 
		//----------------------------------
		
		private var _objectContainer:Sprite;
		private var hintContainer:Sprite;
		
		//----------------------------------
		//  constructor 
		//----------------------------------
		private var _panel:ExtendedTabPanel;
		private var _addButton:DisplayObject;
		private var _removeButton:DisplayObject;
		
		public function Example()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.quality = StageQuality.HIGH;
			
			this.mouseEnabled = false;
			this.tabEnabled = false;
			
			// Контейнер с объектами
			_objectContainer = new Sprite();
			_objectContainer.mouseEnabled = false;
			_objectContainer.tabEnabled = false;
			addChild(_objectContainer);
			
			// Контейнер для хинта
			hintContainer = new Sprite();
			hintContainer.mouseEnabled = false;
			hintContainer.tabEnabled = false;
			addChild(hintContainer);
			
			// Инициализация AlternativaGUIDefaultTheme
			DefaultTheme.init();
			
			// Инициализация AlternativaGUI
			GUI.init(stage, hintContainer, false);
			
			// Инициализация LayoutManager 
			LayoutManager.minStageHeight = 1;
			LayoutManager.minStageWidth = 1;
			LayoutManager.init(stage, [_objectContainer, hintContainer]);
			
			var view : DisplayObject = 
				buildVLayout(
					buildHLayout(
						_addButton = buildButton("add tab"),
						_removeButton = buildButton("remove tab")
					),
					_panel = buildTabPanel()
				);
			
				
			_addButton.addEventListener(MouseEvent.CLICK, onAddButton);
			_removeButton.addEventListener(MouseEvent.CLICK, onRemoveButton);
			
			_objectContainer.addChild(view);
		}
		
		protected function onAddButton(event:Event):void
		{
			var newPanel : MyPanel = new MyPanel();
			_panel.addTabPanel(newPanel, newPanel.name);
		}
		
		protected function onRemoveButton(event:Event):void
		{
			_panel.removeTabAt(_panel.selectTab);
		}
		
		private function buildButton(label : String) : DisplayObject
		{
			var btn : Button = new Button();
			btn.label = label;
			btn.width = 100;
			return btn;
		}
		
		private function buildHLayout(...args) : DisplayObject		
		{
			var v : HBox = new HBox(4);
	
			for each(var child : DisplayObject in args)
			{
				v.addChild(child);
			}
			
			v.update();
			
			return v;
		}
		
		private function buildVLayout(...args) : DisplayObject
		{
			var v : VBox = new VBox(4); 
			
			for each(var child : DisplayObject in args)
			{
				v.addChild(child);
			}
			
			v.update();
			
			return v;
		}	
		
		private function buildTabPanel() : ExtendedTabPanel
		{
			var v:ExtendedTabPanel = new ExtendedTabPanel();
			v.width = 400;
			v.height = 400;
			return v;
		}
	}
}