package namide.tools.lightSlideshow.components 
{
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightSlideshowPicturesLoader 
	{
		protected var _eventDispatcher:EventDispatcher;
		protected var _listPictures:Loader;
		
		
		public function LightSlideshowPicturesLoader( urls:Vector.<String> ) 
		{
			var i:int = urls.length;
			
			
			_eventDispatcher = new EventDispatcher();
			
			
			const l:int = list.length;
			var i:int = -1;
			
			_listURLs = new Vector.<String>( l, true );
			_listPictures = new Vector.<Loader>( l, true );
			
			while ( ++i < l )
			{
				_listURLs[i] = urls[i];
				_listPictures[i] = new Loader();
				_listPictures[i].load( new URLRequest( urls[i] ) );
			}
			
		}
		
	}

}