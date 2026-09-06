package strategy.model {
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.types.Texture;
	
	/**
	 * Объекты отраженной сцены. 
	 */	
	public class InverseObjects extends Object3D {
		
		[Embed(source="textures/house_01_low.jpg")] private static const bmpHouse_01:Class;
		private static const house_01:Texture = new Texture(new bmpHouse_01().bitmapData, "house_01.png");
		[Embed(source="textures/house_02_low.jpg")] private static const bmpHouse_02:Class;
		private static const house_02:Texture = new Texture(new bmpHouse_02().bitmapData, "house_02.png");
		
		public function InverseObjects(name:String=null) {
			
			super(name);
			var house:Mesh = new House5(house_01)
			addChild(house);
			house = new House6(house_01);
			addChild(house);
			house = new House7(house_02);
			addChild(house);
			addChild(new Sky());
			addChild(new Cap());
						
		}

	}
}