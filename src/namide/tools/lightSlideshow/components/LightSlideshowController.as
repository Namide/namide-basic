package namide.tools.lightSlideshow.components 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightSlideshowController 
	{
		public static var PREVIEW:String = "preview";
		public static var NEXT:String = "next";
		public static var DOWNLOAD:String = "download";
		public static var PLAY:String = "play";
		public static var PAUSE:String = "pause";
		public static var MINIMIZE:String = "minimise";
		public static var MAXIMIZE:String = "maximise";
		public static var FULL_SCREEN:String = "full screen";
		public static var NORMAL_SCREEN:String = "normal screen";
		public static var LOADING:String = "loading";
		public static var CROSS:String = "cross";
		
		protected var _content:Sprite = new Sprite();
		
		protected var _buttonsName:Vector.<String>;
		protected var _buttonsSprite:Vector.<Sprite>;
		protected var _buttonsBitmap:Vector.<Bitmap>;
		protected var _buttonsVisibility:Vector.<Boolean>;
		
		protected var _margin:int = 2;
		protected var _scale:int = 2;
		
		protected var _width:int = 0;
		protected var _height:int = 0;
		
		protected var _color:uint = 0xFFFFFFFF;
		protected var _bgColor:uint = 0xAA000000;
		
		public function LightSlideshowController() 
		{
			_buttonsName = new Vector.<String>(0, false);
			_buttonsSprite = new Vector.<Sprite>(0, false);
			_buttonsBitmap = new Vector.<Bitmap>(0, false);
			_buttonsVisibility = new Vector.<Boolean>(0, false);
		}
		
		public function get content():Sprite { return _content; }
		
		public function get margin():int { return _margin; }
		public function set margin(value:int):void { _margin = value; }
		
		public function get width():int { return _width; }
		public function get height():int { return _height; }
		
		public function get color():uint { return _color; }		
		public function set color(value:uint):void 
		{
			_color = value;
			refresh();
		}
		
		public function get bgColor():uint { return _bgColor; }		
		public function set bgColor(value:uint):void 
		{
			_bgColor = value;
			refresh();
		}
		
		public function addButton( btnName:String ):void
		{
			addButtonAt( btnName, int.MAX_VALUE );
			/*var i:int = _buttonsName.indexOf( btnName );
			if (i > -1)
			{
				_buttonsName.splice( i, 1 );
				_buttonsSprite.splice( i, 1 );
				_buttonsBitmap.splice( i, 1 );
				_buttonsVisibility.splice( i, 1 );
			}
			
			var btnSprite:Sprite = new Sprite();
			var btnPixel:ButtonPixel = new ButtonPixel( btnName, _color, _bgColor );
			var btnBitmap:Bitmap = new Bitmap( btnPixel, "auto", false );
			btnBitmap.scaleX = _scale;
			btnBitmap.scaleY = _scale;
			btnSprite.addChild( btnBitmap );
			
			_buttonsName[_buttonsName.length] = btnName;
			_buttonsSprite[_buttonsSprite.length] = btnSprite;
			_buttonsBitmap[_buttonsBitmap.length] = btnBitmap;
			_buttonsVisibility[_buttonsVisibility.length] = true;
			
			_content.addChild( btnSprite );
			
			refresh();*/
		}
		
		public function addButtonAt( btnName:String, id:int ):void
		{
			var i:int = _buttonsName.indexOf( btnName );
			if (i > -1)
			{
				_buttonsName.splice( i, 1 );
				_buttonsSprite.splice( i, 1 );
				_buttonsBitmap.splice( i, 1 );
				_buttonsVisibility.splice( i, 1 );
			}
			
			var btnSprite:Sprite = new Sprite();
			var btnPixel:ButtonPixel = new ButtonPixel( btnName, _color, _bgColor );
			var btnBitmap:Bitmap = new Bitmap( btnPixel, "auto", false );
			btnBitmap.scaleX = _scale;
			btnBitmap.scaleY = _scale;
			btnSprite.addChild( btnBitmap );
			
			if (id > _buttonsName.length) id = _buttonsName.length;
			
			_buttonsName.splice(id, 0, btnName);
			_buttonsSprite.splice(id, 0, btnSprite);
			_buttonsBitmap.splice(id, 0, btnBitmap);
			_buttonsVisibility.splice(id, 0, true);
			
			/*_buttonsName[_buttonsName.length] = btnName;
			_buttonsSprite[_buttonsSprite.length] = btnSprite;
			_buttonsBitmap[_buttonsBitmap.length] = btnBitmap;
			_buttonsVisibility[_buttonsVisibility.length] = true;*/
			
			_content.addChildAt( btnSprite, (id>=0)?id:0 );
			
			refresh();
		}
		
		public function removeButton( btnName:String ):void
		{
			var i:int = _buttonsName.indexOf( btnName );
			if (i > -1)
			{
				_buttonsSprite[i].removeChild( _buttonsBitmap[i] );
				_content.removeChild( _buttonsSprite[i] );
				
				_buttonsName.splice( i, 1 );
				_buttonsSprite.splice( i, 1 );
				_buttonsBitmap[i].bitmapData.dispose();
				_buttonsBitmap.splice( i, 1 );
				_buttonsVisibility.splice( i, 1 );
			}
			
			refresh();
		}
		
		public function getButton( btnName:String ):Sprite
		{
			var i:int = _buttonsName.indexOf( btnName );
			if (i > -1)
			{
				return _buttonsSprite[i];
			}
			return null;
		}
		public function hide(btn:String):void
		{
			if ( _buttonsName.indexOf(btn) == -1 ) return void;
			
			_buttonsVisibility[_buttonsName.indexOf(btn)] = false;
			refresh();
		}
		public function show(btn:String):void
		{
			if ( _buttonsName.indexOf(btn) == -1 ) return void;
			
			_buttonsVisibility[_buttonsName.indexOf(btn)] = true;
			refresh();
		}
		
		public function refreshButton( btnName:String ):void
		{
			var i:int = _buttonsName.indexOf( btnName );
			if (i > -1)
			{
				var btnPixel:ButtonPixel = _buttonsBitmap[i].bitmapData as ButtonPixel;
				btnPixel.setButtonPixel( btnName, btnPixel.color, btnPixel.bgColor );
				_buttonsBitmap[i].bitmapData = btnPixel;
			}
		}
		
		protected function refresh():void
		{
			var i:int = -1;
			const l:int = _buttonsName.length;
			
			_width = 0;
			_height = 0;
			
			while ( ++i < l )
			{
				if ( _buttonsVisibility[i] )
				{
					if (!_width) _width = _margin;
					
					_buttonsSprite[i].visible = true;
					
					_buttonsSprite[i].x = _width;
					_buttonsSprite[i].y = _margin;
					
					_height = Math.max( _buttonsSprite[i].height + 2 * _margin, _height );
					_width += _buttonsSprite[i].width + _margin;
				}
				else
				{
					_buttonsSprite[i].visible = false;
				}
			}
			
		}
		
	}
	
}

import namide.tools.lightSlideshow.components.LightSlideshowController;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.getTimer;

internal class ButtonPixel extends BitmapData
{
	/*public static var PREVIEW:String = "preview";
	public static var NEXT:String = "next";
	public static var DOWNLOAD:String = "download";
	public static var PLAY:String = "play";
	public static var PAUSE:String = "pause";*/
	
	protected static const _PREVIEW_PATTERN:Vector.<uint> = Vector.<uint>([	0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000,
																			0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																			0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000	]);
											
	protected static const _NEXT_PATTERN:Vector.<uint> = Vector.<uint>([	0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000,
																			0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																			0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000	]);
											
	protected static const _PLAY_PATTERN:Vector.<uint> = Vector.<uint>([	0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000	]);
											
	protected static const _PAUSE_PATTERN:Vector.<uint> = Vector.<uint>([	0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000	]);
																
	protected static const _DOWNLOAD_PATTERN:Vector.<uint> = Vector.<uint>([	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
																				0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
																				0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
																				0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000,
																				0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000	]);
	
	protected static const _MINIMIZE_PATTERN:Vector.<uint> = Vector.<uint>([	0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
																				0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
																				0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
																				0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
																				0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000	]);
	
	protected static const _MAXIMIZE_PATTERN:Vector.<uint> = Vector.<uint>([	0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																				0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																				0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
																				0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																				0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000	]);
	
	protected static const _FULL_SCREEN:Vector.<uint> = Vector.<uint>([	0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
																		0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF,
																		0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF,
																		0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF,
																		0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF	]);
																				
	protected static const _NORMAL_SCREEN:Vector.<uint> = Vector.<uint>([	0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
																			0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
																			0xFFFFFFFF, 0x00000000, 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF,
																			0xFFFFFFFF, 0x00000000, 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF,
																			0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000	]);
	
	protected static const _CROSS_PATTERN:Vector.<uint> = Vector.<uint>([	0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0x00000000, 0x00000000, 0xFFFFFFFF, 0x00000000, 0x00000000,
																			0x00000000, 0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, 0x00000000,
																			0xFFFFFFFF, 0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF	]);
	
	protected static var _frame:int = 0;
	protected static function GET_LOADING( frame:int = -1 ):Vector.<uint>
	{
		if (frame == -1) frame = _frame;
		else _frame = frame;
		
		var i:int = 25;
		var listIndex:Vector.<int> = Vector.<int>([ 6, 7, 8, 13, 18, 17, 16, 11 ]);
		var iOK:int = listIndex[ (_frame++) % 8];
		var loading:Vector.<uint> = new Vector.<uint>( i, true );
		while (--i>-1)
		{
			loading[i] = ( i == iOK ) ? 0xFFFFFF : 0x000000;
		}
		return loading;
	}
	
	protected var _color:uint;
	protected var _bgColor:uint;
	protected var _style:Vector.<uint>;
	
	public function ButtonPixel( style:String = "", pColor:uint = 0xFFFFFFFF, pBgColor:uint = 0x55000000 )
	{
		super( 7 /** scaleX*/, 7 /** scaleY*/, true, 0x00000000 );
		if (style) setButtonPixel(style, pColor, pBgColor);
	}
	
	public function setButtonPixel( style:String, pColor:uint = 0xFFFFFFFF, pBgColor:uint = 0x55000000 ):void
	{
		_color = pColor;
		_bgColor = pBgColor;
		
		// adapt the color and background color
		fillRect( new Rectangle(0, 0, width, height), _bgColor );
		_style = getPattern( style ).concat();
		var i:int = _style.length;
		while ( --i > -1) _style[i] = ( _style[i] ) ? _color : _bgColor;
		
		refresh();
	}
	
	public function getPattern( name:String ):Vector.<uint>
	{
		var pattern:Vector.<uint>;
		
		switch( name )
		{
			case LightSlideshowController.PREVIEW : pattern = ButtonPixel._PREVIEW_PATTERN; break;
			case LightSlideshowController.DOWNLOAD : pattern = ButtonPixel._DOWNLOAD_PATTERN; break;
			case LightSlideshowController.PAUSE : pattern = ButtonPixel._PAUSE_PATTERN; break;
			case LightSlideshowController.PLAY : pattern = ButtonPixel._PLAY_PATTERN; break;
			case LightSlideshowController.NEXT : pattern = ButtonPixel._NEXT_PATTERN; break;
			case LightSlideshowController.MINIMIZE : pattern = ButtonPixel._MINIMIZE_PATTERN; break;
			case LightSlideshowController.MAXIMIZE : pattern = ButtonPixel._MAXIMIZE_PATTERN; break;
			case LightSlideshowController.FULL_SCREEN : pattern = ButtonPixel._FULL_SCREEN; break;
			case LightSlideshowController.NORMAL_SCREEN : pattern = ButtonPixel._NORMAL_SCREEN; break;
			case LightSlideshowController.LOADING : pattern = ButtonPixel.GET_LOADING(); break;
			case LightSlideshowController.CROSS : pattern = ButtonPixel._CROSS_PATTERN; break;
		}
		
		return pattern;
	}
	
	public function get color():uint { return _color; }
	public function set color(value:uint):void 
	{
		_color = value;
	}
	
	public function get bgColor():uint { return _bgColor; }
	public function set bgColor(value:uint):void 
	{
		_bgColor = value;
	}
	
	protected function refresh():void
	{
		setVector( new Rectangle( 1, 1, 5, 5 ), _style );
	}
}