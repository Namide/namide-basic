package namide.tools.lightSlideshow.components 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightshowLoader 
	{
		protected var _eventDispatcher:EventDispatcher;
		
		protected var _listLoader:Vector.<Loader>;
		protected var _listURL:Vector.<String>;
		protected var _listStarted:Vector.<Boolean>;
		
		protected var _poolLoading:Vector.<Loader>;
		
		public function LightshowLoader() 
		{
			_poolLoading = new Vector.<Loader>( 0, false );
		}
		
		public function setByURL( listURL:Vector.<String> ):void
		{
			const l:int = list.length;
			var i:int = -1;
			
			_listURLs = new Vector.<String>( l, true );
			_listLoader = new Vector.<Loader>( l, true );
			_listStarted = new Vector.<Boolean>( l, true );
			
			_eventDispatcher = new EventDispatcher();
			
			while ( ++i < l )
			{
				_listURLs[i] = listURL[i];
				_listLoader[i] = new Loader();
				_listStarted[i] = false;
			}
		}
		
		public function getLength():int
		{
			return (_listLoader) ? _listLoader.length : 0;
		}
		
		public function getLoader(id:int):Loader
		{
			if (  _listLoader && _listLoader[id] ) return null;
			
			if (  !_listStarted[id] ) 
			{
				_listLoader[id].load( new URLRequest(_listURL[id]) );
				_listLoader[id].loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_listLoader[id].loaderInfo.addEventListener(Event.COMPLETE, onComplete);
				_listStarted[id] = true;
			}
			
			return _listLoader[id];
		}
		
		protected function onProgress(e:ProgressEvent):void
		{
			_eventDispatcher
		}
		protected function onComplete(e:Event):void
		{
			_eventDispatcher
		}
		
		public function isLoaded(id:int):Loader
		{
			if ( !_listStarted[id] ) return false;
			if ( _listLoader && _listLoader[id] && _listLoader[_currentPicture].content ) return true;
			
			return false;
		}
		
		
		
	}

}