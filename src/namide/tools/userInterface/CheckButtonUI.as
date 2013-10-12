package namide.tools.userInterface 
{
	import namide.basic.utils.ISignal;
	import namide.basic.utils.Signal;
	/**
	 * ...
	 * @author namide.com
	 */
	public class CheckButtonUI extends ButtonUI 
	{
		
		public static const STATE_SELECTED:String = "stateSelected";
		public static const STATE_UNSELECTED:String = "stateUnselect";
		
		protected var _selected:Boolean;
		
		protected var _callbackSelected:Signal;
		protected var _callbackUnselected:Signal;
		
		public function CheckButtonUI() 
		{
			super();
			_selected = false;
			
			_callbackSelected = new Signal();
			_callbackUnselected = new Signal();
			
			_callbackClick.add( function(e:CheckButtonUI):void { changeSelection(); } );
		}
		
		public function changeSelection():CheckButtonUI
		{
			selected = !selected;
			return this;
		}
		
		public function get selected():Boolean { return _selected; }
		public function set selected(val:Boolean):void
		{
			if ( val != _selected )
			{
				_selected = val;
				if ( _selected )	_callbackSelected.dispatch( this );
				else 				_callbackUnselected.dispatch( this );
			} 
		}
		
		
	}

}