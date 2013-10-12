package namide.basic.utils 
{
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class Debug 
	{
		protected static var MAIN:Debug;
		
		protected var _debugMode:Boolean;
		
		protected var _message:String;
		protected var _t:Vector.<uint>;
		
		
		public function Debug() 
		{
			_debugMode = false;
			_message = "";
			_t = new Vector.<uint>(0, false);
		}
		
		public static function getInstance():Debug
		{
			if ( MAIN == null ) MAIN = new Debug();
			return MAIN;
		}
		
		public function add( message:String, tabLength:int = 0 ):void
		{
			if ( !_debugMode ) return void;
			
			var tab:String = "";
			if (tabLength > 0) for ( var i:int = 0; i < tabLength; i++ ) tab += "\t";
			
			_message += ( _message == "" ) ? (tab + message) : ( "\n" + tab + message );
		}
		
		public function addTimed( message:String, timeID:int = -1, initTimer:Boolean = false ):void
		{
			if ( !_debugMode ) return void;
			if ( initTimer )
			{
				initializeTimer( timeID );
				return void;
			}
			
			var tab:String = "";
			if (timeID > 0) for ( var i:int = 0; i < timeID; i++ ) tab += "\t";
			
			_message += ( _message == "" ) ? (tab + message) : ( "\n" + tab + message );
			
			if ( timeID > -1 ) writeTime( timeID );
		}
		
		protected function initializeTimer( id:uint ):void
		{
			while ( _t.length <= id ) _t[_t.length] = getTimer();
			_t[id] = getTimer();
		}
		
		protected function writeTime( id:uint ):void
		{
			while ( _t.length <= id ) _t[_t.length] = getTimer();
			_message += " - t:" + (getTimer() - _t[id]) / 1000 + "s";
			_t[id] = getTimer();
		}
		
		public function traceMessage():void
		{
			if ( !_debugMode ) return void;
			
			addTimed( "--------------------" )
			
			if ( Math.random() < 0.1 )
			{
				trace( _message );
				_message = "";
			}
			
		}
		
		public function get debugMode():Boolean { return _debugMode; }
		public function set debugMode(value:Boolean):void { _debugMode = value; }
	}

}