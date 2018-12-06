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
	 * The materiall fills surface with bitmap image in light-independent manner. Can draw a Skin with no more than 41 Joints per surface. See Skin.divide() for more details.
	 * 
	 * To be drawn with this material, geometry shoud have UV coordinates.
	 * @see alternativa.engine3d.objects.Skin#divide()
	 * @see alternativa.engine3d.core.VertexAttributes#TEXCOORDS
	 */
	public class TintMaterial extends Material {

		/**
		 * @private
		 */
		alternativa3d override function get canDrawInShadowMap():Boolean {
			return opaquePass && alphaThreshold == 0;
		}

		private static var caches:Dictionary = new Dictionary(true);
		private var cachedContext3D:Context3D;
		private var programsCache:Dictionary;

		/**
		 * @private
		 * Procedure for tinted diffuse map with alpha channel
		 */
		static alternativa3d const getDiffuseTintProcedure:Procedure = new Procedure([
			"#v0=vUV",
			"#s0=sDiffuse",
			"#c0=cThresholdAlpha",
			"#c1=cColor",
			"tex t0, v0, s0 <2d, linear,repeat, miplinear>",
			"mul t0.w, t0.w, c0.w",
			"mul t1, t0, c1",
			"mov o0, t1"
		], "getDiffuseTintProcedure");

		/**
		 * @private
		 * Procedure for tinted diffuse with opacity map.
		 */
		static alternativa3d const getDiffuseOpacityTintProcedure:Procedure = new Procedure([
			"#v0=vUV",
			"#s0=sDiffuse",
			"#s1=sOpacity",
			"#c0=cThresholdAlpha",
			"#c1=cColor",
			"tex t0, v0, s0 <2d, linear,repeat, miplinear>",
			"tex t1, v0, s1 <2d, linear,repeat, miplinear>",
			"mul t0.w, t0.w, t0.w", //texture
			"mul t1, t0, c1",		//color texture
			"mul t1.w, t0.x, c0.w", //apply opacity
			"mov o0, t1"			//move to output
		], "getDiffuseOpacityProcedure");
		
		
		/**
		 * @private
		 * Procedure for diffuse with tints based on opacity map.
		 */
		 
		static alternativa3d const getDiffuseTintMapProcedure:Procedure = new Procedure([
			"#v0=vUV",
			"#s0=sDiffuse",
			"#s1=sOpacity",
			"#c0=cThresholdAlpha",
			"#c1=cColor",
			"#c2=cData",
			"tex t0, v0, s0 <2d, linear,repeat, miplinear>",
			"tex t1, v0, s1 <2d, linear,repeat, miplinear>",
						
			"add t2.x, t1.x, t1.y, t1.z", 	//ft2.x = ft1.x+ft1.y+ft1.z (3 for white less for anything else)
			"sge t3.x, t2.x, c2.z",			  	//sge ft3.x, ft2.x, 3 <- 1 if white 
			"slt t3.y, t2.x, c2.y",				//slt ft3.y, ft2.x, 3 <- 0 if black
			//ft1 * ft3.y + tintColor * ft3.x
			
			"sub t3.y, t3.y, t1.x",  //subtract diamonds
			
			"mul t4, t0, t3.y", //ft1 * ft3.y
			"mul t5, c1, t3.x", // tintColor * ft3.x
			"mul t5, t5, t0.x", // blend tint with white
			"add t6, t4, t5",	// +
			
			
			//just to use variables
			//"add t2, t1, c1",
			"mul t1.w, t1.x, c0.w",
			
			"mov o0, t6"			//move to output
		], "getDiffuseTintMapProcedure");
		 
		 
		/*
		static alternativa3d const getDiffuseTintMapProcedure:Procedure = new Procedure([
			"#v0=vUV",
			"#s0=sDiffuse",
			"#s1=sOpacity",
			"#c0=cThresholdAlpha",
			"#c1=cColor",
			"tex t0, v0, s0 <2d, linear,repeat, miplinear>",
			"tex t1, v0, s1 <2d, linear,repeat, miplinear>",
			"mul t2, t1, c1",	    //multiply blend color with alpha texture
			"mul t0.w, t1.x, c0.w", //get normal texture with alpha
			//"mul t0.w, t0.w, t0.w", //get normal texture without alpha
			"add t3, t0, t2",	    //combine the normal and tint
			"mov o0, t3"			//move to output
		], "getDiffuseTintMapProcedure");
		*/
		
		/*
		static alternativa3d const getDiffuseTintMapProcedure:Procedure = new Procedure([
			"#v0=vUV",
			"#s0=sDiffuse",
			"#s1=sOpacity",
			"#c0=cThresholdAlpha",
			"#c1=cColor",
			"#c2=cData",
			"tex t0, v0, s0 <2d, linear,repeat, miplinear>",
			"tex t1, v0, s1 <2d, linear,repeat, miplinear>",
			"add t2, t1, c0.y",			//make copy of alpha tex by adding 0 
			"add t3, t1, c0.y",			//make copy of alpha tex by adding 0 
			"mul t2.xyz, t2.xyz, c2.x", //t2 is all black
			"add t3.xyz, t3.xyz, c2.y", //t3 all white
			"mul t2.w, t1.x, c0.w", //alpha texture black (diamonds)
			"mul t3.w, t1.x, c0.w", //alpha texture white (diamonds)
						
			//"add t0.w, t2.xyz, c0.w", //crown with black diamonds
			"sub t0.xyz, t2.xyz, t1.x", //crown with black diamonds
			
			"mul t5, t1, c2",
			"mul t5, t1, c1",
			
			"mov o0, t0"			//move to output
		], "getDiffuseTintMapProcedure");
		*/
		
		// Which will multiply each pixel by -1 and then add 255. so 255 will become 0 and 0 will become 255
		
		
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
		 *  If <code>true</code>, perform transparent pass. Parts of surface, cumulative alpha value of which is below than  <code>alphaThreshold</code> draw within transparent pass.
		 * @see #alphaThreshold
		 */
		public var transparentPass:Boolean = true;
		
		/**
		 * If <code>true</code>, perform opaque pass. Parts of surface, cumulative alpha value of which is greater or equal than  <code>alphaThreshold</code> draw within opaque pass.
		 * @see #alphaThreshold
		 */
		public var opaquePass:Boolean = true;
		
		/**
		 * alphaThreshold defines starts from which value of alpha a fragment of surface will get into transparent pass.
		 * @see #transparentPass
		 * @see #opaquePass
		 */
		public var alphaThreshold:Number = 0;
		
		/**
		 *  Transparency.
		 */
		public var alpha:Number = 1;
		
		
		public var color:Number = 0xFF0000;
		private var red:Number;
		private var green:Number;
		private var blue:Number;
		private var tintOpacityOnly:Boolean=false;
		
		/**
		 * Creates a new TextureMaterial instance.
		 *
		 * @param diffuseMap Diffuse map.
		 * @param alpha Transparency.
		 */
		public function TintMaterial(diffuseMap:TextureResource = null, opacityMap:TextureResource = null, color:uint=0xFF0000, tintOpacityOnly:Boolean=false,alpha:Number = 1) {
			this.diffuseMap = diffuseMap;
			this.opacityMap = opacityMap;
			this.color = color;
			this.alpha = alpha;
			this.tintOpacityOnly = tintOpacityOnly;
			
			red = ((color >> 16) & 0xFF)/0xFF;
			green = ((color >> 8) & 0xFF)/0xFF;
			blue = (color & 0xff)/0xFF;
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
		private function getProgram(object:Object3D, programs:Vector.<ShaderProgram>, camera:Camera3D, opacityMap:TextureResource, alphaTest:int):ShaderProgram {
			var key:int = (opacityMap != null ? 3 : 0) + alphaTest;
			var program:ShaderProgram = programs[key];
			if (program == null) {
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
				var outProcedure:Procedure = (opacityMap != null ? getDiffuseOpacityTintProcedure : getDiffuseTintProcedure);
				
				if(tintOpacityOnly) {
					outProcedure = getDiffuseTintMapProcedure
				}
				
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
				
				program = new ShaderProgram(vertexLinker, fragmentLinker);

				program.upload(camera.context3D);
				programs[key] = program;
			}
			return program;
		}
		
		private function getDrawUnit(program:ShaderProgram, camera:Camera3D, surface:Surface, geometry:Geometry, opacityMap:TextureResource):DrawUnit {
			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);

			var object:Object3D = surface.object;

			// Draw call
			var drawUnit:DrawUnit = camera.renderer.createDrawUnit(object, program.program, geometry._indexBuffer, surface.indexBegin, surface.numTriangles, program);

			// Streams
			drawUnit.setVertexBufferAt(program.vertexShader.getVariableIndex("aPosition"), positionBuffer, geometry._attributesOffsets[VertexAttributes.POSITION], VertexAttributes.FORMATS[VertexAttributes.POSITION]);
			drawUnit.setVertexBufferAt(program.vertexShader.getVariableIndex("aUV"), uvBuffer, geometry._attributesOffsets[VertexAttributes.TEXCOORDS[0]], VertexAttributes.FORMATS[VertexAttributes.TEXCOORDS[0]]);
			//Constants
			object.setTransformConstants(drawUnit, surface, program.vertexShader, camera);
			drawUnit.setProjectionConstants(camera, program.vertexShader.getVariableIndex("cProjMatrix"), object.localToCameraTransform);
			drawUnit.setFragmentConstantsFromNumbers(program.fragmentShader.getVariableIndex("cThresholdAlpha"), alphaThreshold, 0, 0, alpha);
			drawUnit.setFragmentConstantsFromNumbers(program.fragmentShader.getVariableIndex("cColor"), red, green, blue, alpha);
			
			if(tintOpacityOnly) {
				drawUnit.setFragmentConstantsFromNumbers(program.fragmentShader.getVariableIndex("cData"), -1, 255, 1, 0);
			}
			
			
			// Textures
			drawUnit.setTextureAt(program.fragmentShader.getVariableIndex("sDiffuse"), diffuseMap._texture);
			if (opacityMap != null) {
				drawUnit.setTextureAt(program.fragmentShader.getVariableIndex("sOpacity"), opacityMap._texture);
			}
			return drawUnit;
		}

		/**
		 * @private
		 */
		override alternativa3d function collectDraws(camera:Camera3D, surface:Surface, geometry:Geometry, lights:Vector.<Light3D>, lightsLength:int, objectRenderPriority:int = -1):void {
			var object:Object3D = surface.object;
			
			// Buffers
			var positionBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.POSITION);
			var uvBuffer:VertexBuffer3D = geometry.getVertexBuffer(VertexAttributes.TEXCOORDS[0]);
			
			// Check validity
			if (positionBuffer == null || uvBuffer == null || diffuseMap == null || diffuseMap._texture == null || opacityMap != null && opacityMap._texture == null) return;
			
			// Refresh program cache for this context
			if (camera.context3D != cachedContext3D) {
				cachedContext3D = camera.context3D;
				programsCache = caches[cachedContext3D];
				if (programsCache == null) {
					programsCache = new Dictionary();
					caches[cachedContext3D] = programsCache;
				}
			}
			var optionsPrograms:Vector.<ShaderProgram> = programsCache[object.transformProcedure];
			if(optionsPrograms == null) {
				optionsPrograms = new Vector.<ShaderProgram>(6, true);
				programsCache[object.transformProcedure] = optionsPrograms;
			}

			var program:ShaderProgram;
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

		

	}
}
