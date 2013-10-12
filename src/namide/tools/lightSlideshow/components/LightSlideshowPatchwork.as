package namide.tools.lightSlideshow.components 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightSlideshowPatchwork 
	{
		protected var _eventDispatcher:EventDispatcher;
		
		protected var _patchworkBD:Vector.<BitmapData>;
		protected var _patchworkB:Vector.<Bitmap>;
		protected var _content:Sprite;
		
		protected var _picturesList:Vector.<Loader>;
		//protected var _picturesWidth:Vector.<Number>;
		
		public static const PICTURE_LOADED:String = "picture loaded";
		public static const ALL_PICTURES_LOADED:String = "all pictures loaded";
		
		protected var _margin:int;
		protected var _width:int;
		protected var _height:int;
		
		protected var _bgColor:uint;
		protected var _color:uint;
		
		protected var _selected:int;
		
		public function LightSlideshowPatchwork() 
		{
			_selected = -1;
			_height = 256;
			_content = new Sprite();
			_color = 0xFFFFFF;
			_bgColor = 0xFF000000;
		}
		
		public function refresh( num:int = -1 ):void
		{
			if (!_picturesList) return void;
			
			if (num == -1)
			{
				initContent();
				return void;
			}
			
			_content.graphics.clear();
			
			var loaded:Boolean;
			var scaleX:Number, scaleY:Number;
			var posX:Number = (num == 0) ? _margin : ( _patchworkB[num-1].x + _patchworkB[num-1].width );
			var i:int = num;//_picturesList.length;
			var m:Matrix;
			var w:int, h:int;
			const l:int = _picturesList.length;
			
			const widthThumb:Number = (_width) ? ( ( (_width - 2 * _margin) / _picturesList.length) ) : 0;
			
			
			// Picture to change
				
				loaded = ( _picturesList[i].content != null );
				if (_patchworkB[i])
				{
					_patchworkBD[i].dispose();
					_content.removeChild( _patchworkB[i] );
				}
				if (loaded)
				{
					scaleY = (_height - 2 * _margin) / _picturesList[i].height;
					scaleX = (widthThumb) ? (widthThumb / _picturesList[i].width) : scaleY;
					
					w = (widthThumb) ? widthThumb : (_picturesList[i].content.width * scaleX);
					h = (_height - 2 * _margin);
					
					if (w < 1) w = 1;
					if (h < 1) h = 1;
					
					_patchworkBD[i] = new BitmapData( 	w, h, true, _bgColor );
					
					m = new Matrix();
					m.createBox( scaleX, scaleY );
					_patchworkBD[i].draw( _picturesList[i].content, m );
					_patchworkB[i] = new Bitmap( _patchworkBD[i] );
				}
				else
				{
					_patchworkBD[i] = new BitmapData( 1, 1, true, _bgColor );
					_patchworkB[i] = new Bitmap( _patchworkBD[i] );
					_patchworkB[i].width = (widthThumb) ? widthThumb : (_height - 2 * _margin);
					_patchworkB[i].height = (_height - 2 * _margin);
				}
				
				_patchworkB[i].x = posX;
				_patchworkB[i].y = _margin;
				posX += _patchworkB[i].width;
				_content.addChild( _patchworkB[i] );
				
				if (_selected > -1 && _selected != i ) _patchworkB[i].alpha = 0.75;
				
				
			// next pictures
			while ( ++i < l )
			{
				_patchworkB[i].x = posX;
				_patchworkB[i].y = _margin;
				posX += _patchworkB[i].width;
				//_content.addChild( _patchworkB[i] );
				//if (_selected > -1 && _selected != i ) _patchworkB[i].alpha = 0.5;
			}
			
			_content.graphics.beginFill( getBgColor16(), getBgAlpha() );
			//_content.graphics.drawRect( 0, 0, (_width) ? _width : (posX + _margin), _height );
			_content.graphics.drawRect( 0, 0, posX + _margin, _height );
			if (_selected > -1)	
			{
				_content.graphics.beginFill( getColor(), getColorAlpha() );
				_content.graphics.drawRect( _patchworkB[_selected].x, 0, _patchworkB[_selected].width, _height );
			}
			
			if (_width) _content.width = _width;
			
		}
		
		protected function initContent():void
		{
			_content.graphics.clear();
			
			var loaded:Boolean;
			var scaleX:Number, scaleY:Number;
			var posX:Number = _margin;
			var i:int = -1;//_picturesList.length;
			var m:Matrix;
			var w:int, h:int;
			const l:int = _picturesList.length;
			
			const widthThumb:Number = (_width) ? ( ( (_width - 2 * _margin) / _picturesList.length) ) : 0;
			
			while ( ++i < l )
			{
				loaded = ( _picturesList[i].content != null );
				
				if (_patchworkB[i])
				{
					_patchworkBD[i].dispose();
					_content.removeChild( _patchworkB[i] );
				}
				
				if (loaded)
				{
					scaleY = (_height - 2 * _margin) / _picturesList[i].height;
					scaleX = (widthThumb) ? (widthThumb / _picturesList[i].width) : scaleY;
					
					w = (widthThumb) ? widthThumb : (_picturesList[i].content.width * scaleX);
					h = (_height - 2 * _margin);
					
					if (w < 1) w = 1;
					if (h < 1) h = 1;
					
					_patchworkBD[i] = new BitmapData( 	w, h, true, _bgColor );
					
					m = new Matrix();
					m.createBox( scaleX, scaleY );
					_patchworkBD[i].draw( _picturesList[i].content, m );
					_patchworkB[i] = new Bitmap( _patchworkBD[i] );
					
				}
				else
				{
					_patchworkBD[i] = new BitmapData( 1, 1, true, _bgColor );
					_patchworkB[i] = new Bitmap( _patchworkBD[i] );
					_patchworkB[i].width = (widthThumb) ? widthThumb : (_height - 2 * _margin);
					_patchworkB[i].height = (_height - 2 * _margin);
				}
				
				_patchworkB[i].x = posX;
				_patchworkB[i].y = _margin;
				posX += _patchworkB[i].width;
				_content.addChild( _patchworkB[i] );
				
				if (_selected > -1 && _selected != i ) _patchworkB[i].alpha = 0.75;
			}
			
			_content.graphics.beginFill( getBgColor16(), getBgAlpha() );
			//_content.graphics.drawRect( 0, 0, (_width) ? _width : (posX + _margin), _height );
			_content.graphics.drawRect( 0, 0, posX + _margin, _height );
			
			if (_selected > -1)	
			{
				_content.graphics.beginFill( getColor(), getColorAlpha() );
				_content.graphics.drawRect( _patchworkB[_selected].x, 0, _patchworkB[_selected].width, _height );
			}
			if (_width) _content.width = _width;
			
			/*if (_selected > -1)
			{
				_content.graphics.beginFill( _color, 1 );
				_content.graphics.drawRect( _patchworkB[_selected].x - _margin,
											0,
											_patchworkB[_selected].width + 2 * _margin,
											_height );
			}*/
		}
		
		
		
		public function setByListLoader( listURL:Vector.<Loader> ):void
		{
			var i:int = listURL.length;
			
			//_picturesWidth = new Vector.<Number>( i, true );
			_patchworkBD = new Vector.<BitmapData>( i, true );
			_patchworkB = new Vector.<Bitmap>( i, true );
			_picturesList = listURL;
			
			while ( --i > -1 )
			{
				_picturesList[i].contentLoaderInfo.addEventListener( Event.COMPLETE, onThumbLoaded );
			}
			
			initContent();
		}
		
		
		protected function onThumbLoaded( e:Event ):void
		{
			refresh( _picturesList.indexOf( (e.target as LoaderInfo).loader ) );
		}
		
		public function getTotalPictures():int { return _picturesList.length; }
		
		public function getXbyID( id:int ):Number
		{
			return _patchworkB[id].x + _patchworkB[id].width * 0.5;
		}
		
		public function getRatioXtoIndexPicture( x:Number ):int
		{
			var id:int = _patchworkB.length-1;
			
			var i:int = _patchworkB.length;
			while ( --i > -1)
			{
				if ( x < _patchworkB[i].x / _width ) id = i - 1;
				else break;
			}
			
			if (id < 0) id = 0;
			if (id > _patchworkB.length - 1) id = _patchworkB.length - 1;
			
			return id;
		}
		
		public function get eventDispatcher():EventDispatcher { return _eventDispatcher; }
		
		public function get width():int { return _width; }
		public function set width(value:int):void { _width = value; refresh(); }
		
		public function get height():int { return _height; }
		public function set height(value:int):void { _height = value; refresh(); }
		
		public function get content():Sprite { return _content; }
		
		public function get margin():int { return _margin; }
		public function set margin(value:int):void { _margin = value; refresh(); }
		
		public function get bgColor():uint { return _bgColor; }
		public function set bgColor(value:uint):void { _bgColor = value; refresh(); }
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void { _color = value; refresh(); }
		
		
		public function get selected():int { return _selected; }
		public function set selected(value:int):void 
		{
			_selected = value;
			refresh();
		}
		
		protected function getBgAlpha():Number { return uint( ( _bgColor >> 24 ) & 0xFF ) / 0xFF; }
		protected function getBgColor16():uint { return uint( _bgColor & 0xFFFFFF ); }
		
		private function getColorAlpha():Number { return uint( ( _color >> 24 ) & 0xFF ) / 0xFF; }
		private function getColor():uint { return uint( _color & 0xFFFFFF ); }
		
	}

}