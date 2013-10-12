package namide.basic.geom 
{
	/**
	 * ...
	 * @author Namide.com
	 */
	public class CurvedPath1D
	{
		
		protected var _anchorValues:Vector.<Number>;
		protected var _path:Vector.<Number>;
		protected var _distances:Vector.<Number>;
		
		public function CurvedPath1D( anchorValues:Vector.<Number>, loop:Boolean = false )
		{
			initFromAnchorPoints( anchorValues, loop );
		}
		
		/**
		 * Get a new CurvedPath1D from an array of anchors :
		 * The anchors are the points which pass the line.
		 * 
		 * @param	anchorValues		List of the values (Number)
		 * @param	loop				For the curve begin and the curve end
		 * @return						A new CurvedPath1D created
		 */
		public static function curvedPath1D( anchorValues:Array /* of Number */, loop:Boolean = false ):CurvedPath1D
		{
			return new CurvedPath1D( Vector.<Number>(anchorValues), loop );
		}
		
		/**
		 * Set the CurvedPath1D from anchors :
		 * The anchors are the points which pass the line.
		 * 
		 * @param	anchorValues		List of the values (Number)
		 * @param	loop				For the curve begin and the curve end
		 * @return						The CurvedPath1D
		 */
		public function initFromAnchorPoints( anchorValues:Vector.<Number>, loop:Boolean = false ):CurvedPath1D
		{
			_anchorValues = anchorValues;
			
			if ( loop && ! ( Math.abs(_anchorValues[_anchorValues.length-1] - _anchorValues[0] ) < 0.0001 ) )
			{
				_anchorValues.fixed = false;
				_anchorValues[_anchorValues.length] = _anchorValues[0];
			}
			_anchorValues.fixed = true;
			
			const anchorLength:int = anchorValues.length;
			const pathLength:int = anchorLength + 2 * (anchorLength - 1);
			
			_path = new Vector.<Number>( pathLength, true );
			var distanceLength:Number = anchorLength - 1;
			_distances = new Vector.<Number>( distanceLength, true );
			var distance:Number;
			var totalDistance:Number = 0;
			
			var prevP:Number, nextP:Number, actuP:Number;
			var i:int = anchorLength;
			var j:int = pathLength - 1;
			var iTriple:int;
			while ( --i > -1 )
			{
				actuP = _anchorValues[i];
				
				if ( i < anchorLength-1 )	nextP = _anchorValues[i + 1];
				else if ( loop )			nextP = _anchorValues[1];
				else						nextP = actuP + actuP - anchorValues[i - 1];
				
				if ( i > 0 )				prevP = anchorValues[i - 1];
				else if ( loop )			prevP = anchorValues[anchorLength - 2];
				else						prevP = actuP + actuP - anchorValues[i + 1];
				
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
				
				distance = 1 / distanceLength;
				if ( i < distanceLength )
				{
					_distances[i] = distance;
				}
			}
			
			return this;
		}
		protected function getControlPoint( p1:Number, p2:Number, p3:Number ):Number
		{
			var length:Number = 0.25;//0.333;
			return ( p3 - p1 ) * length + p2;
		}
		
		public function getAnchorPoints():Vector.<Number> { return _anchorValues; }
		
		public function get path():Vector.<Number> { return _path; }
		public function set path(value:Vector.<Number>):void { _path = value; }
		
		public function getValueAt( time:Number ):Number
		{
			const l:int = _distances.length;
			
			if ( time <= 0 )
			{
				return (_path[1] - _path[0]) * time * 4 / _distances[0] + _path[0];
			}
			if ( time >= 1 )
			{
				const pathLastId:Number = _path.length - 1;
				return (_path[pathLastId] - _path[pathLastId - 1]) * (time - 1) * 4 / (_distances[l - 1]) + _path[pathLastId];
			}
			
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
			const iTriple:int = 3 * i;
			
			const p0:Number = _path[iTriple];
			const p1:Number = _path[iTriple+1];
			const p2:Number = _path[iTriple+2];
			const p3:Number = _path[iTriple+3];
			
			const subT:Number = 1 - t;
			
			return p0 * subT * subT * subT + 3 * p1 * t * subT * subT + 3 * p2 * t * t * subT + p3 * t * t * t;
		}
	}

}