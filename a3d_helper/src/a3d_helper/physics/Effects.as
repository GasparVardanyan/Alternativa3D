package a3d_helper.physics
{
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.types.Body;
	import alternativa.physicsengine.physics.types.BodyList;
	import alternativa.physicsengine.physics.types.BodyListItem;
	import a3d_helper.utils.Utils;
	
	public class Effects
	{
		public function Effects() {}
		
		public static function Blast(bodies:BodyList, pos:Vector3, k:Number = 2500, name:String = "Blast", filter:IBodyFilter = null):Vector.<EffectOutput>
		{
			var output:Vector.<EffectOutput> = new Vector.<EffectOutput>();
			
			for (var bodyLI:BodyListItem = bodies.head; bodyLI != null; bodyLI = bodyLI.next)
			{
				if (bodyLI.body.movable && (filter == null || filter.acceptBody(bodyLI.body)))
				{
					var impulse:Vector3 = Utils.getBlastForce(pos, bodyLI.body.state.position, k);
					bodyLI.body.addForce(impulse);
					
					output.push(new EffectOutput(name, bodyLI.body, impulse));
				}
			}
			
			return output;
		}
		
		public static function TransformTo(body:Body, to:Vector3, k:Number = 1250, name:String = "TransformTo"):EffectOutput
		{
			var force:Vector3 = Utils.getTransformForce(body.state.position, to, k);
			body.addForce(force);
			return new EffectOutput(name, body, force);
		}
	}
}
