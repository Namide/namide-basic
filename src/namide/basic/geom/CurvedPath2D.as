package namide.basic.geom 
{
	/**
	 * ...
	 * @author Namide.com
	 */
	public class CurvedPath2D 
	{
		
		protected var _anchorPoints:Vector.<Vector2D>;
		protected var _path:Vector.<Vector2D>;
		protected var _distances:Vector.<Number>;
		
		public function CurvedPath2D( anchorPoints:Vector.<Vector2D>, loop:Boolean = false )
		{
			initByAnchorPoints( anchorPoints, loop );
		}
		
		public function initByAnchorPoints( anchorPoints:Vector.<Vector2D>, loop:Boolean = false ):CurvedPath2D
		{
			_anchorPoints = anchorPoints;
			
			if ( loop && !_anchorPoints[_anchorPoints.length - 1].isNear( _anchorPoints[0] ) )
			{
				_anchorPoints.fixed = false;
				_anchorPoints[_anchorPoints.length] = _anchorPoints[0];
			}
			_anchorPoints.fixed = true;
			
			const anchorLength:int = _anchorPoints.length;
			const pathLength:int = anchorLength + 2 * (anchorLength - 1);
			
			_path = new Vector.<Vector2D>( pathLength, true );
			var distanceLength:Number = anchorLength - 1;
			_distances = new Vector.<Number>( distanceLength, true );
			var distance:Number;
			var totalDistance:Number = 0;
			
			var prevP:Vector2D, nextP:Vector2D, actuP:Vector2D;
			var i:int = anchorLength;
			var j:int = pathLength - 1;
			var iTriple:int;
			while ( --i > -1 )
			{
				actuP = _anchorPoints[i];
				
				if ( i < anchorLength-1 )	nextP = _anchorPoints[i + 1];
				else if ( loop )			nextP = _anchorPoints[1];
				else						nextP = actuP.add( actuP.sub( _anchorPoints[i - 1] ) );
				
				if ( i > 0 )				prevP = _anchorPoints[i - 1];
				else if ( loop )			prevP = _anchorPoints[anchorLength - 2];
				else						prevP = actuP.add( actuP.sub( _anchorPoints[i + 1] ) );
				
				iTriple = 3 * i;
				if ( i == 0 )
				{
					_path[i] = actuP;
					_path[i + 1] = getControlPoint( prevP, actuP, nextP );
				}
				else if ( i > distanceLength-1 )
				{
					_path[iTriple - 1] = getControlPoint( nextP, actuP, prevP );
					_path[iTriple] = actuP;
				}
				else
				{
					_path[iTriple - 1] = getControlPoint( nextP, actuP, prevP );
					_path[iTriple] = actuP;
					_path[iTriple + 1] = getControlPoint( prevP, actuP, nextP );
				}
				
				if ( i < distanceLength )
				{
					distance = _path[iTriple + 1].sub( actuP ).length();
					_distances[i] = distance;
					totalDistance += distance;
				}
			}
			
			i = distanceLength;
			while ( --i > -1 )
			{
				_distances[i] /= totalDistance;
			}
			
			return this;
		}
		protected function getControlPoint( p1:Vector2D, p2:Vector2D, p3:Vector2D ):Vector2D
		{
			var length:Number = p3.sub( p2 ).length() * 0.333;
			return p3.sub( p1 ).normalizeSelf().scaleSelf( length ).addSelf( p2 );
		}
		
		public function getAnchorPoints():Vector.<Vector2D> { return _anchorPoints; }
		
		public function get path():Vector.<Vector2D> { return _path; }
		public function set path(value:Vector.<Vector2D>):void { _path = value; }
		
		public function getPositionAt( time:Number ):Vector2D
		{
			const l:int = _distances.length;
			
			if ( time <= 0 )
			{				
				return _path[1].sub( _path[0] ).scaleSelf( time * 4 / _distances[0] ).addSelf( _path[0] );
			}
			if ( time >= 1 )
			{
				const pathLastId:Number = _path.length - 1;
				return _path[pathLastId].sub( _path[pathLastId - 1] ).scaleSelf( (time - 1) * 4 / (_distances[l - 1]) ).addSelf( _path[pathLastId] );
			}
			
			var pos:Vector2D = new Vector2D();
			
			var i:int = 0;
			var distPrev:Number = 0;
			var distNext:Number = 0;
			loopDist : while ( i < l )
			{
				distNext += _distances[i];
				if ( time <= distNext )
				{
					break loopDist;
				}
				distPrev = distNext;
				i++;
			}
			
			const t:Number = ( time - distPrev ) / ( distNext - distPrev );
			
			if ( t >= 1 )
			{
				pos.x = _anchorPoints[i+1].x;
				pos.y = _anchorPoints[i+1].y;
				return pos;
			}
			else if ( t<=0 )
			{
				pos.x = _anchorPoints[i].x;
				pos.y = _anchorPoints[i].y;
				return pos;
			}
			
			const iTriple:int = 3 * i;
			
			const p0:Vector2D = _path[iTriple];
			const p1:Vector2D = _path[iTriple+1];
			const p2:Vector2D = _path[iTriple+2];
			const p3:Vector2D = _path[iTriple+3];
			
			const subT:Number = 1 - t;
			pos.x = p0.x * subT * subT * subT + 3 * p1.x * t * subT * subT + 3 * p2.x * t * t * subT + p3.x * t * t * t;
			pos.y = p0.y * subT * subT * subT + 3 * p1.y * t * subT * subT + 3 * p2.y * t * t * subT + p3.y * t * t * t;
			
			return pos;
		}
	}

}