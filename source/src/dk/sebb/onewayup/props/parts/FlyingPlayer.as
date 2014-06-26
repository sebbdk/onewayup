package dk.sebb.onewayup.props.parts
{
	import com.greensock.TweenLite;
	
	import dk.sebb.onewayup.Assets;
	import dk.sebb.onewayup.Game;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	
	public class FlyingPlayer extends Sprite
	{
		public var player:Image;
		public var jetpack:Image;
		
		public var packLeft:PDParticleSystem;
		public var packRight:PDParticleSystem;
		
		public function FlyingPlayer()
		{
			player = Assets.getImage('pilot_02');
			jetpack = Assets.getImage('pilot_jetpack');
			
			packLeft = Assets.getBlastParticle();
			packLeft.x = 5;
			packLeft.alpha = 0.6;
			
			packRight = Assets.getBlastParticle();
			packRight.x = 20;
			
			packLeft.y = packRight.y = 37;
			
			Starling.juggler.add(packLeft);
			Starling.juggler.add(packRight);
			
			addChild(player);
			addChild(jetpack);
			
			ignite();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(evt:Event):void {
			packRight.emitterY = Game.player.body.position.y * packRight.scaleY - 30;
			packRight.emitterX = Game.player.body.position.x * packRight.scaleX - 15;
			
			packLeft.emitterY = Game.player.body.position.y * packRight.scaleY - 30;
			packLeft.emitterX = Game.player.body.position.x * packRight.scaleX - 10;;
		}
		
		public function ignite():void {
			packLeft.start();
			packRight.start();
			
			return;
			TweenLite.to(packLeft, 3, {scaleX:0.4, scaleY:0.4, onComplete:function():void {
				TweenLite.to(packLeft, 3, {scaleX:0.2, scaleY:0.2});
			}});
			
			TweenLite.to(packRight, 3, {scaleX:0.4, scaleY:0.4, onComplete:function():void {
				TweenLite.to(packRight, 3, {scaleX:0.2, scaleY:0.2});
			}});
		}
	}
}