package namide.basic.display 
{
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public interface IBitmapAnimated
	{
		function play():void;
		function stop():void;
		
		function gotoAndStop( frame:Object ):void;
		function gotoAndPlay( frame:Object ):void;
		
		function nextFrame():void;
		function prevFrame():void;
		
		function get currentFrame():int;
		function get currentFrameLabel():String;
		function get currentLabel():String;
		function get currentLabels():Array;
		
		function get totalFrames():int;
	}
	
}