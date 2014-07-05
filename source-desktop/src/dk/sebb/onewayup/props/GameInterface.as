package dk.sebb.onewayup.props
{
	import flash.text.Font;
	import flash.utils.setInterval;
	
	import dk.sebb.onewayup.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class GameInterface extends Sprite
	{
		public var scoreText:TextField;
		public var splashScreen:Image;
		
		public var tabMessage:Image;
		
		public var splashContainer:Sprite;
		
		public function GameInterface() {	
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var font:Font = new Assets.VisitorFont();
			scoreText = new TextField(512, 128, "", font.fontName, 62, 0xFFFFFF);
			addChild(scoreText);
			
			splashContainer = new Sprite()
			addChild(splashContainer);
			
			splashScreen = Assets.getImage('splash_screen');
			splashContainer.addChild(splashScreen);
			
			tabMessage =  Assets.getImage('tap_start');
			splashContainer.addChild(tabMessage);
			
			setInterval(function():void {
				tabMessage.visible = !tabMessage.visible;
			}, 1000);
		}
		
		private function onAddedToStage(evt:Event):void {
			splashScreen.y = (stage.stageHeight / 2) - splashScreen.height;
			tabMessage.y = (stage.stageHeight / 2) - 24;
		}
	}
}