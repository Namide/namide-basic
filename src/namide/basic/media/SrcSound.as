package namide.basic.media 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import namide.basic.utils.ISignal;
	import namide.basic.utils.Signal;
	
	/**
	 * ...
	 * @author Namide
	 */
	public class SrcSound implements ISound 
	{
		
		protected var _onLoadProgress:Signal;
		private var _onPlayed:Signal;
		private var _onPaused:Signal;
		private var _onStopped:Signal;
		private var _onPlayProgress:Signal;
		private var _onEnd:Signal;
		private var _onError:Signal;
		private var _onReadyToPlay:Signal;
		
		private var _volume:Number = 1;
		private var _loop:int = 0;
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		
		private var _type:String = "default";
		private var _isPlaying:Boolean = false;
		private var _autoPlay:Boolean = true;
		
		protected var _loadProgress:Number = 0;
		public function get loadProgress():Number { return (_sound.bytesLoaded<1) ? 0 : (_sound.bytesLoaded / _sound.bytesTotal); }
		
		protected var _isPlayable:Boolean = false;
		
		protected var _src:String;
		protected var _pauseTime:uint = 0;
		
		public function SrcSound()
		{
			_onLoadProgress = new Signal();
			_onPlayed = new Signal();
			_onPaused = new Signal();
			_onStopped = new Signal();
			_onPlayProgress = new Signal();
			_onEnd = new Signal();
			_onError = new Signal();
			_onReadyToPlay = new Signal();
			
			_soundTransform = new SoundTransform( 1, 0 );
		}
		
		
		public function setSrcAndLoad( src:String ):SrcSound
		{
			_src = src;
			
			var request:URLRequest = new URLRequest(_src);
			const self:SrcSound = this;
			
			_sound = new Sound();
			
			try
			{
				_sound.load( request );
				//if ( _autoPlay ) play( _pauseTime );
			}
			catch (e:Error)
			{
				_onError.dispatch( self, e.message );
			}
			
			_soundTransform = new SoundTransform( _volume );
			
			
			_sound.addEventListener( ProgressEvent.PROGRESS, function(e:ProgressEvent):void
			{
				_onLoadProgress.dispatch( self );
			}, false, 0, true);
			_sound.addEventListener( Event.COMPLETE , function(e:Event):void
			{
				_isPlayable = true;
				
				try
				{
					if ( self.autoPlay )	self.play( -1 );
					else 					self.pause();
				}
				catch (e:Error)
				{
					_onError.dispatch( self, e.message );
				}
				
				_onReadyToPlay.dispatch( self );
				
			}, false, 0, true);
			_sound.addEventListener( IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
			{
				_onError.dispatch( self, e.text );
			}, false, 0, true);
			_sound.addEventListener( SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void
			{
				_onError.dispatch( self, e.text );
			}, false, 0, true);
			
			return this;
		}
		
		
		/* INTERFACE namide.basic.media.ISound */

		public function get onPlayed():ISignal { return _onPlayed; }
		public function get onPaused():ISignal { return _onPaused; }

		public function get onStopped():ISignal { return _onStopped; }
		public function get onPlayProgress():ISignal { return _onPlayProgress; }

		public function get onEnd():ISignal { return _onEnd; }
		public function get onError():ISignal {	return _onError; }

		public function get onReadyToPlay():ISignal { return _onReadyToPlay; }

		public function isPlayable():Boolean { return _isPlayable; }

		public function play(time:int = -1):ISound 
		{
			if ( time < 0 ) time = _pauseTime;
			if ( time < 0 ) time = 0;
			
			if ( _sound )
			{
				_isPlaying = true;
				
				var self:SrcSound = this;
				
				_soundChannel = _sound.play( time, 0, _soundTransform );
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, function(e:Event):void
				{
					_onEnd.dispatch( self );
					if ( _loop-- > 0 ) 	self.play( _pauseTime );
					else 				self.stop();
				}, false, 0, true );
				
				_onPlayed.dispatch( this );
			}
			else
			{
				_pauseTime = time;
				_autoPlay = true;
			}
			
			return this;
		}

		public function pause():ISound 
		{
			_pauseTime = currentTime;
			_isPlaying = false;
			_autoPlay = false;
			
			if ( _soundChannel )
			{
				_pauseTime = _soundChannel.position;
				_soundChannel.stop();
				_onPaused.dispatch( this );
			}
			
			return this;
		}

		public function stop():ISound 
		{
			_isPlaying = false;
			_autoPlay = false;
			_pauseTime = 0;
			
			if ( _soundChannel )
			{
				_soundChannel.stop();
				_onStopped.dispatch( this );
			}
			
			return this;
		}

		public function get volume():Number 
		{
			if ( _soundTransform ) _volume = _soundTransform.volume;
			return _volume;
		}
		public function set volume(value:Number):void { setVolume( value ); }
		public function setVolume(val:Number):ISound 
		{
			_volume = val;
			if ( _soundChannel && _soundChannel.soundTransform ) _soundChannel.soundTransform.volume = _volume;
			return this;
		}

		public function get loop():int { return _loop; }
		public function set loop(value:int):void { setLoop(value); }
		public function setLoop(val:int):ISound { _loop = val; return this; }

		public function get sound():Sound { return _sound; }
		public function get soundChannel():SoundChannel { return _soundChannel; }
		public function get soundTransform():SoundTransform {	return _soundTransform; }

		public function get type():String {	return _type; }
		public function set type(value:String):void { setType(value); }
		public function setType(val:String):ISound { _type = val; return this; }

		public function get isPlaying():Boolean { return _isPlaying; }
		public function set isPlaying(value:Boolean):void { setPlay(value); }
		public function setPlay(val:Boolean):ISound 
		{
			if ( isPlaying ) 	pause();
			else 				play();
			return this;
		}

		public function get autoPlay():Boolean { return _autoPlay; }
		public function set autoPlay( val:Boolean ):void { setAutoPlay(val); }
		public function setAutoPlay( val:Boolean ):ISound
		{
			_autoPlay = val;
			return this;
		}
		
		public function get currentTime():uint { return _soundChannel.position; }
		public function set currentTime(value:uint):void { setCurrentTime( value ); }
		public function setCurrentTime(val:uint):ISound 
		{
			if ( _isPlaying )
			{
				play( val );
			}
			else
			{
				pause();
				_pauseTime = val;
			}
			return this;
		}

		public function get totalTime():uint { return uint( _sound.length ); }
		
		

		public function dispose():void 
		{
			if ( _sound )
			{
				_sound.close();
			}
			if ( _soundChannel )
			{
				_soundChannel.stop();
				_soundChannel.soundTransform = null;
			}
			if ( _soundTransform )
			{
				_soundTransform = null;
			}
			
			_onLoadProgress.removeAll();
			_onPlayed.removeAll();
			_onPaused.removeAll();
			_onStopped.removeAll();
			_onPlayProgress.removeAll();
			_onEnd.removeAll();
			_onError.removeAll();
			_onReadyToPlay.removeAll();
		}
	}

}
