package dk.sebb.onewayup.props 
{
	
	import flash.utils.setTimeout;
	
	import dk.sebb.onewayup.Assets;
	import dk.sebb.onewayup.props.parts.FlyingPlayer;
	
	import nape.callbacks.CbType;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Player extends Sprite
	{
		public var flying:FlyingPlayer;
		public var prepping:Image;
		public var standing:Image;
		
		public var body:Body;
		public var cbtype:CbType = new CbType();
		public var activeState:DisplayObject;
		
		public var isPreparing:Boolean
		
		public var talky:Image;
		
		public var alive:Boolean = true;
		
		public function Player(space:Space) {
			standing = Assets.getImage('pilot_01');
			flying = new FlyingPlayer();
			prepping= Assets.getImage('pilot_03');
			
			standing.visible = false;
			prepping.visible = false;
			
			activeState = flying;
			
			addChild(standing);
			addChild(activeState);
			addChild(prepping);
			
			prepping.x = flying.x = standing.x -= width/2;
			prepping.y = flying.y = standing.y -= height/2;
			
			standing.x = -standing.width/2;
			flying.x = -standing.width/2;
			prepping.x = -standing.width/2;
			
			body = new Body(BodyType.DYNAMIC);
			var poly:Polygon = new Polygon(Polygon.box(width, height));
			poly.sensorEnabled = false;
			body.shapes.add(poly);
			body.space = space;
			body.cbTypes.add(cbtype);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(evt:Event):void{
			reset();
			
			body.position.x = stage.stageWidth/4;
			
			talky = Assets.getImage('talk_bubble');
			parent.addChild(talky);
			
			talky.y = body.position.y - talky.height - (this.height/2);
			talky.x = body.position.x + (this.width/2);
		}
		
		public function reset():void {
			alive = false;
			body.velocity.setxy(0,0);
			body.position.y = stage.stageHeight - 100;
			body.position.x = stage.stageWidth/2;
			
			setTimeout(function():void {
				alive = true;
			}, 500);
		}
		
		public function update(dt:Number):void {
			if(stage) {
				this.x = body.position.x;
				this.y = body.position.y;
			}
			
			if(body.velocity.y < -100 && activeState != flying) {
				activeState.visible = false;
				activeState = flying;
				activeState.visible = true;
			}
			
			if(body.velocity.y > -100 && activeState != prepping) {
				activeState.visible = false;
				activeState = prepping;
				activeState.visible = true;
			}
			
			if(Math.abs(body.velocity.y) < 10 && activeState != standing && this.y > 650) {
				activeState.visible = false;
				activeState = standing;
				activeState.visible = true;
			}
		}
	}
}