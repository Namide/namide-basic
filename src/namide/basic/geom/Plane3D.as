package namide.basic.geom
{
	import flash.geom.Vector3D;

	/**
	 * Equation of a 3D place
	 * <p>Resolve the algebraic equation : ax + by + cz + d = 0</p>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10
	 * 
	 * @author namide.com
	 */
	public class Plane3D
	{
		
		protected var _a : Number;
		protected var _b : Number;
		protected var _c : Number;
		protected var _d : Number;

		public function Plane3D(a : Number = 0, b : Number = 0, c : Number = 0, d : Number = 0) {
			_a = a;
			_b = b;
			_c = c;
			_d = d;
		}

		/**
		 * Value for a of 3D Place : ax + by + cz + d = 0
		 */
		public function get a():Number { return _a; }
		public function set a( val:Number ):void { _a = val; }

		/**
		 * Value for b of 3D Place : ax + by + cz + d = 0
		 */
		public function get b():Number { return _b; }
		public function set b( val:Number ):void { _b = val; }

		/**
		 * Value for c of 3D Place : ax + by + cz + d = 0
		 */
		public function get c():Number { return _c; }
		public function set c( val:Number ):void { _c = val; }

		/**
		 * Value for d of 3D Place : ax + by + cz + d = 0
		 */
		public function get d():Number { return _d; }
		public function set d(val:Number):void { _d = val; }

		/**
		 * Initialization of the plane 3 differents Vector3D (flash.geom.Vector3D).
		 * 
		 * @param	pt1		point of the plane
		 * @param	pt2		point of the plane
		 * @param	pt3		point of the plane
		 * 
		 * @see flash.geom.Vector3D
		 */
		public function setByPoints( pt1:Vector3D, pt2:Vector3D, pt3:Vector3D ):Plane3D
		{
			_a = (pt2.y - pt1.y) * (pt3.z - pt1.z) - (pt2.z - pt1.z) * (pt3.y - pt1.y);
			_b = - ( (pt2.x - pt1.x) * (pt3.z - pt1.z) - (pt2.z - pt1.z) * (pt3.x - pt1.x) );
			_c = (pt2.x - pt1.x) * (pt3.y - pt1.y) - (pt2.y - pt1.y) * (pt3.x - pt1.x);
			_d = - (a * pt1.x + b * pt1.y + c * pt1.z);
			
			return this;
		}

		/**
		 * Calculates the position x for the point P of the plane.
		 * 
		 * @param	y	Position y of the point P
		 * @param	z	Position z of the point P
		 * @return	Position x of the point P
		 */
		public function getX( y:Number, z:Number ):Number { return - ( _b * y + _c * z + d ) / _a; }
		
		/**
		 * Calculates the position y for the point P of the plane.
		 * 
		 * @param	x	Position x of the point P
		 * @param	z	Position z of the point P
		 * @return	Position y of the point P
		 */
		public function getY( x:Number, z:Number ):Number { return - ( _a * x + _c * z + d ) / _b; }
		
		/**
		 * Calculates the position z for the point P of the plane.
		 * 
		 * @param	x	Position x of the point P
		 * @param	y	Position y of the point P
		 * @return	Position z of the point P
		 */
		public function getZ( x:Number, y:Number ):Number { return - ( _a * x + _b * y + d ) / _c; }
		
		/**
		 * Evaluates if the Point pt is on the plane.
		 * 
		 * @param	pt	Vector3D for the test
		 * @return	true if the Vector3D is on the plane; false if not. 
		 */
		public function hitTestPoint( pt:Vector3D ):Boolean { return ( _a * pt.x + _b * pt.y + _c * pt.z + _d == 0); }

		/**
		 * Evaluates if the Point pt is above the plane.
		 * 
		 * @param	pt	Vector3D for the test
		 * @return	true if the Vector3D is above the plane; false if not. 
		 */
		public function isAbove( pt:Vector3D ):Boolean {	return ( _a * pt.x + _b * pt.y + _c * pt.z + _d > 0); }

		/**
		 * Evaluates if the Point pt is under the plane.
		 * 
		 * @param	pt	Vector3D for the test
		 * @return	true if the Vector3D is under the plane; false if not. 
		 */
		public function isUnder( pt:Vector3D ):Boolean { return ( _a * pt.x + _b * pt.y + _c * pt.z + _d < 0); }

		
		public function toString():String
		{
			return "plane: { a:" + _a + ", b:" + _b + ", c:" + _c + ", d:" + _d + " }";
		}
	}
}