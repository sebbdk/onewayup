package dk.sebb.onewayup.props
{
	import dk.sebb.onewayup.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Background extends Sprite
	{
		public var bgs:Array = [];
		public var move:Boolean = false;
		
		public function Background() {
			build();
		}
		
		public function update(dt:Number, speed:Number):void {
			if(move) {
				for each(var bg:Image in bgs) {
					bg.y += speed * dt;
					
					if(bg.y > 1024) {
						bg.y = -512;
					}
					
					if(bg.y < -512) {
						bg.y = 1024;
					}
				}
			}
		}
		
		private function build():void {
			var bg1:Image = Assets.getImage('stars_repeat');
			var bg2:Image = Assets.getImage('stars_repeat');
			bg2.y = 512;
			var bg3:Image = Assets.getImage('stars_repeat');
			bg3.y = 1024;
			
			addChild(bg1);
			addChild(bg2);
			addChild(bg3);
			
			bgs.push(bg1);
			bgs.push(bg2);
			bgs.push(bg3);
		}
	}
}