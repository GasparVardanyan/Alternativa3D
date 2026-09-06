package entity {
	import alternativa.engine3d.objects.Mesh;

	/**
	 * ...
	 * @author redefy
	 */
	public class Entity extends Mesh {

		public function Entity(){
			GV.entitys.push(this);
		}
		
		public function update():void {
			
		}
	}
}