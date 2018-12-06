/**
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * If it is not possible or desirable to put the notice in a particular file, then You may include the notice in a location (such as a LICENSE file in a relevant directory) where a recipient would be likely to look for such a notice.
 * You may add additional accurate notices of copyright ownership.
 *
 * It is desirable to notify that Covered Software was "Powered by AlternativaPlatform" with link to http://www.alternativaplatform.com/ 
 * */

package alternativa.engine3d.primitives {

	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.Geometry;

	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Vector3D;

	use namespace alternativa3d;

	/**
	 * A plane primitive.
	 */
	public class Sprites3D extends Mesh {

		/**
		 * Creates a new Plane instance.
		 * @param width Width. Can not be less than 0.
		 * @param length Length. Can not be less than 0.
		 * @param widthSegments Number of subdivisions along x-axis.
		 * @param lengthSegments Number of subdivisions along y-axis.
		 * @param twoSided If <code>true</code>, plane has surface for both sides: tob and bottom and only one otherwise.
		 * @param reverse If   <code>twoSided=false</code>, reverse parameter determines for which side surface will be created.
		 * @param bottom Material of the bottom surface.
		 * @param top Material of the top surface.
		 */
		public function Sprites3D(width:Number = 100, height:Number = 100, material:Material = null) {

			var dWidth:Number = width/2;
			var dHeight:Number = height/2;
			// Set bounds
			geometry = new Geometry(4);
			var attributes:Array = new Array;
			attributes[0] = VertexAttributes.POSITION;
			attributes[1] = VertexAttributes.POSITION;
			attributes[2] = VertexAttributes.POSITION;
			attributes[3] = VertexAttributes.TEXCOORDS[0];
			attributes[4] = VertexAttributes.TEXCOORDS[0];
			attributes[5] = VertexAttributes.NORMAL;
			attributes[6] = VertexAttributes.NORMAL;
			attributes[7] = VertexAttributes.NORMAL;
			attributes[8] = VertexAttributes.TANGENT4;
			attributes[9] = VertexAttributes.TANGENT4;
			attributes[10] = VertexAttributes.TANGENT4;
			attributes[11] = VertexAttributes.TANGENT4;
			geometry.addVertexStream(attributes);
			
			geometry.setAttributeValues(VertexAttributes.POSITION, Vector.<Number>([-dWidth, 0,- dHeight, -dWidth, 0, dHeight, dWidth, 0, dHeight, dWidth, 0, -dHeight]));
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], Vector.<Number>([0, 0, 0, 1, 1, 1, 1, 0]));
			geometry.setAttributeValues(VertexAttributes.NORMAL, Vector.<Number>([0, -1, 0, 0, -1, 0, 0, -1, 0, 0, -1, 0]));	
			geometry.setAttributeValues(VertexAttributes.TANGENT4, Vector.<Number>([1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1, 1, 0, 0, -1]));

			geometry.indices = Vector.<uint>([0, 1, 3, 2, 3, 1]);

			addSurface(material, 0, 2);

			boundBox = new BoundBox();
			boundBox.minX = -dWidth;
			boundBox.minY = -dHeight;
			boundBox.minZ = 0;
			boundBox.maxX = dWidth;
			boundBox.maxY = dHeight;
			boundBox.maxZ = 0;
		}
		
		public function lookAt(object:Object3D):void
		{
			var lookV:Vector3D = object.localToGlobal(new Vector3D(0,0,0));
			
			var deltaX:Number = lookV.x - this.x;
			var deltaY:Number = lookV.y - this.y;
			var deltaZ:Number = lookV.z - this.z;
			var rotX:Number = Math.atan2(deltaZ, Math.sqrt(deltaX * deltaX + deltaY * deltaY));
			this.rotationX = rotX;
			this.rotationY = 0;
			this.rotationZ = - Math.atan2(deltaX,deltaY);
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Object3D {
			var res:Sprites3D = new Sprites3D(0, 0);
			res.clonePropertiesFrom(this);
			return res;
		}

	}
}
