package dk.sebb.onewayup.props
{
	import flash.text.Font;
	
	import dk.sebb.onewayup.Assets;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class GameInterface extends Sprite
	{
		public var scoreText:TextField;
		
		public function GameInterface() {
			var font:Font = new Assets.VisitorFont();
			
			scoreText = new TextField(512, 128, "", font.fontName, 62, 0xFFFFFF);
			addChild(scoreText);
		}
	}
}