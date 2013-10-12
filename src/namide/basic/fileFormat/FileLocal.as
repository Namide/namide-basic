package namide.basic.fileFormat 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import namide.basic.utils.ISignal;
	import namide.basic.utils.Signal;
	
	/**
	 * ...
	 * @author Namide
	 */
	public class FileLocal 
	{
		// SERVER
		
			protected var _loader:URLLoader;
		
		// LOCAL
		
			protected var _file:FileReference;
		
		// ALL
		
		protected var _errorCallback:Signal;
		protected var _progressCallback:Signal;
		protected var _completeCallback:Signal;
		protected var _cancelCallback:Signal;
		
		protected var _bytesLoaded:Number;
		protected var _bytesTotal:Number;
		
		protected var _data:ByteArray;
		
		
		public function FileLocal() 
		{
			_errorCallback = new Signal();
			_progressCallback = new Signal();
			_completeCallback = new Signal();
			_cancelCallback = new Signal();
			
			_file = new FileReference();
			_loader = new URLLoader();
		}
		
		public function get errorCallback():ISignal { return _errorCallback; }
		public function get progressCallback():ISignal { return _progressCallback; }
		public function get completeCallback():ISignal { return _completeCallback; }
		public function get cancelCallback():ISignal { return _cancelCallback; }
		
		public function get bytesLoaded():Number { return _bytesLoaded; }
		public function get bytesTotal():Number { return _bytesTotal; }
		public function get type():String { return _file.type; }
		
		public function get data():ByteArray { return _data; }
		public function set data(value:ByteArray):void { _data = value; }
		
		public function getProgress():Number { return _bytesLoaded / _bytesTotal; }
		
		public function loadClientToLocal( url:String, name:String = null ):FileLocal
		{
			_file.download( new URLRequest( url ), name );
			addAllListenerFileRef();
			return this;
		}
		
		public function loadLocalToClient( fileFilters:Array ):FileLocal
		{
			_file.browse( fileFilters );
			_file.addEventListener( Event.SELECT, onSelectLocalToClient );
			_file.addEventListener( Event.CANCEL, onCancelFileRef );
			_file.addEventListener( IOErrorEvent.IO_ERROR , onErrorFileRef );
			return this;
		}
		
		public function onSelectLocalToClient(e:Event):void
		{
			_file.removeEventListener( Event.SELECT, onSelectLocalToClient );
			_file.addEventListener( Event.COMPLETE, onFileRefComplete );
			_file.load();
		}
				
		public function saveClientToLocal( data:* = null, name:String = null ):FileLocal
		{
			if ( _file.name != null ) name = _file.name;// + ".lzma";
			
			if ( data != null ) _data = data;
			if( _data == null ) _errorCallback.dispatch( "File::saveClientToLocal() requiert a data, String or Byterray" )
			
			else
			{
				_file.save( _data, name );
				addAllListenerFileRef();
			}
			
			return this;
		}
		
		public static function compressByteArray( data:ByteArray, compressionAlgorithm:String = CompressionAlgorithm.LZMA ):ByteArray
		{
			var b:ByteArray = data;
			data.position = 0;
			b.compress( compressionAlgorithm );
			return b;
		}
		public static function uncompressToByterray( data:ByteArray, compressionAlgorithm:String = CompressionAlgorithm.LZMA ):ByteArray
		{
			data.position = 0;
			data.uncompress( compressionAlgorithm );
			data.position = 0;
			return data;
		}
		
		public function loadServerToClient( url:String ):FileLocal
		{
			try 
			{
				_loader.load( new URLRequest(url) );
				_loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorLoader);
				_loader.addEventListener(Event.COMPLETE, onCompleteLoader);
				_loader.addEventListener(ProgressEvent.PROGRESS, onProgressLoader);
			}
			catch(e:Error)
			{
				_errorCallback.dispatch( "FileLocal::loadServerToClient() " + e.message );
			}
			return this;
		}
		
		protected function removeAllListenerLoader():void
		{
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorLoader);
			_loader.removeEventListener(Event.COMPLETE, onCompleteLoader);
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgressLoader);
		}
		protected function onProgressLoader(e:ProgressEvent):void
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			
			_progressCallback.dispatch(this);
		}
		
		protected function onErrorLoader(e:IOErrorEvent):void
		{
			removeAllListenerLoader();
			_errorCallback.dispatch( e.text );
		}
		
		protected function onCompleteLoader(e:Event):void
		{
			removeAllListenerLoader();
			
			_data = new ByteArray();
			_data.writeUTFBytes( String(e.target.data) );
			
			_bytesTotal = _loader.bytesTotal;
			_completeCallback.dispatch(this);
		}
		
		protected function addAllListenerFileRef():void
		{
			_file.addEventListener(Event.COMPLETE, onFileRefComplete );
			_file.addEventListener(IOErrorEvent.IO_ERROR, onErrorFileRef);
			_file.addEventListener(ProgressEvent.PROGRESS, onFileRefProgress );
			_file.addEventListener(Event.CANCEL, onCancelFileRef);
		}
		protected function removeAllListenerFileRef():void
		{
			_file.removeEventListener(Event.COMPLETE, onFileRefComplete );
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onErrorFileRef);
			_file.removeEventListener(ProgressEvent.PROGRESS, onFileRefProgress );
			_file.removeEventListener(Event.CANCEL, onCancelFileRef);
			
			_file.removeEventListener( Event.SELECT, onSelectLocalToClient );
			
		}
		
		protected function onFileRefProgress(e:ProgressEvent):void
		{
			_bytesLoaded = e.bytesLoaded;
			_bytesTotal = e.bytesTotal;
			
			_progressCallback.dispatch(this);
		}
		
		protected function onErrorFileRef(e:IOErrorEvent):void
		{
			removeAllListenerFileRef();
			_errorCallback.dispatch( e.text );
		}
		
		protected function onFileRefComplete(e:Event):void
		{
			removeAllListenerFileRef();
			_data = _file.data;
			_bytesTotal = _file.size;
			_completeCallback.dispatch(this);
		}
		
		protected function onCancelFileRef(e:Event):void
		{
			removeAllListenerFileRef();
			_cancelCallback.dispatch(this);
		}
		
	}

}