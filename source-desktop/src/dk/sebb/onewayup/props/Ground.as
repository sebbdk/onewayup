package dk.sebb.onewayup.props
{
	import com.greensock.TweenLite;
	
	import dk.sebb.onewayup.Assets;
	
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Ground extends Sprite
	{
		private var image:Image;
		
		public var body:Body;
		
		public function Ground(space:Space) {
			image = Assets.getImage('ground');
			addChild(image);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			body = new Body(BodyType.KINEMATIC);
			var poly:Polygon = new Polygon(Polygon.box(1000, 56));
			poly.sensorEnabled = false;
			body.shapes.add(poly);
			body.space = space;
			body.group = null;
		}
		
		public function onAddedToStage(evt:Event):void {
			body.position.y = stage.stageHeight - 32;
			body.position.x = stage.stageWidth / 2;
			y = stage.stageHeight - image.height * 0.7;
		}
		
		public function moveDown():void {
			return;
			TweenLite.to(this, 10, {
				y:y+768
			});
		}
	}
}