package a3d_helper.physics
{
	import alternativa.physicsengine.physics.types.Body;
	
	public class EffectOutput
	{
		public var name:String;
		public var body:Body;
		public var value:*;
		
		public function EffectOutput(name:String, body:Body, value:*)
		{
			this.name = name;
			this.body = body;
			this.value = value;
		}
	}
}
