package strategy {
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.engine3d.events.MouseEvent3D;
	import alternativa.engine3d.materials.SpriteTextureMaterial;
	import alternativa.types.Texture;
	import alternativa.utils.BitmapUtils;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * Герой. 
	 */	
	public class SoldierHero extends MovingHero {	
		
		// Статус жизни
		private var lifeBar:Sprite3D;
		// Бубл с речью
		private var speach:Sprite3D;
		private var speachMaterial:SpeachMaterial;
		// Интервал времени, в течение которого герой "говорит"
		private const deltaSpeakTime:Number = 3000;
		// Интервал времени "молчания"
		private var _deltaSilenceTime:Number= 5000;
		
		[Embed(source="avatar/lifebar.png")] private static var lifebarClass:Class;
		private static const lifebarTexture:Texture = new Texture(new lifebarClass().bitmapData);
		[Embed(source="avatar/shadow.png")] private static var shadowClass:Class;
		private static const shadowTexture:Texture = new Texture(new shadowClass().bitmapData);
	
		[Embed(source="avatar/knight_000_0001.jpg")] private static var phase00001Bitmap:Class;
		private static const phase00001:Bitmap = new phase00001Bitmap();
		[Embed(source="avatar/knight_000_0001.gif")] private static var phase00001BitmapA:Class;
		private static const phase00001A:Bitmap = new phase00001BitmapA();
		[Embed(source="avatar/knight_000_0002.jpg")] private static var phase00002Bitmap:Class;
		private static const phase00002:Bitmap = new phase00002Bitmap();
		[Embed(source="avatar/knight_000_0002.gif")] private static var phase00002BitmapA:Class;
		private static const phase00002A:Bitmap = new phase00002BitmapA();
		[Embed(source="avatar/knight_000_0003.jpg")] private static var phase00003Bitmap:Class;
		private static const phase00003:Bitmap = new phase00003Bitmap();
		[Embed(source="avatar/knight_000_0003.gif")] private static var phase00003BitmapA:Class;
		private static const phase00003A:Bitmap = new phase00003BitmapA();
		[Embed(source="avatar/knight_000_0004.jpg")] private static var phase00004Bitmap:Class;
		private static const phase00004:Bitmap = new phase00004Bitmap();
		[Embed(source="avatar/knight_000_0004.gif")] private static var phase00004BitmapA:Class;
		private static const phase00004A:Bitmap = new phase00004BitmapA();
		[Embed(source="avatar/knight_000_0005.jpg")] private static var phase00005Bitmap:Class;
		private static const phase00005:Bitmap = new phase00005Bitmap();
		[Embed(source="avatar/knight_000_0005.gif")] private static var phase00005BitmapA:Class;
		private static const phase00005A:Bitmap = new phase00005BitmapA();
		[Embed(source="avatar/knight_000_0006.jpg")] private static var phase00006Bitmap:Class;
		private static const phase00006:Bitmap = new phase00006Bitmap();
		[Embed(source="avatar/knight_000_0006.gif")] private static var phase00006BitmapA:Class;
		private static const phase00006A:Bitmap = new phase00006BitmapA();
		[Embed(source="avatar/knight_000_0007.jpg")] private static var phase00007Bitmap:Class;
		private static const phase00007:Bitmap = new phase00007Bitmap();
		[Embed(source="avatar/knight_000_0007.gif")] private static var phase00007BitmapA:Class;
		private static const phase00007A:Bitmap = new phase00007BitmapA();
		[Embed(source="avatar/knight_000_0008.jpg")] private static var phase00008Bitmap:Class;
		private static const phase00008:Bitmap = new phase00008Bitmap();
		[Embed(source="avatar/knight_000_0008.gif")] private static var phase00008BitmapA:Class;
		private static const phase00008A:Bitmap = new phase00008BitmapA();
		[Embed(source="avatar/knight_000_0009.jpg")] private static var phase00009Bitmap:Class;
		private static const phase00009:Bitmap = new phase00009Bitmap();
		[Embed(source="avatar/knight_000_0009.gif")] private static var phase00009BitmapA:Class;
		private static const phase00009A:Bitmap = new phase00009BitmapA();
		[Embed(source="avatar/knight_000_0010.jpg")] private static var phase00010Bitmap:Class;
		private static const phase00010:Bitmap = new phase00010Bitmap();
		[Embed(source="avatar/knight_000_0010.gif")] private static var phase00010BitmapA:Class;
		private static const phase00010A:Bitmap = new phase00010BitmapA();
		[Embed(source="avatar/knight_000_0011.jpg")] private static var phase00011Bitmap:Class;
		private static const phase00011:Bitmap = new phase00011Bitmap();
		[Embed(source="avatar/knight_000_0011.gif")] private static var phase00011BitmapA:Class;
		private static const phase00011A:Bitmap = new phase00011BitmapA();
		[Embed(source="avatar/knight_000_0012.jpg")] private static var phase00012Bitmap:Class;
		private static const phase00012:Bitmap = new phase00012Bitmap();
		[Embed(source="avatar/knight_000_0012.gif")] private static var phase00012BitmapA:Class;
		private static const phase00012A:Bitmap = new phase00012BitmapA();
		[Embed(source="avatar/knight_000_0013.jpg")] private static var phase00013Bitmap:Class;
		private static const phase00013:Bitmap = new phase00013Bitmap();
		[Embed(source="avatar/knight_000_0013.gif")] private static var phase00013BitmapA:Class;
		private static const phase00013A:Bitmap = new phase00013BitmapA();
		[Embed(source="avatar/knight_000_0014.jpg")] private static var phase00014Bitmap:Class;
		private static const phase00014:Bitmap = new phase00014Bitmap();
		[Embed(source="avatar/knight_000_0014.gif")] private static var phase00014BitmapA:Class;
		private static const phase00014A:Bitmap = new phase00014BitmapA();
		[Embed(source="avatar/knight_000_0015.jpg")] private static var phase00015Bitmap:Class;
		private static const phase00015:Bitmap = new phase00015Bitmap();
		[Embed(source="avatar/knight_000_0015.gif")] private static var phase00015BitmapA:Class;
		private static const phase00015A:Bitmap = new phase00015BitmapA();
	
		[Embed(source="avatar/knight_045_0001.jpg")] private static var phase04501Bitmap:Class;
		private static const phase04501:Bitmap = new phase04501Bitmap();
		[Embed(source="avatar/knight_045_0001.gif")] private static var phase04501BitmapA:Class;
		private static const phase04501A:Bitmap = new phase04501BitmapA();
		[Embed(source="avatar/knight_045_0002.jpg")] private static var phase04502Bitmap:Class;
		private static const phase04502:Bitmap = new phase04502Bitmap();
		[Embed(source="avatar/knight_045_0002.gif")] private static var phase04502BitmapA:Class;
		private static const phase04502A:Bitmap = new phase04502BitmapA();
		[Embed(source="avatar/knight_045_0003.jpg")] private static var phase04503Bitmap:Class;
		private static const phase04503:Bitmap = new phase04503Bitmap();
		[Embed(source="avatar/knight_045_0003.gif")] private static var phase04503BitmapA:Class;
		private static const phase04503A:Bitmap = new phase04503BitmapA();
		[Embed(source="avatar/knight_045_0004.jpg")] private static var phase04504Bitmap:Class;
		private static const phase04504:Bitmap = new phase04504Bitmap();
		[Embed(source="avatar/knight_045_0004.gif")] private static var phase04504BitmapA:Class;
		private static const phase04504A:Bitmap = new phase04504BitmapA();
		[Embed(source="avatar/knight_045_0005.jpg")] private static var phase04505Bitmap:Class;
		private static const phase04505:Bitmap = new phase04505Bitmap();
		[Embed(source="avatar/knight_045_0005.gif")] private static var phase04505BitmapA:Class;
		private static const phase04505A:Bitmap = new phase04505BitmapA();
		[Embed(source="avatar/knight_045_0006.jpg")] private static var phase04506Bitmap:Class;
		private static const phase04506:Bitmap = new phase04506Bitmap();
		[Embed(source="avatar/knight_045_0006.gif")] private static var phase04506BitmapA:Class;
		private static const phase04506A:Bitmap = new phase04506BitmapA();
		[Embed(source="avatar/knight_045_0007.jpg")] private static var phase04507Bitmap:Class;
		private static const phase04507:Bitmap = new phase04507Bitmap();
		[Embed(source="avatar/knight_045_0007.gif")] private static var phase04507BitmapA:Class;
		private static const phase04507A:Bitmap = new phase04507BitmapA();
		[Embed(source="avatar/knight_045_0008.jpg")] private static var phase04508Bitmap:Class;
		private static const phase04508:Bitmap = new phase04508Bitmap();
		[Embed(source="avatar/knight_045_0008.gif")] private static var phase04508BitmapA:Class;
		private static const phase04508A:Bitmap = new phase04508BitmapA();
		[Embed(source="avatar/knight_045_0009.jpg")] private static var phase04509Bitmap:Class;
		private static const phase04509:Bitmap = new phase04509Bitmap();
		[Embed(source="avatar/knight_045_0009.gif")] private static var phase04509BitmapA:Class;
		private static const phase04509A:Bitmap = new phase04509BitmapA();
		[Embed(source="avatar/knight_045_0010.jpg")] private static var phase04510Bitmap:Class;
		private static const phase04510:Bitmap = new phase04510Bitmap();
		[Embed(source="avatar/knight_045_0010.gif")] private static var phase04510BitmapA:Class;
		private static const phase04510A:Bitmap = new phase04510BitmapA();
		[Embed(source="avatar/knight_045_0011.jpg")] private static var phase04511Bitmap:Class;
		private static const phase04511:Bitmap = new phase04511Bitmap();
		[Embed(source="avatar/knight_045_0011.gif")] private static var phase04511BitmapA:Class;
		private static const phase04511A:Bitmap = new phase04511BitmapA();
		[Embed(source="avatar/knight_045_0012.jpg")] private static var phase04512Bitmap:Class;
		private static const phase04512:Bitmap = new phase04512Bitmap();
		[Embed(source="avatar/knight_045_0012.gif")] private static var phase04512BitmapA:Class;
		private static const phase04512A:Bitmap = new phase04512BitmapA();
		[Embed(source="avatar/knight_045_0013.jpg")] private static var phase04513Bitmap:Class;
		private static const phase04513:Bitmap = new phase04513Bitmap();
		[Embed(source="avatar/knight_045_0013.gif")] private static var phase04513BitmapA:Class;
		private static const phase04513A:Bitmap = new phase04513BitmapA();
		[Embed(source="avatar/knight_045_0014.jpg")] private static var phase04514Bitmap:Class;
		private static const phase04514:Bitmap = new phase04514Bitmap();
		[Embed(source="avatar/knight_045_0014.gif")] private static var phase04514BitmapA:Class;
		private static const phase04514A:Bitmap = new phase04514BitmapA();
		[Embed(source="avatar/knight_045_0015.jpg")] private static var phase04515Bitmap:Class;
		private static const phase04515:Bitmap = new phase04515Bitmap();
		[Embed(source="avatar/knight_045_0015.gif")] private static var phase04515BitmapA:Class;
		private static const phase04515A:Bitmap = new phase04515BitmapA();
	
		[Embed(source="avatar/knight_090_0001.jpg")] private static var phase09001Bitmap:Class;
		private static const phase09001:Bitmap = new phase09001Bitmap();
		[Embed(source="avatar/knight_090_0001.gif")] private static var phase09001BitmapA:Class;
		private static const phase09001A:Bitmap = new phase09001BitmapA();
		[Embed(source="avatar/knight_090_0002.jpg")] private static var phase09002Bitmap:Class;
		private static const phase09002:Bitmap = new phase09002Bitmap();
		[Embed(source="avatar/knight_090_0002.gif")] private static var phase09002BitmapA:Class;
		private static const phase09002A:Bitmap = new phase09002BitmapA();
		[Embed(source="avatar/knight_090_0003.jpg")] private static var phase09003Bitmap:Class;
		private static const phase09003:Bitmap = new phase09003Bitmap();
		[Embed(source="avatar/knight_090_0003.gif")] private static var phase09003BitmapA:Class;
		private static const phase09003A:Bitmap = new phase09003BitmapA();
		[Embed(source="avatar/knight_090_0004.jpg")] private static var phase09004Bitmap:Class;
		private static const phase09004:Bitmap = new phase09004Bitmap();
		[Embed(source="avatar/knight_090_0004.gif")] private static var phase09004BitmapA:Class;
		private static const phase09004A:Bitmap = new phase09004BitmapA();
		[Embed(source="avatar/knight_090_0005.jpg")] private static var phase09005Bitmap:Class;
		private static const phase09005:Bitmap = new phase09005Bitmap();
		[Embed(source="avatar/knight_090_0005.gif")] private static var phase09005BitmapA:Class;
		private static const phase09005A:Bitmap = new phase09005BitmapA();
		[Embed(source="avatar/knight_090_0006.jpg")] private static var phase09006Bitmap:Class;
		private static const phase09006:Bitmap = new phase09006Bitmap();
		[Embed(source="avatar/knight_090_0006.gif")] private static var phase09006BitmapA:Class;
		private static const phase09006A:Bitmap = new phase09006BitmapA();
		[Embed(source="avatar/knight_090_0007.jpg")] private static var phase09007Bitmap:Class;
		private static const phase09007:Bitmap = new phase09007Bitmap();
		[Embed(source="avatar/knight_090_0007.gif")] private static var phase09007BitmapA:Class;
		private static const phase09007A:Bitmap = new phase09007BitmapA();
		[Embed(source="avatar/knight_090_0008.jpg")] private static var phase09008Bitmap:Class;
		private static const phase09008:Bitmap = new phase09008Bitmap();
		[Embed(source="avatar/knight_090_0008.gif")] private static var phase09008BitmapA:Class;
		private static const phase09008A:Bitmap = new phase09008BitmapA();
		[Embed(source="avatar/knight_090_0009.jpg")] private static var phase09009Bitmap:Class;
		private static const phase09009:Bitmap = new phase09009Bitmap();
		[Embed(source="avatar/knight_090_0009.gif")] private static var phase09009BitmapA:Class;
		private static const phase09009A:Bitmap = new phase09009BitmapA();
		[Embed(source="avatar/knight_090_0010.jpg")] private static var phase09010Bitmap:Class;
		private static const phase09010:Bitmap = new phase09010Bitmap();
		[Embed(source="avatar/knight_090_0010.gif")] private static var phase09010BitmapA:Class;
		private static const phase09010A:Bitmap = new phase09010BitmapA();
		[Embed(source="avatar/knight_090_0011.jpg")] private static var phase09011Bitmap:Class;
		private static const phase09011:Bitmap = new phase09011Bitmap();
		[Embed(source="avatar/knight_090_0011.gif")] private static var phase09011BitmapA:Class;
		private static const phase09011A:Bitmap = new phase09011BitmapA();
		[Embed(source="avatar/knight_090_0012.jpg")] private static var phase09012Bitmap:Class;
		private static const phase09012:Bitmap = new phase09012Bitmap();
		[Embed(source="avatar/knight_090_0012.gif")] private static var phase09012BitmapA:Class;
		private static const phase09012A:Bitmap = new phase09012BitmapA();
		[Embed(source="avatar/knight_090_0013.jpg")] private static var phase09013Bitmap:Class;
		private static const phase09013:Bitmap = new phase09013Bitmap();
		[Embed(source="avatar/knight_090_0013.gif")] private static var phase09013BitmapA:Class;
		private static const phase09013A:Bitmap = new phase09013BitmapA();
		[Embed(source="avatar/knight_090_0014.jpg")] private static var phase09014Bitmap:Class;
		private static const phase09014:Bitmap = new phase09014Bitmap();
		[Embed(source="avatar/knight_090_0014.gif")] private static var phase09014BitmapA:Class;
		private static const phase09014A:Bitmap = new phase09014BitmapA();
		[Embed(source="avatar/knight_090_0015.jpg")] private static var phase09015Bitmap:Class;
		private static const phase09015:Bitmap = new phase09015Bitmap();
		[Embed(source="avatar/knight_090_0015.gif")] private static var phase09015BitmapA:Class;
		private static const phase09015A:Bitmap = new phase09015BitmapA();

		
		[Embed(source="avatar/knight_135_0001.jpg")] private static var phase13501Bitmap:Class;
		private static const phase13501:Bitmap = new phase13501Bitmap();
		[Embed(source="avatar/knight_135_0001.gif")] private static var phase13501BitmapA:Class;
		private static const phase13501A:Bitmap = new phase13501BitmapA();
		[Embed(source="avatar/knight_135_0002.jpg")] private static var phase13502Bitmap:Class;
		private static const phase13502:Bitmap = new phase13502Bitmap();
		[Embed(source="avatar/knight_135_0002.gif")] private static var phase13502BitmapA:Class;
		private static const phase13502A:Bitmap = new phase13502BitmapA();
		[Embed(source="avatar/knight_135_0003.jpg")] private static var phase13503Bitmap:Class;
		private static const phase13503:Bitmap = new phase13503Bitmap();
		[Embed(source="avatar/knight_135_0003.gif")] private static var phase13503BitmapA:Class;
		private static const phase13503A:Bitmap = new phase13503BitmapA();
		[Embed(source="avatar/knight_135_0004.jpg")] private static var phase13504Bitmap:Class;
		private static const phase13504:Bitmap = new phase13504Bitmap();
		[Embed(source="avatar/knight_135_0004.gif")] private static var phase13504BitmapA:Class;
		private static const phase13504A:Bitmap = new phase13504BitmapA();
		[Embed(source="avatar/knight_135_0005.jpg")] private static var phase13505Bitmap:Class;
		private static const phase13505:Bitmap = new phase13505Bitmap();
		[Embed(source="avatar/knight_135_0005.gif")] private static var phase13505BitmapA:Class;
		private static const phase13505A:Bitmap = new phase13505BitmapA();
		[Embed(source="avatar/knight_135_0006.jpg")] private static var phase13506Bitmap:Class;
		private static const phase13506:Bitmap = new phase13506Bitmap();
		[Embed(source="avatar/knight_135_0006.gif")] private static var phase13506BitmapA:Class;
		private static const phase13506A:Bitmap = new phase13506BitmapA();
		[Embed(source="avatar/knight_135_0007.jpg")] private static var phase13507Bitmap:Class;
		private static const phase13507:Bitmap = new phase13507Bitmap();
		[Embed(source="avatar/knight_135_0007.gif")] private static var phase13507BitmapA:Class;
		private static const phase13507A:Bitmap = new phase13507BitmapA();
		[Embed(source="avatar/knight_135_0008.jpg")] private static var phase13508Bitmap:Class;
		private static const phase13508:Bitmap = new phase13508Bitmap();
		[Embed(source="avatar/knight_135_0008.gif")] private static var phase13508BitmapA:Class;
		private static const phase13508A:Bitmap = new phase13508BitmapA();
		[Embed(source="avatar/knight_135_0009.jpg")] private static var phase13509Bitmap:Class;
		private static const phase13509:Bitmap = new phase13509Bitmap();
		[Embed(source="avatar/knight_135_0009.gif")] private static var phase13509BitmapA:Class;
		private static const phase13509A:Bitmap = new phase13509BitmapA();
		[Embed(source="avatar/knight_135_0010.jpg")] private static var phase13510Bitmap:Class;
		private static const phase13510:Bitmap = new phase13510Bitmap();
		[Embed(source="avatar/knight_135_0010.gif")] private static var phase13510BitmapA:Class;
		private static const phase13510A:Bitmap = new phase13510BitmapA();
		[Embed(source="avatar/knight_135_0011.jpg")] private static var phase13511Bitmap:Class;
		private static const phase13511:Bitmap = new phase13511Bitmap();
		[Embed(source="avatar/knight_135_0011.gif")] private static var phase13511BitmapA:Class;
		private static const phase13511A:Bitmap = new phase13511BitmapA();
		[Embed(source="avatar/knight_135_0012.jpg")] private static var phase13512Bitmap:Class;
		private static const phase13512:Bitmap = new phase13512Bitmap();
		[Embed(source="avatar/knight_135_0012.gif")] private static var phase13512BitmapA:Class;
		private static const phase13512A:Bitmap = new phase13512BitmapA();
		[Embed(source="avatar/knight_135_0013.jpg")] private static var phase13513Bitmap:Class;
		private static const phase13513:Bitmap = new phase13513Bitmap();
		[Embed(source="avatar/knight_135_0013.gif")] private static var phase13513BitmapA:Class;
		private static const phase13513A:Bitmap = new phase13513BitmapA();
		[Embed(source="avatar/knight_135_0014.jpg")] private static var phase13514Bitmap:Class;
		private static const phase13514:Bitmap = new phase13514Bitmap();
		[Embed(source="avatar/knight_135_0014.gif")] private static var phase13514BitmapA:Class;
		private static const phase13514A:Bitmap = new phase13514BitmapA();
		[Embed(source="avatar/knight_135_0015.jpg")] private static var phase13515Bitmap:Class;
		private static const phase13515:Bitmap = new phase13515Bitmap();
		[Embed(source="avatar/knight_135_0015.gif")] private static var phase13515BitmapA:Class;
		private static const phase13515A:Bitmap = new phase13515BitmapA();
	
		[Embed(source="avatar/knight_180_0001.jpg")] private static var phase18001Bitmap:Class;
		private static const phase18001:Bitmap = new phase18001Bitmap();
		[Embed(source="avatar/knight_180_0001.gif")] private static var phase18001BitmapA:Class;
		private static const phase18001A:Bitmap = new phase18001BitmapA();
		[Embed(source="avatar/knight_180_0002.jpg")] private static var phase18002Bitmap:Class;
		private static const phase18002:Bitmap = new phase18002Bitmap();
		[Embed(source="avatar/knight_180_0002.gif")] private static var phase18002BitmapA:Class;
		private static const phase18002A:Bitmap = new phase18002BitmapA();
		[Embed(source="avatar/knight_180_0003.jpg")] private static var phase18003Bitmap:Class;
		private static const phase18003:Bitmap = new phase18003Bitmap();
		[Embed(source="avatar/knight_180_0003.gif")] private static var phase18003BitmapA:Class;
		private static const phase18003A:Bitmap = new phase18003BitmapA();
		[Embed(source="avatar/knight_180_0004.jpg")] private static var phase18004Bitmap:Class;
		private static const phase18004:Bitmap = new phase18004Bitmap();
		[Embed(source="avatar/knight_180_0004.gif")] private static var phase18004BitmapA:Class;
		private static const phase18004A:Bitmap = new phase18004BitmapA();
		[Embed(source="avatar/knight_180_0005.jpg")] private static var phase18005Bitmap:Class;
		private static const phase18005:Bitmap = new phase18005Bitmap();
		[Embed(source="avatar/knight_180_0005.gif")] private static var phase18005BitmapA:Class;
		private static const phase18005A:Bitmap = new phase18005BitmapA();
		[Embed(source="avatar/knight_180_0006.jpg")] private static var phase18006Bitmap:Class;
		private static const phase18006:Bitmap = new phase18006Bitmap();
		[Embed(source="avatar/knight_180_0006.gif")] private static var phase18006BitmapA:Class;
		private static const phase18006A:Bitmap = new phase18006BitmapA();
		[Embed(source="avatar/knight_180_0007.jpg")] private static var phase18007Bitmap:Class;
		private static const phase18007:Bitmap = new phase18007Bitmap();
		[Embed(source="avatar/knight_180_0007.gif")] private static var phase18007BitmapA:Class;
		private static const phase18007A:Bitmap = new phase18007BitmapA();
		[Embed(source="avatar/knight_180_0008.jpg")] private static var phase18008Bitmap:Class;
		private static const phase18008:Bitmap = new phase18008Bitmap();
		[Embed(source="avatar/knight_180_0008.gif")] private static var phase18008BitmapA:Class;
		private static const phase18008A:Bitmap = new phase18008BitmapA();
		[Embed(source="avatar/knight_180_0009.jpg")] private static var phase18009Bitmap:Class;
		private static const phase18009:Bitmap = new phase18009Bitmap();
		[Embed(source="avatar/knight_180_0009.gif")] private static var phase18009BitmapA:Class;
		private static const phase18009A:Bitmap = new phase18009BitmapA();
		[Embed(source="avatar/knight_180_0010.jpg")] private static var phase18010Bitmap:Class;
		private static const phase18010:Bitmap = new phase18010Bitmap();
		[Embed(source="avatar/knight_180_0010.gif")] private static var phase18010BitmapA:Class;
		private static const phase18010A:Bitmap = new phase18010BitmapA();
		[Embed(source="avatar/knight_180_0011.jpg")] private static var phase18011Bitmap:Class;
		private static const phase18011:Bitmap = new phase18011Bitmap();
		[Embed(source="avatar/knight_180_0011.gif")] private static var phase18011BitmapA:Class;
		private static const phase18011A:Bitmap = new phase18011BitmapA();
		[Embed(source="avatar/knight_180_0012.jpg")] private static var phase18012Bitmap:Class;
		private static const phase18012:Bitmap = new phase18012Bitmap();
		[Embed(source="avatar/knight_180_0012.gif")] private static var phase18012BitmapA:Class;
		private static const phase18012A:Bitmap = new phase18012BitmapA();
		[Embed(source="avatar/knight_180_0013.jpg")] private static var phase18013Bitmap:Class;
		private static const phase18013:Bitmap = new phase18013Bitmap();
		[Embed(source="avatar/knight_180_0013.gif")] private static var phase18013BitmapA:Class;
		private static const phase18013A:Bitmap = new phase18013BitmapA();
		[Embed(source="avatar/knight_180_0014.jpg")] private static var phase18014Bitmap:Class;
		private static const phase18014:Bitmap = new phase18014Bitmap();
		[Embed(source="avatar/knight_180_0014.gif")] private static var phase18014BitmapA:Class;
		private static const phase18014A:Bitmap = new phase18014BitmapA();
		[Embed(source="avatar/knight_180_0015.jpg")] private static var phase18015Bitmap:Class;
		private static const phase18015:Bitmap = new phase18015Bitmap();
		[Embed(source="avatar/knight_180_0015.gif")] private static var phase18015BitmapA:Class;
		private static const phase18015A:Bitmap = new phase18015BitmapA();
		
		[Embed(source="avatar/knight_225_0001.jpg")] private static var phase22501Bitmap:Class;
		private static const phase22501:Bitmap = new phase22501Bitmap();
		[Embed(source="avatar/knight_225_0001.gif")] private static var phase22501BitmapA:Class;
		private static const phase22501A:Bitmap = new phase22501BitmapA();
		[Embed(source="avatar/knight_225_0002.jpg")] private static var phase22502Bitmap:Class;
		private static const phase22502:Bitmap = new phase22502Bitmap();
		[Embed(source="avatar/knight_225_0002.gif")] private static var phase22502BitmapA:Class;
		private static const phase22502A:Bitmap = new phase22502BitmapA();
		[Embed(source="avatar/knight_225_0003.jpg")] private static var phase22503Bitmap:Class;
		private static const phase22503:Bitmap = new phase22503Bitmap();
		[Embed(source="avatar/knight_225_0003.gif")] private static var phase22503BitmapA:Class;
		private static const phase22503A:Bitmap = new phase22503BitmapA();
		[Embed(source="avatar/knight_225_0004.jpg")] private static var phase22504Bitmap:Class;
		private static const phase22504:Bitmap = new phase22504Bitmap();
		[Embed(source="avatar/knight_225_0004.gif")] private static var phase22504BitmapA:Class;
		private static const phase22504A:Bitmap = new phase22504BitmapA();
		[Embed(source="avatar/knight_225_0005.jpg")] private static var phase22505Bitmap:Class;
		private static const phase22505:Bitmap = new phase22505Bitmap();
		[Embed(source="avatar/knight_225_0005.gif")] private static var phase22505BitmapA:Class;
		private static const phase22505A:Bitmap = new phase22505BitmapA();
		[Embed(source="avatar/knight_225_0006.jpg")] private static var phase22506Bitmap:Class;
		private static const phase22506:Bitmap = new phase22506Bitmap();
		[Embed(source="avatar/knight_225_0006.gif")] private static var phase22506BitmapA:Class;
		private static const phase22506A:Bitmap = new phase22506BitmapA();
		[Embed(source="avatar/knight_225_0007.jpg")] private static var phase22507Bitmap:Class;
		private static const phase22507:Bitmap = new phase22507Bitmap();
		[Embed(source="avatar/knight_225_0007.gif")] private static var phase22507BitmapA:Class;
		private static const phase22507A:Bitmap = new phase22507BitmapA();
		[Embed(source="avatar/knight_225_0008.jpg")] private static var phase22508Bitmap:Class;
		private static const phase22508:Bitmap = new phase22508Bitmap();
		[Embed(source="avatar/knight_225_0008.gif")] private static var phase22508BitmapA:Class;
		private static const phase22508A:Bitmap = new phase22508BitmapA();
		[Embed(source="avatar/knight_225_0009.jpg")] private static var phase22509Bitmap:Class;
		private static const phase22509:Bitmap = new phase22509Bitmap();
		[Embed(source="avatar/knight_225_0009.gif")] private static var phase22509BitmapA:Class;
		private static const phase22509A:Bitmap = new phase22509BitmapA();
		[Embed(source="avatar/knight_225_0010.jpg")] private static var phase22510Bitmap:Class;
		private static const phase22510:Bitmap = new phase22510Bitmap();
		[Embed(source="avatar/knight_225_0010.gif")] private static var phase22510BitmapA:Class;
		private static const phase22510A:Bitmap = new phase22510BitmapA();
		[Embed(source="avatar/knight_225_0011.jpg")] private static var phase22511Bitmap:Class;
		private static const phase22511:Bitmap = new phase22511Bitmap();
		[Embed(source="avatar/knight_225_0011.gif")] private static var phase22511BitmapA:Class;
		private static const phase22511A:Bitmap = new phase22511BitmapA();
		[Embed(source="avatar/knight_225_0012.jpg")] private static var phase22512Bitmap:Class;
		private static const phase22512:Bitmap = new phase22512Bitmap();
		[Embed(source="avatar/knight_225_0012.gif")] private static var phase22512BitmapA:Class;
		private static const phase22512A:Bitmap = new phase22512BitmapA();
		[Embed(source="avatar/knight_225_0013.jpg")] private static var phase22513Bitmap:Class;
		private static const phase22513:Bitmap = new phase22513Bitmap();
		[Embed(source="avatar/knight_225_0013.gif")] private static var phase22513BitmapA:Class;
		private static const phase22513A:Bitmap = new phase22513BitmapA();
		[Embed(source="avatar/knight_225_0014.jpg")] private static var phase22514Bitmap:Class;
		private static const phase22514:Bitmap = new phase22514Bitmap();
		[Embed(source="avatar/knight_225_0014.gif")] private static var phase22514BitmapA:Class;
		private static const phase22514A:Bitmap = new phase22514BitmapA();
		[Embed(source="avatar/knight_225_0015.jpg")] private static var phase22515Bitmap:Class;
		private static const phase22515:Bitmap = new phase22515Bitmap();
		[Embed(source="avatar/knight_225_0015.gif")] private static var phase22515BitmapA:Class;
		private static const phase22515A:Bitmap = new phase22515BitmapA();
	
		[Embed(source="avatar/knight_270_0001.jpg")] private static var phase27001Bitmap:Class;
		private static const phase27001:Bitmap = new phase27001Bitmap();
		[Embed(source="avatar/knight_270_0001.gif")] private static var phase27001BitmapA:Class;
		private static const phase27001A:Bitmap = new phase27001BitmapA();
		[Embed(source="avatar/knight_270_0002.jpg")] private static var phase27002Bitmap:Class;
		private static const phase27002:Bitmap = new phase27002Bitmap();
		[Embed(source="avatar/knight_270_0002.gif")] private static var phase27002BitmapA:Class;
		private static const phase27002A:Bitmap = new phase27002BitmapA();
		[Embed(source="avatar/knight_270_0003.jpg")] private static var phase27003Bitmap:Class;
		private static const phase27003:Bitmap = new phase27003Bitmap();
		[Embed(source="avatar/knight_270_0003.gif")] private static var phase27003BitmapA:Class;
		private static const phase27003A:Bitmap = new phase27003BitmapA();
		[Embed(source="avatar/knight_270_0004.jpg")] private static var phase27004Bitmap:Class;
		private static const phase27004:Bitmap = new phase27004Bitmap();
		[Embed(source="avatar/knight_270_0004.gif")] private static var phase27004BitmapA:Class;
		private static const phase27004A:Bitmap = new phase27004BitmapA();
		[Embed(source="avatar/knight_270_0005.jpg")] private static var phase27005Bitmap:Class;
		private static const phase27005:Bitmap = new phase27005Bitmap();
		[Embed(source="avatar/knight_270_0005.gif")] private static var phase27005BitmapA:Class;
		private static const phase27005A:Bitmap = new phase27005BitmapA();
		[Embed(source="avatar/knight_270_0006.jpg")] private static var phase27006Bitmap:Class;
		private static const phase27006:Bitmap = new phase27006Bitmap();
		[Embed(source="avatar/knight_270_0006.gif")] private static var phase27006BitmapA:Class;
		private static const phase27006A:Bitmap = new phase27006BitmapA();
		[Embed(source="avatar/knight_270_0007.jpg")] private static var phase27007Bitmap:Class;
		private static const phase27007:Bitmap = new phase27007Bitmap();
		[Embed(source="avatar/knight_270_0007.gif")] private static var phase27007BitmapA:Class;
		private static const phase27007A:Bitmap = new phase27007BitmapA();
		[Embed(source="avatar/knight_270_0008.jpg")] private static var phase27008Bitmap:Class;
		private static const phase27008:Bitmap = new phase27008Bitmap();
		[Embed(source="avatar/knight_270_0008.gif")] private static var phase27008BitmapA:Class;
		private static const phase27008A:Bitmap = new phase27008BitmapA();
		[Embed(source="avatar/knight_270_0009.jpg")] private static var phase27009Bitmap:Class;
		private static const phase27009:Bitmap = new phase27009Bitmap();
		[Embed(source="avatar/knight_270_0009.gif")] private static var phase27009BitmapA:Class;
		private static const phase27009A:Bitmap = new phase27009BitmapA();
		[Embed(source="avatar/knight_270_0010.jpg")] private static var phase27010Bitmap:Class;
		private static const phase27010:Bitmap = new phase27010Bitmap();
		[Embed(source="avatar/knight_270_0010.gif")] private static var phase27010BitmapA:Class;
		private static const phase27010A:Bitmap = new phase27010BitmapA();
		[Embed(source="avatar/knight_270_0011.jpg")] private static var phase27011Bitmap:Class;
		private static const phase27011:Bitmap = new phase27011Bitmap();
		[Embed(source="avatar/knight_270_0011.gif")] private static var phase27011BitmapA:Class;
		private static const phase27011A:Bitmap = new phase27011BitmapA();
		[Embed(source="avatar/knight_270_0012.jpg")] private static var phase27012Bitmap:Class;
		private static const phase27012:Bitmap = new phase27012Bitmap();
		[Embed(source="avatar/knight_270_0012.gif")] private static var phase27012BitmapA:Class;
		private static const phase27012A:Bitmap = new phase27012BitmapA();
		[Embed(source="avatar/knight_270_0013.jpg")] private static var phase27013Bitmap:Class;
		private static const phase27013:Bitmap = new phase27013Bitmap();
		[Embed(source="avatar/knight_270_0013.gif")] private static var phase27013BitmapA:Class;
		private static const phase27013A:Bitmap = new phase27013BitmapA();
		[Embed(source="avatar/knight_270_0014.jpg")] private static var phase27014Bitmap:Class;
		private static const phase27014:Bitmap = new phase27014Bitmap();
		[Embed(source="avatar/knight_270_0014.gif")] private static var phase27014BitmapA:Class;
		private static const phase27014A:Bitmap = new phase27014BitmapA();
		[Embed(source="avatar/knight_270_0015.jpg")] private static var phase27015Bitmap:Class;
		private static const phase27015:Bitmap = new phase27015Bitmap();
		[Embed(source="avatar/knight_270_0015.gif")] private static var phase27015BitmapA:Class;
		private static const phase27015A:Bitmap = new phase27015BitmapA();
	
		[Embed(source="avatar/knight_315_0001.jpg")] private static var phase31501Bitmap:Class;
		private static const phase31501:Bitmap = new phase31501Bitmap();
		[Embed(source="avatar/knight_315_0001.gif")] private static var phase31501BitmapA:Class;
		private static const phase31501A:Bitmap = new phase31501BitmapA();
		[Embed(source="avatar/knight_315_0002.jpg")] private static var phase31502Bitmap:Class;
		private static const phase31502:Bitmap = new phase31502Bitmap();
		[Embed(source="avatar/knight_315_0002.gif")] private static var phase31502BitmapA:Class;
		private static const phase31502A:Bitmap = new phase31502BitmapA();
		[Embed(source="avatar/knight_315_0003.jpg")] private static var phase31503Bitmap:Class;
		private static const phase31503:Bitmap = new phase31503Bitmap();
		[Embed(source="avatar/knight_315_0003.gif")] private static var phase31503BitmapA:Class;
		private static const phase31503A:Bitmap = new phase31503BitmapA();
		[Embed(source="avatar/knight_315_0004.jpg")] private static var phase31504Bitmap:Class;
		private static const phase31504:Bitmap = new phase31504Bitmap();
		[Embed(source="avatar/knight_315_0004.gif")] private static var phase31504BitmapA:Class;
		private static const phase31504A:Bitmap = new phase31504BitmapA();
		[Embed(source="avatar/knight_315_0005.jpg")] private static var phase31505Bitmap:Class;
		private static const phase31505:Bitmap = new phase31505Bitmap();
		[Embed(source="avatar/knight_315_0005.gif")] private static var phase31505BitmapA:Class;
		private static const phase31505A:Bitmap = new phase31505BitmapA();
		[Embed(source="avatar/knight_315_0006.jpg")] private static var phase31506Bitmap:Class;
		private static const phase31506:Bitmap = new phase31506Bitmap();
		[Embed(source="avatar/knight_315_0006.gif")] private static var phase31506BitmapA:Class;
		private static const phase31506A:Bitmap = new phase31506BitmapA();
		[Embed(source="avatar/knight_315_0007.jpg")] private static var phase31507Bitmap:Class;
		private static const phase31507:Bitmap = new phase31507Bitmap();
		[Embed(source="avatar/knight_315_0007.gif")] private static var phase31507BitmapA:Class;
		private static const phase31507A:Bitmap = new phase31507BitmapA();
		[Embed(source="avatar/knight_315_0008.jpg")] private static var phase31508Bitmap:Class;
		private static const phase31508:Bitmap = new phase31508Bitmap();
		[Embed(source="avatar/knight_315_0008.gif")] private static var phase31508BitmapA:Class;
		private static const phase31508A:Bitmap = new phase31508BitmapA();
		[Embed(source="avatar/knight_315_0009.jpg")] private static var phase31509Bitmap:Class;
		private static const phase31509:Bitmap = new phase31509Bitmap();
		[Embed(source="avatar/knight_315_0009.gif")] private static var phase31509BitmapA:Class;
		private static const phase31509A:Bitmap = new phase31509BitmapA();
		[Embed(source="avatar/knight_315_0010.jpg")] private static var phase31510Bitmap:Class;
		private static const phase31510:Bitmap = new phase31510Bitmap();
		[Embed(source="avatar/knight_315_0010.gif")] private static var phase31510BitmapA:Class;
		private static const phase31510A:Bitmap = new phase31510BitmapA();
		[Embed(source="avatar/knight_315_0011.jpg")] private static var phase31511Bitmap:Class;
		private static const phase31511:Bitmap = new phase31511Bitmap();
		[Embed(source="avatar/knight_315_0011.gif")] private static var phase31511BitmapA:Class;
		private static const phase31511A:Bitmap = new phase31511BitmapA();
		[Embed(source="avatar/knight_315_0012.jpg")] private static var phase31512Bitmap:Class;
		private static const phase31512:Bitmap = new phase31512Bitmap();
		[Embed(source="avatar/knight_315_0012.gif")] private static var phase31512BitmapA:Class;
		private static const phase31512A:Bitmap = new phase31512BitmapA();
		[Embed(source="avatar/knight_315_0013.jpg")] private static var phase31513Bitmap:Class;
		private static const phase31513:Bitmap = new phase31513Bitmap();
		[Embed(source="avatar/knight_315_0013.gif")] private static var phase31513BitmapA:Class;
		private static const phase31513A:Bitmap = new phase31513BitmapA();
		[Embed(source="avatar/knight_315_0014.jpg")] private static var phase31514Bitmap:Class;
		private static const phase31514:Bitmap = new phase31514Bitmap();
		[Embed(source="avatar/knight_315_0014.gif")] private static var phase31514BitmapA:Class;
		private static const phase31514A:Bitmap = new phase31514BitmapA();
		[Embed(source="avatar/knight_315_0015.jpg")] private static var phase31515Bitmap:Class;
		private static const phase31515:Bitmap = new phase31515Bitmap();
		[Embed(source="avatar/knight_315_0015.gif")] private static var phase31515BitmapA:Class;
		private static const phase31515A:Bitmap = new phase31515BitmapA();
		
		/**
		 * Конструктор класса.
		 * @param position позиция на сетке, в которой будет находится герой 
		 * @param direction направление лицевой фазы
		 * @param name
		 */
		public function SoldierHero(position:Point, direction:Point, name:String=null) {
			// Инициализация списка текстур [шаг][фаза]
			steps = initSteps();
			super(position, direction);
	
			this.scaleX = this.scaleY = this.scaleZ = 5;
			// Установка обработчика для выделения
			addEventListener(MouseEvent3D.CLICK, click);
			// Статус жизни
			lifeBar = new Sprite3D();
			var lifeMaterial:SpriteTextureMaterial = new SpriteTextureMaterial(lifebarTexture);
			lifeBar.material = lifeMaterial;
			lifeBar.z = steps[0][0].height;
			// Речь
			speach = new Sprite3D();
			speach.z = lifeBar.z;
			speachMaterial = new SpeachMaterial();
			speach.material = speachMaterial;
			// Тень
			var shadow:Sprite3D = new Sprite3D();
			shadow.material = new SpriteTextureMaterial(shadowTexture, 1, false, BlendMode.NORMAL, 0.5, 0.5);
			addChild(shadow);
			
		}
		
		public function set deltaSilenceTime(value:Number):void {
			_deltaSilenceTime = value;
		}

		/**
		 * Инициализация списка текстур.  
		 * @return двумерный список [шаг][фаза]
		 */		
		private function initSteps():Array {
			
			return new Array(
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00001.bitmapData, phase00001A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04501.bitmapData, phase04501A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09001.bitmapData, phase09001A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13501.bitmapData, phase13501A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18001.bitmapData, phase18001A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22501.bitmapData, phase22501A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27001.bitmapData, phase27001A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31501.bitmapData, phase31501A.bitmapData, false))), 
		    new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00002.bitmapData, phase00002A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04502.bitmapData, phase04502A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09002.bitmapData, phase09002A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13502.bitmapData, phase13502A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18002.bitmapData, phase18002A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22502.bitmapData, phase22502A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27002.bitmapData, phase27002A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31502.bitmapData, phase31502A.bitmapData, false))),  
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00003.bitmapData, phase00003A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04503.bitmapData, phase04503A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09003.bitmapData, phase09003A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13503.bitmapData, phase13503A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18003.bitmapData, phase18003A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22503.bitmapData, phase22503A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27003.bitmapData, phase27003A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31503.bitmapData, phase31503A.bitmapData, false))), 
			new Array(
			    new Texture(BitmapUtils.mergeBitmapAlpha(phase00004.bitmapData, phase00004A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04504.bitmapData, phase04504A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09004.bitmapData, phase09004A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13504.bitmapData, phase13504A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18004.bitmapData, phase18004A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22504.bitmapData, phase22504A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27004.bitmapData, phase27004A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31504.bitmapData, phase31504A.bitmapData, false))), 
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00005.bitmapData, phase00005A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04505.bitmapData, phase04505A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09005.bitmapData, phase09005A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13505.bitmapData, phase13505A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18005.bitmapData, phase18005A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22505.bitmapData, phase22505A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27005.bitmapData, phase27005A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31505.bitmapData, phase31505A.bitmapData, false))), 
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00006.bitmapData, phase00006A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04506.bitmapData, phase04506A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09006.bitmapData, phase09006A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13506.bitmapData, phase13506A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18006.bitmapData, phase18006A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22506.bitmapData, phase22506A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27006.bitmapData, phase27006A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31506.bitmapData, phase31506A.bitmapData, false))), 
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00007.bitmapData, phase00007A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04507.bitmapData, phase04507A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09007.bitmapData, phase09007A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13507.bitmapData, phase13507A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18007.bitmapData, phase18007A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22507.bitmapData, phase22507A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27007.bitmapData, phase27007A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31507.bitmapData, phase31507A.bitmapData, false))), 
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00008.bitmapData, phase00008A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04508.bitmapData, phase04508A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09008.bitmapData, phase09008A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13508.bitmapData, phase13508A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18008.bitmapData, phase18008A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22508.bitmapData, phase22508A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27008.bitmapData, phase27008A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31508.bitmapData, phase31508A.bitmapData, false))), 
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00009.bitmapData, phase00009A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04509.bitmapData, phase04509A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09009.bitmapData, phase09009A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13509.bitmapData, phase13509A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18009.bitmapData, phase18009A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22509.bitmapData, phase22509A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27009.bitmapData, phase27009A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31509.bitmapData, phase31509A.bitmapData, false))), 
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00010.bitmapData, phase00010A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04510.bitmapData, phase04510A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09010.bitmapData, phase09010A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13510.bitmapData, phase13510A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18010.bitmapData, phase18010A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22510.bitmapData, phase22510A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27010.bitmapData, phase27010A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31510.bitmapData, phase31510A.bitmapData, false))), 					
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00011.bitmapData, phase00011A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04511.bitmapData, phase04511A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09011.bitmapData, phase09011A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13511.bitmapData, phase13511A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18011.bitmapData, phase18011A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22511.bitmapData, phase22511A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27011.bitmapData, phase27011A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31511.bitmapData, phase31511A.bitmapData, false))), 					
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00012.bitmapData, phase00012A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04512.bitmapData, phase04512A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09012.bitmapData, phase09012A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13512.bitmapData, phase13512A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18012.bitmapData, phase18012A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22512.bitmapData, phase22512A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27012.bitmapData, phase27012A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31512.bitmapData, phase31512A.bitmapData, false))), 
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00013.bitmapData, phase00013A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04513.bitmapData, phase04513A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09013.bitmapData, phase09013A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13513.bitmapData, phase13513A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18013.bitmapData, phase18013A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22513.bitmapData, phase22513A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27013.bitmapData, phase27013A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31513.bitmapData, phase31513A.bitmapData, false))),
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00014.bitmapData, phase00014A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04514.bitmapData, phase04514A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09014.bitmapData, phase09014A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13514.bitmapData, phase13514A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18014.bitmapData, phase18014A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22514.bitmapData, phase22514A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27014.bitmapData, phase27014A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31514.bitmapData, phase31514A.bitmapData, false))), 						 				
			new Array(
				new Texture(BitmapUtils.mergeBitmapAlpha(phase00015.bitmapData, phase00015A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase04515.bitmapData, phase04515A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase09015.bitmapData, phase09015A.bitmapData, false)),
				new Texture(BitmapUtils.mergeBitmapAlpha(phase13515.bitmapData, phase13515A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase18015.bitmapData, phase18015A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase22515.bitmapData, phase22515A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase27015.bitmapData, phase27015A.bitmapData, false)), 
				new Texture(BitmapUtils.mergeBitmapAlpha(phase31515.bitmapData, phase31515A.bitmapData, false)))); 						 				
									
			
		}

		/**
		 * Обработка клика на героя. 
		 */		
		public function click(e:MouseEvent3D):void {
			
			if (this.children.has(lifeBar)) {
				deselect();
			} else {
				
				if (!Strategy.shiftDown) { 
					for (var h:* in Strategy.selectedHeroes) {
						var selHero:SoldierHero = h as SoldierHero;
						selHero.deselect();
					}
				}
				select();
			}
								
		}
		
		/**
		 * Выделение героя. 
		 */		
		public function select():void {
			
			if (!this.children.has(lifeBar)) { 
				this.addChild(lifeBar);
			}
			Strategy.selectedHeroes.add(this);
		}
		
		/**
		 * Снятие выделения с героя. 
		 */		
		public function deselect():void {
			this.removeChild(lifeBar);
			Strategy.selectedHeroes.remove(this);
		}
		
		private var lastSpeakTime:Number = 0;
		// Индикатор текущего состояния (говорит/не говорит)
		private var flagSpeak:Boolean = false;
		
		/**
		 * Определяет речь героя.
		 */		
		public function speak():void {
			
			var speakTime:Number = getTimer();
			if (flagSpeak) {
				if (speakTime - lastSpeakTime > deltaSpeakTime) {
					removeChild(speach);
					lastSpeakTime = speakTime;
					flagSpeak = false;
				}
				
			} else {
				if (speakTime - lastSpeakTime > _deltaSilenceTime) {
					speachMaterial.speak();
					addChild(speach);
					lastSpeakTime = speakTime;
					flagSpeak = true;
				}
			}
			
			
		}
	}
}
	