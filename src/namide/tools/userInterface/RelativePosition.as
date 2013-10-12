package namide.tools.userInterface 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author namide.com
	 */
	public class RelativePosition 
	{
		
		/**
		 * Position x
		 */
		public static const PROPERTIE_X:uint = 1;
		
		/**
		 * Position y
		 */
		public static const PROPERTIE_Y:uint = 2;
		
		/**
		 * width
		 */
		public static const PROPERTIE_W:uint = 4;
		
		/**
		 * height
		 */
		public static const PROPERTIE_H:uint = 8;
		
		protected var _relativeDataList:Vector.<RelativeDatas>;
		
		public function RelativePosition() 
		{
			_relativeDataList = new Vector.<RelativeDatas>( 0, false );
		}
		
		/**
		 * Add a relative depency between two DisplayObjects
		 * 
		 * @param	target					the child who change when his parent change
		 * @param	targetPropertiesMoves	the children's properties to change
		 * @param	parent					the parent who change his child
		 * @param	parentPropertiesMoves	the parent's properties who change his child
		 * @return	the object RelativePosition
		 */
		public function add( target:DisplayObject, targetPropertiesMoves:uint, parent:DisplayObject, parentPropertiesMoves:uint ):RelativePosition
		{
			var relativeData:RelativeDatas = new RelativeDatas( target, parent );
			relativeData.setTargetMove( testAND(targetPropertiesMoves, PROPERTIE_X),  testAND(targetPropertiesMoves, PROPERTIE_Y),  testAND(targetPropertiesMoves, PROPERTIE_W),  testAND(targetPropertiesMoves, PROPERTIE_H) );
			relativeData.setParentDependencies( testAND(parentPropertiesMoves, PROPERTIE_X),  testAND(parentPropertiesMoves, PROPERTIE_Y),  testAND(parentPropertiesMoves, PROPERTIE_W),  testAND(parentPropertiesMoves, PROPERTIE_H) );
			relativeData.updateDependencies();
			
			_relativeDataList[_relativeDataList.length] = relativeData;
			
			return this;
		}
		
		/**
		 * Update all or by parent.
		 * 
		 * @param	parent
		 * @return
		 */
		public function update( parent:DisplayObject = null ):RelativePosition
		{
			var i:int = _relativeDataList.length;
			var j:int;
			while ( --i > -1 )
			{
				if ( parent == null || _relativeDataList[i].parent == parent )
				{
					if ( _relativeDataList[i].updateTarget() )
					{
						j = _relativeDataList.length;
						while ( --j > -1 )
						{
							if( _relativeDataList[j].parent == _relativeDataList[i].target ) update( _relativeDataList[j].parent );
						}
					}
					
				}
			}
			return this;
		}
		
		/**
		 * Remove all dependencies for a target
		 * 
		 * @param	target
		 * @return
		 */
		public function removeTarget( target:DisplayObject ):RelativePosition
		{
			var i:int;
			while ( (i = search("target", target)) > -1 )
			{
				_relativeDataList.splice( i, 1 );
			}
			
			return this;
		}
		
		/**
		 * Remove all dependencies for a parent
		 * 
		 * @param	target
		 * @return
		 */
		public function removeParent( parent:DisplayObject ):RelativePosition
		{
			var i:int;
			while ( (i = search("parent", parent)) > -1 )
			{
				_relativeDataList.splice( i, 1 );
			}
			
			return this;
		}
		
		protected function search( propertie:String, value:* ):int
		{
			var i:int = _relativeDataList.length;
			while ( --i > -1 ) 
			{
				if ( _relativeDataList[propertie] == value ) return i;
			}
			return -1;
		}
		
		protected function testAND( value:uint, operand:uint ):Boolean { return (value & operand) == operand; }
		
	}

}

import flash.display.DisplayObject;

internal class RelativeDatas
{
	protected var _target:DisplayObject;
	protected var _parent:DisplayObject;
	
	protected var _decalX:Number;
	protected var _decalY:Number;
	protected var _decalW:Number;
	protected var _decalH:Number;
	
	/*protected var _parentX:Number;
	protected var _parentY:Number;
	protected var _parentW:Number;
	protected var _parentH:Number;*/
	
	protected var _moveTargetX:Boolean;
	protected var _moveTargetY:Boolean;
	protected var _moveTargetW:Boolean;
	protected var _moveTargetH:Boolean;
	
	protected var _dependencyParentX:Boolean;
	protected var _dependencyParentY:Boolean;
	protected var _dependencyParentW:Boolean;
	protected var _dependencyParentH:Boolean;
	
	public function RelativeDatas( 	target:DisplayObject, parent:DisplayObject )
	{
		_target = target;
		_parent = parent;
	}
	
	public function setTargetMove( x:Boolean, y:Boolean, w:Boolean, h:Boolean ):RelativeDatas
	{
		_moveTargetX = x;
		_moveTargetY = y;
		_moveTargetW = w;
		_moveTargetH = h;
		return this;
	}
	
	public function setParentDependencies( x:Boolean, y:Boolean, w:Boolean, h:Boolean ):RelativeDatas
	{
		_dependencyParentX = x;
		_dependencyParentY = y;
		_dependencyParentW = w;
		_dependencyParentH = h;
		return this;
	}
	
	public function updateDependencies():RelativeDatas
	{
		var parentDecalX:Number = ( (_dependencyParentX) ? _parent.x : 0 ) + ( (_dependencyParentW) ? _parent.width : 0 );
		var parentDecalY:Number = ( (_dependencyParentY) ? _parent.y : 0 ) + ( (_dependencyParentH) ? _parent.height : 0 );
		
		if ( _moveTargetX ) _decalX = _target.x - parentDecalX;
		if ( _moveTargetY ) _decalY = _target.y - parentDecalY;
		if ( _moveTargetW ) _decalW = _target.width - parentDecalX;
		if ( _moveTargetH ) _decalH = _target.height - parentDecalY;
		
		return this;
	}
	
	public function updateTarget():Boolean
	{
		
		var moved:Boolean = false;
		
		var parentDecalX:Number = ( (_dependencyParentX) ? _parent.x : 0 ) + ( (_dependencyParentW) ? _parent.width : 0 );
		var parentDecalY:Number = ( (_dependencyParentY) ? _parent.y : 0 ) + ( (_dependencyParentH) ? _parent.height : 0 );
		
		
		if ( _moveTargetX && _decalX != _target.x - parentDecalX )
		{
			moved = true;
			_target.x = _decalX + parentDecalX;
		}
		if ( _moveTargetY && _decalY != _target.y - parentDecalY )
		{
			moved = true;
			target.y = _decalY + parentDecalY;
		}
		if ( _moveTargetW && _decalW != _target.width - parentDecalX )
		{
			moved = true;
			_target.width = _decalW + parentDecalX;
		}
		if ( _moveTargetH && _decalH != _target.height - parentDecalY )
		{
			moved = true;
			_target.height = _decalH + parentDecalY;
		}
		
		return moved;
	}
	
	public function get target():DisplayObject { return _target; }
	public function get parent():DisplayObject { return _parent; }
	
}