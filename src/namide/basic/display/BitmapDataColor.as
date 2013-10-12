package namide.basic.display 
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author namide.com
	 */
	public class BitmapDataColor 
	{
		protected var _content:BitmapData;
		
		public function BitmapDataColor( picture:BitmapData ) 
		{
			_content = picture;
		}
		
		/**
		 * Bitmap data to modified
		 */
		public function set content(picture:BitmapData):void { _content = picture; }
		public function get content():BitmapData { return _content; }
		
		/**
		 * Transform a greyscale picture to a same picture with a gradient of two colors.
		 * 
		 * @param	color1	replace the whites
		 * @param	color2	replace the blacks
		 * @return	the DBitmapDataColor object
		 */
		public function greyToColor16( color1:uint, color2:uint ):BitmapDataColor
		{
			const rect:Rectangle = new Rectangle(0, 0, _content.width, _content.height);
			
			const rMax:int = Math.max( (color1 >> 16) & 0xFF, (color2 >> 16) & 0xFF );
			const rMin:int = Math.min( (color1 >> 16) & 0xFF, (color2 >> 16) & 0xFF );
			const gMax:int = Math.max( (color1 >> 8) & 0xFF, (color2 >> 8) & 0xFF );
			const gMin:int = Math.min( (color1 >> 8) & 0xFF, (color2 >> 8) & 0xFF );
			const bMax:int = Math.max( color1 & 0xFF, color2 & 0xFF );
			const bMin:int = Math.min( color1 & 0xFF, color2 & 0xFF );
			
			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = (rMax - rMin) / 0xFF;
			ct.redOffset = rMin;
			ct.greenMultiplier = (gMax - gMin) / 0xFF;
			ct.greenOffset = gMin;
			ct.blueMultiplier = (bMax - bMin) / 0xFF;
			ct.blueOffset = bMin;
			_content.colorTransform(rect, ct);

			return this;
		}
		
		/**
		 * Transform a greyscale picture to a same picture with a gradient of two colors.
		 * 
		 * @param	greyBitmapData		the original grey bitmapdata
		 * @param	color1				replace the whites
		 * @param	color2				replace the blacks
		 * @return	the DBitmapDataColor object
		 */
		public static function greyToColor16( greyBitmapData:BitmapData, color1:uint, color2:uint ):BitmapData
		{
			var DBD:BitmapDataColor = new BitmapDataColor( greyBitmapData );
			DBD.greyToColor16( color1, color2 );
			return DBD._content;
		}
		
		/**
		 * Apply an greyscale opacity mask.
		 * Opacity masks enable you to make portions of an element or visual either transparent or partially transparent.
		 * His blacks are transparents and his whites are opaque.
		 * 
		 * @param	opacityMask
		 * @return	the DBitmapDataColor object
		 */
		public function applyOpacityMask( opacityMask:BitmapData ):BitmapDataColor
		{
			const rectangle:Rectangle = new Rectangle(0, 0, _content.width, _content.height);
			var contentV:Vector.<uint> = _content.getVector(rectangle);
			var maskV:Vector.<uint> = opacityMask.getVector(rectangle);
			
			var i:uint = contentV.length;
			while (--i > -1)
			{
				contentV[i] = (contentV[i] & 0xFFFFFF) | ( ( maskV[i] & 0xFF ) << 24 );
			}
			
			_content.dispose();
			_content = new BitmapData( rectangle.width, rectangle.height, true, 0x00000000 );
			_content.setVector(rectangle, contentV);
			
			return this;
		}
		
		/**
		 * Apply an greyscale opacity mask.
		 * Opacity masks enable you to make portions of an element or visual either transparent or partially transparent.
		 * His blacks are transparents and his whites are opaque.
		 * 
		 * @param	opacityMask
		 * @return	the DBitmapDataColor object
		 */
		public static function applyOpacityMask( colorBitmapData:BitmapData, opacityMask:BitmapData ):BitmapData
		{
			var DBD:BitmapDataColor = new BitmapDataColor( colorBitmapData );
			DBD.applyOpacityMask( opacityMask );
			return DBD._content;
		}
		
		/**
		 * If your BitmapData has 24 bits,
		 * the opacity mask is generated by the alpha channel
		 * 
		 * @return	opacity mask
		 */
		public function getOpacityMask():BitmapData
		{
			const rectangle:Rectangle = new Rectangle(0, 0, _content.width, _content.height);
			var contentV:Vector.<uint> = _content.getVector(rectangle);
			var opacityMaskV:Vector.<uint> = new Vector.<uint>(contentV.length, true);
			var opacityMask:BitmapData = new BitmapData(rectangle.width, rectangle.height, false, 0x000000);
			
			var canal:int;
			
			var i:uint = contentV.length;
			while (--i > -1)
			{
				canal = ( contentV[i] >> 24 ) & 0xFF;
				opacityMaskV[i] = canal << 16 | canal << 8 | canal;
			}
			
			opacityMask.setVector(rectangle, opacityMaskV);
			
			return opacityMask;
		}
		
		/**
		 * If your BitmapData has 24 bits,
		 * the opacity mask is generated by the alpha channel
		 * 
		 * @return	opacity mask
		 */
		public static function getOpacityMap( colorBitmapData:BitmapData ):BitmapData
		{
			var DBD:BitmapDataColor = new BitmapDataColor( colorBitmapData );
			return DBD.getOpacityMask();
		}
	}

}