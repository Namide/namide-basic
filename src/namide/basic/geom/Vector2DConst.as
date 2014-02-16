package namide.basic.geom 
{
	/**
	 * The DVector2DConst is a 2 dimensional vector, copy of Vect2Const by playchilla.com
	 * 
	 * all methods that ends with Self actually modifies the object itself (including obvious ones copy, copyXY and zero).
	 * For example v1 += v2; is written as v1.addSelf(v2);
	 *
	 * @author namide.com copy of playchilla.com
	 */
	public class Vector2DConst 
	{
		internal var _x:Number;
		internal var _y:Number;
		
		private static const _RadsToDeg:Number = 180 / Math.PI;
		
		public static const ZERO:Vector2DConst = new Vector2DConst();
		public static const EPSILON:Number = 0.0000001;
		public static const EPSILON_SQRT:Number = EPSILON * EPSILON;
		
		public function Vector2DConst( x:Number = 0, y:Number = 0 ) 
		{
			_x = x;
			_y = y;
		}
		
		/**
		 * The first element of a DVector2D object, such as the x coordinate of a point in the two-dimensional space.
		 */
		public function get x():Number { return _x; }
		
		/**
		 * The second element of a DVector2D object, such as the y coordinate of a point in the two-dimensional space.
		 */
		public function get y():Number { return _y; }
 
		/**
		 * Returns a new DVector2D object that is an exact copy of the current DVector2D object.
		 * @return	A new Vector3D object that is a copy of the current Vector3D object.
		 */
		public function clone():Vector2D { return new Vector2D(_x, _y); }

		
		//////////////////////////////////////////////////////////
		//														//
		//			ADD, SUBSTRACT, MULTIPLY AND DIVIDE			//
		//														//
		//////////////////////////////////////////////////////////
		
		/**
		 * Adds the value of the x and y elements of the current DVector2D object to the values of the x and y elements of another DVector2D object.
		 * 
		 * @param	a	A DVector2D object to be added to the current DVector2D object.
		 * @return	A DVector2D object that is the result of adding the current DVector2D object to another DVector2D object.
		 */
		public function add(pos:Vector2DConst):Vector2D { return new Vector2D(_x + pos._x, _y + pos._y); }
		
		/**
		 * Adds the value of the x and y elements of the current DVector2D object to x and y arguments.
		 * 
		 * @param	x	A Number to be added to the x value of the current DVector2D object.
		 * @param	y	A Number to be added to the y value of the current DVector2D object.
		 * @return	A DVector2D object that is the result of adding the current DVector2D object to the coordinates x and y.
		 */
		public function addXY(x:Number, y:Number):Vector2D { return new Vector2D(_x + x, _y + y); }
 
		/**
		 * Subtracts the value of the x and y elements of the current DVector2D object to the values of the x and y elements of another DVector2D object.
		 * 
		 * @param	a	A DVector2D object to be subtracted to the current DVector2D object.
		 * @return	A DVector2D object that is the result of subtracting the current DVector2D object to another DVector2D object.
		 */
		public function sub(pos:Vector2DConst):Vector2D { return new Vector2D(_x - pos._x, _y - pos._y); }
		
		/**
		 * Subtracts the value of the x and y elements of the current DVector2D object to x and y arguments.
		 * 
		 * @param	x	A Number to be subtracted to the x value of the current DVector2D object.
		 * @param	y	A Number to be subtracted to the y value of the current DVector2D object.
		 * @return	A DVector2D object that is the result of subtracting the current DVector2D object to the coordinates x and y.
		 */
		public function subXY(x:Number, y:Number):Vector2D { return new Vector2D(_x - x, _y - y); }
 
		/**
		 * Multiplies the value of the x and y elements of the current DVector2D object to the values of the x and y elements of another DVector2D object.
		 * 
		 * @param	a	A DVector2D object to be multiplied to the current DVector2D object.
		 * @return	A DVector2D object that is the result of multiplying the current DVector2D object to another DVector2D object.
		 */
		public function multiply(vec:Vector2DConst):Vector2D { return new Vector2D(_x * vec._x, _y * vec._y); }
		
		/**
		 * Multiplies the value of the x and y elements of the current DVector2D object to x and y arguments.
		 * 
		 * @param	x	A Number to be multiplied to the x value of the current DVector2D object.
		 * @param	y	A Number to be multiplied to the y value of the current DVector2D object.
		 * @return	A DVector2D object that is the result of multiplying the current DVector2D object to the coordinates x and y.
		 */
		public function multiplyXY(x:Number, y:Number):Vector2D { return new Vector2D(_x * x, _y * y); }
 
		/**
		 * Divides the value of the x and y elements of the current DVector2D object to x and y arguments.
		 * 
		 * @param	a	A DVector2D object to be divided to the current DVector2D object.
		 * @return	A DVector2D object that is the result of dividing the current DVector2D object to the coordinates x and y.
		 */
		public function divide(vec:Vector2DConst):Vector2D { return new Vector2D(_x / vec._x, _y / vec._y); }
		
		/**
		 * Divides the value of the x and y elements of the current DVector2D object to x and y arguments.
		 * 
		 * @param	x	A Number to be divided to the x value of the current DVector2D object.
		 * @param	y	A Number to be divided to the y value of the current DVector2D object.
		 * @return	A DVector2D object that is the result of dividing the current DVector2D object to the coordinates x and y.
		 */
		public function divideXY(x:Number, y:Number):Vector2D { return new Vector2D(_x / x, _y / y); }
 
		
		/**
		 * Scales the current DVector2D object by a scalar, a magnitude.
		 * The DVector2D object's x and y elements are multiplied by the scalar number specified in the parameter.
		 * For example, if the vector is scaled by ten, the result is a vector that is ten times longer.
		 * The scalar can also change the direction of the vector.
		 * Multiplying the vector by a negative number reverses its direction.
		 * 
		 * @param	s	Multiplier (scalar) used to scale a Vector3D object.
		 * @return	A DVector2D object that is the result of scaling the current DVector2D object to s.
		 */
		public function scale(s:Number):Vector2D { return new Vector2D(_x * s, _y * s); }
 
		/**
		 * Converts a DVector2D object to a unit vector by dividing the first two elements (x, y) by the length of the vector.
		 * Unit vertices are vertices that have a direction but their length is one.
		 * They simplify vector calculations by removing length as a factor.
		 * 
		 * @return	The current DVector2D object normalized.
		 */
		public function normalize():Vector2D
		{
			const nf:Number = 1 / Math.sqrt(_x * _x + _y * _y);
			return new Vector2D(_x * nf, _y * nf);
		}
 
		/**
		 * length of the current DVector2D
		 * 
		 * @return length of the current DVector2D
		 */
		public function length():Number { return Math.sqrt(_x * _x + _y * _y); }
		
		/**
		 * Square root of the length of the current DVector2D
		 * 
		 * @return the square length of the length of the current DVector2D
		 */
		public function lengthSqrt():Number { return _x * _x + _y * _y; }
		
		/**
		 * the distance between the current DVector2D and the vector vec.
		 * 
		 * @param	pt		Point for calculated the distance.
		 * @return			The distance between the current DVector2D and pt.
		 */
		public function distance(vec:Vector2DConst):Number
		{
			const xd:Number = _x - vec._x;
			const yd:Number = _y - vec._y;
			return Math.sqrt(xd * xd + yd * yd);
		}
		
		/**
		 * the distance between the current DVector2D and the positions pX and pY.
		 * 
		 * @param	pX		X-axis coordinate.
		 * @param	pY		Y-axis coordinate.
		 * @return			The distance between the current DVector2D and the coordinates.
		 */
		public function distanceXY(x:Number, y:Number):Number
		{
			const xd:Number = _x - x;
			const yd:Number = _y - y;
			return Math.sqrt(xd * xd + yd * yd);
		}
		
		/**
		 * The scare root of the distance between the current DVector2D and the vector vec.
		 * 
		 * @param	pt		Point for calculated the distance.
		 * @return			The scare root of the distance between the current DVector2D and pt.
		 */
		public function distanceSqrt(vec:Vector2DConst):Number
		{
			const xd:Number = _x - vec._x;
			const yd:Number = _y - vec._y;
			return xd * xd + yd * yd;
		}
		
		/**
		 * The scare root of the distance between the current DVector2D and the positions pX and pY.
		 * 
		 * @param	pX		X-axis coordinate.
		 * @param	pY		Y-axis coordinate.
		 * @return			The scare root of the distance between the current DVector2D and the coordinates.
		 */
		public function distanceXYSqrt(x:Number, y:Number):Number
		{
			const xd:Number = _x - x;
			const yd:Number = _y - y;
			return xd * xd + yd * yd;
		}
 
		/**
		 * Determines whether the two vectors are equal.
		 * They are equal if they have the same x and y values. 
		 * 
		 * @param	second vector to compare.
		 * @return	A value of true if the object is equal to this coordinates; false if it is not equal. 
		 */
		public function equals(vec:Vector2DConst):Boolean { return _x == vec._x && _y == vec._y; }
		
		/**
		 * Determines whether the points and the coordinates are equal.
		 * They are equal if they have the same x and y values. 
		 * 
		 * @param	x	X-axis of the coordinate to be compared.
		 * @param	y	Y-axis of the coordinate to be compared.
		 * @return	A value of true if the object is equal to this coordinates; false if it is not equal. 
		 */
		public function equalsXY(x:Number, y:Number):Boolean { return _x == x && _y == y; }
		
		/**
		 * Test if the DUtilsVector2D is normalized.
		 * 
		 * @return A value of true if the object is normalized; false if it is not equal. 
		 */
		public function isNormalized():Boolean { return Math.abs((_x * _x + _y * _y)-1) < EPSILON_SQRT; }
		
		/**
		 * Test if the DUtilsVector2D is equal to 0.
		 * 
		 * @return A value of true if the object is equal to 0; false if it is not equal. 
		 */
		public function isZero():Boolean { return _x == 0 && _y == 0; }
		
		/**
		 * Test if the DUtilsVector2D is near to the second Point <code>pt</code>.
		 * 
		 * @param	vec		Second Point to compare
		 * @return	A value of true if the DUtilsVector2D is near to the second Point; false if it is not near. 
		 */
		public function isNear(vec:Vector2DConst):Boolean
		{
			if ( Math.abs(_x - vec._x) > EPSILON ) return false;
			else if ( Math.abs(_y - vec._y) > EPSILON ) return false;
			
			return true;
		}
		
		/**
		 * Test if the DUtilsVector2D is near to the coordinates x and y.
		 * 
		 * @param	x		X-axis of the coordinate to be compared.
		 * @param	y		Y-axis of the coordinate to be compared.
		 * @return	A value of true if the DUtilsVector2D is near to the coordinates; false if it is not near. 
		 */
		public function isNearXY(x:Number, y:Number):Boolean
		{
			if ( Math.abs(_x - x) > EPSILON ) return false;
			else if ( Math.abs(_y - y) > EPSILON ) return false;
			
			return true;
		}
		
		/**
		 * Test if the DUtilsVector2D is within the distance epsilon to the second Point <code>pt</code>.
		 * 
		 * @param	vec			Second Point to compare
		 * @param	epsilon		Maximum distance to compare
		 * @return	A value of true if the DUtilsVector2D is within the distance epsilon to the second Point; false if it is not near. 
		 */
		public function isWithin(vec:Vector2DConst, epsilon:Number):Boolean { return distanceSqrt(vec) < epsilon * epsilon; }
		
		/**
		 * Test if the DUtilsVector2D is within the distance epsilon to the coordinates x and y.
		 * 
		 * @param	x			X-axis of the coordinate to be compared.
		 * @param	y			Y-axis of the coordinate to be compared.
		 * @param	epsilon		Maximum distance to compare
		 * @return	A value of true if the DUtilsVector2D is within the distance epsilon to the coordinates; false if it is not near. 
		 */
		public function isWithinXY(x:Number, y:Number, epsilon:Number):Boolean { return distanceXYSqrt(x, y) < epsilon * epsilon; }
		
		/**
		 * Test if the DUtilsVector2D is valid. No coordinate to NaN or infinite.
		 * 
		 * @return	A value of true if the DUtilsVector2D is valid; false if it is not near. 
		 */
		public function isValid():Boolean { return !isNaN(_x) && !isNaN(_y) && isFinite(_x) && isFinite(_y); }
		
		/**
		 * Angle in degrees of the DUtilsVector2D.
		 * 
		 * @return	Angle in degrees of the DUtilsVector2D.
		 */
		public function getDegrees():Number { return getRads() * _RadsToDeg; }
		
		/**
		 * Angle in radians of the DUtilsVector2D.
		 * 
		 * @return	Angle in radians of the DUtilsVector2D.
		 */
		public function getRads():Number { return Math.atan2(_y, _x); }
 
		/**
		 * Dot product for two vectors.
		 * 
		 * @param	vec		Second Point to multiplied
		 * @return	A new Point multiplying by the two Points.
		 */
		public function dot(vec:Vector2DConst):Number { return _x * vec._x + _y * vec._y; }
		
		/**
		 * Dot product for a vector and a coordinates.
		 * 
		 * @param	x			X-axis of the coordinate to be multiplied.
		 * @param	y			Y-axis of the coordinate to be multiplied.
		 * @return	A new Point multiplying by the current DUtilsVector2D and the coordinates.
		 */
		public function dotXY(x:Number, y:Number):Number { return _x * x + _y * y; }
 
		/**
		 * Cross determinant of the current vector and un new Point.
		 * 
		 * @param	vec		Second Point to be cross determinated
		 * @return	The cross determinant of the current vector and the Point pt.
		 */
		public function crossDeterminant(vec:Vector2DConst):Number { return _x * vec._y - _y * vec._x; }
		
		/**
		 * Cross determinant of the current vector and coordinates.
		 * 
		 * @param	x			X-axis of the coordinate to be cross determinated
		 * @param	y			Y-axis of the coordinate to be cross determinated
		 * @return	The cross determinant of the current vector and the coordinates.
		 */
		public function crossDeterminantXY(x:Number, y:Number):Number { return _x * y - _y * x; }
 
		/**
		 * Rotate the vector (in radians).
		 * 
		 * @param	rads		Angle in radians for the rotation.
		 * @return	A new Point after the rotation of the current DUtilsVector2D.
		 */
		public function rotate(rads:Number):Vector2D
		{
			const s:Number = Math.sin(rads);
			const c:Number = Math.cos(rads);
			return new Vector2D(_x * c - _y * s, _x * s + _y * c);
		}
		
		/**
		 * Rotate to 90° the vector in the direction of clockwise.
		 * 
		 * @return	A new Point after the rotation.
		 */
		public function normalRight():Vector2D { return new Vector2D(-_y, _x); }
		
		/**
		 * Rotate to 90° the vector in the opposite direction of clockwise.
		 * 
		 * @return	A new Point after the rotation.
		 */
		public function normalLeft():Vector2D { return new Vector2D(_y, -_x); }
		
		/**
		 * Rotate to 180° the vector.
		 * 
		 * @return	A new Point after the rotation.
		 */
		public function negate():Vector2D { return new Vector2D( -_x, -_y); }
 
		/**
		 * Spinor rotation ?
		 */
		public function rotateSpinor(vec:Vector2DConst):Vector2D { return new Vector2D(_x * vec._x - _y * vec._y, _x * vec._y + _y * vec._x); }
		
		/**
		 * Spinor rotation ?
		 */
		public function spinorBetween(vec:Vector2DConst):Vector2D
		{
			const d:Number = lengthSqrt();
			const r:Number = (vec._x * _x + vec._y * _y) / d;
			const i:Number = (vec._y * _x - vec._x * _y) / d;
			return new Vector2D(r, i);
		}
 
		/**
		 * Lerp
		 */
		public function interpolateTo(to:Vector2DConst, t:Number):Vector2D { return new Vector2D(_x + t * (to._x - _x), _y + t * (to._y - _y)); }
 
		/**
		 * Spherical linear interpolation
		 * Note: sphericalInterpolateTo is not well tested yet.
		 * 
		 * @param	vec
		 * @param	t
		 * @return
		 */
		public function sphericalInterpolateTo(vec:Vector2DConst, t:Number):Vector2D
		{
			const cosTheta:Number = dot(vec);
			const theta:Number = Math.acos(cosTheta);
			const sinTheta:Number = Math.sin(theta);
			if (sinTheta <= EPSILON)
				return vec.clone();
			const w1:Number = Math.sin((1 - t) * theta) / sinTheta;
			const w2:Number = Math.sin(t * theta) / sinTheta;
			return scale(w1).add(vec.scale(w2));
		}
		
		/**
		 * Reflect
		 */
		public function reflect(normal:Vector2DConst):Vector2D
		{
			const d:Number = 2 * (_x * normal._x + _y * normal._y);
			return new Vector2D(_x - d * normal._x, _y - d * normal._y);
		}
		
		
		/*
		 * Project the vector into a vector
		 */
		public function project( vect:Vector2DConst ):Vector2D
		{
			const s:Number = dot( vect ) / ( vect.length() * vect.length() );
			return vect.scale(s);
		}
		
		
		/**
		 * Helpers
		 */
		public static function swap(a:Vector2D, b:Vector2D):void
		{
			const x:Number = a.x;
			const y:Number = a.y;
			a._x = b._x;
			a._y = b._y;
			b._x = x;
			b._y = y;
		
		}
		
		/**
		 * 
		 * @param	A
		 * @param	O
		 * @param	C
		 * @return		AÔB
		 */
		public static function getDegreesBetween( A:Vector2D, O:Vector2D, B:Vector2D ):Number
		{
			return getRadsBetween( A, O, B ) * Vector2DConst._RadsToDeg;
		}
		
		/**
		 * 
		 * @param	A
		 * @param	O
		 * @param	C
		 * @return		AÔB
		 */
		public static function getRadsBetween( A:Vector2D, O:Vector2D, B:Vector2D ):Number
		{
			const PI_2:Number = Math.PI + Math.PI;
			var rads:Number = A.sub(O).getRads() - B.sub(O).getRads();
			rads %= PI_2;
			if ( rads > Math.PI ) rads -= PI_2;
			else if( rads < -Math.PI ) rads += PI_2;
			
			return rads;
			/*const OA:DVector2D = O.sub(A);
			const OB:DVector2D = O.sub(B);
			const vect:DVector2D = OA.rotate( OB.getRads() );
			
			return vect.getRads();*/
		}
		
		
		/**
		 * String
		 */
		public function toString():String { return "[" + _x + ", " + _y + "]"; }
		
	}

}