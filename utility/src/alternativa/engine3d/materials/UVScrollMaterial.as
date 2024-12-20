/**
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 * If it is not possible or desirable to put the notice in a particular file, then You may include the notice in a location (such as a LICENSE file in a relevant directory) where a recipient would be likely to look for such a notice.
 * You may add additional accurate notices of copyright ownership.
 *
 * It is desirable to notify that Covered Software was "Powered by AlternativaPlatform" with link to http://www.alternativaplatform.com/ 
 * */

package alternativa.engine3d.materials {

	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.DrawUnit;
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Renderer;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.compiler.Linker;
	import alternativa.engine3d.materials.compiler.Procedure;
	import alternativa.engine3d.materials.compiler.VariableType;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;

	import avmplus.getQualifiedClassName;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	use namespace alternativa3d;

	/**
	 * The material fills surface with bitmap image in light-independent manner. Can draw a Skin with no more than 41 Joints per surface. See Skin.divide() for more details.
	 * 
	 * To be drawn with this material, geometry shoud have UV coordinates.
	 * @see alternativa.engine3d.objects.Skin#divide()
	 * @see alternativa.engine3d.core.VertexAttributes#TEXCOORDS
	 */
	public class UVScrollMaterial extends Material {

		private static var caches	:Dictionary = new Dictionary(true);
		private var cachedContext3D	:Context3D;
		private var programsCache		:Dictionary;

		/**
		 * @private
		 * Procedure for diffuse map with alpha channel
		 */
		static alternativa3d const getDiffuseProcedure:Procedure = new Procedure([
			"#v0=vUV",
			"#s0=sDiffuse",
			"#c0=cThresholdAlpha",
			"#c1=cCustomUV",
			
			"mov t1, v0",
			
			"add t1.xy, t1.xy, c1.zw", // posisiona el UV en las coordenadas XY
			"div t1.xy, t1.xy, c1.xy", // ESCALAR AL TAMAÑO CORRECTO  
			"frc t1.xy, t1.xy", 		// ROund the numbers...
			
			"tex t0, t1, s0 <2d, linear,nearest, miplinear>",
			"mul t0.w, t0.w, c0.w",
			"mov o0, t0"
		], "getDiffuseProcedure");

		
		
		
		
		/**
		 * @private
		 * Procedure for diffuse with opacity map.
		 */
		static alternativa3d const getDiffuseOpacityProcedure:Procedure = new Procedure([
			 
			"#v0=vUV",
			"#s0=sDiffuse",
			"#s1=sOpacity",
			"#c0=cThresholdAlpha",
			"#c1=cCustomUV",
			
			"mov t1, c1",  
			
				"mov t5, v0",
				"add t5.xy, t5.xy, c1.zw",
				"div t5.xy, t5.xy, c1.xy", 
				"tex t0, t5, s0 <2d, linear,nearest, miplinear>",
				
			
			/**NO SCROLL**/"tex t1, v0, s1 <2d, linear,nearest, miplinear>", 
			
			"mul t0.w, t1.x, c0.w",
			"mov o0, t0" 
			
		], "getDiffuseOpacityProcedure"); 
		
		
		static alternativa3d const getScrollingDiffuseOpacityProcedure:Procedure = new Procedure([
			 
			"#v0=vUV",
			"#s0=sDiffuse",
			"#s1=sOpacity",
			"#c0=cThresholdAlpha",
			"#c1=cCustomUV",
			
			"mov t1, c1",  
			
				"mov t5, v0",
				"add t5.xy, t5.xy, c1.zw",
				"div t5.xy, t5.xy, c1.xy", 
				"tex t0, t5, s0 <2d, linear,nearest, miplinear>",
				
			/**WITH SCROLL**/"tex t1, t5, s1 <2d, linear,nearest, miplinear>", 
			
			
			"mul t0.w, t1.x, c0.w",
			"mov o0, t0" 
			
		], "getDiffuseOpacityProcedure"); 
		

		/**
		 * @private
		 * Alpha-test check procedure.
		 */
		static alternativa3d const thresholdOpaqueAlphaProcedure:Procedure = new Procedure([
			"#c0=cThresholdAlpha",
			"sub t0.w, i0.w, c0.x",
			"kil t0.w",
			"mov o0, i0"
		], "thresholdOpaqueAlphaProcedure");

		/**
		 * @private
		 * Alpha-test check procedure.
		 */
		static alternativa3d const thresholdTransparentAlphaProcedure:Procedure = new Procedure([
			"#c0=cThresholdAlpha",
			"slt t0.w, i0.w, c0.x",
			"mul i0.w, t0.w, i0.w",
			"mov o0, i0"
		], "thresholdTransparentAlphaProcedure");

		/**
		 * @private
		 * Pass UV to the fragment shader procedure
		 */
		static alternativa3d const _passUVProcedure:Procedure = new Procedure(["#v0=vUV", "#a0=aUV", "mov v0, a0"], "passUVProcedure");

		/**
		 * Diffuse map.
		 */
		public var diffuseMap:TextureResource;
		
		/**
		 *  Opacity map.
		 */
		public var opacityMap:TextureResource;
		
		/**
		 *  If <code>true</code>, perform transparent pass. Parts of surface, cumulative alpha value of which is below than  <code>alphaThreshold</code> will be drawn within transparent pass.
		 * @see #alphaThreshold
		 */
		public var transparentPass:Boolean = true;
		
		/**
		 * If <code>true</code>, perform opaque pass. Parts of surface, cumulative alpha value of which is greater or equal than  <code>alphaThreshold</code> will be drawn within opaque pass.
		 * @see #alphaThreshold
		 */
		public var opaquePass:Boolean = true;
		
		/**
		 * alphaThreshold defines starts from which value of alpha a fragment of the surface will get into transparent pass.
		 * @see #transparentPass
		 * @see #opaquePass
		 */
		public var alphaThreshold:Number = 0;
		
		/**
		 *  Transparency.
		 */
		public var alpha:Number = 1;
		
		
		public var atlasWidth:Number = 0;
		public var atlasHeight:Number = 0;
		public var spriteWidth:Number = 16;
		public var spriteHeight:Number = 16;
		public var x:Number = 0;
		public var y:Number = 1;
		
		private var _currentFrame:int;
		private var _totalFrames:int;
		private var _tilesWidth:int;
		private var _tilesHeight:int;
		
		private var _paddingX:Number;
		private var _paddingY:Number;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _vScrollOpacityMapAlso:Boolean;
		
		
		/**
		 * Creates a new TextureMaterial instance.
		 *
		 * @param diffuseMap Diffuse map.
		 * @param alpha Transparency.
		 */
		public function UVScrollMaterial( 
			diffuseMap	:TextureResource = null, 
			opacityMap	:TextureResource = null, 
			alpha		:Number 		   = 1, 
			atlasWidth	:Number 	= 0, 
			atlasHeight	:Number 	= 0, 
			spriteWidth	:Number 	= 16, 
			spriteHeight	:Number 	= 16,
			padding		:int = 0 ,
			scrollOpacityMap:Boolean = false,
			totalFramesInAtlas:int = 0
			) {
				 
			this.diffuseMap 		= diffuseMap;
			this.opacityMap 		= opacityMap;
			this.alpha 			= alpha;
			this.atlasWidth 		= atlasWidth;
			this.atlasHeight 		= atlasHeight;
			this.spriteWidth 		= spriteWidth;
			this.spriteHeight 	= spriteHeight; 
			
			 
			_vScrollOpacityMapAlso = scrollOpacityMap;
			
			
			//
			// calcular cuantos tiles hay en horizontal y en vertical.
			//
			 
			_tilesWidth 	= atlasWidth / (spriteWidth + padding*2); 
			_tilesHeight 	= atlasHeight / (spriteHeight + padding * 2) ;  
			
			
			 
			//
			// el tamaño del sprite ahora vale 1.
			//
			_scaleX = 1 / ( spriteWidth / atlasWidth );
			_scaleY = 1 / ( spriteHeight / atlasHeight );
			 
			
			//
			// caclular el padding en relacion al ancho. Ancho = 1, Padding = ?
			//
			_paddingX = padding / spriteWidth;
			_paddingY = padding / spriteHeight;
			 
			
			if ( totalFramesInAtlas )
			{
				_totalFrames = totalFramesInAtlas;
			}
			else 
			{
				_totalFrames  = _tilesWidth * _tilesHeight;
			}
			
			x = _paddingX;
			y = _paddingY;
			_currentFrame = 0;
			
		}
		
		public function get totalFrames():int { return _totalFrames;  }
		public function set currentFrame( v:Number ):void 
		{ 
			
			v %= _totalFrames;  
			
			setTileXY( v % _tilesWidth, Math.floor( v / _tilesWidth ) );
			
			_currentFrame = v;
			
		}
		public function get currentFrame():Number {
			return _currentFrame;
		}
		
		public function setTileXY( x:Number=0,y:Number=0 ):void
		{
			this.x = (_paddingX*2*x) + _paddingX + x;
			this.y = (_paddingY*2*y) + _paddingY + y;
		}

		/**
		 * @private
		 */
		override alternativa3d function fillResources(resources:Dictionary, resourceType:Class):void {
			super.fillResources(resources, resourceType);
			if (diffuseMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(diffuseMap)) as Class, resourceType)) {
				resources[diffuseMap] = true;
			}
			if (opacityMap != null && A3DUtils.checkParent(getDefinitionByName(getQualifiedClassName(opacityMap)) as Class, resourceType)) {
				resources[opacityMap] = true;
			}
		}

		/**
		 * @param object
		 * @param programs
		 * @param camera
		 * @param opacityMap
		 * @param alphaTest 0 - disabled, 1 - opaque, 2 - contours
		 * @return
		 */
		private function getProgram(object:Object3D, programs:Vector.<UVScrollMaterialProgram>, camera:Camera3D, opacityMap:TextureResource, alphaTest:int):UVScrollMaterialProgram {
			
			var key:int = (_vScrollOpacityMapAlso? 6 : 0) + (opacityMap != null ? 3 : 0) + alphaTest;
			
			var program:UVScrollMaterialProgram = programs[key];
			
			if (program == null) 
			{
				// Make program
				// Vertex shader
				var vertexLinker:Linker = new Linker(Context3DProgramType.VERTEX);
				
				var positionVar:String = "aPosition";
				vertexLinker.declareVariable(positionVar, VariableType.ATTRIBUTE);
				if (object.transformProcedure != null) {
					positionVar = appendPositionTransformProcedure(object.transformProcedure, vertexLinker);
				}
				vertexLinker.addProcedure(_projectProcedure);
				vertexLinker.setInputParams(_projectProcedure, positionVar);
				vertexLinker.addProcedure(_passUVProcedure);

				// Pixel shader
				var fragmentLinker:Linker = new Linker(Context3DProgramType.FRAGMENT);
				var outProcedure:Procedure = (opacityMap != null ? 
				
					( _vScrollOpacityMapAlso? getScrollingDiffuseOpacityProcedure : getDiffuseOpacityProcedure )
					
					: getDiffuseProcedure);
				fragmentLinker.addProcedure(outProcedure);
				
				
				if (alphaTest > 0) {
					fragmentLinker.declareVariable("tColor");
					fragmentLinker.setOutputParams(outProcedure, "tColor");
					if (alphaTest == 1) {
						fragmentLinker.addProcedure(thresholdOpaqueAlphaProcedure, "tColor");
					} else {
						fragmentLinker.addProcedure(thresholdTransparentAlphaProcedure, "tColor");
					}
				}
				
				fragmentLinker.varyings = vertexLinker.varyings;
				
				program = new UVScrollMaterialProgram(vertexLinker, fragmentLinker); 
				program.upload(camera.context3D);
				programs[key] = program;
			}
			
			return program;
		}
		
		private function getDrawUnit(program:UVScrollMaterialProgram, camera:Camera3D, surface:Surface, geometry:Geometry, opacityMap:TextureResource):DrawUnit {
			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);

			var object:Object3D = surface.object;

			// Draw call
			var drawUnit:DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);

			// Streams
			drawUnit.setVertexBufferAt(program.aPosition, positionBuffer, geometry._attributesOffsets[VertexAttributes.POSITION], VertexAttributes.FORMATS[VertexAttributes.POSITION]);
			drawUnit.setVertexBufferAt(program.aUV, uvBuffer, geometry._attributesOffsets[VertexAttributes.TEXCOORDS[0]], VertexAttributes.FORMATS[VertexAttributes.TEXCOORDS[0]]);
			//Constants
			object.setTransformConstants(drawUnit, surface, program.vertexShader, camera);
			drawUnit.setProjectionConstants(camera, program.cProjMatrix, object.localToCameraTransform);
			drawUnit.setFragmentConstantsFromNumbers(program.cThresholdAlpha, alphaThreshold, 0, 0, alpha);
			
			// / (spriteWidth / atlasWidth)  
			
			drawUnit.setFragmentConstantsFromNumbers( program.cCustomUV, _scaleX, _scaleY, x, y );
			
			// PADDING
			//drawUnit.setFragmentConstantsFromNumbers(program.vPadding, _padding, _padding, 1,1);
			
			// Textures
			drawUnit.setTextureAt(program.sDiffuse, diffuseMap._texture);
			
			if (opacityMap != null) {
				drawUnit.setTextureAt(program.sOpacity, opacityMap._texture);
			}
			
			return drawUnit;
		}

		/**
		 * @private
		 */
		override alternativa3d function collectDraws( camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, useShadow:Boolean, objectRenderPriority:int = -1 ):void {
			var object:Object3D = surface.object;
			
			// Buffers
			var positionBuffer:VertexBuffer3D 	= geometry.getVertexBuffer(VertexAttributes.POSITION);
			var uvBuffer:VertexBuffer3D 		= geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);
			
			// Check validity
			if (positionBuffer == null || uvBuffer == null || diffuseMap == null || diffuseMap._texture == null || opacityMap != null && opacityMap._texture == null) return;
			
			
			// Refresh program cache for this context
			if ( camera.context3D != cachedContext3D ) 
			{
				cachedContext3D 	= camera.context3D;
				programsCache 	= caches[cachedContext3D];
				
				if (programsCache == null) 
				{
					programsCache 			= new Dictionary();
					caches[cachedContext3D] 	= programsCache;
				}
			}
			
			
			var p:Procedure = object.transformProcedure,
				
				optionsPrograms:Vector.<UVScrollMaterialProgram> = programsCache[p] ;
				
			if ( optionsPrograms == null ) 
			{
									optionsPrograms = new Vector.<UVScrollMaterialProgram>(12, true);
				programsCache[p] = 	optionsPrograms;
			} 
			
			
			var program:UVScrollMaterialProgram;
			var drawUnit:DrawUnit;
			// Opaque pass
			if (opaquePass && alphaThreshold <= alpha) {
				if (alphaThreshold > 0) {
					// Alpha test
					// use opacityMap if it is presented
					program = getProgram(object, optionsPrograms, camera, opacityMap, 1);
					drawUnit = getDrawUnit(program, camera, surface, geometry, opacityMap);
				} else {
					// do not use opacityMap at all
					program = getProgram(object, optionsPrograms, camera, null, 0);
					drawUnit = getDrawUnit(program, camera, surface, geometry, null);
				}
				// Use z-buffer within DrawCall, draws without blending
				camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority : Renderer.OPAQUE);
			}
			// Transparent pass
			if (transparentPass && alphaThreshold > 0 && alpha > 0) {
				// use opacityMap if it is presented
				if (alphaThreshold <= alpha && !opaquePass) {
					// Alpha threshold
					program = getProgram(object, optionsPrograms, camera, opacityMap, 2);
					drawUnit = getDrawUnit(program, camera, surface, geometry, opacityMap);
				} else {
					// There is no Alpha threshold or check z-buffer by previous pass
					program = getProgram(object, optionsPrograms, camera, opacityMap, 0);
					drawUnit = getDrawUnit(program, camera, surface, geometry, opacityMap);
				}
				// Do not use z-buffer, draws with blending
				
				drawUnit.blendSource = Context3DBlendFactor.SOURCE_ALPHA;
				drawUnit.blendDestination = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
				 
				
				camera.renderer.addDrawUnit(drawUnit, objectRenderPriority >= 0 ? objectRenderPriority : Renderer.TRANSPARENT_SORT);
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Material {
			var res:UVScrollMaterial = new UVScrollMaterial(diffuseMap, opacityMap, alpha);
			res.clonePropertiesFrom(this);
			return res;
		}

		/**
		 * @inheritDoc
		 */
		override protected function clonePropertiesFrom(source:Material):void {
			super.clonePropertiesFrom(source);
			var tex:TextureMaterial = source as TextureMaterial;
			diffuseMap = tex.diffuseMap;
			opacityMap = tex.opacityMap;
			opaquePass = tex.opaquePass;
			transparentPass = tex.transparentPass;
			alphaThreshold = tex.alphaThreshold;
			alpha = tex.alpha;
		}

	}
}

import alternativa.engine3d.materials.ShaderProgram;
import alternativa.engine3d.materials.compiler.Linker;

import flash.display3D.Context3D;

class UVScrollMaterialProgram extends ShaderProgram {

	public var aPosition:int = -1;
	public var aUV:int = -1;
	public var cProjMatrix:int = -1;
	public var cThresholdAlpha:int = -1;
	public var cCustomUV:int = -1;
	public var sDiffuse:int = -1;
	public var sOpacity:int = -1; 

	public function UVScrollMaterialProgram(vertex:Linker, fragment:Linker) {
		super(vertex, fragment);
	}

	override public function upload(context3D:Context3D):void {
		super.upload(context3D);

		aPosition = vertexShader.findVariable("aPosition");
		aUV = vertexShader.findVariable("aUV");
		cProjMatrix = vertexShader.findVariable("cProjMatrix");
		cThresholdAlpha = fragmentShader.findVariable("cThresholdAlpha");
		sDiffuse = fragmentShader.findVariable("sDiffuse");
		sOpacity = fragmentShader.findVariable("sOpacity");
		cCustomUV = fragmentShader.findVariable("cCustomUV"); 
	}

}
