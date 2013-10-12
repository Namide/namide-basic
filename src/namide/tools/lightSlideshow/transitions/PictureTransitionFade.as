package namide.tools.lightSlideshow.transitions 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class PictureTransitionFade implements PicturesTransition 
	{
		[Embed("shader/transitionFade.pbj", mimeType="application/octet-stream")]
		protected var _pbjTransitionFade:Class;
		protected var _shaderTransitionFade:Shader;
		protected var _shaderJob:ShaderJob;
		
		protected var _width:int;
		protected var _height:int;
		protected var _content:Bitmap;
		
		protected var _value:Number;
		
		protected var _picture1:Bitmap;
		protected var _picture2:Bitmap;
		
		public function PictureTransitionFade( w:int, h:int ) 
		{			
			_content = new Bitmap();
			
			_shaderTransitionFade = new Shader();
			_shaderTransitionFade.byteCode = new _pbjTransitionFade();
			width = w;
			height = h;
			
			_value = 0;
			
			
			initShader();
		}
		
		protected function initShader():void
		{
			if ( !_shaderTransitionFade.data.picture1.input || !_shaderTransitionFade.data.picture2.input ) return void;
			
			_content.bitmapData = new BitmapData( _width, _height, false, 0xFF0000 );
			
			_shaderTransitionFade.data.shaderSize.value = [_width, _height];
			_shaderTransitionFade.data.percent.value = [_value];
			refresh();
			
		}
		
		/* INTERFACE com.namide.dLib.display.advanced.slideshow.transitions.IDPicturesTransition */
		
		public function get content():Bitmap
		{
			return _content;
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
			_shaderTransitionFade.data.percent.value = [_value];
			refresh();
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function set width(value:int):void 
		{
			_width = value;
			initShader();
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function set height(value:int):void 
		{
			_height = value;
			initShader();
		}
		
		public function addPicture(pict:Bitmap):void 
		{
			if ( _picture2 )
			{
				_picture1 = new Bitmap( _content.bitmapData.clone() );
				_picture2 = pict;
			}
			else if ( _picture1 )
			{
				_picture2 = pict;
			}
			else
			{
				_picture1 = pict;
			}
			
			
			if ( _picture1 && _picture2 )
			{
				_shaderTransitionFade.data.picture1.input = _picture1.bitmapData;
				_shaderTransitionFade.data.picture1Position.value = [ _picture1.x, _picture1.y ];
				_shaderTransitionFade.data.picture1Scale.value = [ _picture1.scaleX, _picture1.scaleY ];
				
				_shaderTransitionFade.data.picture2.input = _picture2.bitmapData;
				_shaderTransitionFade.data.picture2Position.value = [ _picture2.x, _picture2.y ];
				_shaderTransitionFade.data.picture2Scale.value = [ _picture2.scaleX, _picture2.scaleY ];
				
				if ( !_content.bitmapData ) initShader();
				else refresh();
			}
			
		}
		
		public function getPictures():Vector.<Bitmap>
		{
			return Vector.<Bitmap>([ _picture1, _picture2 ]);
		}
		
		public function swapPictures():void 
		{
			
		}
		
		public function refresh():void 
		{
			//var myJob:ShaderJob = new ShaderJob(_shaderTransitionFade, _content.bitmapData);
			//myJob.start(true);
			_shaderJob = new ShaderJob(_shaderTransitionFade, _content.bitmapData);
			_shaderJob.start(true);
		}
		
	}

}