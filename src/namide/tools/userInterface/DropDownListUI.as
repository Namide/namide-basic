package namide.tools.userInterface 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import namide.basic.utils.Signal;
	
	/**
	 * ...
	 * @author namide.com
	 */
	public class DropDownListUI extends Sprite 
	{
		
		protected var _buttons:Vector.<ButtonUI>;
		protected var _topMenu:ButtonUI;
		
		protected var _opened:Boolean = false;
		
		protected var _callbackOpen:Signal;
		protected var _callbackClose:Signal;
		
		public function DropDownListUI() 
		{
			super();
			_callbackOpen = new Signal();
			_callbackClose = new Signal();
		}
		
		
		public function get topMenu():ButtonUI { return _topMenu; }
		public function set topMenu(val:ButtonUI):void
		{
			if ( _topMenu != null )
			{
				_topMenu.callbackClick.remove( onOpenClose );
				if(_topMenu.parent == this) removeChild( _topMenu );
			}
			
			_topMenu = val;
			_topMenu.callbackClick.add( onOpenClose );
			addChild( _topMenu );
			updatePositions();
		}
		
		public function get opened():Boolean { return _opened; }
		
		
		public function getButtons():Vector.<ButtonUI> { return _buttons.concat(); }
		public function addButton( buttons:ButtonUI ):DropDownListUI
		{
			if (_buttons == null) _buttons = new Vector.<ButtonUI>( 0, false );
			
			const i:int = _buttons.length;
			_buttons[i] = buttons;
			addChild( _buttons[i] );
			
			updatePositions();
			return this;
		}
		
		public function addButtons( listButtons:Vector.<ButtonUI> ):DropDownListUI
		{
			if (_buttons == null) _buttons = new Vector.<ButtonUI>( 0, false );
			
			var i:int, j:int
			const l:int = listButtons.length;
			for ( i = 0; i < l; i++ )
			{
				j = _buttons.length;
				_buttons[j] = listButtons[i];
				addChild( _buttons[j] );
			}
			updatePositions();
			return this;
		}
		
		protected function updatePositions():DropDownListUI
		{
			if ( _topMenu == null ) return this;
			_topMenu.y = 0;
			
			if ( _buttons == null ) return this;
			
			var posY:Number = _topMenu.height;
			var i:int;
			const l:int = _buttons.length;
			for ( i = 0; i < l; i++)
			{
				_buttons[i].y = posY;
				posY += _buttons[i].height;
				_buttons[i].visible = _opened;
			}
			
			return this;
		}
		
		protected function onOpenClose( target:IButtonUI ):void { openClose(); }
		public function openClose():void
		{
			if ( _opened ) 	close();
			else 			open();
		}
		
		public function open():DropDownListUI
		{
			if ( _buttons == null || _opened ) return this;
			
			var i:int = _buttons.length;
			while( --i > -1 )
			{
				_buttons[i].visible = true;
			}
			
			_opened = true;
			_callbackOpen.dispatch( this );
			
			addEventListener( MouseEvent.ROLL_OUT, forceClose );
			
			return this;
		}
		
		public function forceClose(e:Event):void { close(); }
		public function close():DropDownListUI
		{
			if ( _buttons == null || !_opened ) return this;
			
			var i:int = _buttons.length;
			while( --i > -1 )
			{
				_buttons[i].visible = false;
			}
			
			_opened = false;
			_callbackClose.dispatch( this );
			
			removeEventListener( MouseEvent.ROLL_OUT, forceClose );
			
			return this;
		}
		
	}

} 