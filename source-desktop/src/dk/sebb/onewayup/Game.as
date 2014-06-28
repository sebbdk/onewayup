package dk.sebb.onewayup
{

	import com.greensock.TweenLite;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import dk.sebb.onewayup.props.Background;
	import dk.sebb.onewayup.props.GameInterface;
	import dk.sebb.onewayup.props.Ground;
	import dk.sebb.onewayup.props.Plane;
	import dk.sebb.onewayup.props.Player;
	
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.extensions.PDParticleSystem;
	
	public class Game extends Sprite
	{
		private var _t:int;
		public var paused:Boolean = false;
		
		private var bg:Background = new Background();
		private var ground:Ground;
		private var music:Sound;
		
		private var speed:Number = -400;
		private var debrees:Array = [];
		private var space:Space;
		private var gameInterface:GameInterface;
		
		public static var player:Player;
		public static var instance:Game;
		
		public var explodeParticle:PDParticleSystem;
		
		private var scene:Sprite = new Sprite();
		
		public function Game() {
			instance = this;
			
			//setup physics
			space = new Space(new Vec2(0, 200));
			Main.napeDebug = new ShapeDebug(512, 768);
			//Main.instance.addChild(Main.napeDebug.display);
			
			player = new Player(space);
			ground = new Ground(space);
			
			addChild(bg);
			addChild(scene);
			
			scene.addChild(ground);
			scene.addChild(player);
			
			scene.addChild(player.flying.packLeft);
			scene.addChild(player.flying.packRight);
			
			//setup game loop
			_t = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//setup music
			music = new Assets.music();
			var soundChannel:SoundChannel = music.play(0, 10000);

			SoundMixer.soundTransform = new SoundTransform(0, 0);
			
			//initiate controls
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//add explosion!
			explodeParticle = Assets.getExplodeParticle();
			Starling.juggler.add(explodeParticle);
			
			//add game interface
			gameInterface = new GameInterface();
			addChild(gameInterface);	
		}
		
		private function onAddedToStage(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			//start game
			bg.move = true;
			ground.moveDown();
			
			tick();
			setInterval(tick, 100);
		}
		
		private function onKeyUp(evt:KeyboardEvent):void {
			if(evt.charCode === Keyboard.SPACE) {
			}
		}
			
		private function onKeyDown(evt:KeyboardEvent):void {
			if(evt.charCode === Keyboard.SPACE && player.alive) {
				player.body.applyImpulse(new Vec2(0, speed));
				player.body.velocity.y = player.body.velocity.y > speed ? player.body.velocity.y:speed;
				
				player.flying.packLeft.speed = 100;
				player.flying.packRight.speed = 100; 
			}
		}
		
		private function tick():void {
			if(!player.alive) {
				return;
			}
			
			//update scores!
			var score:int = (Math.round((player.body.position.y-stage.stageHeight+100) / 100) * -1);
			score = score > 0 ? score:0;
			gameInterface.scoreText.text = score.toString() + ' px';
			
			//sawn stuff!
			var plane:Plane = new Plane(space);
			scene.addChild(plane);
			
			for each(var cplane:Plane in debrees) {
				if( Math.abs(cplane.body.position.y - plane.body.position.y)  < 300 ) {
					plane.body.space = null;
					scene.removeChild(plane);
					return;
				}
			}
			
			
			debrees.push(plane);
		}
		
		public function lerp( amount:Number , start:Number, end:Number ):Number {
			if ( start == end )  {
				return start ;
			}
			return ( ( 1 - amount ) * start ) + ( amount * end ) ;
		};
		
		public function reset():void {
			paused = true;
			
			scene.addChild(explodeParticle);
			explodeParticle.x = player.x;
			explodeParticle.y = player.body.position.y;
			explodeParticle.start(0.2);
			player.visible = false;
			
			player.flying.packLeft.stop();
			player.flying.packRight.stop();
			
			setTimeout(function():void {
				paused = false;
				
				player.visible = true;
				player.reset();
				
				player.flying.packLeft.start();
				player.flying.packRight.start();
				
				for each(var plane:Plane in debrees) {
					plane.body.space = null;
					scene.removeChild(plane);
				}
				
				TweenLite.to(bg.moon, 1, {
					y:-bg.moon.height * 0.8
				})
				debrees = [];
			}, 1500);
		}
		
		private function onEnterFrame(e:Event):void {
			//update delta
			var t:int = getTimer();
			var dt:Number = (t - _t) * (60/1000);
			
			//game update logic
			if(!paused) {
				space.step((1/60) * dt, 10, 10);
			
				bg.update(dt, player.body.velocity.y * -1 * 0.03);
				bg.y = 0;
				player.update(dt);
				
				for each(var debree:Plane in debrees) {
					debree.update(dt);
				}
				
				//update jetpack
				var max:int = (player.body.velocity.y / speed) * 20 + 10;
				max = max > 0 ? max:1;
				player.flying.packLeft.maxNumParticles = max;
				player.flying.packRight.maxNumParticles = max;
				
				//update camera
				scene.x = lerp(0.05, scene.x, -player.x + (stage.stageWidth/2));
				scene.y = lerp(0.05, scene.y, (-player.y + (stage.stageHeight/2)) + stage.stageHeight * 0.35);
				
				if(player.body.velocity.y > 200) {
					reset();
				}
			}
			
			Main.napeDebug.display.x = scene.x;
			Main.napeDebug.display.y = scene.y;
			
			//update debug
			Main.napeDebug.clear();
			Main.napeDebug.draw(space);
			
			//finish delta
			_t = t;
		}
	}
}