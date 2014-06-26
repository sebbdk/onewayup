package
{
	import flash.display.Sprite;
	
	import dk.sebb.onewayup.Game;
	
	import nape.util.ShapeDebug;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(backgroundColor="#666666", frameRate="60", height="768", width="512", quality="HIGH")]
	public class Main extends Sprite
	{
		private var _starling:Starling;
		
		public static var napeDebug:ShapeDebug;
		public static var instance:Main;
		public static var stats:Stats;
		
		public function Main() {
			instance = this;
			_starling = new Starling(Game, stage);
			_starling.start();
			_starling.stage.color = 0x484952;
			
			stats = new Stats();
			addChild(stats);
		}
	}
}