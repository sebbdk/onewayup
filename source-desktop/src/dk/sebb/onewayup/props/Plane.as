package dk.sebb.onewayup.props
{
	import dk.sebb.onewayup.Assets;
	import dk.sebb.onewayup.Game;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Plane extends Sprite
	{
		private var plane:Image;
		public var body:Body;
		private var speed:int = 30;
		private var baseSpeed:int = 200;
		
		public var cbtype:CbType = new CbType();
		
		public var onCollisionListener:InteractionListener;
		
		public function Plane(space:Space) {
			plane = Assets.getImage('plane');
			plane.scaleX = 0.75;
			plane.scaleY = 0.75;
			
			plane.x -= plane.width/2;
			plane.y -= plane.height/2;
			addChild(plane);
			
			addEventListener(Event.ADDED_TO_STAGE, flyBy);
			y = -256;
			
			body = new Body(BodyType.DYNAMIC);
			
			var poly:Polygon = new Polygon(Polygon.box(width * 0.75, height/2));
			poly.sensorEnabled = true;
			poly.translate(new Vec2(width * 0.14, height/4));
			body.shapes.add(poly);
			
			var poly2:Polygon = new Polygon(Polygon.box(width * 0.25, height/1.5));
			poly2.sensorEnabled = true;
			poly2.translate(new Vec2(-width * 0.33, 0));
			body.shapes.add(poly2);
			
			body.space = space;
			body.position.y = plane.height / 2;
			body.cbTypes.add(cbtype);
			body.gravMass = 0;
			
			onCollisionListener = new InteractionListener(CbEvent.ONGOING, 
				InteractionType.ANY,
				cbtype,
				Game.player.cbtype,
				onCollision);
			space.listeners.add(onCollisionListener);
		}
		
		private function onCollision(collision:InteractionCallback):void {
			trace('I was hit bu the pluyer! oh noes!');
			Game.instance.reset();
		}
	
		public function flyBy(evt:Event):void {
			speed = baseSpeed + Math.random() * 200;
			
			var direction:int = Math.round(Math.random()) == 1 ? 1:-1;
			body.velocity.x = direction * speed;
			
			body.scaleShapes(direction, 1);
			
			//body.position.y = Game.player.body.position.y - (stage.stageHeight) * Math.random() - stage.stageHeight * 0.8;
			var bpos:int = Game.player.body.position.y < -512 ? Game.player.body.position.y:-256;
			body.position.y = bpos - 512 + (1024 * Math.random());
			
			
			body.position.x = direction > 0 ? -plane.width : stage.stageWidth + (plane.width/2);
			scaleX = direction * -1;
		}
		
		public function update(dt:Number):void {
			this.x = body.position.x;
			this.y = body.position.y;
			
			if(Game.player.body.velocity.y > 0) {
				if(Game.player.body.position.x > body.position.y) {
					body.velocity.y = -Math.abs(Game.player.body.velocity.y) * 2;
				} else {
					body.velocity.y = Math.abs(Game.player.body.velocity.y) * 2;
				}
			} else {
				body.velocity.y = 0;
			}
		}
	}
}