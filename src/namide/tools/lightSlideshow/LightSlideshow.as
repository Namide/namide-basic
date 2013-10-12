package namide.tools.lightSlideshow
{
	import namide.tools.lightSlideshow.components.LightshowThumbManager;
	import namide.tools.lightSlideshow.components.LightSlideshowController;
	import namide.tools.lightSlideshow.components.LightSlideshowEngine;
	import namide.tools.lightSlideshow.components.LightSlideshowLegend;
	import namide.tools.lightSlideshow.components.LightSlideshowPatchwork;
	import namide.tools.lightSlideshow.components.LightSlideshowPictureManager;
	import namide.tools.lightSlideshow.transitions.PictureTransitionFadeSimple;
	import namide.tools.lightSlideshow.transitions.PictureTransitionFadeSimple;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightSlideshow 
	{
		protected var _thumbsManader:LightshowThumbManager;
		protected var _eventDispatcher:EventDispatcher;
		
		protected var _width:int = 512;
		protected var _height:int = 512;
		
		protected var _downloadEnabled:Boolean = true;
		protected var _fullScreenEnabled:Boolean = true;
		protected var _exitEnabled:Boolean = true;
		protected var _legendEnabled:Boolean = true;
		protected var _timelineEnabled:Boolean = true;
		
		protected var _pictureManager:LightSlideshowPictureManager;
		protected var _content:Sprite;
		
		protected var _slideshow:LightSlideshowEngine;
		protected var _controler:LightSlideshowController;
		protected var _legendControler:LightSlideshowController;
		protected var _legendComment:LightSlideshowLegend;
		protected var _legendNumber:LightSlideshowLegend;
		protected var _softwareHead:LightSlideshowController;
		protected var _percentLoaded:LightSlideshowLegend;
		protected var _timeline:LightSlideshowPatchwork;
		protected var _roll:LightSlideshowPatchwork;
		
		protected var _rollX:int;
		
		
		protected var _legendVisible:Boolean = true;
		protected var _loadSetInterval:int;
		
		public static const CLICK_EXIT:String = "close";
		
		public function LightSlideshow( params:Object = null ) 
		{
			var transition:PictureTransitionFadeSimple = new PictureTransitionFadeSimple( 100, 100 );
			
			_slideshow = new LightSlideshowEngine( transition );
			_eventDispatcher = new EventDispatcher();
			
			if ( params ) initParams( params );
			
			_content = new Sprite();
			_content.addChild( _slideshow.content );
			
			initControler();
			initSoftwareHead();
			initLegend();
			
			onResize();
			
			_content.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
		}
		
		
		//----------------------------------------
		//
		//		GETTERS AND SETTERS
		//
		//----------------------------------------
		
		public function get content():Sprite { return _content; }
		
		public function get width():int { return _width; }
		public function set width(value:int):void 
		{
			_width = value;
			onResize();
		}
		
		public function get height():int { return _height; }
		public function set height(value:int):void 
		{
			_height = value;
			onResize();
		}
		
		public function get eventDispatcher():EventDispatcher { return _eventDispatcher; }
		
		public function get downloadEnabled():Boolean { return _downloadEnabled; }
		public function set downloadEnabled(value:Boolean):void 
		{
			_downloadEnabled = value;
			if ( _downloadEnabled && _controler.getButton( LightSlideshowController.DOWNLOAD ) == null )
			{
				_controler.addButtonAt( LightSlideshowController.DOWNLOAD, 0 );
				_controler.getButton( LightSlideshowController.DOWNLOAD ).addEventListener(MouseEvent.CLICK, downloadCurrentPicture );
				_controler.getButton( LightSlideshowController.DOWNLOAD ).buttonMode = true;
			}
			else if( !_downloadEnabled && _controler.getButton(LightSlideshowController.DOWNLOAD ) )
			{
				_controler.getButton( LightSlideshowController.DOWNLOAD ).removeEventListener( MouseEvent.CLICK, downloadCurrentPicture );
				_controler.removeButton( LightSlideshowController.DOWNLOAD );
			}
		}
		
		public function get fullScreenEnabled():Boolean { return _fullScreenEnabled; }
		public function set fullScreenEnabled(value:Boolean):void 
		{
			_fullScreenEnabled = value;
			if ( _fullScreenEnabled && _softwareHead.getButton( LightSlideshowController.NORMAL_SCREEN ) == null )
			{
				_softwareHead.addButtonAt( LightSlideshowController.NORMAL_SCREEN, 1 );
				_softwareHead.addButtonAt( LightSlideshowController.FULL_SCREEN, 1 );
				
				_softwareHead.getButton( LightSlideshowController.NORMAL_SCREEN ).addEventListener(MouseEvent.CLICK, changeScreen );
				_softwareHead.getButton( LightSlideshowController.FULL_SCREEN ).addEventListener(MouseEvent.CLICK, changeScreen );
				_softwareHead.getButton( LightSlideshowController.NORMAL_SCREEN ).buttonMode = true;
				_softwareHead.getButton( LightSlideshowController.FULL_SCREEN ).buttonMode = true;
			}
			else if( !_fullScreenEnabled && _softwareHead.getButton(LightSlideshowController.NORMAL_SCREEN ) )
			{
				_softwareHead.getButton( LightSlideshowController.NORMAL_SCREEN ).removeEventListener( MouseEvent.CLICK, changeScreen );
				_softwareHead.getButton( LightSlideshowController.FULL_SCREEN ).removeEventListener( MouseEvent.CLICK, changeScreen );
				_softwareHead.removeButton( LightSlideshowController.NORMAL_SCREEN );
				_softwareHead.removeButton( LightSlideshowController.FULL_SCREEN );
			}
			
		}
		
		public function get exitEnabled():Boolean { return _exitEnabled; }
		public function set exitEnabled(value:Boolean):void 
		{
			_exitEnabled = value;
			if ( _exitEnabled && _softwareHead.getButton( LightSlideshowController.CROSS ) == null )
			{
				_softwareHead.addButtonAt( LightSlideshowController.CROSS, 2 );
				_softwareHead.getButton( LightSlideshowController.CROSS ).addEventListener(MouseEvent.CLICK, closeSlideshow );
				_softwareHead.getButton( LightSlideshowController.CROSS ).buttonMode = true;
			}
			else if( !_exitEnabled && _controler.getButton(LightSlideshowController.DOWNLOAD ) )
			{
				_softwareHead.getButton( LightSlideshowController.CROSS ).removeEventListener( MouseEvent.CLICK, closeSlideshow );
				_softwareHead.removeButton( LightSlideshowController.CROSS );
			}
		}
		
		public function get legendEnabled():Boolean { return _legendEnabled; }
		public function set legendEnabled(value:Boolean):void 
		{
			_legendEnabled = value;
			if ( _legendEnabled && _legendComment == null )
			{
				_legendComment = new LightSlideshowLegend();
				_legendComment.color = _controler.color;
				_legendComment.bgColor = _controler.bgColor;
				_legendComment.width = 250;
				_content.addChild( _legendComment.content );
				refreshLegend();
			}
			else if( !_legendEnabled && _legendComment )
			{
				_legendComment.content.parent.removeChild( _legendComment.content );
				_legendComment = null;
			}
		}
		
		public function get timelineEnabled():Boolean { return _timelineEnabled; }
		public function set timelineEnabled(value:Boolean):void 
		{
			_timelineEnabled = value;
			
			if ( _timelineEnabled && _timeline == null )
			{
				initTimeline();
			}
			else if ( !_timelineEnabled && _timeline )
			{
				_timeline.content.removeEventListener( MouseEvent.MOUSE_MOVE, onSeekbarMove );
				_timeline.content.removeEventListener( MouseEvent.MOUSE_OVER, onSeekbarOver );
				_timeline.content.removeEventListener( MouseEvent.MOUSE_OUT, onSeekbarOut );
				_timeline.content.removeEventListener( MouseEvent.CLICK, onSeekbarClick );
				
				_roll.content.removeEventListener( Event.ENTER_FRAME, onRollEnterFrame );
				
				_content.removeChild( _timeline.content );
				_content.removeChild( _roll.content );
				
				_timeline = null;
				_roll = null;
			}
		}
		
		
		
		//----------------------------------------
		//
		//		ADVANCED SETTERS
		//
		//----------------------------------------
		
		public function setPicturesByXML( xml:XML ):void
		{
			_pictureManager = new LightSlideshowPictureManager();
			_pictureManager.initPicturesByXML( xml );
			_slideshow.setPicturesByURL( _pictureManager.getListData("url") );
			
			_thumbsManader = new LightshowThumbManager();
			_thumbsManader.setPicturesByURL( _pictureManager.getListData("thumb") );
			
			initTimeline();
			
			onResize();
		}
		
		
		
		public function size( width:int, height:int ):void
		{
			_width = width;
			_height = height;
			onResize();
		}
		
		
		//----------------------------------------
		//
		//		PRIVATE CREATION FUNCTIONS
		//
		//----------------------------------------
		
		protected function initParams( params:Object ):void
		{
			for ( var key:String in params )
			{
				this[key] = params[key];
			}
		}
		
		protected function initTimeline():void
		{
			if ( !_timelineEnabled ) return void;
			
			_timeline = new LightSlideshowPatchwork();
			_timeline.height = _controler.height - 2 * _controler.margin;
			_timeline.width = 800;
			_timeline.margin = int( (_timeline.height - 4) * 0.5 );
			_timeline.bgColor = _controler.bgColor;
			_timeline.color = _controler.color;
			_timeline.setByListLoader( _thumbsManader.getListThumbs() );
			_timeline.content.addEventListener( MouseEvent.MOUSE_MOVE, onSeekbarMove );
			_timeline.content.addEventListener( MouseEvent.MOUSE_OVER, onSeekbarOver );
			_timeline.content.addEventListener( MouseEvent.MOUSE_OUT, onSeekbarOut );
			_timeline.content.addEventListener( MouseEvent.CLICK, onSeekbarClick );
			
			_roll = new LightSlideshowPatchwork();
			_roll.margin = _controler.margin;
			_roll.height = 64 + 2 * _roll.margin;
			_roll.bgColor = _controler.bgColor;
			_roll.color = _controler.color;
			_roll.content.visible = false;
			_roll.setByListLoader( _thumbsManader.getListThumbs() );
			_roll.content.addEventListener( Event.ENTER_FRAME, onRollEnterFrame );
			
			_content.addChild( _timeline.content );
			_content.addChildAt( _roll.content, 1 );
		}
		
		protected function initLegend():void
		{
			_legendControler = new LightSlideshowController();
			_legendControler.color = _controler.color;
			_legendControler.bgColor = _controler.bgColor;
			_legendControler.addButton( LightSlideshowController.MINIMIZE );
			_legendControler.addButton( LightSlideshowController.MAXIMIZE );
			
			_legendControler.getButton( LightSlideshowController.MINIMIZE ).addEventListener( MouseEvent.CLICK, hideLegend, false, 0, true );
			_legendControler.getButton( LightSlideshowController.MAXIMIZE ).addEventListener( MouseEvent.CLICK, showLegend, false, 0, true );
			
			if (_legendEnabled)
			{
				_legendComment = new LightSlideshowLegend();
				_legendComment.color = _controler.color;
				_legendComment.bgColor = _controler.bgColor;
				_legendComment.width = 250;
				_legendComment.changeText( Math.random() + " " + _slideshow.currentPicture, true );
			}
			
			_legendNumber = new LightSlideshowLegend();
			_legendNumber.color = _controler.color;
			_legendNumber.bgColor = _controler.bgColor;
			_legendNumber.format.size = 10;
			_legendNumber.height = _controler.height - ( 2 * _controler.margin );
			
			_slideshow.eventDispatcher.addEventListener( LightSlideshowEngine.PICTURE_CHANGE, refreshLegend, false, 0, true );
			
			_content.addChild( _legendControler.content );
			_content.addChild( _legendComment.content );
			_content.addChild( _legendNumber.content );
		}
		
		protected function initControler():void
		{
			_controler = new LightSlideshowController();
			_controler.color = 0xFF000000;
			_controler.bgColor = 0xCCFFFFFF;
			
			if(_downloadEnabled) _controler.addButton( LightSlideshowController.DOWNLOAD );
			_controler.addButton( LightSlideshowController.PREVIEW );
			_controler.addButton( LightSlideshowController.PAUSE );
			_controler.addButton( LightSlideshowController.PLAY );
			_controler.addButton( LightSlideshowController.NEXT );
			
			_controler.getButton( LightSlideshowController.PREVIEW ).addEventListener( MouseEvent.CLICK, _slideshow.prev );
			_controler.getButton( LightSlideshowController.PREVIEW ).buttonMode = true;
			if (_downloadEnabled)
			{
				_controler.getButton( LightSlideshowController.DOWNLOAD ).addEventListener(MouseEvent.CLICK, downloadCurrentPicture );
				_controler.getButton( LightSlideshowController.DOWNLOAD ).buttonMode = true;
			}
			_controler.getButton( LightSlideshowController.PAUSE ).addEventListener(MouseEvent.CLICK, _slideshow.pause );
			_controler.getButton( LightSlideshowController.PAUSE ).buttonMode = true;
			_controler.getButton( LightSlideshowController.PLAY ).addEventListener(MouseEvent.CLICK, _slideshow.play );
			_controler.getButton( LightSlideshowController.PLAY ).buttonMode = true;
			_controler.getButton( LightSlideshowController.NEXT ).addEventListener(MouseEvent.CLICK, _slideshow.next );
			_controler.getButton( LightSlideshowController.NEXT ).buttonMode = true;
			_slideshow.eventDispatcher.addEventListener( LightSlideshowEngine.PLAYED_CHANGE, refreshControler, false, 0, true );
			_slideshow.eventDispatcher.addEventListener( LightSlideshowEngine.PICTURE_START_LOAD, onStartLoadingPicture, false, 0, true );
			_slideshow.eventDispatcher.addEventListener( LightSlideshowEngine.PICTURE_LOADED, onStopLoadingPicture, false, 0, true );
			_slideshow.eventDispatcher.addEventListener( LightSlideshowEngine.PICTURE_PROGRESS_LOAD, onChangeLoadingPicture, false, 0, true );
			
			_content.addChild( _controler.content );
		}
		
		protected function initSoftwareHead():void
		{
			_softwareHead = new LightSlideshowController();
			_softwareHead.color = _controler.color;
			_softwareHead.bgColor = _controler.bgColor;
			_softwareHead.addButton( LightSlideshowController.LOADING );
			if ( _fullScreenEnabled )
			{
				_softwareHead.addButton( LightSlideshowController.NORMAL_SCREEN );
				_softwareHead.addButton( LightSlideshowController.FULL_SCREEN );
			}
			if ( _exitEnabled )
			{
				_softwareHead.addButton( LightSlideshowController.CROSS );
			}
			if ( _fullScreenEnabled )
			{
				_softwareHead.getButton( LightSlideshowController.NORMAL_SCREEN ).addEventListener(MouseEvent.CLICK, changeScreen );
				_softwareHead.getButton( LightSlideshowController.NORMAL_SCREEN ).buttonMode = true;
				_softwareHead.getButton( LightSlideshowController.FULL_SCREEN ).addEventListener(MouseEvent.CLICK, changeScreen );
				_softwareHead.getButton( LightSlideshowController.FULL_SCREEN ).buttonMode = true;
			}
			if ( _exitEnabled )
			{
				_softwareHead.getButton( LightSlideshowController.CROSS ).addEventListener( MouseEvent.CLICK, closeSlideshow );
				_softwareHead.getButton( LightSlideshowController.CROSS ).buttonMode = true;
			}
			
			_percentLoaded = new LightSlideshowLegend();
			_percentLoaded.color = _controler.color;
			_percentLoaded.bgColor = _controler.bgColor;
			_percentLoaded.format.size = 10;
			_percentLoaded.height = _controler.height - ( 2 * _controler.margin );
			
			_content.addChild( _softwareHead.content );
			_content.addChild( _percentLoaded.content );
		}
		
		
		//----------------------------------------
		//
		//		PRIVATE FUNCTIONS
		//
		//----------------------------------------
		
		
		public function changeScreen(event:Event = null):void
		{
			if ( !_fullScreenEnabled ) return void;
			
			if (_content.stage.displayState == StageDisplayState.NORMAL)
			{
				try
				{
					_content.stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				catch (e:SecurityError)
				{
					//if you don't complete STEP TWO below, you will get this SecurityError
					trace("an error has occured. please modify the html file to allow fullscreen mode");
				}
			}
			else
			{
				_content.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function downloadCurrentPicture(e:Event = null):void
		{
			var id:int = _pictureManager.getIndexByData( "url", _slideshow.currentURL );
			navigateToURL( new URLRequest( _pictureManager.getData( id, "download" ) ), "_blank" );
		}
		
		private function refreshControler(e:Event = null):void
		{
			if (_slideshow.played)
			{
				_controler.show( LightSlideshowController.PAUSE );
				_controler.hide( LightSlideshowController.PLAY );
			}
			else
			{
				_controler.show( LightSlideshowController.PLAY );
				_controler.hide( LightSlideshowController.PAUSE );
			}
			
			if (_content && _content.stage )
			{
				if( _content.stage.displayState == StageDisplayState.FULL_SCREEN )
				{
					_softwareHead.show( LightSlideshowController.NORMAL_SCREEN );
					_softwareHead.hide( LightSlideshowController.FULL_SCREEN );
				}
				else
				{
					_softwareHead.show( LightSlideshowController.FULL_SCREEN );
					_softwareHead.hide( LightSlideshowController.NORMAL_SCREEN );
				}
			}
			
			_softwareHead.content.x = _width - _softwareHead.width;
			
			_controler.content.x = _width - _controler.width;
			_controler.content.y = _height - _controler.height;
			
			_percentLoaded.content.y = _controler.margin;
			_percentLoaded.content.x = _softwareHead.content.x - _percentLoaded.content.width;
		}
		
		protected function showLegend(e:Event = null):void
		{
			_legendVisible = true;
			refreshLegend();
		}
		protected function hideLegend(e:Event = null):void
		{
			_legendVisible = false;
			refreshLegend();
		}
		private function refreshLegend(e:Event = null):void
		{
			
			if (_legendVisible) 
			{
				_legendControler.show(LightSlideshowController.MINIMIZE);
				_legendControler.hide(LightSlideshowController.MAXIMIZE);
			}
			else
			{
				_legendControler.show(LightSlideshowController.MAXIMIZE);
				_legendControler.hide(LightSlideshowController.MINIMIZE);
			}
			
			_legendControler.content.x = 0;
			_legendControler.content.y = _height - _controler.height;
			
			if (_pictureManager && _legendComment)
			{
				var id:int = _pictureManager.getIndexByData( "url", _slideshow.currentURL );
				var textLegend:String = _pictureManager.getData( id, "legend" );
				if (!textLegend) textLegend = "";
				
				_legendComment.changeText( textLegend, true );
				_legendComment.content.x = _legendControler.margin;
				_legendComment.content.y = _legendControler.content.y - (_legendComment.content.height);
				
				if (_legendVisible) _legendComment.content.visible = true;
				else				_legendComment.content.visible = false;
			
			}
			
			
			
			// Number Legend
			
			if (_legendNumber)
			{
				_legendNumber.changeText( "<b>" + String(_slideshow.currentPicture + 1) + "/" + String(_slideshow.totalPictures) + "</b>", false );
			
				_legendNumber.content.x = _legendControler.width;
				_legendNumber.content.y = _legendControler.content.y + _legendControler.margin;
				
			}
			
			if (_content && _timeline)
			{
				_timeline.content.x = (_legendVisible) ? (_legendNumber.content.x + _legendNumber.content.width + _legendNumber.margin) : (_legendControler.content.x + _legendControler.content.width + 2 * _legendControler.margin );
				
				_timeline.content.y = _legendNumber.content.y;
				_timeline.width = _controler.content.x - _timeline.content.x;
				
				_timeline.selected = _slideshow.currentPicture;
			}
			
			if (_content && _timeline)
			{
				_roll.content.y = _timeline.content.y - (_roll.height + _controler.margin);
			}
			
			if (_legendVisible) _legendNumber.content.visible = true;
			else				_legendNumber.content.visible = false;
			
		}
		
		protected function closeSlideshow( e:Event = null ):void
		{
			while ( _content.numChildren > 0 ) _content.removeChild( _content.getChildAt(0) );
			_eventDispatcher.dispatchEvent( new Event(LightSlideshow.CLICK_EXIT) );
		}
		
		//----------------------------------------
		//
		//		HANDLERS EVENTS
		//
		//----------------------------------------
		
		protected function onAddedToStage(e:Event):void
		{
			_content.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_content.stage.focus = _content.stage;
			_content.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if (e.keyCode == 37) _slideshow.prev();
			if (e.keyCode == 39) _slideshow.next();
			if (e.keyCode == 32) _slideshow.playPause();
			if (e.keyCode == 70) changeScreen();
			
		}
		
		private function onRollEnterFrame(e:Event):void 
		{
			if (_roll.content.visible)
			{
				_roll.selected = _timeline.getRatioXtoIndexPicture( _timeline.content.mouseX / _timeline.content.width );
				
				var margin:int;
				_content.stage.stageWidth * 0.5 - _roll.getXbyID( _timeline.getRatioXtoIndexPicture( _timeline.content.mouseX / _timeline.content.width ) );
				_roll.content.x += (_rollX - _roll.content.x) * 0.5
			}
		}
		
		protected function onSeekbarOver( e:Event ):void
		{
			_roll.content.visible = true;
			onSeekbarMove(e);
		}
		protected function onSeekbarOut( e:Event ):void
		{
			_roll.content.visible = false;
		}
		protected function onSeekbarMove( e:Event = null ):void
		{
			_roll.selected = _timeline.getRatioXtoIndexPicture( _timeline.content.mouseX / _timeline.content.width );
			_rollX = _content.stage.stageWidth * 0.5 - _roll.getXbyID( _timeline.getRatioXtoIndexPicture( _timeline.content.mouseX / _timeline.content.width ) );
		}
		protected function onSeekbarClick( e:Event ):void
		{
			_slideshow.go( _timeline.getRatioXtoIndexPicture( _timeline.content.mouseX / _timeline.content.width ) );
		}
		
		protected function onStartLoadingPicture(e:Event = null):void
		{
			_softwareHead.show( LightSlideshowController.LOADING );
			_percentLoaded.content.visible = true;
			
			_percentLoaded.changeText( "<b>0%</b>", false );
			
			if (_softwareHead.content) refreshControler();
			
			clearInterval( _loadSetInterval );
			_loadSetInterval = setInterval( _softwareHead.refreshButton, 250, LightSlideshowController.LOADING );
		}
		protected function onChangeLoadingPicture(e:ProgressEvent = null):void
		{
			if ( e.bytesLoaded > e.bytesTotal )
				_percentLoaded.changeText( "<b>?%<b>", false );
			else if ( isFinite( e.bytesLoaded / e.bytesTotal ) )
				_percentLoaded.changeText( "<b>" + Math.round( 100 * e.bytesLoaded / e.bytesTotal ) + "%</b>", false );
			else
				_percentLoaded.changeText( "<b>0%<b>", false );
			
			refreshControler();
		}
		protected function onStopLoadingPicture(e:Event = null):void
		{
			_softwareHead.hide( LightSlideshowController.LOADING );
			_percentLoaded.content.visible = false;
			
			if (_softwareHead.content) refreshControler();
			clearInterval( _loadSetInterval );
		}
		
		protected function onResize(e:Event = null):void
		{
			_slideshow.size( _width, _height );
			if (_controler.content) refreshControler();
			if (_legendControler.content) refreshLegend();
			
		}
	}

}