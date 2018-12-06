package cc3dexample 
{
	import alternativa.engine3d.core.Face;
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Wrapper;
	import alternativa.engine3d.objects.Mesh;
	use namespace alternativa3d;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class FaceMacros
	{
		
		public static function makeDoubleSided(mesh:Mesh):void {
			  // Create new list of faces and combine them together
			   var tailNewFace:Face;
			   var newFace:Face;
			   var headNewFace:Face;
			   var lastFace:Face;
			   for (var face:Face = mesh.faceList; face!=null; face= face.next) {
					newFace = cloneFace(face);
					flipFaces(newFace);
					if (tailNewFace !=  null) tailNewFace.next = newFace
					else headNewFace = newFace
					tailNewFace = newFace;
					lastFace = face;
			   }
			   // combine lists with new
			   lastFace.next = headNewFace;
		}
		
		public static function cloneFace(face:Face):Face  
		{
			// Prepare cloned face 
			var clipFace:Face = face.create();
			clipFace.material = face.material;
			clipFace.offset = face.offset;
			clipFace.normalX = face.normalX;
			clipFace.normalY = face.normalY;
			clipFace.normalZ = face.normalZ;
			
			// deepCloneWrapper() inline
			var wrapper:Wrapper = face.wrapper;
			var wrapperClone:Wrapper = wrapper.create();
			wrapperClone.vertex = wrapper.vertex;

			var w:Wrapper = wrapper.next;
			var tailWrapper:Wrapper = wrapperClone;
			var wClone:Wrapper;
			while (w != null) {
				wClone = w.create();
				wClone.vertex = w.vertex;
				tailWrapper.next = wClone;
				tailWrapper = wClone;
				w = w.next;
			}
			
		
			clipFace.wrapper =  wrapperClone;
			return clipFace;
		}
		
		public static function flipFaces(list:Face):void {
			
			for (var f:Face = list; f != null; f = f.next) {
				// Flip normal/offset values
				f.normalX = -f.normalX;
				f.normalY = -f.normalY;
				f.normalZ = -f.normalZ;
				f.offset = -f.offset;
				
				// Reverse vertex order
				var nextWrapper:Wrapper;
				var headerWrapper:Wrapper = null;
				for (var w:Wrapper = f.wrapper; w != null; w = nextWrapper) {
					nextWrapper = w.next;
					w.next = headerWrapper;
					headerWrapper = w;
				}
				f.wrapper = headerWrapper;
			}
			
		}
		
	}

}