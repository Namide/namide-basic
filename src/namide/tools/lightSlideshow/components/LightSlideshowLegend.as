package namide.tools.lightSlideshow.components 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightSlideshowLegend 
	{
		protected var _format:TextFormat;
		protected var _color:uint = 0xFFFFFF;
		protected var _bgColor:uint = 0x000000;
		
		protected var _margin:int = 2;
		
		protected var _content:Sprite;
		protected var _bgUI:Shape;
		protected var _textUI:TextField;
		
		protected var _width:int = 0;
		protected var _height:int = 0;
		
		public function LightSlideshowLegend() 
		{
			_content = new Sprite();
			_textUI = new TextField();
			
			_format = new TextFormat( "Verdana" );
			
			_content.addChild(_textUI);
		}
		
		public function changeText( text:String, multiligne:Boolean = true ):void
		{
			const margLeftRight:int = 2;
			
			_textUI.multiline = multiligne;
			_textUI.wordWrap = multiligne;
			
			_textUI.htmlText = text;
			
			_textUI.textColor = _color & 0xFFFFFF;
			_textUI.alpha = ( ( (_color >> 0xFFFFFF) & 0xFF ) ? ( (_color >> 24) & 0xFF ) / 0xFF : 1);
			_textUI.setTextFormat(_format);
			
			if ( _width ) _textUI.width = _width - 2 * margLeftRight;
			if ( _height ) _textUI.height = _height;
			
			_textUI.autoSize = TextFieldAutoSize.LEFT;
			
			_textUI.x = ( _width && (_textUI.width+2*margLeftRight) > _width ) ? Math.round( (_width - _textUI.width) * 0.5 ) : margLeftRight;
			_textUI.y = ( _height && (_textUI.height) > _height ) ? Math.round( (_height - _textUI.height) * 0.5 ) : 0;
			
			_content.graphics.clear();
			_content.graphics.beginFill( _bgColor & 0xFFFFFF, ( ( (_bgColor >> 0xFFFFFF) & 0xFF ) ? ( (_bgColor >> 24) & 0xFF ) / 0xFF : 1) );
			_content.graphics.drawRect(0, 0, (_width)?_width:_textUI.width+2*margLeftRight, (_height)?_height:_textUI.height );
			
		}
		
		protected function refresh():void
		{
			changeText( _textUI.text, _textUI.multiline );
		}
		
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
		
		public function get margin():int { return _margin; }
		public function set margin(value:int):void
		{
			_margin = value;
			refresh();
		}
		
		public function get width():int { return _width; }
		public function set width(value:int):void {	_width = value;	}
		
		public function get height():int { return _height; }
		public function set height(value:int):void { _height = value; }
		
		public function get content():Sprite { return _content; }
		
		public function get format():TextFormat { return _format; }
		public function set format(value:TextFormat):void { _format = value; }
		
		
	}

}