package dk.sebb.onewayup.props
{
	import dk.sebb.onewayup.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Background extends Sprite
	{
		public var bgs:Array = [];
		public var clouds:Array = [];
		public var moon:Image;
		
		public var move:Boolean = false;
		
		public function Background() {
			build();
		}
		
		public function lerp( amount:Number , start:Number, end:Number ):Number {
			if ( start == end )  {
				return start ;
			}
			return ( ( 1 - amount ) * start ) + ( amount * end ) ;
		};
		
		public function update(dt:Number, speed:Number):void {
			if(move) {
				for each(var bg:Image in bgs) {
					bg.y = lerp(0.7, bg.y, bg.y + speed * dt) ;
					//bg.y += speed * dt;
					
					if(bg.y > 1024) {
						bg.y = -512;
					}
					
					if(bg.y < -512) {
						bg.y = 1024;
					}
				}
				
				for each(var cloud:Image in clouds) {
					cloud.y += speed * dt;
					
					if(cloud.y > 1024) {
						resetCloud(cloud);
					}
					
					if(cloud.y < -2024) {
						resetCloud(cloud);
					}
				}
				
				moon.y += speed * dt * 0.01;
			}
		}
		
		private function build():void {
			//make some backgrounds
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
			
			//setup the moon
			moon = Assets.getImage('moon');
			//moon.scaleX = moon.scaleY = 1.5;
			moon.x = 256 - (moon.width / 2);
			moon.y = -moon.height * 0.8;
			addChild(moon);
			
			//make some clouds
			for(var x:int = 0; x < 15; x++) {
				var name:String = 'cloud_0' + Math.ceil(Math.random() * 4);
				var cloud:Image = Assets.getImage(name);
				resetCloud(cloud);
				addChild(cloud);
				clouds.push(cloud);
			}
		
		}
		
		public function resetCloud(cloud:Image):void {
			cloud.y = -2024 * Math.random() - 200;
			cloud.x = 512 * Math.random();
		}
	}
}