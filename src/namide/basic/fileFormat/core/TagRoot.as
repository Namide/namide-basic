package namide.basic.fileFormat.core 
{
	import namide.basic.utils.Signal;
	
	/**
	 * ...
	 * @author Namide
	 */
	public class TagRoot extends Tag 
	{
		protected var _error:Signal;
		
		public function TagRoot( errorCallBack:Signal ) 
		{
			super();
			_error = errorCallBack;
		}
		
		public function get error():Signal { return _error; }
		public function set error(value:Signal):void { _error = value; }
		
		override protected function dispatchError( message:String ):void
		{
			_error.dispatch( message );
		}
		
	}

}