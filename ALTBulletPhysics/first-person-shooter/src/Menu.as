package {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import utility.TweenNano;

	/**
	 * ...
	 * @author redefy
	 */
	[SWF(width="1024",height="768",frameRate="60")]
	public class Menu extends Sprite {
		
		private var background:Bitmap;
		private var newGame:MovieClip;
		private var settingsGame:MovieClip;
		private var aboutGame:MovieClip;
		
		private var level1Game:MovieClip;
		private var level2Game:MovieClip;
		private var backGame:MovieClip;
		
		private var menuLabel:Bitmap;

		public function Menu():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			GV.stage = stage;
			GV.stage.scaleMode = StageScaleMode.EXACT_FIT;
			background = new GFX.MenuBackground();
			addChild(background);
			
			newGame = new GFX.MenuNewGame();
			newGame.y = 570;
			addChild(newGame);
			
			settingsGame = new GFX.MenuSettings();
			settingsGame.y = 630;
			addChild(settingsGame);
			
			aboutGame = new GFX.MenuAbout();
			aboutGame.y = 690;
			addChild(aboutGame);
			
			newGame.x = settingsGame.x = aboutGame.x = 795;
			newGame.mouseEnabled = settingsGame.mouseEnabled = aboutGame.mouseEnabled = false;
			
			activeButtons();
			
			level1Game = new GFX.MenuLevel1();
			level1Game.name = "level1";
			level1Game.x = 265;
			level1Game.y = 270;
			addChild(level1Game);
			
			level2Game = new GFX.MenuLevel2();
			level2Game.name = "level2";
			level2Game.x = 557.5;
			level2Game.y = 270;
			addChild(level2Game);
			
			menuLabel = new GFX.MenuLabel();
			menuLabel.x = 322.5;
			menuLabel.y = 204.6;
			addChild(menuLabel);
			
			backGame = new GFX.MenuBack();
			backGame.name = "back";
			backGame.x = 485;
			backGame.y = 454.4;
			addChild(backGame);
			
			menuLabel.alpha = level1Game.alpha = level2Game.alpha = backGame.alpha = 0;
			disableButtonsLevels();
		}
		
		private function activeButtons():void {
			newGame.mouseEnabled = settingsGame.mouseEnabled = aboutGame.mouseEnabled = true;
			
			newGame.addEventListener(MouseEvent.MOUSE_DOWN, handlersMenu);
			settingsGame.addEventListener(MouseEvent.MOUSE_DOWN, handlersMenu);
			aboutGame.addEventListener(MouseEvent.MOUSE_DOWN, handlersMenu);
			
			TweenNano.to(newGame, 1, { x:795 } );
			TweenNano.to(settingsGame, 1.5, { x:795 } );
			TweenNano.to(aboutGame, 2, { x:795});
		}
		
		private function disableButtons():void {
			newGame.mouseEnabled = settingsGame.mouseEnabled = aboutGame.mouseEnabled = false;
			
			newGame.removeEventListener(MouseEvent.MOUSE_DOWN, handlersMenu);
			settingsGame.removeEventListener(MouseEvent.MOUSE_DOWN, handlersMenu);
			aboutGame.removeEventListener(MouseEvent.MOUSE_DOWN, handlersMenu);
			
			TweenNano.to(newGame, 1, { x:GV.stage.stageWidth + 500 } );
			TweenNano.to(settingsGame, 2, { x:GV.stage.stageWidth + 500 } );
			TweenNano.to(aboutGame, 3, { x:GV.stage.stageWidth + 500});
		}
		
		private function handlersMenu(e:MouseEvent):void {
			disableButtons();
			activeButtonsLevels();
		}
		
		private function activeButtonsLevels():void {
			level1Game.mouseEnabled = level2Game.mouseEnabled = backGame.mouseEnabled = true;
			
			level1Game.addEventListener(MouseEvent.MOUSE_DOWN, handlersMenuLevels);
			level2Game.addEventListener(MouseEvent.MOUSE_DOWN, handlersMenuLevels);
			backGame.addEventListener(MouseEvent.MOUSE_DOWN, handlersMenuLevels);
			
			TweenNano.to(menuLabel, 1, { alpha:1 } );
			TweenNano.to(level1Game, 1, { alpha:1 } );
			TweenNano.to(level2Game, 1, { alpha:1 } );
			TweenNano.to(backGame, 1, { alpha:1});
		}
		
		private function disableButtonsLevels():void {
			level1Game.mouseEnabled = level2Game.mouseEnabled = backGame.mouseEnabled = false;
			
			level1Game.removeEventListener(MouseEvent.MOUSE_DOWN, handlersMenuLevels);
			level2Game.removeEventListener(MouseEvent.MOUSE_DOWN, handlersMenuLevels);
			backGame.removeEventListener(MouseEvent.MOUSE_DOWN, handlersMenuLevels);
			
			TweenNano.to(menuLabel, 1, { alpha:0 } );
			TweenNano.to(level1Game, 1, { alpha:0 } );
			TweenNano.to(level2Game, 1, { alpha:0 } );
			TweenNano.to(backGame, 1, { alpha:0});
		}
		
		private function handlersMenuLevels(e:MouseEvent):void {
			switch(e.currentTarget.name) {
				case "back":
					disableButtonsLevels();
					activeButtons();
				break;
				
				case "level2":
					disableButtonsLevels();
					removeChild(background);
					removeChild(settingsGame);
					removeChild(newGame);
					removeChild(aboutGame);
					
					var fps:FPS = new FPS();
					addChild(fps);
				break;
			}
		}
	}
}