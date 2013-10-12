package namide.basic.fileFormat.core 
{
	import namide.basic.utils.Signal;
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class Tag 
	{
		/**
		 * A standart Tag content elements or content.
		 */
		public static var TYPE_STANDARD:String = "typeStandart";
		
		/**
		 * A empty element has no content or elements.
		 * The data of this Tag is in the attributes.
		 */
		public static var TYPE_EMPTY_ELEMENT:String = "typeEmptyElement";
		
		protected var _name:String;
		protected var _type:String;
		protected var _attributes:Object;
		protected var _elements:Vector.<Tag>;
		protected var _content:String;
		
		protected var _parent:Tag;
		
		/**
		 * If the Tag describe an XML tag :
		 * 
		 * TYPE_STANDARD
		 * <name attribute1="" attribute2="" ... >
		 * 	<element0 />
		 * 	<element1></element1>
		 * </name>
		 * 
		 * TYPE_STANDARD
		 * <name attribute1="" attribute2="" ... >
		 * 	content
		 * </name>
		 * 
		 * TYPE_EMPTY_ELEMENT
		 * <name attribute1="" attribute2="" ... />
		 * 
		 * 
		 *
		 */
		public function Tag() 
		{
			_type = Tag.TYPE_EMPTY_ELEMENT;
		}
		
		/**
		 * Name of the Tag
		 */
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
		
		/**
		 * Type of the Tag :
		 * Tag.TYPE_STANDARD is like a open tag : <tag></tag>
		 * Tag.TYPE_EMPTY_ELEMENT is like a closed tag : <tag />
		 * 
		 * a Tag.TYPE_EMPTY_ELEMENT has no elements and no content.
		 */
		public function get type():String { return _type; }
		public function set type(value:String):void { _type = value; }
		
		/**
		 * List of attributes of the Tag.
		 * 
		 * in example if 
		 * var attributes:Object = { a:"yes", b:25 };
		 * in XML it is like
		 * <tag a="yes" b="25" />
		 */
		public function get attributes():Object { return _attributes; }
		public function set attributes(value:Object):void { _attributes = value; }
		
		
		public function t( ElementName:String, ElementId:uint = 0 ):Tag { return getElementByNameAndId(ElementName, ElementId); }
		public function a( AttributeName:String ):* { return getAttributeByName(AttributeName); }
		
		
		public function getAttributeByName( pName:String ):*
		{
			if ( _attributes[pName] == null ) 
			{
				var pathString:String = "[" + getPath().join(",") + "]";
				dispatchError( "attribute \""+pName+"\" not found on " + pathString );
			}
			
			return _attributes[pName];
		}
		
		protected function dispatchError( message:String ):void
		{
			if ( _parent != null ) _parent.dispatchError( message );
		}
		
		protected function getPath():Array
		{
			var path:Array = [this._name];
			var element:Tag = this;
			while ( element._parent != null )
			{
				element = element._parent;
				path[path.length] = element._name;
			}
			return path.reverse();
		}
		
		/**
		 * Content of the Tag.
		 * The tag is  necessarily of type Tag.TYPE_STANDARD if it had a content.
		 * 
		 * in example if 
		 * var content:String = "The <b>winter</b> is comming !";
		 * in XML it is like
		 * <tag><![CDATA[The <b>winter</b> is comming !]]></tag>
		 */
		public function get content():String { return _content; }
		public function set content(value:String):void
		{
			_type = Tag.TYPE_STANDARD;
			_content = value;
			if ( value != null ) _elements = null; 
		}
		
		/**
		 * Elements of Tag is a list of Tag
		 */
		public function get elements():Vector.<Tag> { return _elements; }
		public function set elements(value:Vector.<Tag>):void
		{
			_type = Tag.TYPE_STANDARD;
			_elements = value;
			var i:int = value.length
			while( --i > -1 )
			{
				value[i]._parent = this;
			}
			if ( value != null ) _content = null; 
		}
		
		/**
		 * Return a list of elements sorted by their names
		 * 
		 * @param	pName	Name of all the elements in the list
		 * @return			A list of element with the name is pName
		 */
		public function getElementsByName( pName:String ):Vector.<Tag>
		{
			var tags:Vector.<Tag> = new Vector.<Tag>( 0, false );
			if ( _elements != null && _elements.length > 0 )
			{
				const l:int = _elements.length;
				for ( var i:int = 0; i < l; i++ )
				{
					if ( _elements[i]._name == pName ) tags[tags.length] = _elements[i];
				}
			}
			return tags;
		}
		
		public function getElementByNameAndId( pName:String, id:uint = 0 ):Tag
		{
			var tags:Vector.<Tag> = getElementsByName(pName);
			
			if ( tags.length < 1 )
			{
				var pathString:String = "[" + getPath().join(",") + "]";
				dispatchError( "element \""+pName+"\" not found on the path " + pathString );
			}
			else 
			{
				const l:int = tags.length;
				if ( id > l - 1 )
				{
					pathString = "[" + getPath().join(",") + "]";
					dispatchError( "element \"" + pName + "\" not found on the id " + id + " (path: " + pathString + ", idMax:" +(l - 1)+ ")" );
				}
				else
				{
					return tags[id];
				}
				
			}
			
			return null;
		}
		
		
		/**
		 * Remove element
		 * 
		 * @param	pName	Name of all the elements in the list
		 * @return			the root tag
		 */
		public function removeElementsByName( pName:String ):Tag
		{
			if ( _elements != null && _elements.length > 0 )
			{
				var i:int = _elements.length;
				while( --i > -1 )
				{
					if ( _elements[i]._name == pName ) _elements.splice( i, 1 );
				}
				
			}
			return this;
		}
		
		/**
		 * Add a new attribute for the Tag
		 * 
		 * @param	label	Label of the attribute
		 * @param	data	Content of the attribute
		 */
		public function addAttribute( label:String, data:String ):void
		{
			if ( _attributes == null ) _attributes = { };
			_attributes[label] = data;
		}
		
		/**
		 * Remove attribute of the Tag
		 * 
		 * @param	label	Label of the attribute
		 * @param	data	Content of the attribute
		 */
		public function removeAttribute( label:String ):void
		{
			_attributes = null;
		}
		
		/**
		 * Add a new element in the list of the Tag's element
		 * 
		 * @param	data	The new Tag to added
		 */
		public function addElement( data:Tag ):void
		{
			_type = Tag.TYPE_STANDARD
			
			data._parent = this;
			if ( _elements == null ) _elements = new Vector.<Tag>( 0, false );
			_elements[_elements.length] = data;
		}
		
		/*public function toString():String
		{
			var str:String = "<"+_name;
			if (_attributes != null) for (var key:String in _attributes ) str +=  " " + key + ":" + _attributes[key];
			if (_elements != null) for (var i:int = 0; i < _elements.length; i++ ) str +=  "\n" + _elements[i].toString();
			if (_content != null) str +=  "\n" + _content;
			str += ">";
			return str;
		}*/
		
	}

}