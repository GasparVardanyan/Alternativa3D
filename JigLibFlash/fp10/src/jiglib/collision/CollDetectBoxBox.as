package jiglib.collision
{
	import flash.geom.Vector3D;
	
	import jiglib.cof.JConfig;
	import jiglib.data.EdgeData;
	import jiglib.data.SpanData;
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.MaterialProperties;
	import jiglib.physics.PhysicsState;

	public class CollDetectBoxBox extends CollDetectFunctor
	{
		private const MAX_SUPPORT_VERTS:Number = 10;
		private var combinationDist:Number;

		public function CollDetectBoxBox()
		{
			name = "BoxBox";
			type0 = "BOX";
			type1 = "BOX";
		}

		//Returns true if disjoint.  Returns false if intersecting
		private function disjoint(out:SpanData, axis:Vector3D, box0:JBox, box1:JBox):Boolean
		{
			var obj0:SpanData = box0.getSpan(axis);
			var obj1:SpanData = box1.getSpan(axis);
			var obj0Min:Number=obj0.min,obj0Max:Number=obj0.max,obj1Min:Number=obj1.min,obj1Max:Number=obj1.max,tiny:Number=JMath3D.NUM_TINY;

			if (obj0Min > (obj1Max + JConfig.collToll + tiny) || obj1Min > (obj0Max + JConfig.collToll + tiny))
			{
				out.flag = true;
				return true;
			}
			if ((obj0Max > obj1Max) && (obj1Min > obj0Min))
			{
				out.depth = Math.min(obj0Max - obj1Min, obj1Max - obj0Min);
			}
			else if ((obj1Max > obj0Max) && (obj0Min > obj1Min))
			{
				out.depth = Math.min(obj1Max - obj0Min, obj0Max - obj1Min);
			}
			else
			{
				out.depth = Math.min(obj0Max, obj1Max);
				out.depth -= Math.max(obj0Min, obj1Min);
			}
			out.flag = false;
			return false;
		}

		private function addPoint(contactPoints:Vector.<Vector3D>, pt:Vector3D, combinationDistanceSq:Number):Boolean
		{
			for each (var contactPoint:Vector3D in contactPoints)
			{
				if (contactPoint.subtract(pt).lengthSquared < combinationDistanceSq)
				{
					contactPoint = JNumber3D.getScaleVector(contactPoint.add(pt), 0.5);
					return false;
				}
			}
			contactPoints.push(pt);
			return true;
		}
		
		private function getSupportPoint(box:JBox, axis:Vector3D):Vector3D {
			var orientationCol:Vector.<Vector3D> = box.currentState.getOrientationCols();
			var _as:Number=axis.dotProduct(orientationCol[0]),_au:Number=axis.dotProduct(orientationCol[1]),_ad:Number=axis.dotProduct(orientationCol[2]),tiny:Number=JMath3D.NUM_TINY;
			
			var p:Vector3D = box.currentState.position.clone();
  
			if (_as < -tiny) {
				p = p.add(JNumber3D.getScaleVector(orientationCol[0], 0.5 * box.sideLengths.x));
			}else if (_as >= tiny) {
				p = p.subtract(JNumber3D.getScaleVector(orientationCol[0], 0.5 * box.sideLengths.x));
			}
  
			if (_au < -tiny) {
				p = p.add(JNumber3D.getScaleVector(orientationCol[1], 0.5 * box.sideLengths.y));
			}else if (_au > tiny) {
				p = p.subtract(JNumber3D.getScaleVector(orientationCol[1], 0.5 * box.sideLengths.y));
			}
  
			if (_ad < -tiny) {
				p = p.add(JNumber3D.getScaleVector(orientationCol[2], 0.5 * box.sideLengths.z));
			}else if (_ad > tiny) {
				p = p.subtract(JNumber3D.getScaleVector(orientationCol[2], 0.5 * box.sideLengths.z));
			}
			return p;
		}

		private function getAABox2EdgeIntersectionPoints(contactPoint:Vector.<Vector3D>, origBoxSides:Vector3D, origBoxState:PhysicsState, edgePt0:Vector3D, edgePt1:Vector3D):int {
			var jDir:int,kDir:int,num:int=0,iDir:int,iFace:int;
			var dist0:Number,dist1:Number,frac:Number,tiny:Number=JMath3D.NUM_TINY;
			var pt:Vector3D,edgeDir:Vector3D;
			
			edgeDir = edgePt1.subtract(edgePt0);
			edgeDir.normalize();
			var ptArr:Vector.<Number>,faceOffsets:Vector.<Number>,edgePt0Arr:Vector.<Number>,edgePt1Arr:Vector.<Number>,edgeDirArr:Vector.<Number>,sidesArr:Vector.<Number>;
			edgePt0Arr = JNumber3D.toArray(edgePt0);
			edgePt1Arr = JNumber3D.toArray(edgePt1);
			edgeDirArr = JNumber3D.toArray(edgeDir);
			sidesArr = JNumber3D.toArray(JNumber3D.getScaleVector(origBoxSides, 0.5));
			for (iDir = 2; iDir >= 0; iDir--) {
				if (Math.abs(edgeDirArr[iDir]) < 0.1) {
					continue;
				}
				jDir = (iDir + 1) % 3;
				kDir = (iDir + 2) % 3;
				faceOffsets = Vector.<Number>([ -sidesArr[iDir], sidesArr[iDir]]);
				for (iFace = 1; iFace >= 0; iFace-- ) {
					dist0 = edgePt0Arr[iDir] - faceOffsets[iFace];
					dist1 = edgePt1Arr[iDir] - faceOffsets[iFace];
					frac = -1;
					if (dist0 * dist1 < -tiny) {
						frac = -dist0 / (dist1 - dist0);
					}else if (Math.abs(dist0) < tiny) {
						frac = 0;
					}else if (Math.abs(dist1) < tiny) {
						frac = 1;
					}
					if (frac >= 0) {
						pt = JNumber3D.getScaleVector(edgePt0, 1 - frac).add(JNumber3D.getScaleVector(edgePt1, frac));
						ptArr = JNumber3D.toArray(pt);
						if ((ptArr[jDir] > -sidesArr[jDir] - tiny) && (ptArr[jDir] < sidesArr[jDir] + tiny) && (ptArr[kDir] > -sidesArr[kDir] - tiny) && (ptArr[kDir] < sidesArr[kDir] + tiny) ) {
							pt = origBoxState.orientation.transformVector(pt);
							pt = pt.add(origBoxState.position);
							addPoint(contactPoint, pt, combinationDist);
							if (++num == 2) {
								return num;
							}
						}
					}
				}
			}
			return num;
		}
		
		private function getBox2BoxEdgesIntersectionPoints(contactPoint:Vector.<Vector3D>, box0:JBox, box1:JBox, newState:Boolean):Number
		{
			var num:Number = 0;
			var seg:JSegment;
			var box0State:PhysicsState = (newState) ? box0.currentState : box0.oldState;
			var box1State:PhysicsState = (newState) ? box1.currentState : box1.oldState;
			var boxPts:Vector.<Vector3D> = box1.getCornerPointsInBoxSpace(box1State, box0State);
			
			var boxEdges:Vector.<EdgeData> = box1.edges;
			var edgePt0:Vector3D,edgePt1:Vector3D;
			for each (var boxEdge:EdgeData in boxEdges)
			{
				edgePt0 = boxPts[boxEdge.ind0];
				edgePt1 = boxPts[boxEdge.ind1];
				num += getAABox2EdgeIntersectionPoints(contactPoint, box0.sideLengths, box0State, edgePt0, edgePt1);
				if (num >= 8) {
					return num;
				}
			}
			return num;
		}

		private function getBoxBoxIntersectionPoints(contactPoint:Vector.<Vector3D>, box0:JBox, box1:JBox, newState:Boolean):uint
		{
			getBox2BoxEdgesIntersectionPoints(contactPoint, box0, box1, newState);
			getBox2BoxEdgesIntersectionPoints(contactPoint, box1, box0, newState);
			return contactPoint.length;
		}
		
		override public function collDetect(info:CollDetectInfo, collArr:Vector.<CollisionInfo>):void
		{
			var box0:JBox = info.body0 as JBox;
			var box1:JBox = info.body1 as JBox;

			if (!box0.hitTestObject3D(box1))
				return;

			if (!box0.boundingBox.overlapTest(box1.boundingBox))
				return;

			var numTiny:Number = JMath3D.NUM_TINY,numHuge:Number = JMath3D.NUM_HUGE;

			var dirs0Arr:Vector.<Vector3D> = box0.currentState.getOrientationCols();
			var dirs1Arr:Vector.<Vector3D> = box1.currentState.getOrientationCols();

			// the 15 potential separating axes
			var axes:Vector.<Vector3D> = Vector.<Vector3D>([dirs0Arr[0], dirs0Arr[1], dirs0Arr[2],
				dirs1Arr[0], dirs1Arr[1], dirs1Arr[2],
				dirs0Arr[0].crossProduct(dirs1Arr[0]),
				dirs0Arr[1].crossProduct(dirs1Arr[0]),
				dirs0Arr[2].crossProduct(dirs1Arr[0]),
				dirs0Arr[0].crossProduct(dirs1Arr[1]),
				dirs0Arr[1].crossProduct(dirs1Arr[1]),
				dirs0Arr[2].crossProduct(dirs1Arr[1]),
				dirs0Arr[0].crossProduct(dirs1Arr[2]),
				dirs0Arr[1].crossProduct(dirs1Arr[2]),
				dirs0Arr[2].crossProduct(dirs1Arr[2])]);

			var l2:Number;
			// the overlap depths along each axis
			var overlapDepths:Vector.<SpanData> = new Vector.<SpanData>();
			var i:int = 0;
			var axesLength:int = axes.length;

			// see if the boxes are separate along any axis, and if not keep a 
			// record of the depths along each axis
			var ax:Vector3D;
			for (i = 0; i < axesLength; i++)
			{
				overlapDepths[i] = new SpanData();

				l2 = axes[i].lengthSquared;
				if (l2 < numTiny)
					continue;
				
				ax = axes[i].clone();
				ax.normalize();
				if (disjoint(overlapDepths[i], ax, box0, box1)) {
					info.body0.removeCollideBodies(info.body1);
					info.body1.removeCollideBodies(info.body0);
					return;
				}
			}

			// The box overlap, find the separation depth closest to 0.
			var minDepth:Number = numHuge;
			var minAxis:int = -1;
			axesLength = axes.length;
			for (i = 0; i < axesLength; i++)
			{
				l2 = axes[i].lengthSquared;
				if (l2 < numTiny)
					continue;

				// If this axis is the minimum, select it
				if (overlapDepths[i].depth < minDepth)
				{
					minDepth = overlapDepths[i].depth;
					minAxis = int(i);
				}
			}
			
			if (minAxis == -1) {
				info.body0.removeCollideBodies(info.body1);
				info.body1.removeCollideBodies(info.body0);
				return;
			}
			
			// Make sure the axis is facing towards the box0. if not, invert it
			var N:Vector3D = axes[minAxis].clone();
			if (box1.currentState.position.subtract(box0.currentState.position).dotProduct(N) > 0)
				N.negate();
			
			var contactPointsFromOld:Boolean = true;
			var contactPoints:Vector.<Vector3D> = new Vector.<Vector3D>();
			combinationDist = 0.05 * Math.min(Math.min(box0.sideLengths.x, box0.sideLengths.y, box0.sideLengths.z), Math.min(box1.sideLengths.x, box1.sideLengths.y, box1.sideLengths.z));
			combinationDist += (JConfig.collToll * 3.464);
			combinationDist *= combinationDist;

			if (minDepth > -numTiny)
				getBoxBoxIntersectionPoints(contactPoints, box0, box1, false);
			
			if (contactPoints.length == 0)
			{
				contactPointsFromOld = false;
				getBoxBoxIntersectionPoints(contactPoints, box0, box1, true);
			}
			
			var bodyDelta:Vector3D = box0.currentState.position.subtract(box0.oldState.position).subtract(box1.currentState.position.subtract(box1.oldState.position));
			var bodyDeltaLen:Number = bodyDelta.dotProduct(N);
			var oldDepth:Number = minDepth + bodyDeltaLen;
			
			var SATPoint:Vector3D = new Vector3D();
			switch(minAxis){
				//-----------------------------------------------------------------
				// Box0 face, Box1 Corner collision
				//-----------------------------------------------------------------
			case 0:
			case 1:
			case 2:
			{
				//-----------------------------------------------------------------
				// Get the lowest point on the box1 along box1 normal
				//-----------------------------------------------------------------
				SATPoint = getSupportPoint(box1, JNumber3D.getScaleVector(N, -1));
				break;
			}
			//-----------------------------------------------------------------
			// We have a Box2 corner/Box1 face collision
			//-----------------------------------------------------------------
			case 3:
			case 4:
			case 5:
			{
				//-----------------------------------------------------------------
				// Find with vertex on the triangle collided
				//-----------------------------------------------------------------
				SATPoint = getSupportPoint(box0, N);
				break;
			}
			//-----------------------------------------------------------------
			// We have an edge/edge colliiosn
			//-----------------------------------------------------------------
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
			case 11:
			case 12:
			case 13:
			case 14:
			{ 
				//-----------------------------------------------------------------
				// Retrieve which edges collided.
				//-----------------------------------------------------------------
				i = minAxis - 6;
				var ia:int = i / 3;
				var ib:int = i - ia * 3;
				//-----------------------------------------------------------------
				// find two P0, P1 point on both edges. 
				//-----------------------------------------------------------------
				var P0:Vector3D = getSupportPoint(box0, N);
				var P1:Vector3D = getSupportPoint(box1, JNumber3D.getScaleVector(N, -1));
      
				//-----------------------------------------------------------------
				// Find the edge intersection. 
				//-----------------------------------------------------------------
     
				//-----------------------------------------------------------------
				// plane along N and F, and passing through PB
				//-----------------------------------------------------------------
				var planeNormal:Vector3D = N.crossProduct(dirs1Arr[ib]);
				var planeD:Number = planeNormal.dotProduct(P1);
      
				//-----------------------------------------------------------------
				// find the intersection t, where Pintersection = P0 + t*box edge dir
				//-----------------------------------------------------------------
				var div:Number = dirs0Arr[ia].dotProduct(planeNormal);
      
				//-----------------------------------------------------------------
				// plane and ray colinear, skip the intersection.
				//-----------------------------------------------------------------
				if (Math.abs(div) < numTiny)
					return;
      
				var t:Number = (planeD - P0.dotProduct(planeNormal)) / div;
      
				//-----------------------------------------------------------------
				// point on edge of box0
				//-----------------------------------------------------------------
				P0 = P0.add(JNumber3D.getScaleVector(dirs0Arr[ia], t));
				SATPoint = P0.add(JNumber3D.getScaleVector(N, 0.5 * minDepth));
				break;
			}
			}

			var collPts:Vector.<CollPointInfo>;
			if (contactPoints.length > 0)
			{
				collPts = new Vector.<CollPointInfo>(contactPoints.length, true);

				var minDist:Number = numHuge,maxDist:Number = -numHuge,dist:Number,depth:Number,depthScale:Number;
				
				var cpInfo:CollPointInfo;
				var contactPoint:Vector3D;

				for each (contactPoint in contactPoints)
				{
					dist = contactPoint.subtract(SATPoint).length;
					
					if (dist < minDist)
						minDist = dist;

					if (dist > maxDist)
						maxDist = dist;
				}

				if (maxDist < minDist + numTiny)
					maxDist = minDist + numTiny;

				i = 0;
				for each (contactPoint in contactPoints)
				{
					dist = contactPoint.subtract(SATPoint).length;
					depthScale = (dist - minDist) / (maxDist - minDist);
					depth = (1 - depthScale) * oldDepth;
					cpInfo = new CollPointInfo();
					
					if (contactPointsFromOld)
					{
						cpInfo.r0 = contactPoint.subtract(box0.oldState.position);
						cpInfo.r1 = contactPoint.subtract(box1.oldState.position);
					}
					else
					{
						cpInfo.r0 = contactPoint.subtract(box0.currentState.position);
						cpInfo.r1 = contactPoint.subtract(box1.currentState.position);
					}
					
					cpInfo.initialPenetration = depth;
					collPts[int(i++)] = cpInfo;
				}
			}
			else
			{
				cpInfo = new CollPointInfo();
				cpInfo.r0 = SATPoint.subtract(box0.currentState.position);
				cpInfo.r1 = SATPoint.subtract(box1.currentState.position);
				cpInfo.initialPenetration = oldDepth;
				
				collPts = new Vector.<CollPointInfo>(1, true);
				collPts[0] = cpInfo;
			}

			var collInfo:CollisionInfo = new CollisionInfo();
			collInfo.objInfo = info;
			collInfo.dirToBody = N;
			collInfo.pointInfo = collPts;
			
			var mat:MaterialProperties = new MaterialProperties();
			mat.restitution = 0.5*(box0.material.restitution + box1.material.restitution);
			mat.friction = 0.5*(box0.material.friction + box1.material.friction);
			collInfo.mat = mat;
			collArr.push(collInfo);
			info.body0.collisions.push(collInfo);
			info.body1.collisions.push(collInfo);
			info.body0.addCollideBody(info.body1);
			info.body1.addCollideBody(info.body0);
		}
	}
}