package namide.basic.utils 
{

	//import org.osflash.signals.ISignal;
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public interface IDistortedTime 
	{
		function get onEnterFrame():ISignal;
		//function set onEnterFrame( value:ICallback ):void;
		
		//function addOnEnterFrame( fct:Function ):Function;
		//function removeOnEnterFrame( fct:Function ):void;
		
		function start( time:uint = 0 ):void;
		
		function get speed():Number;
		function set speed( value:Number ):void;
		
		function get dTMilliseconds():uint;
		function get dTSeconds():Number;
		function get timerMilliseconds():uint;
		function get timerSeconds():Number;
		function getTimerMilliseconds():uint;
		
		function addCallbackTimeLoop( fct:Function, time:uint, params:Array = null, loopNumber:int = 0, loopTime:uint = 0 ):Function;
		function addCallbackDelayLoop( fct:Function, delay:uint, params:Array = null, loopNumber:int = 0, loopTime:uint = 0 ):Function;
		function clearCallbackLoop( fct:Function ):void;
		
	}
	
}