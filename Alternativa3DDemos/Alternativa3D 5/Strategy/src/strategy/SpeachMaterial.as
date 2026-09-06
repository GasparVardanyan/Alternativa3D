package strategy {
	import alternativa.engine3d.*;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.Skin;
	import alternativa.engine3d.materials.SpriteMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	use namespace alternativa3d;

	/**
	 * Материал для бубла с речью. 
	 */	
	public class SpeachMaterial extends SpriteMaterial {
		// Текстовое поле		
		private var textField:TextField = new TextField();
		// Набор фраз
		private var phrases:Set = new Set();
		private var container:Sprite = new Sprite();

		[Embed(source="avatar/talk.png")] private static var talkClass:Class;
		private const talkBitmap:Bitmap = new Bitmap(new talkClass().bitmapData);
		
		public function SpeachMaterial(alpha:Number=1, blendMode:String=BlendMode.NORMAL) {
			super(alpha, blendMode);
			
			phrases.add("I have come with\n the delegation");
			phrases.add("Have you any\n accmodation?");
			phrases.add("There is no hot \n water");
			phrases.add("Excuse my poor\n pronunciation!");
			phrases.add("Please, come back\n and clean later");
			phrases.add("What is all this?");
			phrases.add("Do not talk rot!");
			phrases.add("Fasten safety \n belts!");
			phrases.add("Excuse my poor \n pronunciation!");
			phrases.add("Fasten safety \n belts!");
			phrases.add("I have something \n in my eye");
			phrases.add("This stain is \n blood");
			phrases.add("What’s this \n bill for?");
			phrases.add("Excuse my poor \n pronunciation!");
			phrases.add("How do you eat \n this?");
			phrases.add("I was robbed \n of my wallet on \n the subway");
			phrases.add("How soon does \n the show begin?");
			phrases.add("Excuse my poor \n pronunciation!");
			phrases.add("May I have this \n dance, please?");
			
			// Настройка текстового поля
			textField = new TextField();
			textField.width = 110;
			textField.height = 50;
			textField.multiline = true;	
			textField.embedFonts = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;

			var textFormat:TextFormat = new TextFormat();
			textFormat.font  = "Alternativa";
			textFormat.color = 0;
			textFormat.size = 14;
			textField.defaultTextFormat = textFormat;
			
			container.addChild(talkBitmap);
			talkBitmap.y = -talkBitmap.height/6*5;
			container.addChild(textField);
			textField.x = talkBitmap.x + 30;
			textField.y = talkBitmap.y + 10;
			
		}
		
		override alternativa3d function draw(camera:Camera3D, skin:Skin):void {
			// Отрисовываем бубл
			skin.addChild(container);
			// Корректируем его положение на экране
			var point:Point3D = _sprite.globalCoords.clone();
			point.transform(camera.cameraMatrix);
			container.x = point.x;
			container.y = point.y;
												
		}
		
		override alternativa3d function removeFromScene(scene:Scene3D):void {
			
			if (container.parent != null) {
				container.parent.removeChild(container);
			}
			super.removeFromScene(scene);
		}
		
		/**
		 * Меняет фразу случайным образом. 
		 */		
		public function speak():void {
			
			textField.text = phrases.any();
			
		}
		
		
		
		
	}
}