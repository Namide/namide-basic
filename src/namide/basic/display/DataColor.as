package namide.basic.display 
{
	
	/**
	 * ...
	 * @author namide.com
	 */
	public class DataColor 
	{
		
		protected var _rgba:uint;
		
		
		public function DataColor(pColor:uint = 0xFF000000) 
		{
			_rgba = pColor;
		}
		
		public function set rgba(c:uint):void { _rgba = c; }
		public function get rgba():uint { return _rgba; }
		
		/**
		 * Hue, Saturation, Lightness
		 * 
		 * @param	hue			0 to 1
		 * @param	saturation	0 to 1
		 * @param	lightness	0 to 1
		 * @return	RGB color
		 */
		public function setByHLS( hue:Number, lightness:Number, saturation:Number ):uint
		{
			var r:Number;
			var g:Number;
			var b:Number;
			
			if ( saturation == 0 )
			{
				r = lightness * 255;
				g = lightness * 255;
				b = lightness * 255;
			}
			else
			{
				var var_1:Number;
				var var_2:Number;
				
				if ( lightness < 0.5 )	var_2 = lightness * ( 1 + saturation );
				else           			var_2 = ( lightness + saturation ) - ( saturation * lightness );
				
				var_1 = 2 * lightness - var_2;
				
				r = Math.round( 255 * Hue_2_RGB( var_1, var_2, hue + ( 1 * 0.333333 ) ) );
				g = Math.round( 255 * Hue_2_RGB( var_1, var_2, hue ) );
				b = Math.round( 255 * Hue_2_RGB( var_1, var_2, hue - ( 1 * 0.333333 ) ) );
			}
			
			_rgba = r << 16 | g << 8 | b;
			
			return _rgba;
			
			function Hue_2_RGB( v1:Number, v2:Number, vH:Number):Number
			{
				
			   if ( vH < 0 ) vH += 1;
			   if ( vH > 1 ) vH -= 1;
			   if ( ( 6 * vH ) < 1 ) return ( v1 + ( v2 - v1 ) * 6 * vH );
			   if ( ( 2 * vH ) < 1 ) return ( v2 );
			   if ( ( 3 * vH ) < 2 ) return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 );
			   
			   return v1;
			}
		}
		
		public static function hslToRgb( hue:Number, saturation:Number , lightness:Number ):uint
		{
			var c:DataColor = new DataColor();
			return c.setByHLS(hue, saturation, lightness);
		}
		
		/**
		 * @param	color
		 * @param	f			The level of interpolation between the two points. If f=0, this this.color is returned; if f=1, color is return.
		 * @return
		 */
		public function interpolateTo( color:uint, f:Number ):uint
		{
			_rgba = interpolationRGBA( _rgba, color, f );
			return _rgba;
		}
		
		public static function interpolationRGBA( color1:uint, color2:uint, f:Number ):uint
		{
			const a:int = ( int((color1 >> 24) & 0xFF) - int((color2 >> 24) & 0xFF) ) * f + (color2 >> 24 & 0xFF);
			const r:int = ( int((color1 >> 16) & 0xFF) - int((color2 >> 16) & 0xFF) ) * f + (color2 >> 16 & 0xFF);
			const g:int = ( int((color1 >> 8) & 0xFF)  - int((color2 >> 8) & 0xFF) )  * f + (color2 >> 8 & 0xFF);
			const b:int = ( int((color1 >> 0) & 0xFF)  - int((color2 >> 0) & 0xFF) )  * f + (color2 >> 0 & 0xFF);
			
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
	}

}