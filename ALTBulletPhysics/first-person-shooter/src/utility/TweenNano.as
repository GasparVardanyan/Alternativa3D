/**
 * VERSION: 1.05
 * DATE: 2010-05-11
 * AS3 (AS2 is also available)
 * UPDATES AND DOCUMENTATION AT: http://www.TweenNano.com
 **/
package utility {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	public class TweenNano {
		protected static var _time:Number;
		protected static var _frame:uint;
		protected static var _masterList:Dictionary = new Dictionary(false); 
		protected static var _shape:Shape = new Shape(); 
		protected static var _tnInitted:Boolean; 
		protected static var _reservedProps:Object = {ease:1, delay:1, useFrames:1, overwrite:1, onComplete:1, onCompleteParams:1, runBackwards:1, immediateRender:1, onUpdate:1, onUpdateParams:1};
	
		public var duration:Number; 
		public var vars:Object; 
		public var startTime:Number;
		public var target:Object;
		public var active:Boolean; 
		public var gc:Boolean;
		public var useFrames:Boolean;
		public var ratio:Number = 0;
		
		protected var _ease:Function;
		protected var _initted:Boolean;
		protected var _propTweens:Array; 
		
		public function TweenNano(target:Object, duration:Number, vars:Object) {
			if (!_tnInitted) {			
				_time = getTimer() * 0.001;
				_frame = 0;
				_shape.addEventListener(Event.ENTER_FRAME, updateAll, false, 0, true);
				_tnInitted = true;
			}
			this.vars = vars;
			this.duration = duration;
			this.active = Boolean(duration == 0 && this.vars.delay == 0 && this.vars.immediateRender != false);
			this.target = target;
			if (typeof(this.vars.ease) != "function") {
				_ease = TweenNano.easeOut;
			} else {
				_ease = this.vars.ease;
			}
			_propTweens = [];
			this.useFrames = Boolean(vars.useFrames == true);
			var delay:Number = ("delay" in this.vars) ? Number(this.vars.delay) : 0;
			this.startTime = (this.useFrames) ? _frame + delay : _time + delay;
			
			var a:Array = _masterList[target];
			if (a == null || int(this.vars.overwrite) == 1 || this.vars.overwrite == null) { 
				_masterList[target] = [this];
			} else {
				a[a.length] = this;
			}
			
			if (this.vars.immediateRender == true || this.active) {
				renderTime(0);
			}
		}
		
		public function init():void {
			for (var p:String in this.vars) {
				if (!(p in _reservedProps)) {
					_propTweens[_propTweens.length] = [p, this.target[p], (typeof(this.vars[p]) == "number") ? this.vars[p] - this.target[p] : Number(this.vars[p])]; //[property, start, change]
				}
			}
			if (this.vars.runBackwards) {
				var pt:Array;
				var i:int = _propTweens.length;
				while (--i > -1) {
					pt = _propTweens[i];
					pt[1] += pt[2];
					pt[2] = -pt[2];
				}
			}
			_initted = true;
		}
		
		public function renderTime(time:Number):void {
			if (!_initted) {
				init();
			}
			var pt:Array, i:int = _propTweens.length;
			if (time >= this.duration) {
				time = this.duration;
				this.ratio = 1;
			} else if (time <= 0) {
				this.ratio = 0;
			} else {
				this.ratio = _ease(time, 0, 1, this.duration);			
			}
			while (--i > -1) {
				pt = _propTweens[i];
				this.target[pt[0]] = pt[1] + (this.ratio * pt[2]); 
			}
			if (this.vars.onUpdate) {
				this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
			}
			if (time == this.duration) {
				complete(true);
			}
		}

		public function complete(skipRender:Boolean=false):void {
			if (!skipRender) {
				renderTime(this.duration);
				return;
			}
			kill();
			if (this.vars.onComplete) {
				this.vars.onComplete.apply(null, this.vars.onCompleteParams);
			}
		}
		
		public function kill():void {
			this.gc = true;
			this.active = false;
		}
		
		public static function to(target:Object, duration:Number, vars:Object):TweenNano {
			return new TweenNano(target, duration, vars);
		}
		
		public static function from(target:Object, duration:Number, vars:Object):TweenNano {
			vars.runBackwards = true;
			if (!("immediateRender" in vars)) {
				vars.immediateRender = true;
			}
			return new TweenNano(target, duration, vars);
		}
		
		public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array=null, useFrames:Boolean=false):TweenNano {
			return new TweenNano(onComplete, 0, {delay:delay, onComplete:onComplete, onCompleteParams:onCompleteParams, useFrames:useFrames, overwrite:0});
		}
		
		public static function updateAll(e:Event=null):void {
			_frame += 1;
			_time = getTimer() * 0.001;
			var ml:Dictionary = _masterList, a:Array, tgt:Object, i:int, t:Number, tween:TweenNano;
			for (tgt in ml) {
				a = ml[tgt];
				i = a.length;
				while (--i > -1) {
					tween = a[i];
					t = (tween.useFrames) ? _frame : _time;
					if (tween.active || (!tween.gc && t >= tween.startTime)) {
						tween.renderTime(t - tween.startTime);
					} else if (tween.gc) {
						a.splice(i, 1);
					}
				}
				if (a.length == 0) {
					delete ml[tgt];
				}
			}
		}
		
		 public static function killTweensOf(target:Object, complete:Boolean=false):void {
			if (target in _masterList) {
				if (complete) {
					var a:Array = _masterList[target];
					var i:int = a.length;
					while (--i > -1) {
						if (!TweenNano(a[i]).gc) {
							TweenNano(a[i]).complete(false);
						}
					}
				}
				delete _masterList[target];
			}
		}
		
		private static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -1 * (t /= d) * (t - 2);
		}
		
	}
}