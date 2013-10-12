package namide.framework 
{
	
	/**
	 * ...
	 * @author namide.com
	 */
	public class VO 
	{
		//public static function get TYPE():String { return "VO not defined in the VO Object"; }
		//public function get type():String {	return TYPE; }
		
		public function VO( params:Object = null )
		{
			if ( params != null  )
			{
				for ( var key:String in params )
				{
					this[key] = params[key];
				}
			}
		}
		
		
	}
	
}