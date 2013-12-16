package namide.basic.geom 
{
	import namide.basic.geom.Vector2D;
	
	/**
	 * Linear equation
	 * <p>type : y = ax + b ou x = c</p>
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * 
	 * @author namide.com
	 */
	public class Equation2D
	{
		
		private var _a:Number;					// _a for y = ax + b
		private var _b:Number;					// _b for y = ax + b
		private var _c:Number;					// _c for x = c
		
		private var _instance:Equation2D;
		
		/**
		 * Initialisation of the linear equation (of type y = ax + b or x = c)
		 * <p>
		 * You can create an Equation2D object with multiple different initialization :
		 * Use the constructor or the method setByPoints();
		 * <ul>
		 * 		<li>a and b for y = ax + b.</li>
		 * 		<li>a and b two differents Points in the line</li>
		 * 		<li>a = NaN, b = NaN and c for que x = c</li>
		 * </ul>
		 * </p>
		 * 
		 * @param	a		type Number who a for y = ax + b (the slope or grandiant)
		 * @param	b		type Number who b for y = ax + b
		 * @param	c		type Number, if a = NaN and b = NaN, c for x = c (vertical line)
		 * 
		 */
		public function Equation2D(a:Number = 0, b:Number = 0, c:Number = NaN ):void
		{
			_a = a;
			_b = b;
			_c = c;
		}
		
		/**
		 * Calculate Y for y = a x + b
		 * 
		 * @param	x	Abscissa
		 * @return		y
		 */
		public function getY( x:Number ):Number
		{
			if ( !isNaN(_c) )
			{
				return NaN;
			}
			
			return _a * x + _b;
		}
		
		/**
		 * Value a of the linear equation y = ax + b
		 * <p>The angle of the line</p>
		 */
		public function get a():Number { return _a; }
		public function set a(val:Number):void { _a = val; }
		
		/**
		 * Value b of the linear equation y = ax + b
		 * <p>The y position of the line</p>
		 */
		public function get b():Number { return _b; }
		public function set b(val:Number):void { _b = val; }
		
		/**
		 * Value c of the linear equation x = c
		 * <p>If c!=NaN : a = b = NaN and this line is vertical</p>
		 */
		public function get c():Number { return _c; }
		public function set c(val:Number):void { _c = val; }
		
		/**
		 * Initialization of the values a, b and c of the linear equation since 2 differents Points (com.namide.dLib.geom.DVector2D).
		 * 
		 * @param	pt1		First DVector2D for pt1.y = a * pt1.x + b or pt1.x = c
		 * @param	pt2		Second DVector2D different from the first for pt2.y = a * pt2.x + b or pt2.x = c
		 * 
		 * @see com.namide.dLib.geom.DVector2D
		 */
		public function setByPoints(pt1:Vector2D, pt2:Vector2D):Equation2D
		{
			if (pt1.x == pt2.x)
			{
				if (pt1.y == pt2.y)
				{
					_a = NaN;
					_b = NaN;
					_c = NaN;
				}
				else
				{
					_a = NaN;
					_b = NaN;
					_c = pt1.x;
				}
			}
			else
			{
				_a = (pt1.y - pt2.y) / (pt1.x - pt2.x);
				_b = pt1.y - (_a * pt1.x);
				_c = NaN;
			}
			
			return this;
		}
		
		
		/**
		 * Create a DEquation2D starting from 2 Points (com.namide.dLib.geom.DVector2D).
		 * 
		 * @param	pt1		First DVector2D for pt1.y = a * pt1.x + b or pt1.x = c
		 * @param	pt2		Second DVector2D different from the first for pt2.y = a * pt2.x + b or pt2.x = c
		 * @return			DEquation2D
		 * 
		 * @see com.namide.dLib.geom.DVector2D
		 */
		public static function pointsToEquation(pt1:Vector2D, pt2:Vector2D):Equation2D
		{
			var l:Equation2D = new Equation2D();
			l.setByPoints(pt1, pt2);
			
			return l;
		}
		
		/**
		 * Initialization of the values a, b and c of the linear equation starting from l : a perpendicular equation
		 * and a DVector2D, not in l but in the return equation.
		 * 
		 * @param	l		perpendicular equation
		 * @param	pt		DVector2D of the final equation
		 * 
		 * @see com.namide.dLib.geom.DVector2D
		 */
		public function initByOrthogonalEquationAndPoint( l:Equation2D, pt:Vector2DConst ):Equation2D
		{
			
			_a = NaN;
			_b = NaN;
			_c = NaN;
			
			if ( isNaN(l._c) )
			{
				if (l.a == 0)
				{
					_c = pt.x;
				}
				else
				{
					_a = -1 / l._a;
					_b = pt.y - (_a * pt.x);
				}
			}
			else
			{
				_a = 0;
				_b = pt.y;
			}
			
			return this;
		}
		
		/**
		 * Create a new DEquation2D initialised by l (a perpendicular equation) and a (a point of the equation).
		 * 
		 * @param	l		perpendicular equation
		 * @param	pt		DVector2D of the final equation
		 * @return
		 */
		public static function equationByOrthogonalEquationAndPoint( l:Equation2D, pt:Vector2DConst ):Equation2D
		{
			return new Equation2D().initByOrthogonalEquationAndPoint( l, pt );
		}
		
		/**
		 * Angle in radiant of the line
		 * <p>If the rad is 0, the line is horizontal</p>
		 */
		public function getAngleRad():Number
		{
			if 		( !isNaN(_c) ) return 90;
			else if ( !isNaN(_a) ) return Math.atan( _a );
			else 						return NaN;
		}
		
		/**
		 * DVector2D between two lines.
		 * <p>Return <code>null</code> if one of the line is null or if the lines are parrallel.</p>
		 * 
		 * @param	l	line who cut the DEquation2D.
		 * @return		Cross DVector2D between l and the DEquation2D.
		 * 
		 * @see com.namide.dLib.geom.DVector2D
		 */
		public function cross(l:Equation2D):Vector2D
		{			
			if ((this == null) || (l == null)) return null;
			
			var a0:Number = _a;
			var b0:Number = _b;
			var c0:Number = _c;
			var a1:Number = l._a;
			var b1:Number = l._b;
			var c1:Number = l._c;
			var u:Number;

			if ( isNaN(c0) && isNaN(c1) )
			{
				if (a0 == a1) return null; 
				
				u = (b1 - b0) / (a0 - a1);		
				return new Vector2D(u, (a0 * u + b0) );
			}
			else
			{
				if (!isNaN(c0))
				{
					if (!isNaN(c1))
					{
						return null;
					}
					else
					{
						return new Vector2D( c0, (a1 * c0 + b1) );
					}
					
				}
				else if (!isNaN(c1))
				{
					return new Vector2D( c1 , (a0 * c1 + b0) );
				}
			}
			return null;
		}
		
		/**
		 * Evaluates if the DVector2D pt is on the DEquation2D.
		 * 
		 * @param	pt	DVector2D for the test
		 * @return	 true if the DVector2D is on the equation; false if not. 
		 */
		public function hitTestPoint(pt:Vector2D):Boolean
		{
			if ( isNaN(_c) )
			{
				return (pt.y == _a * pt.x + _b);
			}
			else
			{
				return (_c == pt.x);
			}
		}
		
		
		public function toString():String
		{
			return String("(a=" + _a + ", b="+_b + ", c=" + _c+")");
		}
		
	}
		
}