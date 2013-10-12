package namide.tools.lightSlideshow.components 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightshowThumbManager 
	{
		//protected var _eventDispatcher:EventDispatcher;
		
		protected var _listURLs:Vector.<String>;
		protected var _listThumbs:Vector.<Loader>;
		
		/*protected var _numThumbsLoaded:int;
		
		public static const THUMB_LOADED:String = "thumb loaded";
		public static const ALL_LOADED:String = "all loaded";
		
		public function DSlightshowThumbManager() 
		{
			_eventDispatcher = new EventDispatcher();
		}*/
		
		public function setPicturesByURL( list:Vector.<String> ):void
		{
			const l:int = list.length;
			//_numThumbsLoaded = 0;
			var i:int = -1;
			
			_listURLs = new Vector.<String>( l, true );
			_listThumbs = new Vector.<Loader>( l, true );
			
			while ( ++i < l )
			{
				_listURLs[i] = list[i];
				_listThumbs[i] = new Loader();
				//_listThumbs[i].contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbLoaded );
				//_listThumbs[i].load( new URLRequest( _listURLs[i] ) );
				if (i == 0)
				{
					_listThumbs[i].load( new URLRequest( _listURLs[i] ) );
					_listThumbs[i].contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbLoaded);
				}
				
			}
		}
		
		protected function onThumbLoaded(e:Event):void
		{
			var loader:Loader = (e.target as LoaderInfo).loader;
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, onThumbLoaded);
			
			var next:int = _listThumbs.indexOf(loader) + 1;
			
			if (next < _listURLs.length)
			{
				_listThumbs[next].load( new URLRequest( _listURLs[next] ) );
				_listThumbs[next].contentLoaderInfo.addEventListener(Event.COMPLETE, onThumbLoaded);
			}
			
			
			
			/*var event:Event = new Event( THUMB_LOADED );
			//event.target = e.target;
			_eventDispatcher.dispatchEvent( event );
			
			_numThumbsLoaded++;
			if ( _numThumbsLoaded >= _listThumbs.length )
			{
				event = new Event( ALL_LOADED );
				//event.target = this;
				_eventDispatcher.dispatchEvent( event );
			}*/
		}
		
		public function getListThumbs():Vector.<Loader> { return _listThumbs; }
		//public function get eventDispatcher():EventDispatcher { return _eventDispatcher; }
		
	}

}