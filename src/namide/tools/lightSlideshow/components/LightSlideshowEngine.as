package namide.tools.lightSlideshow.components 
{
	import namide.basic.display.BitmapDataResizerBilinear;
	import namide.tools.lightSlideshow.transitions.PicturesTransition;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightSlideshowEngine
	{
		protected var _eventDispatcher:EventDispatcher;
		
		protected var _content:Sprite;
		
		protected var _pictureOnLoading:LoaderInfo;
		
		protected var _transition:PicturesTransition;
		
		protected var _listURLs:Vector.<String>;
		protected var _listPictures:Vector.<Loader>;
		
		protected var _currentPicture:int;
		protected var _played:Boolean = true;
		
		protected var _timeTransition:uint = 1000;
		protected var _timeView:uint = 4000;
		protected var _timeToChange:uint;
		
		protected var _idTimeout:uint;
		
		protected var _width:int;
		protected var _heigth:int;
		
		protected var _bgColor:uint = 0x000000;
		
		public static const PICTURE_CHANGE:String = "picture change";
		public static const PLAYED_CHANGE:String = "played change";
		public static const PICTURE_START_LOAD:String = "picture start load";
		public static const PICTURE_LOADED:String = "picture loaded";
		public static const PICTURE_PROGRESS_LOAD:String = "picture progress load";
		
		public function LightSlideshowEngine( pTransition:PicturesTransition, params:Object = null ) 
		{
			_eventDispatcher = new EventDispatcher();
			
			_width = _heigth = 512;
			
			_content = new Sprite();
			transition = pTransition;
			
			
			init( params );
			
			if(_listPictures && _played) play();
		}
        
		protected function init( params:Object ):void
		{
			if ( params ) for ( var key:String in params ) this[key] = params[key];
		}
		
		public function setPicturesByURL( list:Vector.<String> ):void
		{
			const l:int = list.length;
			var i:int = -1;
			
			_listURLs = new Vector.<String>( l, true );
			_listPictures = new Vector.<Loader>( l, true );
			
			while ( ++i < l )
			{
				_listURLs[i] = list[i];
				_listPictures[i] = new Loader();
			}
			
			play();
		}
		
		public function getURLofID( id:int ):String { return _listURLs[id]; }
		
		public function get played():Boolean { return _played; }
		public function set played(value:Boolean):void
		{
			if ( value ) play(); 
			else pause();
		}
		
		public function playPause(e:* = null):void
		{
			played = !_played;
		}
		
		public function play(e:* = null):void
		{
			var savePlayed:Boolean = _played;
			_played = true;
			clearTimeout( _idTimeout );
			_idTimeout = setTimeout( next, _timeTransition + timeView );
			go(_currentPicture);
			
			if (_played != savePlayed) _eventDispatcher.dispatchEvent( new Event(PLAYED_CHANGE) );
		}
		public function pause(e:* = null):void
		{
			var savePlayed:Boolean = _played;
			_played = false;
			clearTimeout( _idTimeout );
			
			if (_played != savePlayed) _eventDispatcher.dispatchEvent( new Event(PLAYED_CHANGE) );
		}
		
		
		public function go( num:int ):void
		{
			while ( num < 0 ) num = totalPictures + num;
			num %= totalPictures;
			_currentPicture = num;
			
			clearTimeout( _idTimeout );
			
			
			if ( _listPictures && _listPictures[_currentPicture].content )
			{
				killOldLoad();
				
				_eventDispatcher.dispatchEvent( new Event(LightSlideshowEngine.PICTURE_LOADED) );
				
				_transition.addPicture( moveAndResize( _listPictures[_currentPicture].content as Bitmap ) );
				if(played) _idTimeout = setTimeout( next, _timeTransition + timeView );
				startShader();
			}
			else if (_listPictures && _listPictures[_currentPicture] && !_listPictures[_currentPicture].loaderInfo )
			{
				killOldLoad();
				startNewLoad(_currentPicture);
				
				_eventDispatcher.dispatchEvent( new Event(LightSlideshowEngine.PICTURE_START_LOAD) );
				
			}
			else if (_listPictures && _listPictures[_currentPicture] )
			{
				killOldLoad();
				startNewLoad(_currentPicture);
				
				_eventDispatcher.dispatchEvent( new Event(LightSlideshowEngine.PICTURE_START_LOAD) );
			}
			else
			{
				_idTimeout = setTimeout( go, 1000, _currentPicture );
			}
			
			// EVENTS
			var event:Event = new Event( PICTURE_CHANGE );
			_eventDispatcher.dispatchEvent( event );
		}
		
		protected function killOldLoad():void
		{
			if (_pictureOnLoading)
			{
				_pictureOnLoading.removeEventListener( ProgressEvent.PROGRESS, pictureProgressLoad );
				_pictureOnLoading.removeEventListener( Event.COMPLETE, pictureLoaded );
				
				if ( _pictureOnLoading.content == null && _pictureOnLoading.loader ) 
				{
					try
					{
						_pictureOnLoading.loader.close();
					}
					catch (e:Error) { }
				}
			}
		}
		
		protected function startNewLoad(num:int):void
		{
			if (_listPictures[num].loaderInfo == null) _listPictures[num].load( new URLRequest( _listURLs[num] ) );
			
			_pictureOnLoading = _listPictures[num].contentLoaderInfo;
			_pictureOnLoading.addEventListener( ProgressEvent.PROGRESS, pictureProgressLoad, false, 0, true );
			_pictureOnLoading.addEventListener( Event.COMPLETE, pictureLoaded, false, 0, true );
		}
		
		private function pictureProgressLoad( e:ProgressEvent ):void
		{
			if( e.target == _pictureOnLoading )//if ( _listPictures[currentPicture].contentLoaderInfo == e.target )
			{
				var event:ProgressEvent = new ProgressEvent( LightSlideshowEngine.PICTURE_PROGRESS_LOAD, false, false, e.bytesLoaded, e.bytesTotal );
				_eventDispatcher.dispatchEvent( event );
			}
		}
		
		private function pictureLoaded(e:Event):void 
		{
			(e.target as LoaderInfo).removeEventListener( ProgressEvent.PROGRESS, pictureProgressLoad );
			(e.target as LoaderInfo).removeEventListener( Event.COMPLETE, pictureLoaded );
			if ( _listPictures[currentPicture].contentLoaderInfo == e.target ) go( _currentPicture );
		}
		
		private function startShader():void 
		{
			_timeToChange = getTimer();
			refresh();
			_content.removeEventListener( Event.ENTER_FRAME, refresh );
			_content.addEventListener( Event.ENTER_FRAME, refresh );
		}
		public function next(e:* = null):void { go( _currentPicture + 1 ); }
		public function prev(e:* = null):void { go( _currentPicture - 1 ); }
		
		public function set transition( pTransition:PicturesTransition ):void
		{
			if(_transition) _content.removeChild( _transition.content );
			_transition = pTransition;
			
			var front:Bitmap = new Bitmap( new BitmapData( 10, 10, false, 0x000000 ) )
			_transition.addPicture( moveAndResize( front ) );
			
			_content.addChildAt( _transition.content, 0 );
		}
		public function get transition():PicturesTransition { return _transition; }
		
		public function get currentPicture():int { return _currentPicture; }
		public function get totalPictures():int { return (_listPictures)?_listPictures.length:0; }
		public function get currentURL():String { return (_listPictures)?_listURLs[_currentPicture]:null; }
		
		public function get bgColor():uint { return _bgColor; }
		public function set bgColor(value:uint):void { _bgColor = value; }
		
		public function get timeView():uint { return _timeView; }
		public function set timeView(value:uint):void { _timeView = value; }
		
		public function get timeTransition():uint { return _timeTransition; }
		public function set timeTransition(value:uint):void { _timeTransition = value; }
		
		public function get content():Sprite { return _content; }	
		public function set content(value:Sprite):void { _content = value; }
		
		
		
		public function get width():int { return _width; }
		public function set width(value:int):void 
		{
			_width = value;
			_transition.width = _width;
			resize();
		}
		
		public function get height():int { return _heigth; }		
		public function set height(value:int):void 
		{
			_heigth = value;
			_transition.height = _heigth;
			resize();
		}
		
		public function size( width:int, height:int ):void
		{
			_width = width;
			_heigth = height;
			_transition.size( _width, _heigth );
			resize();
		}
		
		public function get eventDispatcher():EventDispatcher {	return _eventDispatcher; }
		
		protected function resize():void
		{
			if (_transition.content.bitmapData)
			{
				var img:Bitmap = new Bitmap( _transition.content.bitmapData );
				_transition.addPicture( moveAndResize( img ) );
			}
			if ( _listPictures )
			{
				if( _listPictures[_currentPicture].content ) _transition.addPicture( moveAndResize( _listPictures[_currentPicture].content as Bitmap ) );
			}
		}
		
		protected function refresh(e:Event = null):void
		{
			if ( getTimer() <= _timeToChange ) 	
			{
				_transition.value = 0;
			}
			else if ( getTimer() < _timeToChange + _timeTransition )
			{
				_transition.value = ( getTimer() - _timeToChange ) / _timeTransition;
			}
			else
			{
				_transition.value = 1;
				_content.removeEventListener( Event.ENTER_FRAME, refresh );
			}
			
		}
		
		protected function moveAndResize( target:Bitmap ):Bitmap
		{
			return new Bitmap( BitmapDataResizerBilinear.bilinearIterative( target.bitmapData, _width, _heigth, BitmapDataResizerBilinear.METHOD_LETTERBOX, false, 2 ) );
		}
	}
}
