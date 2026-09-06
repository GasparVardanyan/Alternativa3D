package strategy.model {
	import alternativa.types.Texture;

	/**
	 * Здания. 
	 */	
	public class Objects extends TextureLoader {
		[Embed(source="textures/house_01_low.jpg")] private static const bmpHouse_01:Class;
		private static const house_01:Texture = new Texture(new bmpHouse_01().bitmapData, "house_01.png");
		[Embed(source="textures/house_02_low.jpg")] private static const bmpHouse_02:Class;
		private static const house_02:Texture = new Texture(new bmpHouse_02().bitmapData, "house_02.png");
		
		
		public function Objects(name:String=null) {
			super();
			
			var house01:Array = new Array();
			var house02:Array = new Array();
			
			var house:House0 = new House0(house_01); 
			addChild(house);
			house01.push(house.material);
			
			// Крыша большого дома
			var house1:House1 = new House1(house_01);
			addChild(house1);
			house01.push(house1.material);
			
			// Дом большой
			var house2:House2 = new House2(house_02);
			addChild(house2);
			house02.push(house2.material);
			
			var house22:House22 = new House22(house_02); 
			addChild(house22);
			house02.push(house22.material);
			
			var house3:House3 = new House3(house_02);
			addChild(house3);
			house02.push(house3.material);
			
			var house4:House4 = new House4(house_01); 
			addChild(house4);
			house01.push(house4.material);
			
			var house44:House44 = new House44(house_01); 
			addChild(house44);
			house01.push(house44.material);
			
			addChild(new FenceClass());
			
			var house8:House8 = new House8(house_02);  
			addChild(house8);
			house02.push(house8.material);
		
			// Вспомогательные объекты с более низкой мобильностью для оптимизации BSP-дерева			
			addChild(new Box1());
			addChild(new Box2());
			addChild(new BigBox1());
			addChild(new BigBox2());
			
			// Пути к текстурам высокого разрешения
			urls = ["alternativa/demo/strategy/model/textures/house_01.jpg", "alternativa/demo/strategy/model/textures/house_02.jpg"];
			materials = [house01, house02];
				
		}
		
		
		
	}
}