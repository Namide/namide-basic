package namide.tools.userInterface 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import namide.basic.utils.ISignal;
	import namide.basic.utils.Signal;
	
	/**
	 * ...
	 * @author namide.com
	 */
	public class ButtonUI extends Sprite implements IButtonUI 
	{
		protected var _callbackFocusIn:Signal;
		protected var _callbackFocusOut:Signal;
		protected var _callbackClick:Signal;
		
		public var userContent:*;
		
		public function ButtonUI() 
		{
			super();
			
			_callbackFocusIn = new Signal();
			_callbackFocusOut = new Signal();
			_callbackClick = new Signal();
			
			initListener();
			
			buttonMode = true;
		}
		
		protected function initListener(e:Event = null):void
		{
			removeListener();
			
			addEventListener( Event.REMOVED_FROM_STAGE, removeListener );
			addEventListener( FocusEvent.FOCUS_IN, focusIn );
			addEventListener( FocusEvent.FOCUS_OUT, focusOut );
			addEventListener( MouseEvent.ROLL_OVER, focusIn );
			addEventListener( MouseEvent.ROLL_OUT, focusOut );
			addEventListener( MouseEvent.CLICK, click );
			
			removeEventListener( Event.ADDED_TO_STAGE, initListener );
		}
		protected function removeListener(e:Event = null):void
		{
			removeEventListener( Event.REMOVED_FROM_STAGE, removeListener );
			removeEventListener( FocusEvent.FOCUS_IN, focusIn );
			removeEventListener( FocusEvent.FOCUS_OUT, focusOut );
			removeEventListener( MouseEvent.ROLL_OVER, focusIn );
			removeEventListener( MouseEvent.ROLL_OUT, focusOut );
			removeEventListener( MouseEvent.CLICK, click );
			
			addEventListener( Event.ADDED_TO_STAGE, initListener );
		}
		
		
		protected function click(e:Event):void
		{
			_callbackClick.dispatch(this);
		}
		
		protected function focusIn(e:Event):void
		{
			_callbackFocusIn.dispatch(this);
		}
		
		protected function focusOut(e:Event):void
		{
			_callbackFocusOut.dispatch(this);
		}
		
		/* INTERFACE namide.tools.userInterface.IButtonUI */
		
		public function get callbackFocusOut():ISignal { return _callbackFocusOut; }
		public function get callbackFocusIn():ISignal { return _callbackFocusIn; }
		public function get callbackClick():ISignal { return _callbackClick; }
		
		
	}

}