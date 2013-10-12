package namide.basic.utils 
{
	/**
	 * Callback replaces the event model.
	 * 
	 * @author Damien Doussaud - namide.com
	 */
	public class Signal implements ISignal
	{
		protected var _callback:Vector.<Function>;
		
		// add or remove during the dispatch
		protected var _dispatch:Boolean;
		protected var _removedTemp:Vector.<Function>;
		protected var _addedTemp:Vector.<Function>;
		
		
		public function Signal() { }
		
		public function add( fct:Function ):Function
		{
			if ( _callback == null ) 	_callback = new Vector.<Function>( 0, false );
			else						remove( fct );
			
			if ( _dispatch )
			{
				if ( _addedTemp == null ) 	_addedTemp = Vector.<Function>([fct]);
				else						_addedTemp[_addedTemp.length] = fct;
			}
			else
			{
				_callback.splice( 0, 0, fct );
			}
			
			return fct;
		}
		
		/*public function addAt( fct:Function, i:int ):Function
		{
			if ( _callback == null || i >= _callback.length ) add( fct );
			
			_callback.splice( i, 0, fct );
			return fct;
		}*/
		
		public function remove( fct:Function ):void
		{
			if ( _callback == null ) return ;
			
			const i:int = _callback.indexOf( fct );
			if ( _dispatch )
			{
				if ( _removedTemp == null ) _removedTemp = Vector.<Function>([fct]);
				else						_removedTemp[_removedTemp.length] = fct;
			}
			else if ( i > -1 )
			{
				_callback.splice( i, 1 );
			}
		}
		
		public function removeAll():void
		{
			if ( _callback == null ) return ;
			
			if ( _dispatch )
			{
				_removedTemp = _callback.concat();
			}
			else
			{
				_callback = null;
			}
			
		}
		
		/*public function replace( oldFct:Function, newFct:Function ):Function
		{
			var i:int = _callback.indexOf(oldFct);
			if (i > -1) _callback[i] = newFct;
			else		add( newFct );
			
			return newFct;
		}*/
		
		
		public function dispatch( ...rest ):void
		{
			if ( _callback == null ) return ;
			
			_dispatch = true;
			
			var i:int = _callback.length;
			loop:while ( --i > -1 ) 
			{
				if ( _removedTemp )
				{
					if ( _removedTemp.indexOf( _callback[i] ) > -1 ) continue loop;
				}
				_callback[i].apply( null , rest );
			}
			
			_dispatch = false;
			
			if ( _removedTemp != null )
			{
				i = _removedTemp.length;
				while ( --i > -1 )
				{
					remove( _removedTemp[i] );
				}
				_removedTemp = null;
			}
			if ( _addedTemp != null )
			{
				i = _addedTemp.length;
				while ( --i > -1 ) 
				{
					_addedTemp[i].apply( null , rest );
				}
				
				_callback = _callback.concat( _addedTemp );
				_addedTemp = null;
			}
			
		}
		
		public function getCallbackLength():uint
		{
			return ( _callback != null ) ? _callback.length : 0;
		}
	}

}