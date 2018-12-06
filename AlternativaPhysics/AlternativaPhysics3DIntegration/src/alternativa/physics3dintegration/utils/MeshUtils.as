package alternativa.physics3dintegration.utils {
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.WireFrame;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.physicsengine.geometry.GeometryFace;
	import alternativa.physicsengine.geometry.GeometryMesh;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * EN:
	 * Collection of utilities associated with the mesh. <br>
	 * Creates standard shapes meshes: triangle, rectangle, cone, cylinder.<br>
	 * Converts Mesh to GeometryMesh and back.<br>
	 *
	 * RU:
	 * Набор утилит связанных с мешем.<br>
	 * Создание мешей стандартных фигур: треугольник, прямоугольник, конус, цилиндр.<br>
	 * Конвертирование из Mesh в GeometryMesh и обратно.<br>
	 */
	public class MeshUtils {
		/**
		 * @private
		 */
		private static function addVertex(vertices:Vector.<Number>, tcoord:Vector.<Number>, normals:Vector.<Number>, v:Vector3, normal:Vector3, uvCalculator:IVertexUVCalculator):void {
			vertices.push(v.x);
			vertices.push(v.y);
			vertices.push(v.z);
			uvCalculator.addUV(v, tcoord);
			normals.push(normal.x);
			normals.push(normal.y);
			normals.push(normal.z);
		}

		/**
		 * EN:
		 * Creates Mesh from GeometryMesh.
		 * @param geomMesh GeometryMesh
		 * @param material Material
		 * @param uvCalculator class calculating vertex' UV by its coordinates
		 * @return A3D mesh
		 *
		 * RU:
		 * Создает меш A3D из геометрического меша.
		 * @param geomMesh геометрический меш
		 * @param material материал
		 * @param uvCalculator класс, расчитывающий UV для вершины по ее координатам
		 * @return меш A3D
		 */
		public static function createMesh3dFromGeometryMesh(geomMesh:GeometryMesh, material:Material, uvCalculator:IVertexUVCalculator = null):Mesh {
			if (uvCalculator == null) {
				uvCalculator = new TrivialUVCalculator();
			}
			var mesh:Mesh = new Mesh();
			var attributes:Array = new Array();
			var m4:Matrix4 = new Matrix4();
			attributes[0] = VertexAttributes.POSITION;
			attributes[1] = VertexAttributes.POSITION;
			attributes[2] = VertexAttributes.POSITION;
			attributes[3] = VertexAttributes.TEXCOORDS[0];
			attributes[4] = VertexAttributes.TEXCOORDS[0];
			attributes[5] = VertexAttributes.NORMAL;
			attributes[6] = VertexAttributes.NORMAL;
			attributes[7] = VertexAttributes.NORMAL;
			var g:Geometry = mesh.geometry = new Geometry();
			g.addVertexStream(attributes);
			var indices:Vector.<uint> = new Vector.<uint>();
			var vertices:Vector.<Number> = new Vector.<Number>(0);
			var tcoords:Vector.<Number> = new Vector.<Number>(0);
			var normals:Vector.<Number> = new Vector.<Number>(0);
			var cid:int = 0;
			for each (var f:GeometryFace in geomMesh.faces) {
				for (var i:int = f.vertices.length; i -- > 2;) {
					if (geomMesh.dimension == 2) {
						indices.push(cid++);
						indices.push(cid++);
						indices.push(cid++);
						f.normal.negate();
						addVertex(vertices, tcoords, normals, f.vertices[0], f.normal, uvCalculator);
						addVertex(vertices, tcoords, normals, f.vertices[i], f.normal, uvCalculator);
						addVertex(vertices, tcoords, normals, f.vertices[i - 1], f.normal, uvCalculator);
						f.normal.negate();

					}
					indices.push(cid++);
					indices.push(cid++);
					indices.push(cid++);
					addVertex(vertices, tcoords, normals, f.vertices[0], f.normal, uvCalculator);
					addVertex(vertices, tcoords, normals, f.vertices[i - 1], f.normal, uvCalculator);
					addVertex(vertices, tcoords, normals, f.vertices[i], f.normal, uvCalculator);
				}
			}
			g.numVertices = vertices.length/3;
			g.setAttributeValues(VertexAttributes.POSITION, vertices);
			g.setAttributeValues(VertexAttributes.TEXCOORDS[0], tcoords);
			g.setAttributeValues(VertexAttributes.NORMAL, normals);
			g.indices = indices;
			mesh.addSurface(material, 0, g.numTriangles);
			mesh.matrix = m4.createMatrix3D();
			return mesh;
		}

		/**
		 * EN:
		 * Creates a GeometryMesh from A3D mesh.
		 * @param mesh A3D mesh
		 * @return GeometryMesh
		 *
		 * RU:
		 * Создает геометрический меш из меша A3D.
		 * @param mesh меш A3D
		 * @return геометрический меш
		 */
		public static function createGeometryMeshFromMesh3d(mesh:Mesh):GeometryMesh {
			var g:Geometry = mesh.geometry;
			var geomMesh:GeometryMesh = new GeometryMesh();
			var a:Vector.<Number> = g.getAttributeValues(VertexAttributes.POSITION);
			var vect:Vector3D = new Vector3D();
			for (var i:int = 0; i < a.length; i += 3) {
				vect.x = a[i];
				vect.y = a[i + 1];
				vect.z = a[i + 2];
				vect = mesh.localToGlobal(vect);
				geomMesh.addVertexXYZ(vect.x, vect.y, vect.z);
			}
			var v:Vector.<Vector3> = geomMesh.vertices;
			var ind:Vector.<uint> = g.indices;
			for (i = g.numTriangles; i -- > 0;) {
				geomMesh.addTriangleFace(v[ind[i*3]], v[ind[i*3 + 1]], v[ind[i*3 + 2]]);
			}
			return geomMesh;
		}

		/**
		 * EN:
		 * Creates A3D mesh of triangle using 3 vertices. Mesh contains of 2 faces.
		 * @param v0 first vertex
		 * @param v1 second vertex
		 * @param v2 third vertex
		 * @param material material
		 * @return mesh of A3D triangle
		 *
		 * RU:
		 * Создает меш A3d треугольника из 3 вершин. Меш содержит две грани.
		 * @param v0 первая вершина
		 * @param v1 вторая вершина
		 * @param v2 третья вершина
		 * @param material материал
		 * @return меш A3d треугольника
		 */
		public static function createTriangle(v0:Vector3, v1:Vector3, v2:Vector3, material:Material):Mesh {
			var tri:GeometryMesh = new GeometryMesh(2);
			tri.addVertex(v0);
			tri.addVertex(v1);
			tri.addVertex(v2);
			tri.addTriangleFace(v0, v1, v2);
			return createMesh3dFromGeometryMesh(tri, material);
		}

		/**
		 * EN:
		 * Creates A3D mesh of truncated cone.<br>
		 * Major base of cone lies in the plane OXY. Major base center of cone is at the origin.
		 *
		 * @param smallRadius minor base of radius. It equals to zero if cone is not truncated.
		 * @param bigRadius major base of radius
		 * @param height cone's height. If cone is truncated then height is the distance between the minor and major bases.
		 * @param material material
		 * @param circleSegments number of segments in bases
		 * @return mesh of A3D cone
		 *
		 * RU:
		 * Создает меш A3d усеченного конуса.<br>
		 * Конус лежит на плоскости OXY своим большим основанием. Центр основания совпадает с началом координат.
		 *
		 * @param smallRadius радиус меньшего основания. Равен 0 в случае, если конус не усеченный.
		 * @param bigRadius радиус большего основания
		 * @param height высота конуса. Если конус усеченный, это расстояние между большим и меньшим основаниями.
		 * @param material материал
		 * @param circleSegments количество сегментов, на которое разбиваются окружности оснований
		 * @return меш A3d конуса
		 */
		public static function createConicFrustum(smallRadius:Number, bigRadius:Number, height:Number, material:Material, circleSegments:int = 16):Mesh {
			var fromTop:Number = 0.75*height*(Math.pow(bigRadius, 4.0) - Math.pow(smallRadius, 4.0))/((bigRadius - smallRadius)*(Math.pow(bigRadius, 3.0) - Math.pow(smallRadius, 3.0)));
			fromTop -= height*smallRadius/(bigRadius - smallRadius);
			var con:GeometryMesh = new GeometryMesh();

			var v1:Vector.<Vector3> = new Vector.<Vector3>(circleSegments, 0), v2:Vector.<Vector3> = new Vector.<Vector3>(circleSegments, 0);
			for (var i:int = 0; i < circleSegments; i++) {
				var alpha:Number = Math.PI*(i + i)/circleSegments;
				v1[i] = con.addVertexXYZ(bigRadius*Math.cos(alpha), bigRadius*Math.sin(alpha), 0);
				if (smallRadius < 1e-6 && i) {
					v2[i] = v2[i - 1];
				} else {
					v2[i] = con.addVertexXYZ(smallRadius*Math.cos(alpha), smallRadius*Math.sin(alpha), height);
				}
				if (i) {
					con.addQuadFace(v1[i - 1], v1[i], v2[i], v2[i - 1]);
				}
			}
			con.addQuadFace(v1[circleSegments - 1], v1[0], v2[0], v2[circleSegments - 1]);
			for (i = 0; i < circleSegments - 1 - i; i++) {
				var t:Vector3 = v1[i];
				v1[i] = v1[circleSegments - 1 - i];
				v1[circleSegments - 1 - i] = t;
			}
			con.addFace(v1);
			if (smallRadius > 1e-6) {
				con.addFace(v2);
			}
			return createMesh3dFromGeometryMesh(con, material);
		}

		/**
		 * EN:
		 * Creates mesh of A3D cylinder. <br>
		 * Cylinder's base lies in the plane OXY. Cylinder's base center is at the origin.
		 * @param radius radius of base
		 * @param height cylinder's height. Distance between the bases.
		 * @param material material
		 * @param circleSegments number of segments in bases
		 * @return mesh of A3D cone
		 *
		 * RU:
		 * Создает меш A3d цилиндра. <br>
		 * Цилиндр лежит на плоскости OXY своим основанием. Центр основания совпадает с началом координат.
		 *
		 * @param radius радиус основания
		 * @param height высота цилиндра. Расстояние между основаниями.
		 * @param material материал
		 * @param circleSegments количество сегментов, на которое разбиваются окружности оснований
		 * @return меш A3d цилиндра
		 */
		public static function createCylinder(radius:Number, height:Number, material:Material, circleSegments:int = 16):Mesh {
			var cyl:GeometryMesh = new GeometryMesh();

			var v1:Vector.<Vector3> = new Vector.<Vector3>(circleSegments, 0), v2:Vector.<Vector3> = new Vector.<Vector3>(circleSegments, 0);
			for (var i:int = 0; i < circleSegments; i++) {
				var alpha:Number = Math.PI*(i + i)/circleSegments;
				v1[i] = cyl.addVertexXYZ(radius*Math.cos(alpha), radius*Math.sin(alpha), - height/2);
				v2[i] = cyl.addVertexXYZ(radius*Math.cos(alpha), radius*Math.sin(alpha), height/2);
				if (i) {
					cyl.addQuadFace(v1[i - 1], v1[i], v2[i], v2[i - 1]);
				}
			}
			cyl.addQuadFace(v1[circleSegments - 1], v1[0], v2[0], v2[circleSegments - 1]);
			for (i = 0; i < circleSegments - 1 - i; i++) {
				var t:Vector3 = v1[i];
				v1[i] = v1[circleSegments - 1 - i];
				v1[circleSegments - 1 - i] = t;
			}
			cyl.addFace(v1);
			cyl.addFace(v2);
			return createMesh3dFromGeometryMesh(cyl, material);
		}

		/**
		 * EN:
		 * Creates mesh of A3D rectangle. <br>
		 * Rectangle lies in the plane OXY. Rectangle center is at the origin.
		 * @param width rectangle's width along the axis OX
		 * @param height rectangle's height along the axis OY
		 * @param material material
		 * @return mesh of A3D rectangle
		 *
		 * RU:
		 * Создает меш A3d прямоугольника.<br>
		 * Прямоугольник лежит в плоскости OXY. Центр прямоугольника совпадает с началом координат.
		 * @param width ширина прямоугольника вдоль оси OX
		 * @param height выстора прямоугольника вдоль оси OY
		 * @param material материал
		 * @return меш A3d прямоугольника
		 */
		public static function createRectangle(width:Number, height:Number, material:Material):Mesh {
			var rect:GeometryMesh = new GeometryMesh(2);
			var v0:Vector3, v1:Vector3, v2:Vector3, v3:Vector3;
			v0 = rect.addVertexXYZ(width*0.5, height*0.5, 0);
			v1 = rect.addVertexXYZ(-width*0.5, height*0.5, 0);
			v2 = rect.addVertexXYZ(-width*0.5, -height*0.5, 0);
			v3 = rect.addVertexXYZ(width*0.5, -height*0.5, 0);
			rect.addQuadFace(v0, v1, v2, v3);
			return createMesh3dFromGeometryMesh(rect, material, new PlaneUVCalculator(width, height));

		}

		/**
		 * EN:
		 * Creates sphere. Sphere's center is at the origin.
		 * @param radius sphere radius
		 * @param material material
		 * @param sphereSegments number of segments
		 * @return mesh of A3D sphere
		 *
		 * RU:
		 * Создает сферу. Центр сферы совпадает с началом координат.
		 * @param radius радиус сферы
		 * @param material материал
		 * @param sphereSegments количество сегментов
		 * @return меш A3d сферы
		 */
		public static function createSphere(radius:Number, material:Material, sphereSegments:int = 4):Mesh {
			var cir:Mesh = new GeoSphere(radius, sphereSegments);
			cir = createMesh3dFromGeometryMesh(createGeometryMeshFromMesh3d(cir), material);
			return cir;
		}

		/**
		 * EN:
		 * Creates mesh of A3D box. Box' center is at the origin.
		 * @param size box' sizes.<br>
		 *	 size.x - size along the axis OX.<br>
		 *	 size.y - size along the axis OY.<br>
		 *	 size.z - size along the axis OZ.<br>
		 *  @param material material
		 *  @return mesh of A3D box
		 *
		 * RU:
		 * Создает меш A3d бокса. Центр бокса совпадает с началом координат.
		 * @param size размеры бокса.<br>
		 *	 size.x - размер вдоль оси ОX.<br>
		 *	 size.y - размер вдоль оси ОY.<br>
		 *	 size.z - размер вдоль оси ОZ.
		 * @param material материал
		 * @return меш A3d бокса
		 */
		public static function createBox(size:Vector3, material:Material):Mesh {
			var box:Box = new Box(size.x, size.y, size.z, 1, 1, 1, false, material);
			return box;
		}

		/**
		 * EN:
		 * Creates segment.
		 * @param start starting point of segment
		 * @param direction segment's direction
		 * @param len segment's length
		 * @param color color
		 * @param alpha opacity
		 * @param thickness segment's thickness
		 * @return segment
		 *
		 * RU:
		 * Создает отрезок.
		 * @param start точка начала отрезка
		 * @param direction направляющая отрезка
		 * @param len длина отрезка
		 * @param color цвет
		 * @param alpha прозрачность
		 * @param thickness толщина линии
		 * @return отрезок
		 */
		public static function createSegment(start:Vector3, direction:Vector3, len:Number, color:uint, alpha:Number = 1.0, thickness:Number = 3):WireFrame {
			direction = direction.clone();
			direction.setLength(1.0);

			direction.scale(len).add(start);
			var p1:Vector3D = new Vector3D(),  p2:Vector3D = new Vector3D();
			start.toVector3D(p1);
			direction.toVector3D(p2);
			var points:Vector.<Vector3D> = new Vector.<Vector3D>();
			points.push(p1);
			points.push(p2);
			return WireFrame.createLinesList(points, color, alpha, thickness);
		}


		/**
		 * EN:
		 * Transforms A3D mesh.
		 * @param mesh mesh.
		 * @param transform specified transformation
		 *
		 * RU:
		 * Трансформирует меш A3d.
		 * @param mesh меш
		 * @param transform заданная трансформация
		 */
		public static function transformMesh(mesh:Mesh, transform:Matrix4):void {
			if (transform != null) {
				var m:Matrix3D = transform.createMatrix3D();
				m.prepend(mesh.matrix);
				mesh.matrix = m;
			}
		}

	}
}

import alternativa.physicsengine.math.Vector3;

internal interface IVertexUVCalculator {
	function addUV(v:Vector3, uvs:Vector.<Number>):void;
}

internal class TrivialUVCalculator implements IVertexUVCalculator {
	public function addUV(v:Vector3, uvs:Vector.<Number>):void {
		uvs.push(1);
		uvs.push(1);
	}
}

internal class PlaneUVCalculator implements IVertexUVCalculator {
	private var width:Number, height:Number;
	public function PlaneUVCalculator(width:Number, height:Number) {
		this.width = width;
		this.height = height;
	}
	public function addUV(v:Vector3, uvs:Vector.<Number>):void {
		uvs.push(v.x / width + 0.5);
		uvs.push(-v.y / height + 0.5);
	}
}







