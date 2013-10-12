package namide.basic.fileFormat 
{
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import namide.basic.fileFormat.core.Tag;
	import namide.basic.utils.ISignal;
	import namide.basic.utils.Signal;
	/**
	 * ...
	 * @author Namide
	 */
	public class XmlCompressor 
	{
		protected var _xmlParser:XmlParser;
		protected var _tag:Tag;
		
		protected var _complete:Signal;
		public function get complete():ISignal { return _complete; };
		
		protected var _error:Signal;
		public function get error():ISignal { return _error; };
		
		
		public function XmlCompressor() 
		{
			_xmlParser = new XmlParser();
			_complete = new Signal();
			_error = new Signal();
		}
		
		public function loadXml( url:String ):XmlCompressor
		{
			_xmlParser.load( url );
			_xmlParser.complete.add( onLoaded );
			_xmlParser.error.add( _error.dispatch );
			
			return this;
		}
		
		public function encode():ByteArray
		{
			_xmlParser.error.add( onError );
			var tag:Tag = _xmlParser.decode();
			_xmlParser.error.remove( onError );
			
			var tagNode:Tag;
			//var assets:Vector.<Tag> = tag.getElementsByName("asset");
			tag.getElementsByName("asset")[0].removeElementsByName("contributor");
			tag.getElementsByName("asset")[0].removeElementsByName("created");
			tag.getElementsByName("asset")[0].removeElementsByName("modified");
			
			_xmlParser.tag = tag 
			var s:String = _xmlParser.encodeToString(false);
			var b:ByteArray = new ByteArray();
			b.writeUTFBytes( s );
			b.compress( CompressionAlgorithm.LZMA );
			
			return b;
		}
		
		
		
		protected function onLoaded( xmlParser:XmlParser ):void
		{
			_xmlParser.complete.remove( onLoaded );
			_xmlParser.error.remove( _error.dispatch );
			
			_complete.dispatch( this );
		}
		
		protected function onError(msg:String):void
		{
			_xmlParser.complete.remove( onLoaded );
			_xmlParser.error.remove( _error.dispatch );
			
			_error.dispatch( msg );
		}
	}

}