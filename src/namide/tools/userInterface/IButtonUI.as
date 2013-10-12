package namide.tools.userInterface 
{
	import namide.basic.utils.ISignal;
	
	/**
	 * ...
	 * @author namide.com
	 */
	public interface IButtonUI 
	{
		function get callbackFocusOut():ISignal;
		function get callbackFocusIn():ISignal;
		function get callbackClick():ISignal;
	}
	
}