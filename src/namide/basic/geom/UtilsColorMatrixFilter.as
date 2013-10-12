package namide.basic.geom 
{
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * Static class to generate differents ColorMatrixFilter
	 * for alterate brightness, saturation, contrast...
	 * 
	 * @author namide.com Damien Doussaud
	 */
	public class UtilsColorMatrixFilter
	{
		// Luminance conversion constants   
        private static const R_LUM:Number = 0.212671;
        private static const G_LUM:Number = 0.715160;
        private static const B_LUM: Number = 0.072169;
		
		public function UtilsColorMatrixFilter(key:Key) {}
		
		/**
         * Changes matrix to alter brightness
         *
         * @param      Number between -1 and 1
         * @return ColorMatrixFilter to alter brightness
         */   
        public static function getBrightness( brightness:Number ):ColorMatrixFilter
        {
			brightness = 255 * brightness;	// 255 * brightness
           
            const mat:Array =  [ 	1,0,0,0, brightness,
									0,1,0,0, brightness,
									0,0,1,0, brightness,
									0, 0, 0, 1, 0  ];
			
			return new ColorMatrixFilter( mat );
        }
		
		/**
         * Return a ColorMatrixFilter to alter saturation
         *
         * @param  saturation	negative saturates reversed colors, 0 is grey scale and positive saturates the réal colors
         * @return ColorMatrixFilter to alter saturation
         */ 
        public static function getSaturation( saturation:Number ):ColorMatrixFilter
        {
            const isValue:Number = 1- saturation;
           
            const irlum:Number = isValue * R_LUM;
            const iglum:Number = isValue * G_LUM;
            const iblum:Number = isValue * B_LUM;
           
            const mat:Array =  [	irlum + saturation,   	iglum,                 	iblum,     			0, 0,
									irlum,             		iglum + saturation, 	iblum,              0, 0,
                                    irlum,    				iglum,         			iblum + saturation, 0, 0,
                                    0,      				0,           			0,                	1, 0 ];
                   
            return new ColorMatrixFilter( mat );
        }
		
		/**
         * Return a ColorMatrixFilter to alter contrast
         *
         * @param      Number  	-2 negate the colors, -1 is grey 0x808080, 0 don't change, positive number increase the contrast
         * @return ColorMatrixFilter to alter contrast
         */ 
        public static function getContrast( contrast:Number ):ColorMatrixFilter
        {
            const scale:Number = contrast + 1;
            const offset:Number = -contrast * 128;//128 - ( 1 - scale );
            
            const mat:Array = [ scale,  0,      0,   	0,   	offset,
								0,   	scale,  0,      0,     	offset,
								0,   	0,     	scale,  0,     	offset,
								0,   	0,     	0,      1,     	0      ];
                                           
            return new ColorMatrixFilter( mat );
        }
		
		/**
		 * Mix multiple ColorMatrixFilter
		 * 
		 * @param	a			A ColorMatrixFilter to mix with others
		 * @param	b			A ColorMatrixFilter to mix with others
		 * @param	...rest		A list of ColorMatrixFilter to mix with others
		 * @return	The new ColorMatrixFilter mixed
		 */
		public static function mix( a:ColorMatrixFilter, b:ColorMatrixFilter, ...rest ):ColorMatrixFilter
		{
			const l:uint = rest.length;
			const n:Number = 1 / ( 2 + l );
			var mat:Array = [];
			
			var j:int;
			var i:int = 20;
			while (--i > -1)
			{
				mat[i] = a.matrix[i] + b.matrix[i];
				if (l > 0)
				{
					j = l;
					while (--j > -1) mat[i] += rest[j].matrix[i];
				}
				mat[i] *= n;
			}
			
			return new ColorMatrixFilter( mat );
		}	
	}
}

internal class Key {}