package namide.basic.utils 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class DistortedTime implements IDistortedTime
	{
		protected static var _eventDispatcher:Shape;
		protected static var _INSTANCE:DistortedTime;
		
		protected var _onEnterFrame:Signal;
		
		protected var _globalTimer:uint;
		protected var _globalDT:uint;
		
		protected var _distortedTimer:uint;
		protected var _distortedDT:uint;
		
		protected var _distortedTimerSeconds:Number;
		protected var _distortedDTSeconds:Number;
		
		protected var _distortedSpeed:Number;
		
		
		protected var _callbackFct:Vector.<Function>;
		protected var _callbackTime:Vector.<uint>;
		protected var _callbackParams:Vector.<Array>;
		protected var _callbackLoopNumber:Vector.<int>;
		protected var _callbackLoopTime:Vector.<uint>;
		
		
		public function DistortedTime() 
		{			
			if( DistortedTime._eventDispatcher == null ) DistortedTime._eventDispatcher = new Shape();
			
			_onEnterFrame = new Signal();
			
			
			_callbackFct = new Vector.<Function>( 0, false );
			_callbackTime = new Vector.<uint>( 0, false );
			_callbackParams = new Vector.<Array>( 0, false );
			_callbackLoopNumber = new Vector.<int>( 0, false );
			_callbackLoopTime = new Vector.<uint>( 0, false );
			
			
			_distortedSpeed = 1;
			start();
		}
		
		public function get onEnterFrame():ISignal { return _onEnterFrame; }
		public static function getInstance():DistortedTime { return (_INSTANCE == null) ? ( _INSTANCE = new DistortedTime() ) : _INSTANCE;  };
		
		public function addCallbackDelayLoop( fct:Function, delay:uint, params:Array = null, loopNumber:int = 0, loopTime:uint = 0 ):Function
		{
			return addCallbackTimeLoop( fct, _distortedTimer + delay, params, loopNumber, loopTime );
		}
		public function addCallbackTimeLoop( fct:Function, time:uint, params:Array = null, loopNumber:int = 0, loopTime:uint = 0 ):Function
		{
			var i:int = _callbackTime.length;
			while ( --i > -1 )
			{
				if ( time > _callbackTime[i] )
				{
					i++;
					break;
				}
			}
			_callbackFct.splice( i, 0, fct );
			_callbackTime.splice( i, 0, time );
			_callbackParams.splice( i, 0, params );
			_callbackLoopNumber.splice( i, 0, loopNumber );
			_callbackLoopTime.splice( i, 0, loopTime );
			return fct;
		}
		public function clearCallbackLoop( fct:Function ):void
		{
			var i:int;
			while ( (i = _callbackFct.indexOf(fct)) > -1 )
			{
				_callbackFct.splice( i, 1 );
				_callbackTime.splice( i, 1 );
				_callbackParams.splice( i, 1 );
				_callbackLoopNumber.splice( i, 1 );
				_callbackLoopTime.splice( i, 1 );
			}
		}
		public function clearAllCallbackLoop():void
		{
			var i:int;
			while ( _callbackFct.length > 0 )
			{
				clearCallbackLoop( _callbackFct[0] );
			}
		}
		
		protected function testCallbackLoop():void
		{
			var l:int = _callbackTime.length;
			if ( l == 0 ) return ;
			
			var i:int = -1;
			while ( ++i < _callbackTime.length )
			{
				if ( _callbackTime[i] < _distortedTimer )
				{
					_callbackFct[i].apply( null, _callbackParams[i] );
					
					if ( _callbackLoopNumber[i] != 0 )
					{
						_callbackLoopNumber[i]--;
						var time:uint = _callbackTime[i] + _callbackLoopTime[i];
						addCallbackTimeLoop( _callbackFct[i], time, _callbackParams[i], _callbackLoopNumber[i], _callbackLoopTime[i] );
					}
					
					_callbackFct.splice( i, 1 );
					_callbackTime.splice( i, 1 );
					_callbackParams.splice( i, 1 );
					_callbackLoopNumber.splice( i, 1 );
					_callbackLoopTime.splice( i, 1 );
				}
				else
				{
					return ;
				}
			}
		}
		
		public function start( time:uint = 0 ):void
		{
			_globalTimer = getTimer();
			_distortedTimer = time;
			_eventDispatcher.removeEventListener( Event.ENTER_FRAME, update, false );
			_eventDispatcher.addEventListener( Event.ENTER_FRAME, update, false, int.MAX_VALUE, true );
			
			update();
		}
		
		public function get speed():Number 				{ return _distortedSpeed; }
		public function set speed( value:Number ):void	{ _distortedSpeed = value; }
		
		public function get dTMilliseconds():uint		{ return _distortedDT; }
		public function get dTSeconds():Number 			{ return _distortedDTSeconds; }
		public function get timerMilliseconds():uint	{ return _distortedTimer; }
		public function get timerSeconds():Number		{ return _distortedTimerSeconds; }
		
		public function getTimerMilliseconds():uint { return _distortedTimer;  } 
		
		protected function update( e:Event = null ):void
		{
			_globalDT = getTimer() - _globalTimer;
			_globalTimer = getTimer();
			
			_distortedDT = _globalDT * _distortedSpeed;
			_distortedTimer += _distortedDT;
			
			_distortedDTSeconds = _distortedDT * 0.001;
			_distortedTimerSeconds = _distortedTimer * 0.001;
			
			_onEnterFrame.dispatch();
			testCallbackLoop();
		}
	}
}
