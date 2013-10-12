package namide.basic.geom 
{
	import namide.basic.geom.Vector2D;
	
	/**
	 * DPolygon represent all of the Points of a polygon 2D.
	 * 
	 * @author namide.com
	 */
	public class Polygon2D 
	{
		
		protected var _path:Vector.<Number>;
		
		public function Polygon2D(pPath:Vector.<Number> = null) 
		{
			if (pPath == null) _path = new Vector.<Number>(0, false);
			else path = pPath;
		}
		
		/**
		 * A Vector of Numbers where each pair of numbers is treated as a coordinate location (an x, y pair).
		 * The x- and y-coordinate value pairs are not DVector2D objects;
		 * the data vector is a series of numbers where each group of two numbers represents a coordinate location.
		 * All of this points represent a polygon.
		 */
		public function get path():Vector.<Number> { return _path; }
		public function set path( pPath:Vector.<Number> ):void
		{
			_path = pPath;
			_path.fixed = false;
			const last:int = _path.length;
			if ( ( _path[0] != _path[last - 2] ) || ( _path[1] != _path[last - 1] ) ) _path.push( _path[0], _path[1] );
		}
		
		/**
		 * All of the points of the path.
		 * 
		 * @return A Vector with DVector2D for all points of the path
		 */
		public function getPathVector():Vector.<Vector2D>
		{
			var i:int;
			const l:int = _path.length >> 1;
			var pathDVector2D:Vector.<Vector2D> = new Vector.<Vector2D>( l, true );
			
			i = l;
			while(--i>-1)
			{
				pathDVector2D[i] = new Vector2D( _path[i+i], _path[i+i+1] );
			}
			
			return pathDVector2D;
		}
		
		/**
		 * Edit the path by a path of DVector2D
		 * 
		 * @param	pathVector		The path of DVector2D for initialisation
		 */
		public function setByPathVector( pathVector:Vector.<Vector2D> ):Polygon2D
		{
			var i:int = pathVector.length;
			_path = new Vector.<Number>(i << 1, true);
			
			while( --i > -1 )
			{
				_path[ (i + i) ] = pathVector[i].x;
				_path[ (i + i) + 1 ] = pathVector[i].y;
			}
			
			return this;
		}
		
		public function setByEdgeXFL( edge:String ):Polygon2D
		{
			edge = edge.split("\n").join("").split("\r").join("");
			const div:Number = 1 / 20;
			
			var listOfPoints:Array = edge.split("!").join("|").split("|");
			listOfPoints.shift();
			var i:int = listOfPoints.length;
			while( --i > -1 )
			{
				listOfPoints[i] = listOfPoints[i].split(" ");
				listOfPoints[i] = new Vector2D( Number(listOfPoints[i][0]) * div, Number(listOfPoints[i][1]) * div );
			}
			
			i = listOfPoints.length;
			while( --i > -1 )
			{
				if ( isNaN(listOfPoints[i].x) || isNaN(listOfPoints[i].y) )
				{
					listOfPoints.splice( i, 1 );
				}
				else if ( i > 0 && listOfPoints[i].isNear(listOfPoints[i - 1] ) )
				{
					listOfPoints.splice( i, 1 );
				}
			}
			
			return setByPathVector( Vector.<Vector2D>( listOfPoints ) );
		}
		
		/**
		 * Calculates a convex polygon and change his path.
		 */
		public function convertToConvexForm():void
		{
			var i:int, j:int;
			var listPoints:Vector.<Vector2D> = getPathVector();
			
			var outList:Vector.<Vector2D> = new Vector.<Vector2D>(0, false);
			
			i = listPoints.length;
			while(--i>-1)
			{
				if(outList.length == 0)					outList[0] = listPoints[i];
				else if(listPoints[i].x > outList[0].x)	outList[0] = listPoints[i];
			}
			
			var state:int = 0;
			var choice:Boolean = false;
			search : while(true)
			{
				j = outList.length - 1;
				
				if(state == 0)
				{
				
					choice = false;
					i = listPoints.length;
					while(--i>-1)
					{
						if( !outList[j].equals(listPoints[i]) )
						{
							if(Math.atan2( listPoints[i].y - outList[j].y, listPoints[i].x - outList[j].x ) > 0)
							{
								if( !choice )
								{
									outList[j+1] = listPoints[i];
									choice = true;
								}
								else if( Math.atan2( listPoints[i].y - outList[j].y, listPoints[i].x - outList[j].x ) < Math.atan2( outList[j+1].y - outList[j].y , outList[j+1].x - outList[j].x ) )
								{
									outList[j+1] = listPoints[i];
									choice = true;
								}
							}
						}
					}
					
					if(!choice) 
					{
						state++;
					}
					
				}
				else if(state == 1)
				{
					
					choice = false;
					i = listPoints.length;
					while(--i>-1)
					{
						if( !outList[j].equals(listPoints[i]) )
						{
							if( Math.atan2( listPoints[i].y - outList[j].y, listPoints[i].x - outList[j].x ) <= 0)
							{
								if( !choice )
								{
									outList[j+1] = listPoints[i];
									choice = true;
								}
								else if( Math.atan2( listPoints[i].y - outList[j].y, listPoints[i].x - outList[j].x ) < Math.atan2( outList[j+1].y - outList[j].y , outList[j+1].x - outList[j].x  ) )
								{
									outList[j+1] = listPoints[i];
									choice = true;
								}
							}
						}
					}
					
					if(!choice) 
					{
						state--;
					}
					
				}
				
				if(outList[outList.length - 1].equals(outList[0])) break search;
			}
			
			setByPathVector( outList );
		}
		
		public function invertVertixesOrientation():void
		{
			const l:int = _path.length * 0.5;
			var newPath:Vector.<Number> = new Vector.<Number>( l + l, true );
			
			var i:int = l;
			var i2:int;
			while ( --i > -1 )
			{
				i2 = i + i;
				newPath[i2] = _path[ l - (1 + i2) ];
				newPath[i2+1] = _path[ l - (1 + i2) ];
			}
			
		}
		
		/**
		 * Area of the polygon.
		 * 
		 * @return
		 */
		public function area():Number
		{
			var a:Number = areaSigned();
			return (a < 0) ? a * -1 : a
		}
		
		public function areaSigned():Number
		{
			var i:int = (_path.length * 0.5) - 2;
			var area:Number = 0;
			var i2:int;
			while (--i>-1)
			{
				i2 = i+i;
				area += _path[i2] * _path[i2 + 3] - _path[i2 + 2] * _path[i2 + 1];
			}
			area *= 0.5;
			return area;
		}
		
		/**
		 * Circular motion in the same direction as a clock's hands:
		 * from the top to the right, then down and then to the left, and back to the top.
		 * 
		 * @return	true if the points are in the clockwise
		 */
		public function isClockwise():Boolean
		{
			return areaSigned() > 0;
		}
		
		/**
		 * Calculate the most nearest segment of a point and return this.
		 * 
		 * @param	vect	Point for the calculations
		 * @return	The most nearest segment of a point
		 */
		public function getNearestSegmentOfPoint( vect:Vector2D ):Segment2D
		{
			var line:Equation2D = new Equation2D();
			var segm:Segment2D;
			var cross:Vector2D;
			var dist:Number;
			
			var segmMin:Segment2D;
			var distMin:Number = Number.POSITIVE_INFINITY;
			
			var segments:Vector.<Segment2D> = getSegments();
			var i:int = segments.length;
			while ( --i > -1 )
			{
				segm = segments[i];
				line.initByOrthogonalEquationAndPoint( segm.getEquation(), vect );
				cross = segm.crossByEquation(line);
				if ( cross != null )
				{
					dist = cross.distanceSqrt(vect);
					if ( dist < distMin )
					{
						distMin = dist;
						segmMin = segm;
					}
				}
				
				dist = segm.a.distanceSqrt(vect);
				if ( dist < distMin )
				{
					distMin = dist;
					segmMin = segm;
				}
				
				dist = segm.b.distanceSqrt(vect);
				if ( dist < distMin )
				{
					distMin = dist;
					segmMin = segm;
				}
			}
			
			return segmMin;
		}
		
		/**
		 * The average sum of all points of the path of the polygon.
		 * 
		 * @return DVector2D Center of the polygon
		 */
		public function getCenter():Vector2D
		{
			var center:Vector2D = new Vector2D();
			const l:int = _path.length;
			var i:int = l;
			while (--i > -1)
			{
				if ( i % 2 ) 	center.x += _path[i];
				else 			center.y += _path[i];				
			}
			return center.scaleSelf( 2 / l );
		}
		
		/**
		 * Calculate a list of the polygon's segments.
		 * 
		 * @return		a list of the polygon's segments
		 */
		public function getSegments():Vector.<Segment2D>
		{
			var i:int = _path.length;
			var segments:Vector.<Segment2D> = new Vector.<Segment2D>( i * 0.5 - 1, true );
			i -= 4;
			while ( i > -1 )
			{
				segments[i * 0.5] = new Segment2D( new Vector2D( _path[i], _path[i + 1] ), new Vector2D( _path[i + 2], _path[i + 3] ) );
				i -= 2;
			}
			return segments;
		}
		
		/**
		 * Evaluates if the polygons are intersected.
		 * 
		 * @param	poly	New polygon to evaluated
		 * @return	true if is intersected; false if not
		 */
		public function hitTestPolygon( poly:Polygon2D ):Boolean
		{
			return hitTestPolygons( this, poly );
			/*var vect:DVector2D = poly.getCenter();
			
			if ( hitTestPoint( vect ) ) return true;
			
			var i:int = poly._path.length - 2;
			while ( i > -1 )
			{
				vect.x = poly._path[i];
				vect.y = poly._path[i+1];
				
				if ( hitTestPoint( vect ) ) return true;
				
				i -= 2;
			}
			return false;*/
		}
		
		public static function hitTestPolygons( poly1:Polygon2D, poly2:Polygon2D ):Boolean
		{
			var vect:Vector2D = poly1.getCenter();
			if ( poly2.hitTestPoint( vect ) ) return true;
			vect = poly2.getCenter();
			if ( poly1.hitTestPoint( vect ) ) return true;
			
			var i:int = poly1._path.length - 2;
			while ( i > -1 )
			{
				vect.x = poly1._path[i];
				vect.y = poly1._path[i+1];
				
				if ( poly2.hitTestPoint( vect ) ) return true;
				
				i -= 2;
			}
			
			i = poly2._path.length - 2;
			while ( i > -1 )
			{
				vect.x = poly2._path[i];
				vect.y = poly2._path[i+1];
				
				if ( poly1.hitTestPoint( vect ) ) return true;
				
				i -= 2;
			}
			
			return false;
		}
		
		/**
		 * Return the list of the points of the path in this polygon.
		 * 
		 * @param	path	path which its points are tested
		 * @return			List of points in the polygon
		 */
		public function getPointsInPolygonByPath( path:Vector.<Number> ):Vector.<Vector2D>
		{
			var list:Vector.<Vector2D> = new Vector.<Vector2D>( 0, false );
			
			var vect:Vector2D = new Vector2D();
			var i:int = path.length - 2;
			while ( i > -1 )
			{
				vect.x = path[i];
				vect.y = path[i+1];
				
				if ( hitTestPoint( vect ) ) list[list.length] = vect.clone();
				
				i -= 2;
			}
			return list;
		}
		
		/**
		 * Evaluates if the DVector2D pt is in the polygon.
		 * 
		 * @param	pt	DVector2D for the test
		 * @return	true if the DVector2D is in the polygon; false if not. 
		 */
		public function hitTestPoint(pt:Vector2D):Boolean
		{
			var col:int = 0;
			var l:Equation2D = new Equation2D(0, 0, pt.x);
			var crossPt:Vector2D;
			
			
			var segment:Segment2D = new Segment2D( new Vector2D( _path[0], _path[1]), new Vector2D( _path[_path.length - 2], _path[_path.length - 1]) );
			if ( !segment.a.equals(segment.b) )
			{
				crossPt = segment.crossByEquation(l);
				if ( crossPt != null ) col += (crossPt.y < pt.y) ? 1 : 0;
			}
			
			
			var i:int = _path.length * 0.5 - 1;
			while (--i > -1)
			{
				segment.a.x = _path[i + i];
				segment.a.y = _path[i + i + 1];
				segment.b.x = _path[i + i + 2];
				segment.b.y = _path[i + i + 3];
				crossPt = segment.crossByEquation(l);
				
				if ( crossPt != null ) 
				{
					if ( crossPt.y >= pt.y && !crossPt.equals(segment.a) )
					{
						col += 1;
					}
				}
			}
			
			return col % 2 == 1;
		}
		
		/**
		 * Calculates a convex polygon and change the path.
		 * The path is a Vector of Numbers where each pair of numbers is treated as a coordinate location (an x, y pair).
		 * The x- and y-coordinate value pairs are not DVector2D objects;
		 * the data vector is a series of numbers where each group of two numbers represents a coordinate location.
		 * All of this points represent a polygon.
		 * 
		 * @param	path	Vector of Numbers where each pair of numbers is treated as a coordinate location (an x, y pair)	
		 * @return	New path of a convex polygon
		 */
		public static function pathToPathConvexForm(path:Vector.<Number>):Vector.<Number>
		{
			var p:Polygon2D = new Polygon2D( path );
			p.convertToConvexForm();
			return p.path;
		}
		
		public function toString():String
		{
			var s:String = "(";
			const l:int = path.length;
			var i:int = 0;
			
			for ( i = 0; i < l; i+=2 )
			{
				s += " (x=" + path[i] + ", y=" + path[i+1] + ")";
			}
			s += " )";
			return s;
		}
	}

}