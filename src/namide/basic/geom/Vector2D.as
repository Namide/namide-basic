package namide.basic.geom 
{	
	/**
	 * The DVector2D is a 2 dimensional vector, copy of Vect2 by playchilla.com
	 * 
	 * all methods that ends with Self actually modifies the object itself (including obvious ones copy, copyXY and zero).
	 * For example v1 += v2; is written as v1.addSelf(v2);
	 *
	 * @author namide.com copy of playchilla.com
	 */
	public class Vector2D extends Vector2DConst
	{
		public static const TEMP:Vector2D = new Vector2D();
		
		private static const _RadsToDeg:Number = 180 / Math.PI;
		
		public static const ZERO:Vector2D = new Vector2D();
		public static const EPSILON:Number = 0.0000001;
		public static const EPSILON_SQRT:Number = EPSILON * EPSILON;
		
		public function Vector2D( x:Number = 0, y:Number = 0 )
		{
			super(x, y);
		}
 
		/**
		 * The first element of a DVector2D object, such as the x coordinate of a point in the two-dimensional space.
		 */
		public function set x(x:Number):void { _x = x; }
		
		/**
		 * The second element of a DVector2D object, such as the y coordinate of a point in the two-dimensional space.
		 */
		public function set y(y:Number):void { _y = y; }
		
		public function setByXY( x:Number, y:Number ):Vector2D
		{
			_x = x;
			_y = y;
			return this;
		}
		
		public function setByVector2D( vect:Vector2DConst ):Vector2D
		{
			_x = vect._x;
			_y = vect._y;
			return this;
		}
		
		 
		//////////////////////////////////////////////////////////
		//														//
		//						SETTERS							//
		//														//
		//////////////////////////////////////////////////////////
		
		public function copy(vec:Vector2DConst):Vector2D
		{
			_x = vec.x;
			_y = vec.y;
			return this;
		}
		public function copyXY(x:Number, y:Number):Vector2D
		{
			_x = x;
			_y = y;
			return this;
		}
		public function zero():Vector2D
		{
			_x = 0;
			_y = 0;
			return this;
		}
 
		
		//////////////////////////////////////////////////////////
		//														//
		//			ADD, SUBSTRACT, MULTIPLY AND DIVIDE			//
		//														//
		//////////////////////////////////////////////////////////
		
		
		/**
		 * Add
		 */
		public function addSelf(vec:Vector2DConst):Vector2D
		{
			_x += vec.x;
			_y += vec.y;
			return this;
		}
		public function addXYSelf(x:Number, y:Number):Vector2D
		{
			_x += x;
			_y += y;
			return this;
		}
 
		/**
		 * Sub
		 */
		public function subSelf(vec:Vector2DConst):Vector2D
		{
			_x -= vec.x;
			_y -= vec.y;
			return this;
		}
		public function subXYSelf(x:Number, y:Number):Vector2D
		{
			_x -= x;
			_y -= y;
			return this;
		}
 
		/**
		 * Mul
		 */
		public function mulSelf(vec:Vector2DConst):Vector2D
		{
			_x *= vec.x;
			_y *= vec.y;
			return this;
		}
		public function mulXYSelf(x:Number, y:Number):Vector2D
		{
			_x *= x;
			_y *= y;
			return this;
		}
 
		/**
		 * Div
		 */
		public function divSelf(vec:Vector2DConst):Vector2D
		{
			_x /= vec.x;
			_y /= vec.y;
			return this;
		}
		public function divXYSelf(x:Number, y:Number):Vector2D
		{
			_x /= x;
			_y /= y;
			return this;
		}
 
		/**
		 * Scale
		 */
		public function scaleSelf(s:Number):Vector2D
		{
			_x *= s;
			_y *= s;
			return this;
		}
 
		/**
		 * Normalize
		 */
		public function normalizeSelf():Vector2D
		{
			const nf:Number = 1 / Math.sqrt(_x * _x + _y * _y);
			_x *= nf;
			_y *= nf;
			return this;
		}
 
		/**
		 * Rotate
		 */
		public function rotateSelf(rads:Number):Vector2D
		{
			const s:Number = Math.sin(rads);
			const c:Number = Math.cos(rads);
			const xr:Number = _x * c - _y * s;
			_y = _x * s + _y * c;
			_x = xr;
			return this;
		}
		public function normalRightSelf():Vector2D
		{
			const xr:Number = _x;
			_x = -_y
			_y = xr;
			return this;
		}
		public function normalLeftSelf():Vector2D
		{
			const xr:Number = _x;
			_x = _y
			_y = -xr;
			return this;
		}
		public function negateSelf():Vector2D
		{
			_x = -_x;
			_y = -_y;
			return this;
		}
 
		/**
		 * Spinor
		 */
		public function rotateSpinorSelf(vec:Vector2DConst):Vector2D
		{
			const xr:Number = _x * vec.x - _y * vec.y;
			_y = _x * vec.y + _y * vec.x;
			_x = xr;
			return this;
		}
 
		/**
		 * lerp
		 */
		public function interpolateToSelf(to:Vector2DConst, t:Number):Vector2D
		{
			_x = _x + t * (to.x - _x);
			_y = _y + t * (to.y - _y);
			return this;
		}
 
		/*
		 * Project the vector into a vector
		 */
		public function projectSelf( vect:Vector2DConst ):Vector2D
		{
			const s:Number = dot( vect ) / ( vect.length() * vect.length() );
			return scaleSelf( s );
		}
		
		
		
		
	}
}