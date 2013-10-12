package namide.basic.geom 
{
	import flash.geom.ColorTransform;
	
	/**
	 * Static class to generate differents ColorTransform
	 * for alterate hue and other.
	 * 
	 * @author namide.com Damien Doussaud
	 */
	public class UtilsColorTransform 
	{
		
		public function UtilsColorTransform( key:Key ) { }
		
		/**
		 * Set the ColorTransform so that it can change the hue of DisplayObject.
		 * 
		 * @param	colorTransform	The object to edit
		 * @param	color			The new color for the colorTranform
		 * @param	alpha			The opacity of the color
		 * @return
		 */
		public static function setByHue( colorTransform:ColorTransform, color:uint, opacity:Number = 1 ):ColorTransform
		{
			const r:int = ( (color >> 16) & 0xFF ) * opacity;
			const g:int = ( (color >> 8) & 0xFF ) * opacity;
            const b:int = ( color & 0xFF ) * opacity;
			
			colorTransform.redMultiplier = 1 - opacity;
			colorTransform.greenMultiplier = 1 - opacity;
			colorTransform.blueMultiplier = 1 - opacity;
			colorTransform.redOffset = r;
			colorTransform.greenOffset = g;
			colorTransform.blueOffset = b;
			
			return colorTransform;
		}
		public static function getByHue( color:uint, alpha:Number = 1 ):ColorTransform
		{
			const r:int = ( (color >> 16) & 0xFF ) * alpha;
			const g:int = ( (color >> 8) & 0xFF ) * alpha;
            const b:int = ( color & 0xFF ) * alpha;
			return new ColorTransform( 1 - alpha, 1 - alpha, 1 - alpha, 1, r, g, b, 0 );
		}
	}

}

internal class Key{ }