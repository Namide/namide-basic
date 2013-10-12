package namide.basic.media 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import namide.basic.utils.ISignal;
	
	/**
	 * ...
	 * @author Namide
	 */
	public interface ISound 
	{
		
		function get onPlayed():ISignal;
		function get onPaused():ISignal;
		function get onStopped():ISignal;
		
		function get onPlayProgress():ISignal;
		function get onEnd():ISignal;
		
		function get onError():ISignal;
		function get onReadyToPlay():ISignal;
		function isPlayable():Boolean;
		
		
		
		function play( time:int = -1 ):ISound;
		function pause():ISound;
		function stop():ISound;
		
		function get volume():Number;
		function set volume( val:Number ):void;
		function setVolume( val:Number ):ISound
		
		function get loop():int;
		function set loop( val:int ):void;
		function setLoop( val:int ):ISound
		
		function get sound():Sound;
		function get soundChannel():SoundChannel;
		function get soundTransform():SoundTransform;
		
		
		function get type():String;
		function set type( val:String ):void;
		function setType( val:String ):ISound
		
		function get isPlaying():Boolean;
		function set isPlaying( val:Boolean ):void;
		function setPlay( val:Boolean ):ISound
		
		function get autoPlay():Boolean;
		function set autoPlay( val:Boolean ):void;
		function setAutoPlay( val:Boolean ):ISound
		
		function get currentTime():uint;
		function set currentTime( val:uint ):void;
		function setCurrentTime( val:uint ):ISound
		
		function get totalTime():uint;
		
		
		function dispose():void;
	}
	
}