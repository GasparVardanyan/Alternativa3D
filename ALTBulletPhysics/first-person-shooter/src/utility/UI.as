package utility{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import entity.Entity;
	
	/**
	 * ...
	 * @author redefy
	 */
	public class UI extends Sprite {
		private var _health:Bitmap;
		private var _armor:Bitmap;
		private var _weapons:Bitmap;
		private var _radar:Bitmap;
		private var _croshair:Bitmap;

		private var _healthState:TextField;
		private var _armorState:TextField;
		private var _patronsState:TextField;
		private var _chargersState:TextField;
		private var _broken:TextField;
		
		private var _healthPosition:Point = new Point(15, 80);
		private var _weaponsPosition:Point = new Point(180, 100);
		private var _radarPosition:Point = new Point(10,10);
		private var _armorPosition:Point = new Point(200, 80);
		private var _healthStatePosition:Point = new Point(90, 50);
		private var _armorStatePosition:Point = new Point(270, 50);
		private var _patronsStatePosition:Point = new Point(170, 50);
		private var _chargersStatePosition:Point = new Point(60, 50);
		private var _brokenStatePosition:Point = new Point(100, 50);
		
		public function UI():void {
			init();
		}
		
		private function init():void {
			var bitmapData:BitmapData = new BitmapData(32, 32, true, 0xFF);
			bitmapData.copyPixels(Bitmap(new GFX.UI()).bitmapData, new Rectangle(69, 0, 32, 32), new Point(0, 0));
			_health = new Bitmap(bitmapData);
			_health.scaleX = _health.scaleY = 2;
			addChild(_health);
			
			bitmapData = new BitmapData(170, 48, true, 0xFF);
			bitmapData.copyPixels(Bitmap(new GFX.HUD()).bitmapData, new Rectangle(0, 0, 170, 48), new Point(0, 0));
			_weapons = new Bitmap(bitmapData);
			_weapons.scaleX = _weapons.scaleY = 1;
			addChild(_weapons);
			
			_radar = new GFX.RADAR();
			_radar.scaleX = _radar.scaleY = 1;
			addChild(_radar);
			
			_croshair = new GFX.CROSSHAIR();
			_croshair.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 1);
			_croshair.alpha = 0.8;
			_croshair.scaleX = _radar.scaleY = 1;
			addChild(_croshair);
			
			bitmapData = new BitmapData(32, 32, true, 0xFF);
			bitmapData.copyPixels(Bitmap(new GFX.UI()).bitmapData, new Rectangle(36, 0, 32, 32), new Point(0, 0));
			_armor = new Bitmap(bitmapData);
			_armor.scaleX = _armor.scaleY = 2;
			addChild(_armor);
			
			_healthState = new TextField();
			_healthState.defaultTextFormat = new TextFormat("ui", 42, 0xFFFFFF);
			_healthState.embedFonts = true;
			_healthState.text = "100";
			_healthState.selectable = false;
			addChild(_healthState);
			
			_armorState = new TextField();
			_armorState.defaultTextFormat = new TextFormat("ui", 42, 0xFFFFFF);
			_armorState.embedFonts = true;
			_armorState.text = "100";
			_armorState.selectable = false;
			addChild(_armorState);
			
			_patronsState = new TextField();
			_patronsState.defaultTextFormat = new TextFormat("ui", 42, 0xFFFFFF);
			_patronsState.embedFonts = true;
			_patronsState.text = "30";
			_patronsState.width = 200;
			_patronsState.selectable = false;
			addChild(_patronsState);
			
			_broken = new TextField();
			_broken.defaultTextFormat = new TextFormat("ui", 42, 0xFFFFFF);
			_broken.embedFonts = true;
			_broken.text = "|";
			_broken.width = 20;
			_broken.selectable = false;
			addChild(_broken);
			
			_chargersState = new TextField();
			_chargersState.defaultTextFormat = new TextFormat("ui", 42, 0xFFFFFF);
			_chargersState.embedFonts = true;
			_chargersState.text = "5";
			_chargersState.width = 100;
			_chargersState.selectable = false;
			addChild(_chargersState);
			
			update();
		}
		
		public function set health(num:String):void {
			_healthState.text = num;
		}
		
		public function get health():String {
			return _healthState.text;
		}
		
		public function set armor(num:String):void {
			_armorState.text = num;
		}
		
		public function get armor():String {
			return _armorState.text;
		}
		
		public function set patrons(num:String):void {
			_patronsState.text = num;
		}
		
		public function get patrons():String {
			return _patronsState.text;
		}
		
		public function set chargers(num:String):void {
			_chargersState.text = num;
		}
		
		public function get chargers():String {
			return _chargersState.text;
		}
		
		public function update():void {
			_health.x = _healthPosition.x;
			_health.y = GV.stage.stageHeight - _healthPosition.y;
			
			_weapons.x = GV.stage.stageWidth - _weaponsPosition.x;
			_weapons.y = GV.stage.stageHeight - _weaponsPosition.y;
			
			_radar.x = _radarPosition.x;
			_radar.y = _radarPosition.y;
			
			_croshair.x = GV.stage.stageWidth >> 1;
			_croshair.y = GV.stage.stageHeight >> 1;
			
			_armor.x = _armorPosition.x;
			_armor.y = GV.stage.stageHeight - _armorPosition.y;
			
			_healthState.x = _healthStatePosition.x;
			_healthState.y = GV.stage.stageHeight - _healthStatePosition.y;
			
			_armorState.x = _armorStatePosition.x;
			_armorState.y = GV.stage.stageHeight - _armorStatePosition.y;
			
			_patronsState.x = GV.stage.stageWidth - _patronsStatePosition.x;
			_patronsState.y = GV.stage.stageHeight - _patronsStatePosition.y;
			
			_chargersState.x = GV.stage.stageWidth - _chargersStatePosition.x;
			_chargersState.y = GV.stage.stageHeight - _chargersStatePosition.y;
			
			_broken.x = GV.stage.stageWidth - _brokenStatePosition.x;
			_broken.y = GV.stage.stageHeight - _brokenStatePosition.y;
		}
	}
}