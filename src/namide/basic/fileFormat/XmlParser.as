package namide.basic.fileFormat 
{
	import flash.events.Event;
	import namide.basic.fileFormat.core.TagRoot;
	//import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import namide.basic.fileFormat.core.Tag;
	import namide.basic.utils.ISignal;
	import namide.basic.utils.Signal;
	
	/**
	 * Convert an XML in a Tag object.
	 * The Tag object is easiest to use than XML object.
	 * 
	 * @author Damien Doussaud - namide.com
	 */
	public class XmlParser// extends EventDispatcher
	{
		/**
		 * Dispatch when the XML is loaded
		 * 
		 * @eventType flash.events.Event
		 */
		//[Event(name="complete", type="flash.events.Event")]
		
		/**
		 * Dispatch when a loading error has occured
		 * 
		 * @eventType flash.events.IOErrorEvent
		 */
		//[Event(name="ioError", type="flash.events.IOErrorEvent")]
		
		
		
		protected var _urlLoader:URLLoader;
		protected var _xml:XML;
		protected var _tag:Tag;
		
		protected var _complete:Signal;
		public function get complete():ISignal { return _complete; };
		
		protected var _error:Signal;
		public function get error():ISignal { return _error; };
		
		
		public function XmlParser() 
		{
			_complete = new Signal();
			_error = new Signal();
		}
		
		/**
		 * Source XML to parse
		 */
		public function get xml():XML { return _xml; }
		public function set xml(value:XML):void { _xml = value; }
		
		/**
		 * Tag (XML parsed)
		 */
		public function get tag():Tag { return _tag; }
		public function set tag(value:Tag):void { _tag = value; }
		
		
		/**
		 * Load a XML by an URL
		 * 
		 * @param	url		URL of the XML
		 */
		public function load( url:String ):XmlParser
		{
			_urlLoader = new URLLoader( new URLRequest(url) );
			_urlLoader.addEventListener(Event.COMPLETE, onLoaded);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			return this;
		}
		
		/**
		 * Create a Tag from the XML.
		 * 
		 * @return 		A Tag Object
		 */
		public function decode():Tag
		{
			if ( _xml == null )
			{
				_error.dispatch( "XML is not defined" );
			}
			else
			{
				_tag = new TagRoot( _error );
				decodeTag( _xml, _tag );
			}		
			return _tag;
		}
		
		/**
		 * Create a XML from the Tag
		 * 
		 * @return	A XML
		 */
		public function encode():XML
		{
			if ( _tag == null )
			{
				//throw new Error( "Tag is not defined" );
				_error.dispatch( "Tag is not defined" );
			}
			else
			{
				_xml = new XML( encodeTag( _tag ) );
			}
			
			return _xml;
		}
		
		
		public function encodeToString(cdata:Boolean):String
		{
			var s:String;
			if ( _tag == null )
			{
				_error.dispatch( "Tag is not defined" );
			}
			else
			{
				s = encodeTag( _tag, cdata );
			}
			
			return s;
		}
		
		/**
		 * Create a Tag from the XML.
		 * 
		 * @return 		A Tag Object
		 */
		static public function decode( xml:XML ):Tag
		{
			var xmlParser:XmlParser = new XmlParser();
			xmlParser.xml = xml;
			return xmlParser.decode();
		}
		
		/**
		 * Create a XML from the Tag
		 * 
		 * @return	A XML
		 */
		static public function encode( tag:Tag ):XML
		{
			var xmlParser:XmlParser = new XmlParser();
			xmlParser.tag = tag;
			return xmlParser.encode();
		}
		
		
		
		/**
		 * Create a Tag with the datas of the XML.
		 * 
		 * @param	xml		XML to convert in Tag
		 * @return			The Tag file (data format)
		 */
		protected function decodeTag( xml:XML, tag:Tag = null ):Tag
		{
			const xmlList:XMLList =  XMLList(xml);
			const attNamesList:XMLList = xml.@*;
			var i:int
			
			if( tag == null ) tag = new Tag();
			
			tag.name = xmlList.localName();
			for ( i = 0; i < attNamesList.length(); i++ ) tag.addAttribute( attNamesList[i].name(), attNamesList[i] );
			
			if ( xml.children().length() > 0 )
			{
				if ( xml.hasComplexContent() )
				{
					for ( i = 0; i < xml.children().length(); i++ ) tag.addElement( decodeTag( xml.children()[i] ) );
				}
				else
				{
					tag.content = xml;
				}
			}
			
			return tag;
		}
		
		protected function encodeTag( tag:Tag, cdata:Boolean = false ):String
		{
			var output:String = "<" + tag.name;
			
			
			const cdataBegin:String = (cdata) ? "<![CDATA[" : "" ;
			const cdataEnd:String = (cdata) ? "]]>" : "" ;
			
			if ( tag.attributes != null ) for( var key:String in tag.attributes ) output +=  " " + key + "=\"" + xmlEntities( tag.attributes[key] ) + "\"";
			
			if ( tag.type == Tag.TYPE_STANDARD ) 
			{
				output += ">";
				
				if ( tag.content != null )
				{
					output += cdataBegin + ( (cdata) ? tag.content : xmlEntities(tag.content) )  + cdataEnd;
				}
				else if ( tag.elements != null && tag.elements.length > 0 )
				{
					var l:int = tag.elements.length;
					for (var i:int = 0; i < l; i++ ) output += encodeTag( tag.elements[i] );
				}
			}
			
			if ( tag.type == Tag.TYPE_STANDARD )	output += "</" + tag.name + ">";
			else 									output += " />";
			
			return output;
		}
		
		protected function xmlEntities( str:String ):String
		{
			return str.split("\t").join("&#09;")
					  .split("\n").join("&#10;")
					  .split("\r").join("&#13;")
					  .split(" ").join("&#160;")
					  .split("&").join("&#38;")
					  .split("<").join("&#60;")
					  .split(">").join("&#62;")
					  .split("\"").join("&#34;")
					  .split("'").join("&#39;");
		}
		
		protected function onLoaded(event:Event):void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, onLoaded);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_urlLoader = null;
			
			try
			{
				_xml = new XML(event.target.data);
			}
			catch (event:Error)
			{
				_error.dispatch( event.message );
			}
			
			_complete.dispatch( this );
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			_error.dispatch( event.text );
		}
		
		
	}

}