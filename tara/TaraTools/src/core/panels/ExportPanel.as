package core.panels
{
	import alternativa.gui.controls.button.RadioButtonGroup;
	import alternativa.gui.event.RadioButtonGroupEvent;
	import alternativa.gui.theme.defaulttheme.controls.buttons.Button;
	import alternativa.gui.theme.defaulttheme.controls.buttons.CheckBox;
	import alternativa.gui.theme.defaulttheme.controls.buttons.ToggleButton;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.controls.text.TextInput;
	import core.ExportType;
	import core.MANAGER;
	import core.fs.tara.LOCKER;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import mx.utils.Base64Encoder;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class ExportPanel extends PanelsBase
	{
		public var g_toggles:RadioButtonGroup = new RadioButtonGroup();
		public var g_toggles_con:Sprite = new Sprite();
		public var g_tog_tara:ToggleButton = new ToggleButton();
		public var g_tog_tara_con:Sprite = new Sprite();
		public var g_tog_tara5:ToggleButton = new ToggleButton();
		public var g_tog_tara5_con:Sprite = new Sprite();
		public var g_tog_folder:ToggleButton = new ToggleButton();
		public var g_tog_folder_con:Sprite = new Sprite();
		public var g_btn_tara_con_export:Button = new Button();
		public var g_btn_tara5_con_export:Button = new Button();
		public var g_btn_tara5_con_pswrdLabel:Label = new Label();
		public var g_btn_tara5_con_pswrd:TextInput = new TextInput();
		public var g_btn_folder_con_export:Button = new Button();
		
		public function ExportPanel()
		{
			g_panel_setHeight = 25 + 66 + 50;
			g_toggles.addEventListener(RadioButtonGroupEvent.SELECTED, function(e:RadioButtonGroupEvent):void
			{
				selectExportMode(ToggleButton(e.button).label);
			});
			g_tog_tara.label = "TARA";
			g_toggles.addButton(g_tog_tara);
			g_panel.addChild(g_tog_tara);
			g_tog_tara5.label = "TARA5";
			g_toggles.addButton(g_tog_tara5);
			g_panel.addChild(g_tog_tara5);
			g_tog_folder.label = "Folder";
			g_toggles.addButton(g_tog_folder);
			g_panel.addChild(g_tog_folder);
			g_panel.addChild(g_toggles_con);
			
			g_btn_tara_con_export.label = "EXPORT";
			g_btn_tara_con_export.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				MANAGER.D_EXPORT.type = ExportType.TARA;
				MANAGER.FUNCTIONS.exportSelected();
			});
			g_tog_tara_con.addChild(g_btn_tara_con_export);
			g_btn_tara5_con_export.label = "EXPORT";
			g_btn_tara5_con_export.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				MANAGER.D_EXPORT.type = ExportType.TARA5;
				MANAGER.D_EXPORT_TARA5_PASSWORD = g_btn_tara5_con_pswrd.text;
				MANAGER.FUNCTIONS.exportSelected();
			});
			g_tog_tara5_con.addChild(g_btn_tara5_con_export);
			g_tog_tara5_con.addChild(g_btn_tara5_con_pswrd);
			g_btn_tara5_con_pswrdLabel.text = "Password:";
			g_tog_tara5_con.addChild(g_btn_tara5_con_pswrdLabel);
			g_btn_folder_con_export.label = "EXPORT";
			g_btn_folder_con_export.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				MANAGER.D_EXPORT.type = ExportType.FOLDER;
				MANAGER.FUNCTIONS.exportSelected();
			});
			g_tog_folder_con.addChild(g_btn_folder_con_export);
		}
		
		public function selectExportMode(mode:String):void
		{
			if (g_toggles_con.contains(g_tog_tara_con))
				g_toggles_con.removeChild(g_tog_tara_con);
			if (g_toggles_con.contains(g_tog_tara5_con))
				g_toggles_con.removeChild(g_tog_tara5_con);
			if (g_toggles_con.contains(g_tog_folder_con))
				g_toggles_con.removeChild(g_tog_folder_con);
			
			if (mode == g_tog_tara.label)
				g_toggles_con.addChild(g_tog_tara_con);
			else if (mode == g_tog_tara5.label)
				g_toggles_con.addChild(g_tog_tara5_con);
			else if (mode == g_tog_folder.label)
				g_toggles_con.addChild(g_tog_folder_con);
		}
		
		override protected function addedToGUI(callback:Function = null):void
		{
			g_tog_tara.selected = true;
		}
		
		override protected function afterDraw():void
		{
			var w:Number = g_panel.width;
			var h:Number = g_panel.height;
			var heightUsed:Number = 0;
			heightUsed += 25;
			
			var tmpX:Number = 0;
			for each (var b:ToggleButton in g_toggles.buttonsList)
			{
				b.width = 100;
				b.height = 33;
				b.x = tmpX++ * 100 + w / 2 - 100 * g_toggles.buttonsList.length / 2;
				b.y = heightUsed;
			}
			
			g_btn_tara_con_export.width = 100;
			g_btn_tara_con_export.x = w / 2 - 50;
			g_btn_tara_con_export.y = 25 + 66;
			g_btn_tara5_con_export.width = 100;
			g_btn_tara5_con_export.x = w / 2 - 50;
			g_btn_tara5_con_export.y = 25 + 66;
			g_btn_tara5_con_pswrd.width = 200 * (g_toggles.buttonsList.length - 2);
			g_btn_tara5_con_pswrd.x = w / 2 - 50;
			g_btn_tara5_con_pswrd.y = 25 + 33 + 4;
			g_btn_tara5_con_pswrdLabel.x = w / 2 - 100 * g_toggles.buttonsList.length / 2;
			g_btn_tara5_con_pswrdLabel.y = 25 + 33 + 8;
			g_btn_folder_con_export.width = 100;
			g_btn_folder_con_export.x = w / 2 - 50;
			g_btn_folder_con_export.y = 25 + 66;
		}
	}
}