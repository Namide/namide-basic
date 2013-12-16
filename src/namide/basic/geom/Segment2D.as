package namide.basic.geom 
{
	import namide.basic.geom.Vector2D;
	
	/**
	 * DSegment2D is a line segment (the line betwen two points) [ a, b ]
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9
	 * 
	 * @author namide.com
	 */
	public class Segment2D 
	{
		
		private var _a:Vector2D;
		private var _b:Vector2D;
		
		public function Segment2D( a:Vector2D = null, b:Vector2D = null ) 
		{
			_a = ( a == null ) ? new Vector2D() : a;
			_b = ( b == null ) ? new Vector2D() : b;
		}
		
		/**
		 * First point of the segment
		 */
		public function set a(pt:Vector2D):void { _a = pt; }
		public function get a():Vector2D { return _a; }
		
		/**
		 * Second point of the segment
		 */
		public function set b(pt:Vector2D):void { _b = pt; }
		public function get b():Vector2D { return _b; }
		
		/**
		 * Calculate the center of the DVector2D
		 * 
		 * @return DVector2D which is the center of the segment
		 */
		public function getCenter():Vector2D { return _a.interpolateTo( _b, 0.5 ); }
		
		public function getEquation():Equation2D { return (new Equation2D()).setByPoints( _a, _b ); }
		
		public function getCrossOfOrthogonal(vect:Vector2DConst):Vector2D
		{
			var line:Equation2D = Equation2D.equationByOrthogonalEquationAndPoint( getEquation(), vect );
			var cross:Vector2D = crossByEquation(line);
			
			// if the orthogonal equation don't hit the segment
			if ( cross == null ) cross = ( vect.distanceSqrt(_a) < vect.distanceSqrt(_b) ) ? _a : _b ;
			
			return cross;
		}
		
		/**
		 * Return the orthogonal equation of the segment,
		 * this one cross the point in argument.
		 * 
		 * @param	vect	Point who cross the orthogonal equation
		 * @return	orthogonal equation
		 */
		public function getOrthogonalEquation(vect:Vector2D):Equation2D
		{
			return Equation2D.pointsToEquation( getCrossOfOrthogonal(vect), vect );
		}
		
		/**
		 * Return the orthogonal vector of the segment,
		 * <p>This vector represent the direction of the orthogonal line,
		 * the length of the vector is distance between initial point (vect)
		 * and cross of the orthogonal line and the segment.</p>
		 * 
		 * @param	vect	Point who cross the orthogonal equation
		 * @return	orthogonal vector
		 */
		public function getOrthogonalVector(vect:Vector2D):Vector2D
		{
			return getCrossOfOrthogonal(vect).subSelf(vect).negateSelf();
		}
		
		/**
		 * Calculate the point which cross two line segments
		 * 
		 * @param	segment		Second line segment 
		 * @return	DVector2D which cross the two segments
		 */
		public function crossBySegment(segment:Segment2D):Vector2D
		{
			const l1:Equation2D = Equation2D.pointsToEquation( _a, _b );
			const l2:Equation2D = Equation2D.pointsToEquation( segment._a, segment._b );
			var i:Vector2D = l1.cross(l2);
			
			//trace(".", l1, l2, i);
			
			var min:Number, max:Number;
			
			if (i != null)
			{
				if ( _a.x < _b.x )
				{
					min = _a.x;
					max = _b.x
				}
				else
				{
					min = _b.x;
					max = _a.x
				}
				
				if ( i.x < min || i.x > max ) return null;
				
				if ( _a.y < _b.y )
				{
					min = _a.y;
					max = _b.y
				}
				else
				{
					min = _b.y;
					max = _a.y
				}
				
				if ( i.y < min || i.y > max ) return null;
				
				return i;

				/*if ( hitTestPoint(i) && segment.hitTestPoint(i) ) 
				{
					return i;
				}*/
			}
			return null;
		}
		
		/**
		 * Calculate the point which cross a segment and an equation
		 * 
		 * @param	equation	Equation which cross the line segment
		 * @return	DVector2D which cross the segment and the equation
		 * 
		 * @see com.namide.dLib.geom.DEquation2D
		 */
		public function crossByEquation(equation:Equation2D):Vector2D
		{
			const l1:Equation2D = Equation2D.pointsToEquation( _a, _b );
			const l2:Equation2D = equation;
			
			if(l1 == null) return null;
			
			var i:Vector2D = l1.cross(l2);
			
			if (i != null)
			{
				if ( hitTestPoint(i) ) return i;
			}
			
			return null;
		}
		
		/**
		 * Evaluates if the DVector2D pt is on the DSegment2D.
		 * 
		 * @param	pt	DVector2D for the test
		 * @return	 true if the DVector2D is on the line segment; false if not. 
		 */
		public function hitTestPoint(pt:Vector2D):Boolean
		{
			const l1:Equation2D = Equation2D.pointsToEquation( _a, _b );
			
			
			if (l1.hitTestPoint(pt))
			{
				if ( (pt.x >= _a.x && pt.x <= _b.x) || (pt.x <= _a.x && pt.x >= _b.x) )
				{
					if ( (pt.y >= _a.y && pt.y <= _b.y) || (pt.y <= _a.y && pt.y >= _b.y) )
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function isOver( point:Vector2DConst ):Boolean
		{
			const vx:Number = point.x - _a.x;
			const vy:Number = point.y - _a.y;
			const sx:Number = _b.x - _a.x;
			const sy:Number = _b.y - _a.y;
			
			return ( ( (vx * sy) - (vy * sx) ) > 0 );
		}
		
		public function isOverOrOn( point:Vector2DConst ):Boolean
		{
			const vx:Number = point.x - _a.x;
			const vy:Number = point.y - _a.y;
			const sx:Number = _b.x - _a.x;
			const sy:Number = _b.y - _a.y;
			
			return ( ( (vx * sy) - (vy * sx) ) >= 0 );
		}
		
		public function toString():String
		{
			return "( a=" + _a + ", b=" + _b + " )";
		}
		
	}

}