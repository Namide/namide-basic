package namide.basic.fileFormat 
{
	import namide.basic.fileFormat.core.Tag;
	import namide.basic.utils.ISignal;
	import namide.basic.utils.Signal;
	/**
	 * ...
	 * @author Namide
	 */
	public class ColladaCompressor 
	{
		protected var _xmlParser:XMLParser;
		protected var _tag:Tag;
		
		protected var _complete:Signal;
		public function get complete():ISignal { return _complete; };
		
		protected var _error:Signal;
		public function get error():ISignal { return _error; };
		
		
		public function ColladaCompressor() 
		{
			_xmlParser = new XMLParser();
			_complete = new Signal();
			_error = new Signal();
		}
		
		public function load( dae:String ):ColladaCompressor
		{
			_xmlParser.load( dae );
			_xmlParser.complete.add( onLoaded );
			_xmlParser.error.add( _error.dispatch );
			
			return this;
		}
		
		public function encode():Tag
		{
			_xmlParser.error.add( onError );
			_tag = _xmlParser.decode();
			_xmlParser.error.remove( onError );
			
			var tag:Tag;
			var assets:Vector.<Tag> = _tag.getElementsByName("asset");
			var i:int = assets.length;
			while ( --i > -1 )
			{
				tag = assets[i];
				switch( tag.name )
				{
					case "contributor" : assets.splice( i, 1 ); break;
					case "created" : assets.splice( i, 1 );  break;
					case "modified" : assets.splice( i, 1 ); break;
				}
			}
			
			_xmlParser.tag = _tag 
			trace( _xmlParser.encode() );
			
			return _tag;
		}
		
		
		
		protected function onLoaded( xmlParser:XMLParser ):void
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