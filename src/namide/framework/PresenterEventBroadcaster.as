package namide.framework 
{
	import namide.basic.utils.ISignal;
	/**
	 * ...
	 * @author namide.com
	 */
	public class PresenterEventBroadcaster 
	{
		protected static var _INTERFACE:PresenterEventBroadcaster;
		public static function getInterface():PresenterEventBroadcaster
		{
			if ( _INTERFACE == null ) PresenterEventBroadcaster._INTERFACE = new PresenterEventBroadcaster(new Key());
			return _INTERFACE;
		}
		
		protected var _registered:Object;
		
		public function PresenterEventBroadcaster(key:Key)
		{
			_registered = { };
		}
		
		public function addListener( fct:Function, VOClass:Class ):void
		{
			//trace( "addListener", VOClass.TYPE )
			if ( _registered[VOClass.TYPE] == null ) _registered[VOClass.TYPE] = new Vector.<Function>(0, false);
			var v:Vector.<Function> = _registered[VOClass.TYPE];
			v[v.length] = fct;
		}
		
		public function removeListener( fct:Function, VOClass:Class ):void
		{
			const type:String = (new VOClass() as IVO).type;
			if ( _registered[type] != null )
			{
				var v:Vector.<Function> = _registered[type];
				while( v.indexOf(fct) > -1 ) v.splice( v.indexOf(fct), 1 );
			}
		}
		
		public function suscribe( callback:ISignal ):void { callback.add( dispatch ); }
		public function unsuscribe( callback:ISignal ):void	{ callback.remove( dispatch ); }
		
		/**
		 * Prefer suscribe !
		 * 
		 * @param	valueObject
		 */
		public function dispatch( valueObject:IVO ):void
		{
			const eventType:String = valueObject.type;
			if ( _registered[eventType] != null )
			{
				var v:Vector.<Function> = _registered[eventType];
				var i:int = v.length;
				while ( --i > -1 )
				{
					v[i].apply( null, [valueObject] );
				}
			}
		}
		
	}
}

internal class Key {}