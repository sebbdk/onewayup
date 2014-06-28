package dk.sebb.onewayup
{
	import starling.display.Image;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;

	public class Assets
	{
		// Embed the Atlas XML
		[Embed(source="../../../../assets/atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		[Embed(source="../../../../assets/atlas.png")]
		public static const AtlasTexture:Class;
		
		public static var atlas:TextureAtlas;
		
		//music
		[Embed(source='../../../../assets/music.mp3')]
		public static const music:Class;
		
		//fonts 
		[Embed( embedAsCFF="false", source="../../../../assets/fonts/visitor1.ttf", fontFamily="visitor")]
		public static const VisitorFont:Class;
		
		//jetpack particles!
		[Embed(source="../../../../assets/le_part/particle.pex", mimeType="application/octet-stream")]
		private static const BlastParticleConfig:Class;
		[Embed(source = "../../../../assets/le_part/texture.png")]
		private static const BlastParticle:Class;
		
		//eplosion particles
		[Embed(source="../../../../assets/explode/particle.pex", mimeType="application/octet-stream")]
		private static const ExplodeParticleConfig:Class;
		[Embed(source = "../../../../assets/explode/texture.png")]
		private static const ExplodeParticle:Class;
		
		public static function getBlastParticle():PDParticleSystem {
			var psConfig:XML = XML(new BlastParticleConfig());
			var psTexture:Texture = Texture.fromBitmap(new BlastParticle());
			
			// create particle system
			var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
			return ps;
		}
		
		public static function getExplodeParticle():PDParticleSystem {
			var psConfig:XML = XML(new ExplodeParticleConfig());
			var psTexture:Texture = Texture.fromBitmap(new ExplodeParticle());
			
			// create particle system
			var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
			return ps;
		}
		
		public static function getTexture(name:String):Texture {
			if(!atlas) {
				var texture:Texture = Texture.fromBitmap(new AtlasTexture());
				var xml:XML = XML(new AtlasXml());
				atlas = new TextureAtlas(texture, xml);
			}
			
			return atlas.getTexture(name);
		}
		
		public static function getImage(name:String):Image {
			var img:Image = new Image(getTexture(name));
			img.smoothing = TextureSmoothing.NONE;
			return img;
		}
	}
}