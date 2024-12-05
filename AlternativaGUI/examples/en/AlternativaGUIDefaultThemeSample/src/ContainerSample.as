package {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.container.linear.RelativeVBox;
	import alternativa.gui.container.linear.VBox;
	import alternativa.gui.container.tabPanel.TabData;
	import alternativa.gui.controls.button.RadioButtonGroup;
	import alternativa.gui.data.DataProvider;
	import alternativa.gui.enum.Align;
	import alternativa.gui.event.ListEvent;
	import alternativa.gui.event.RadioButtonGroupEvent;
	import alternativa.gui.event.RolloutEvent;
	import alternativa.gui.event.SliderEvent;
	import alternativa.gui.event.TabPanelEvent;
	import alternativa.gui.layout.IStageSizeListener;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.theme.defaulttheme.container.list.List;
	import alternativa.gui.theme.defaulttheme.container.list.ListObject;
	import alternativa.gui.theme.defaulttheme.container.panel.Panel;
	import alternativa.gui.theme.defaulttheme.container.rollout.Rollout;
	import alternativa.gui.theme.defaulttheme.container.tabPanel.TabButton;
	import alternativa.gui.theme.defaulttheme.container.tabPanel.TabPanel;
	import alternativa.gui.theme.defaulttheme.controls.buttons.Button;
	import alternativa.gui.theme.defaulttheme.controls.buttons.CheckBox;
	import alternativa.gui.theme.defaulttheme.controls.buttons.RadioButton;
	import alternativa.gui.theme.defaulttheme.controls.buttons.SmallButton;
	import alternativa.gui.theme.defaulttheme.controls.buttons.ToggleButton;
	import alternativa.gui.theme.defaulttheme.controls.dropDownList.DropDownList;
	import alternativa.gui.theme.defaulttheme.controls.dropDownMenu.DropDownMenu;
	import alternativa.gui.theme.defaulttheme.controls.numericStepper.NumericStepper;
	import alternativa.gui.theme.defaulttheme.controls.slider.Slider;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.controls.text.TextArea;
	import alternativa.gui.theme.defaulttheme.controls.text.TextInput;
	import alternativa.gui.theme.defaulttheme.controls.tree.Tree;
	import alternativa.gui.theme.defaulttheme.event.PanelEvent;
	import alternativa.gui.theme.defaulttheme.primitives.base.ProgressBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	use namespace alternativagui;

	/**
	 *  
	 * Components container
	 * 
	 */	
	public class ContainerSample extends GUIobject implements IStageSizeListener {
		
		private var leftPanel:Panel;
		
		private var rightPanel:Panel;
		
		private var padding:int = 25;
		
		private var vBox:VBox;
		
		private var relativeVBox:RelativeVBox;

		private var textInput:TextInput;
		
		private var dropDownList:DropDownList;

		private var list:List;

		private var tree:Tree;

		private var progressBar:ProgressBar;

		private var percent:Number = 0;

		private var tabPanel:TabPanel;

		private var dropDownMenu:DropDownMenu;

		public function ContainerSample() {

			var i:int = 0;

            // Data provider for drop-down menu
			var dropDownMenuDataProvider:DataProvider = new DataProvider();
			for (i = 0; i < 6; i++) {
				var object:Object = {};
				object.id = i + 1;
				object.label = object.id + ' item';
				object.items = new DataProvider();
				dropDownMenuDataProvider.addItem(object)
				for (j = 0; j < 10; j++) {
					var object1:Object = {};
					object1.id = object.id + 1 + '.' + j;
					object1.label = object1.id + ' item';
					object1.items = new DataProvider();
					object1.parent = object;
					object.items.addItem(object1);
					for (var k:int = 0; k < 10; k++) {
						var object2:Object = {};
						object2.id = object1.id + 1 + '.' + k;
						object2.label = object2.id + ' item';
						object2.items = new DataProvider();
						object2.parent = object1;
						object1.items.addItem(object2);
					}
				}
			}

            // drop-down menu
			dropDownMenu = new DropDownMenu();
			addChild(dropDownMenu);
			dropDownMenu.dataProvider = dropDownMenuDataProvider;


            // create a left panel
			leftPanel = new Panel();
			leftPanel.title = "Left Panel"
			leftPanel.closeButtonShow = true;
			leftPanel.addEventListener(PanelEvent.MOUSE_UP, leftPanel_MOUSE_UPHandler);
			leftPanel.addEventListener(PanelEvent.MOUSE_DOWN, leftPanel_MOUSE_DOWNHandler);
			leftPanel.addEventListener(PanelEvent.CLOSE, leftPanel_CLOSEHandler);
			addChild(leftPanel);
			
            // create a right panel
			rightPanel = new Panel();
			rightPanel.title = "Right Panel"
			rightPanel.addEventListener(PanelEvent.MOUSE_UP, leftPanel_MOUSE_UPHandler);
			rightPanel.addEventListener(PanelEvent.MOUSE_DOWN, leftPanel_MOUSE_DOWNHandler);
			addChild(rightPanel);

            // create a tab panel
			tabPanel = new TabPanel();
			textInput = new TextInput();

            // group for the radioButtons
			var radioButtonGroup:RadioButtonGroup = new RadioButtonGroup();

            // group for the toggleButtons
			var toggleButtonGroup:RadioButtonGroup = new RadioButtonGroup();

            // create a verical container and specify the distance between items
			vBox = new VBox(5);
			vBox.align = Align.LEFT;
			
            // create a label
			var label:Label = new Label();
			label.text = "Class Button:"
			vBox.addChild(label);
			
			for (i = 0; i < 3; i++) {
				var button:Button = new Button();
				button.label = "Button " + String(i);
				button.hint = "Button " + String(i);
				button.icon = getIcon();
				button.addEventListener(MouseEvent.CLICK, button_clickHandler)
				vBox.addChild(button);
			}

			label = new Label();
			label.text = "Class SmallButton:"
			vBox.addChild(label);

			for (i = 0; i < 3; i++) {
				var smallButton:SmallButton = new SmallButton();
				smallButton.label = "SmallButton " + String(i);
				smallButton.hint = "SmallButton " + String(i);
				smallButton.addEventListener(MouseEvent.CLICK, button_clickHandler)
				vBox.addChild(smallButton);
			}

			label = new Label();
			label.text = "Class RadioButton:"
			vBox.addChild(label);
			var b:RadioButton;
			for (i = 0; i < 4; i++) {
				var radioButton:RadioButton = new RadioButton();
				radioButton.label = "RadioButton: " + String(i);
				radioButton.name = "RadioButton: " + String(i);
				radioButtonGroup.addButton(radioButton);
				vBox.addChild(radioButton);
				if (i == 2) {
					b = radioButton;
				}
			}
			radioButtonGroup.buttonSelected(b);
			label = new Label();
			label.text = "Class ToggleButton:"
			vBox.addChild(label);

			for (i = 0; i < 4; i++) {
				var toggleButton:ToggleButton = new ToggleButton();
				toggleButton.label = "ToggleButton: " + String(i);
				toggleButton.name = "ToggleButton: " + String(i);
				toggleButtonGroup.addButton(toggleButton);
				vBox.addChild(toggleButton);
				if (i == 1) {
					toggleButton.locked = true;
				}
				if (i == 2) {
					toggleButton.selected = true;
				}
			}


			label = new Label();
			label.text = "Class CheckBox:"
			vBox.addChild(label);

			for (i = 0; i < 5; i++) {
				var formsCheckBox:CheckBox = new CheckBox();
				formsCheckBox.label = "CheckBox: " + String(i);
				vBox.addChild(formsCheckBox);
				if (i == 2) {
					formsCheckBox.locked = true;
				}
				if (i == 1) {
					formsCheckBox.checked = true;
				}
			}

			var tabButton:TabButton = new TabButton();
			tabButton.label = "Buttons";
			tabPanel.addTab(new TabData(tabButton, vBox));

            // container for text components
			vBox = new VBox(5);
			vBox.align = Align.LEFT;

			textInput.text = "TextInput";
			vBox.addChild(textInput);

			var textInput2:TextInput = new TextInput();
			textInput2.text = "TextInput with Label";
			textInput2.labelText = "Label:";
			textInput2.labelMargin = 10;
			vBox.addChild(textInput2);

			label = new Label();
			label.text = "Class NumericStepper:"
			vBox.addChild(label);

			var numericStepper:NumericStepper = new NumericStepper(0,10,1);
			vBox.addChild(numericStepper);

			tabButton = new TabButton();
			tabButton.label = "Text";
			tabPanel.addTab(new TabData(tabButton, vBox));

            // container for slider
			vBox = new VBox(5);
			vBox.align = Align.LEFT;

			var slider:Slider = new Slider(20, 0, 1);
			vBox.addChild(slider);

			var slider2:Slider = new Slider(10, 0, 1);
			slider2.hints = ["Custom hint 1","Custom hint 2","Custom hint 3","Custom hint 4","Custom hint 5","Custom hint 6","Custom hint 7","Custom hint 8","Custom hint 9","Custom hint 10"];
			vBox.addChild(slider2);

			tabButton = new TabButton();
			tabButton.label = "Slider";
			tabPanel.addTab(new TabData(tabButton, vBox));

            // create rollout panel
			var buttonVBox:VBox;
			vBox = new VBox(5);
			vBox.align = Align.LEFT;
			var rollout:Rollout;
			for (var j:int = 0; j < 2; j++) {
				rollout = new Rollout();
				rollout.label = "Buttons " + String(j);
				buttonVBox = new VBox(5);
				buttonVBox.iterationsNum = 0;
				for (i = 0; i < 5; i++) {
					var but:Button = new Button();
					but.label = "Rollout: " + String(j) + " But: " + String(i);
					buttonVBox.addChild(but);
				}
				rollout.content = buttonVBox;
				rollout.addEventListener(RolloutEvent.MINIMIZE, rollout_RolloutEventMimimizeHandler);
				rollout.addEventListener(RolloutEvent.MAXIMIZE, rollout_RolloutEventMimimizeHandler);
				vBox.addChild(rollout);
			}
			tabButton = new TabButton();
			tabButton.label = "Rollout";
			tabPanel.addTab(new TabData(tabButton, vBox));


			var dragConteiner:DragContainer = new DragContainer();
			tabButton = new TabButton();
			tabButton.label = "Drag and Drop";
			tabPanel.addTab(new TabData(tabButton, dragConteiner));

			tabPanel.addEventListener(TabPanelEvent.SELECTED, tabButton_SELECTEDHandler);

			leftPanel.content = tabPanel;


            // create DropDownList and fill it by data
			var dropDownDataProvider:DataProvider = new DataProvider();
			var obj:Object;
			for (i = 0; i < 50; i++) {
				obj = new Object();
				obj.label = String(i) + " DropDownObject id: " + String(i);
				obj.icon = getIcon();
				dropDownDataProvider.addItem(obj);
			}


            // create List and fill it by data
			dropDownList = new DropDownList();
			dropDownList.container = stage;

			dropDownList.dataProvider = dropDownDataProvider;
			dropDownList.selectedIndex = 2;

			var listDataProvider:DataProvider = new DataProvider();
			for (i = 0; i < 50; i++) {
				obj = new Object();
				obj.label = String(i) + " ListObject id: " + String(i);
				obj.icon = getIcon();
				listDataProvider.addItem(obj);
			}


			list = new List();
			list.itemRenderer = ListObject;
			list.dataProvider = listDataProvider;
			list.selectedIndex = 2;
//
//
            // create Tree and fill it by data
			var treeDataProvider:DataProvider = new DataProvider();
			/** fields of dataProvider:
			 * id
			 * parentId
			 * label
			 * icon
			 * opened
			 * level - the nesting level
			 * hasChildren
			 * canExpand
			 **/
			for (i = 0; i < 3; i++) {
				obj = new Object();
				obj.parentId = null;
				obj.label = String(i) + "text: " + String(i);
				obj.opened = false;
				obj.level = 0;
				obj.hasChildren = true;
				obj.canExpand = true;
				treeDataProvider.addItem(obj );
				for (j = 0; j < 2; j++) {
					var obj1:Object = new Object();
					obj1.parentId = String(i);
					obj1.label = "id: " + String(j) + " parentId: " + String(i);
					obj1.opened = false;
					obj1.level = 1;
					obj1.hasChildren = true;
					obj1.canExpand = true;
					treeDataProvider.addItem(obj1);
					for (k = 0; k < 10; k++) {
						var obj2:Object = new Object();
						obj2.parentId = String(i) + String(j);
						obj2.label = "id: " + String(k) + " p: " + String(j) + " pId: " + String(i);
						obj2.opened = false;
						obj2.level = 2;
						obj2.hasChildren = false;
						obj2.canExpand = true;
						treeDataProvider.addItem(obj2);
					}
					for (var p:int = 0; p < 5; p++) {
						var obj7:Object = new Object();
						obj7.parentId = String(i) + String(j);
						obj7.label = "file id: " + String(p) + " p: " + String(j) + " pId: " + String(i);
						obj7.opened = false;
						obj7.level = 2;
						obj7.hasChildren = false;
						obj7.canExpand = false;
						treeDataProvider.addItem(obj7);
					}
				}
			}
			for (var a:int = 3; a < 6; a++) {
				obj = new Object();
				obj.parentId = null;
				obj.label = String(a) + "text: " + String(a);
				obj.opened = false;
				obj.level = 0;
				obj.hasChildren = false;
				obj.canExpand = false;
				treeDataProvider.addItem(obj);
			}
			tree = new Tree();
			tree.dataProvider = treeDataProvider;
			dropDownList.height = 1;

			var textArea:TextArea = new TextArea();
			textArea.selectable
			progressBar = new ProgressBar();
			progressBar.height = 1;

			var timerPB:Timer = new Timer(300);
			timerPB.addEventListener(TimerEvent.TIMER, timerPB_timerHandler);

			var relativeVBox:RelativeVBox = new RelativeVBox([dropDownList.height, 0.3, -1, 0.3, progressBar.height], 15);

			relativeVBox.addChild(dropDownList);
			relativeVBox.addChild(tree);
			relativeVBox.addChild(list);
			relativeVBox.addChild(textArea);
			relativeVBox.addChild(progressBar);

			rightPanel.content = relativeVBox;
			
            // Add listener for the RadioGroup change event
			radioButtonGroup.addEventListener(RadioButtonGroupEvent.SELECTED, RadioButtonGroupSelectedHandler);
			toggleButtonGroup.addEventListener(RadioButtonGroupEvent.SELECTED, RadioButtonGroupSelectedHandler);
			
            // slider changes
			slider.addEventListener(SliderEvent.CHANGE_POSITION, SliderChangePosHandler);
			slider2.addEventListener(SliderEvent.CHANGE_POSITION, SliderChangePosHandler);
			
            // Add listener for the dropDownList change event
			dropDownList.addEventListener(ListEvent.LIST_CHANGE, dropDownListSelect);
			
            // select List item
			list.addEventListener(ListEvent.CLICK_ITEM, listSelected);
			
            // select Tree item
			tree.addEventListener(ListEvent.CLICK_ITEM, treeSelected);
			
            // start progress bar timer
			timerPB.start();
		}
		
        // create a fake icon
		private function getIcon():DisplayObject {
			return new Bitmap(new BitmapData(16, 16, false, Math.random() * 0xFF0000));
		}

		override protected function draw():void {
			super.draw();
			
			if (dropDownMenu != null) {
				dropDownMenu.width = _width;
			}
			
			if (leftPanel != null) {
				tabPanel.height = 400;
				leftPanel.x = padding
				leftPanel.y = padding * 2;
				leftPanel.width = (_width - padding * 3) >> 1;
				leftPanel.height = _height - padding * 4;
				if (rightPanel != null) {
					rightPanel.x = leftPanel.x + leftPanel.width + padding;
					rightPanel.y = padding * 2;
					rightPanel.width = _width - padding * 3 - leftPanel.width;
					rightPanel.height = _height - padding * 4;
				}
				if (tabPanel.selectTab == 3) {
					tabPanel.height = 400;
				} else {
					tabPanel.height = 1;
				}
			}
			
		}

		private function button_clickHandler(event:MouseEvent):void {
			textInput.text = "Button click: " + (event.currentTarget as Button).label;
		}

		private function RadioButtonGroupSelectedHandler(event:RadioButtonGroupEvent):void {
			if (event.button is RadioButton) {
				textInput.text = "Selected: " + (event.button as RadioButton).name;
			} else if (event.button is ToggleButton) {
				textInput.text = "Selected: " + (event.button as ToggleButton).name;
			}

		}

		private function SliderChangePosHandler(event:SliderEvent):void {
			textInput.text = "Slider position: " + event.pos;
		}

		private function dropDownListSelect(event:ListEvent):void {
			textInput.text = "DropDownItem selectedIndex: " + dropDownList.selectedIndex;
		}

		private function listSelected(event:ListEvent):void {
			if (event.object != null)
				textInput.text = "List: " + (event.object.label);
		}

		private function treeSelected(event:ListEvent):void {
			if (event.object != null)
				textInput.text = "Tree: " + (event.object.label);
		}

		private function leftPanel_MOUSE_UPHandler(event:PanelEvent):void {
			textInput.text = (event.currentTarget.title) + ": mouseUp";
		}

		private function leftPanel_MOUSE_DOWNHandler(event:PanelEvent):void {
			textInput.text = (event.currentTarget.title) + ": mouseDown";
		}

		private function leftPanel_CLOSEHandler(event:PanelEvent):void {
			textInput.text = (event.currentTarget.title) + ": Close panel";
		}

		private function timerPB_timerHandler(event:TimerEvent):void {
			progressBar.percent = percent / 100;
			progressBar.label = String(percent) + "%";
			percent += 5;
			if (percent > 100) {
				percent = 0;
			}
		}

		private function tabButton_SELECTEDHandler(event:TabPanelEvent):void {
			if (event.index == 3) {
				tabPanel.height = 400;
			} else {
				tabPanel.height = 1;
			}
			
			LayoutManager.redrawManager.drawObjects();
		}
		
		private function rollout_RolloutEventMimimizeHandler(event:RolloutEvent):void {
			tabPanel.height = 400;
			
			LayoutManager.redrawManager.drawObjects();
		}
	}
}
