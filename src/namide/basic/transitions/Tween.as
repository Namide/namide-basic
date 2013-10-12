package namide.basic.transitions 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	import namide.basic.geom.CurvedPath1D;
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class Tween
	{
		
		//------------------------------
		//
		//		EDITABLE PARAMS
		//
		//------------------------------
		
		
		protected var _timer:Function = getTimer;
		protected var _time:uint = 1000;
		protected var _delay:Number = 0;
		protected var _loop:int = 0;
		protected var _continue:Boolean = false;
		protected var _autoRefresh:Boolean = true;
		protected var _equation:Function = Equations.easeNone;
		protected var _equationParam:Object;
		protected var _onStart:Function;
		protected var _onStartParams:Array;
		protected var _onUpdate:Function;
		protected var _onUpdateParams:Array;
		protected var _onComplete:Function;
		protected var _onCompleteParams:Array;
		
		
		
		
		
		//------------------------------
		//
		//		INTERNAL DATAS
		//
		//------------------------------
		
		protected static var _SHAPE:Shape = new Shape();
		protected static var _tweenList:Vector.<Tween> = new Vector.<Tween>( 0, false );
		
		protected var _target:Object;
		protected var _started:Boolean;
		
		
		protected var _tBegin:Number;
		
		protected var _targetProperties:Object;
		protected var _targetPropertiesLabel:Vector.<String>;
		protected var _targetPropertiesBegin:Vector.<Number>;
		protected var _targetPropertiesDelta:Vector.<Number>;
		protected var _targetPropertiesPath:Vector.<CurvedPath1D>;
		
		//protected var _onOverwrite:Function;
		//protected var _onOverwriteParams:Array;
		
		
		/**
		 * 
		 * @param	pTarget				target object whose properties this tween affects. This can be any object, not just a DisplayObject
		 * @param	targetProperties	All label's properties of number type (uint, int, Number) for the target
		 * @param	params				optional params for the Tween :
		 * 								_timer:Function 			function who return the actual _time, getTimer() by default
		 * 								_time:Number				_time in milliseconds
		 * 								_delay:Number			_delay in milliseconds
		 * 								_equation:Function		type of _equation (see _equation class)
		 * 								_equationParam:Object	optional parameters of the _equation
		 * 								_onStart:Function		callback when the Tween start				
		 * 								_onStartParams:Array		arguments of the callback _onStart				
		 * 								_onUpdate:Function		callback when the Tween updated				
		 * 								_onUpdateParams:Array	arguments of the callback _onUpdate				
		 * 								_onComplete:Function		callback when the Tween complete				
		 * 								_onCompleteParams:Array	arguments of the callback _onComplete
		 * 								_loop:int				-1 = Infinity ; 0 = no _loop ; 1, 2, 3...
		 * 						
		 */
		public function Tween( pTarget:Object /*, targetProperties:Object, params:Object = null*/ ) 
		{
			_target = pTarget;
			//_targetProperties = targetProperties;
			_started = false;
			start();
		}
		
		
		//------------------------------
		//
		//		EDITABLE SETTERS
		//
		//------------------------------
		
		/**
		 * Add a value for interpolation
		 * 
		 * @param	label		Name of the propertie of yout object (in example "x", "y", "alpha"...)
		 * @param	value		Value of the propertie : umber or CurvedPath1D for a complex path
		 * @return
		 */
		public function setValue( label:String, value:* ):Tween
		{
			if ( _targetProperties == null ) _targetProperties = { };
			_targetProperties[label] = value;
			return this;
		}
		
		
		/**
		 * Set the function who return the actual _time, it is the function getTimer() by default
		 * 
		 * @param	value		Function who return the actual _time, it is the function getTimer() by default
		 * @return				The actual Tween
		 */
		public function setTimer(value:Function):Tween { _timer = value; _tBegin = _timer.apply() + _delay; return this; }
		
		/**
		 * Set the time of the interpolation in milliseconds
		 * 
		 * @param	value		Time of the interpolation in milliseconds
		 * @return				The actual Tween
		 */
		public function setTime(value:Number):Tween { _time = value; return this; }
		
		/**
		 * Set the delay in milliseconds
		 * 
		 * @param	value		Delay in milliseconds
		 * @return				The actual Tween
		 */
		public function setDelay(value:Number):Tween { _delay = value; _tBegin = _timer.apply() + _delay; return this; }
		
		/**
		 * Set the time to start in milliseconds
		 * 
		 * @param	value		Start time in milliseconds
		 * @return				The actual Tween
		 */
		public function setStartTime(value:uint):Tween { _tBegin = value; _delay = _tBegin - _timer.apply(); return this; }
		
		
		
		/**
		 * Number of loops of the tween :
		 * ● -1 = infinite loops
		 * ● 0 = no _loop
		 * ● 1 = 1 loop
		 * ● 2 = 2 loops
		 * ● ...
		 * 
		 * @param	value		-1 = Infinity ; 0 = no _loop ; 1, 2, 3...
		 * @return				The actual Tween
		 */
		public function setLoop(value:int):Tween { _loop = value; return this; }
		
		public function setContinue(value:Boolean):Tween { _continue = value; return this; }
		
		
		/**
		 * If the autoRefresh = false, you must call the refresh method every
		 * time for update the tween.
		 * 
		 * @param	value
		 * @return
		 */
		public function setAutoRefresh(value:Boolean):Tween
		{
			_autoRefresh = value;
			Tween._SHAPE.removeEventListener( Event.ENTER_FRAME, refresh );
			if( _autoRefresh ) Tween._SHAPE.addEventListener( Event.ENTER_FRAME, refresh );
			return this;
		}
		
		
		/**
		 * Set the type of _equation (see _equation class)
		 * 
		 * @param	value		Type of _equation (see _equation class)
		 * @return				The actual Tween
		 */
		public function setEquation(value:Function):Tween { _equation = value; return this; }
		
		/**
		 * Set the optional parameters of the _equation
		 * 
		 * @param	value		Optional parameters of the _equation
		 * @return				The actual Tween
		 */
		public function setEquationParam(value:Object):Tween { _equationParam = value; return this; }
		
		/**
		 * Set the callback when the Tween start
		 * 
		 * @param	callback			Callback when the Tween start
		 * @param	callbackParams		Arguments of the callback onStart
		 * @return						The actual Tween
		 */
		public function setOnStart( callback:Function, callbackParams:Array = null ):Tween
		{
			_onStart = callback;
			_onStartParams = callbackParams;
			return this;
		}
		
		/**
		 * Set the callback when the Tween updated
		 * 
		 * @param	value		Callback when the Tween updated
		 * @param	value		Arguments of the callback onUpdate
		 * @return				The actual Tween
		 */
		public function setOnUpdate( callback:Function, callbackParams:Array = null ):Tween
		{
			_onUpdate = callback;
			_onUpdateParams = callbackParams;
			return this;
		}
		
		/**
		 * Set the callback when the Tween complete
		 * 
		 * @param	value		Callback when the Tween complete
		 * @param	value		Arguments of the callback _onComplete	
		 * @return				The actual Tween
		 */
		public function setOnComplete( callback:Function, callbackParams:Array = null ):Tween
		{
			_onComplete = callback;
			_onCompleteParams = callbackParams;
			return this;
		}
		
		
		
		
		//------------------------------
		//
		//		STATIC PUBLIC METHODS
		//
		//------------------------------
		
		/**
		 * create a new Tween
		 * 
		 * @param	pTarget				target object whose properties this tween affects. This can be any object, not just a DisplayObject
		 * @param	targetProperties	All label's properties of number type (uint, int, Number) for the target
		 * @return	the tween created
		 */
		public static function add( pTarget:Object/*, targetProperties:Object, params:Object = null*/ ):Tween
		{
			return new Tween( pTarget/*, targetProperties, params*/ );
		}
		
		/**
		 * Remove all Tweens for one target.
		 * 
		 * @param	pTarget			target object whose properties these tweens affects
		 */
		public static function removeAllTweensOfTarget( pTarget:Object ):void
		{
			var i:int = _tweenList.length;
			while ( --i > -1 ) if ( _tweenList[i]._target == pTarget ) _tweenList[i].remove();
		}
		
		/**
		 * Remove all Tweens
		 */
		public static function removeAllTweens():void
		{
			var i:int = _tweenList.length;
			while ( --i > -1 ) _tweenList[i].remove();
		}
		
		/**
		 * Number of Tweens
		 */
		public static function numTweens():int
		{
			return _tweenList.length;
		}
		
		//------------------------------
		//
		//		PUBLIC METHODS
		//
		//------------------------------
		
		/**
		 * Remove the tween
		 */
		public function remove():void
		{
			_SHAPE.removeEventListener( Event.ENTER_FRAME, refresh );
			var i:int = _tweenList.indexOf( this );
			_tweenList.splice( i, 1 );
		}
		
		public function removeTargetProperties( propertieLabel:String ):void
		{
			var i:int = _targetPropertiesLabel.indexOf( propertieLabel );
			
			if ( i > -1 )
			{
				_targetPropertiesBegin.splice( i, 1 );
				_targetPropertiesDelta.splice( i, 1 );
				_targetPropertiesLabel.splice( i, 1 );
			}
			
		}
		
		/**
		 * Constrain the refresh
		 * 
		 * @param			Inactives params
		 */
		public function refresh( ...rest ):void
		{
			var t:Number = _timer.apply() - _tBegin;
			
			if ( t < 0 && !_continue ) return ;
			else if ( t > _time && !_continue ) t = _time;
			
			if ( !_started )
			{
				initTargetProperties( _targetProperties );
				_started = true;
				if( _onStart != null ) _onStart.apply( null, _onStartParams );
			}
			
			applyMotion( t );
			
			if ( t < _time || _continue )
			{
				if( _onUpdate != null ) _onUpdate.apply( null, _onUpdateParams );
			}
			else if ( t >= _time )
			{
				if ( _loop != 0 )
				{
					_loop--;
					_tBegin = _timer.apply();
				}
				else
				{
					if ( _onComplete != null ) _onComplete.apply( null, _onCompleteParams );
					remove();
				}
				
			}
			
		}
		
		
		//------------------------------
		//
		//		PROTECTED METHODS
		//
		//------------------------------
		
		
		protected function initTargetProperties( targetProperties:Object ):void
		{
			_targetPropertiesLabel = new Vector.<String>( 0, false );
			_targetPropertiesBegin = new Vector.<Number>( 0, false );
			_targetPropertiesDelta = new Vector.<Number>( 0, false );
			_targetPropertiesPath = new Vector.<CurvedPath1D>( 0, false );
			
			var i:int = 0;
			for ( var key:String in targetProperties )
			{
				_targetPropertiesLabel[i] = key;
				
				if ( targetProperties[key] is CurvedPath1D )
				{
					_targetPropertiesPath[i] = targetProperties[key];
					_targetPropertiesBegin[i] = 0;
					_targetPropertiesDelta[i] = 0;
				}
				else
				{
					_targetPropertiesPath[i] = null;
					_targetPropertiesBegin[i] = _target[key];
					_targetPropertiesDelta[i] = targetProperties[key] - _targetPropertiesBegin[i];
				}
				
				i++;
			}
		}
		
		protected function start():void
		{
			Tween._SHAPE.addEventListener( Event.ENTER_FRAME, refresh );
			_tweenList[_tweenList.length] = this;
			
			_tBegin = _timer.apply() + _delay;
			//refresh();
		}
		
		
		
		protected function applyMotion( t:uint ):void
		{
			var tModified:Number = _equation.apply( null, [ t, 0, 1, _time ] );
			var propertieTarget:*;
			
			var i:int = _targetPropertiesLabel.length;
			while (--i > -1)
			{
				propertieTarget = _target[_targetPropertiesLabel[i]];
				if ( _targetPropertiesPath[i] != null )
				{
					_target[ _targetPropertiesLabel[i] ] = _targetPropertiesPath[i].getValueAt( tModified );
				}
				else
				{
					_target[ _targetPropertiesLabel[i] ] = tModified * _targetPropertiesDelta[i] + _targetPropertiesBegin[i];
				}
			}
		}
		
		
		
	}
	
}