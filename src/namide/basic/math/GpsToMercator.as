package namide.basic.math 
{
	import flash.geom.Point;
	import namide.basic.geom.Equation2D;
	import namide.basic.geom.Vector2D;
	/**
	 * ...
	 * @author Namide
	 */
	public class GpsToMercator 
	{
		
		protected var minGpsX:Number;
		protected var maxGpsX:Number;
		protected var minGpsY:Number;
		protected var maxGpsY:Number;
		protected var minMercX:Number;
		protected var maxMercX:Number;
		protected var minMercY:Number;
		protected var maxMercY:Number;
		
		protected var proportionalMercatorX:Equation2D;
		protected var proportionalMercatorY:Equation2D;
		
		protected static const EQUATORIAL_CIRCUMFERENCE:Number = 40075017;		// unit = meter
		protected static const MERIDIAN_ELLIPSE:Number = 40007860;
		
		protected static const R_MAJOR:Number = 6378137.0;						//Equatorial Radius, WGS84
		protected static const R_MINOR:Number = 6356752.314245179;				//defined as constant
		protected static const F:Number = 298.257223563;						//1/F=(a-b)/a , a=R_MAJOR, b=R_MINOR
		
		
		public function GpsToMercator() { }
		
		public function connectionGpsMercator( minLatitude:Number = 85, maxLatitude:Number = -85, minLongitude:Number = -180, maxLongitude:Number = 180,
											   minMercX:Number = 0, maxMercX:Number = 1, minMercY:Number = 0, maxMercY:Number = 1 ):GpsToMercator
		{
			this.minGpsX = minLongitude;
			this.maxGpsX = maxLongitude;
			this.minGpsY = minLatitude;
			this.maxGpsY = maxLatitude;
			this.minMercX = minMercX;
			this.maxMercX = maxMercX;
			this.minMercY = minMercY;
			this.maxMercY = maxMercY;
			
			var minDisplaceUV:Point = convertUV( this.minGpsY, this.minGpsX );
			var maxDisplaceUV:Point = convertUV( this.maxGpsY, this.maxGpsX );
			
			var minDisplaceMerc:Point = new Point( this.minMercX, this.minMercY );
			var maxDisplaceMerc:Point = new Point( this.maxMercX, this.maxMercY );
			
			proportionalMercatorX = (new Equation2D()).setByPoints( new Vector2D( minDisplaceUV.x, minDisplaceMerc.x ), new Vector2D( maxDisplaceUV.x, maxDisplaceMerc.x ) );
			proportionalMercatorY = (new Equation2D()).setByPoints( new Vector2D( minDisplaceUV.y, minDisplaceMerc.y ), new Vector2D( maxDisplaceUV.y, maxDisplaceMerc.y ) );
			
			return this;
		}
		
		public function convertProportionnal( gpsY:Number, gpsX:Number ):Point
		{
			var pos:Point = convertUV(gpsY, gpsX);
			
			pos.x = proportionalMercatorX.getY( pos.x );
			pos.y = proportionalMercatorY.getY( pos.y );
			
			return pos;
		}
		
		public function convertMeters( gpsY:Number, gpsX:Number ):Point
		{
			return gpsToMercator( gpsX, gpsY );
		}
		
		public function convertUV( gpsY:Number, gpsX:Number ):Point
		{
			var pos:Point = gpsToMercator( gpsX, gpsY );
			pos.x = 0.5 + pos.x / EQUATORIAL_CIRCUMFERENCE;
			pos.y = 0.5 - pos.y / MERIDIAN_ELLIPSE;
			return pos;
		}
		
		
		protected function deg2rad( d:Number ):Number {	return d * (Math.PI / 180.0); }
		protected function rad2deg(r:Number ):Number { return r / (Math.PI / 180.0); }
		
		protected function gpsToMercator(lon:Number, lat:Number):Point
		{
			var x:Number = R_MAJOR * deg2rad(lon);
			
			if (lat > 89.5) lat = 89.5;
			if (lat < -89.5) lat = -89.5;
			
			var temp:Number = R_MINOR / R_MAJOR;
			var es:Number = 1.0 - (temp * temp);
			var eccent:Number = Math.sqrt(es);
			
			var phi:Number = deg2rad(lat);
			
			var sinphi:Number = Math.sin(phi);
			
			var con:Number = eccent * sinphi;
			var com:Number = .5 * eccent;
			var con2:Number = Math.pow((1.0-con) / (1.0+con), com);
			var ts:Number = Math.tan(.5 * (Math.PI*0.5 - phi))/con2;
			var y:Number = 0 - R_MAJOR * Math.log(ts);
			return new Point(x, y);
		}
		
		protected function mercatorToGps(x:Number, y:Number):Point
		{
			var lon:Number = rad2deg( (x/R_MAJOR) );
			
			var temp:Number = R_MINOR / R_MAJOR;
			var e:Number = Math.sqrt(1.0 - (temp * temp));
			var lat:Number = rad2deg( pj_phi2( Math.exp( 0-( y/R_MAJOR ) ), e ) );
			
			return new Point( lon, lat );
		}
		
		protected function pj_phi2( ts:Number, e:Number):Number
		{
			const N_ITER:int = 15;
			const HALFPI:Number = Math.PI/2;
			
			const TOL:Number = 0.0000000001;
			var eccnth:Number, Phi:Number, con:Number, dphi:Number;
			var i:int;
			eccnth = .5 * e;
			Phi = HALFPI - 2. * Math.atan (ts);
			i = N_ITER;
			do 
			{
				con = e * Math.sin (Phi);
				dphi = HALFPI - 2. * Math.atan (ts * Math.pow((1. - con) / (1. + con), eccnth)) - Phi;
				Phi += dphi;
			} 
			while ( Math.abs(dphi) > TOL && --i);
			
			return Phi;
		}
		
	}

}