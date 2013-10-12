package namide.basic.utils 
{
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public interface ISignal 
	{
		function add( fct:Function ):Function;
		function remove( fct:Function ):void;
		function removeAll():void;
		
		//function dispatch( ...rest ):void;
	}
	
}