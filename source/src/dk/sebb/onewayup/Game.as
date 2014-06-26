package dk.sebb.onewayup
{

	import flash.media.Sound;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import dk.sebb.onewayup.props.Background;
	import dk.sebb.onewayup.props.Ground;
	import dk.sebb.onewayup.props.Plane;
	import dk.sebb.onewayup.props.Player;
	
	import nape.geom.Vec2;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class Game extends Sprite
	{
		private var _t:int;
		
		private var bg:Background = new Background();
		private var ground:Ground;
		public static var player:Player;
		
		private var music:Sound;
		
		private var speed:Number = -400;
		
		private var debrees:Array = [];
		
		private var space:Space;
		
		public static var instance:Game;
		
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
			//music.play(0, 10000);
			
			//initiate controls
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//start game
			bg.move = true;
			ground.moveDown();
			
			spawnDebree();
			setInterval(spawnDebree, 100);
		}
		
		private function onAddedToStage(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
		
		private function spawnDebree():void {
			if(!player.alive) {
				return;
			}
			
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
			trace('reset!');
			for each(var plane:Plane in debrees) {
				plane.body.space = null;
				scene.removeChild(plane);
			}
			debrees = [];
		}
		
		private function onEnterFrame(e:Event):void {
			//clean
			var index:int = 0;
			for each(var plane:Plane in debrees) {
				if(plane.body.position.x > stage.stageWidth*2 || plane.body.position.x < -stage.stageWidth) {
					plane.body.space = null;
					scene.removeChild(plane);
					debrees.splice(index, 1);
				}
				index++;
			}
		
			//set max particles
			var max:int = (player.body.velocity.y / speed) * 20 + 10;
			max = max > 0 ? max:1;
			player.flying.packLeft.maxNumParticles = max;
			player.flying.packRight.maxNumParticles = max;
			
			//update delta
			var t:int = getTimer();
			var dt:Number = (t - _t) * (60/1000);
			
			//game update logic
			space.step((1/60) * dt, 10, 10);
			
			bg.update(dt, player.body.velocity.y * -1 * 0.03);
			bg.y = 0;
			player.update(dt);
			
			for each(var debree:Plane in debrees) {
				debree.update(dt);
			}
			
			//update camera
			scene.x = lerp(0.05, scene.x, -player.x + (stage.stageWidth/2));
			scene.y = lerp(0.05, scene.y, (-player.y + (stage.stageHeight/2)) + stage.stageHeight * 0.35);
			
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