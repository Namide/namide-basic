package namide.basic.utils 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Namide
	 */
	public class EventsCollector 
	{
		protected static var _INSTANCE:EventsCollector;
		
		protected var _eventsDatasList:Vector.<EventDatas>
		
		public function EventsCollector()
		{
			_eventsDatasList = new Vector.<EventDatas>( 0, false );
		}
		
		public static function getGlobalInstance():EventsCollector
		{
			if ( _INSTANCE == null ) _INSTANCE = new EventsCollector();
			return _INSTANCE;
		}
		
		public function replaceEventListener(  target:EventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):EventsCollector
		{
			removeEventListenersByType( target, eventType );
			addEventListener( target, eventType, listener, useCapture, priority, useWeakReference );
			return this;
		}
		
		public function addEventListener( target:EventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):EventsCollector
		{
			var ed:EventDatas = new EventDatas( target, eventType, listener, useCapture );
			ed.addEventListener( priority, useWeakReference );
			
			_eventsDatasList[_eventsDatasList.length] = ed;
			
			return this;
		}
		
		public function removeEventListener( target:EventDispatcher, eventType:String, listener:Function, useCapture:Boolean = false ):EventsCollector
		{
			var i:int = _eventsDatasList.length;
			while ( --i > -1 )
			{
				if ( _eventsDatasList[i].compare( target, eventType, listener, int(useCapture) ) )
				{
					_eventsDatasList[i].removeEventListener();
					_eventsDatasList.splice( i, 1 );
				}
			}
			return this;
		}
		
		public function removeEventListenersByType( target:EventDispatcher, eventType:String ):EventsCollector
		{
			var i:int = _eventsDatasList.length;
			while ( --i > -1 )
			{
				if ( _eventsDatasList[i].compare( target, eventType ) )
				{
					_eventsDatasList[i].removeEventListener();
					_eventsDatasList.splice( i, 1 );
				}
			}
			return this;
		}
		
		public function removeAllEventListenersOfTarget( target:EventDispatcher ):EventsCollector
		{
			var i:int = _eventsDatasList.length;
			while ( --i > -1 )
			{
				if ( _eventsDatasList[i].compare( target ) )
				{
					_eventsDatasList[i].removeEventListener();
					_eventsDatasList.splice( i, 1 );
				}
			}
			return this;
		}
		
		public function removeAllEventListenersOfTargetRecursivly( target:DisplayObject ):EventsCollector
		{
			removeAllEventListenersOfTarget( target );
			
			if ( target is DisplayObjectContainer )
			{
				const container:DisplayObjectContainer = target as DisplayObjectContainer;
				var i:int = container.numChildren;
				while ( --i > -1 )
				{
					removeAllEventListenersOfTargetRecursivly( container.getChildAt(i) );
				}
			}
			
			return this;
		}
		
	}

}

import flash.events.EventDispatcher;

internal class EventDatas
{
	protected var _eventType:String;
	protected var _listener:Function;
	protected var _target:EventDispatcher;
	protected var _useCapture:Boolean;
	
	public function EventDatas( target:EventDispatcher, eventType:String, listener:Function, useCapture:Boolean )
	{
		_target = target;
		_eventType = eventType;
		_listener = listener;
		_useCapture = useCapture;
	}
	
	public function get eventType():String { return _eventType; }
	public function get listener():Function { return _listener; }
	public function get target():EventDispatcher { return _target; }
	public function get useCapture():Boolean { return _useCapture; }
	
	
	public function addEventListener( priority:int, useWeakReference:Boolean ):void
	{
		_target.addEventListener( _eventType, _listener, _useCapture, priority, useWeakReference );
	}
	
	public function removeEventListener():EventDatas
	{
		_target.removeEventListener( _eventType, _listener, _useCapture );
		return this;
	}
	
	public function compare( target:EventDispatcher, eventType:String = null, listener:Function = null, useCapture:int = -1 ):Boolean
	{
		if ( target != _target ) return false;
		if ( eventType != null && eventType != _eventType ) return false;
		if ( listener != null && listener != _listener ) return false;
		if ( useCapture != -1 && Boolean(useCapture) != _useCapture ) return false;
		
		return true;
	}
	
}
