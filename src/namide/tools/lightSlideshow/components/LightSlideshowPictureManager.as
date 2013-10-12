package namide.tools.lightSlideshow.components 
{
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public class LightSlideshowPictureManager 
	{
		protected var _allPictures:Vector.<Object>;
		
		public function LightSlideshowPictureManager() 
		{
			
		}
		
		public function initPicturesByXML( pictureData:XML ):void
		{
			var i:int = pictureData.picture.length();
			var j:int;
			
			_allPictures = new Vector.<Object>( i, true );
			while (--i > -1)
			{
				_allPictures[i] = { };
				j = pictureData.picture[i].*.length();
				
				while (--j > -1)
				{
					_allPictures[i][pictureData.picture[i].*[j].name().toString()] = pictureData.picture[i].*[j].toString();
				}
			}
		}
		
		public function getListData( label:String ):Vector.<String>
		{
			var i:int = _allPictures.length;
			var listData:Vector.<String> = new Vector.<String>( i, true );
			while ( --i > -1 )
			{
				listData[i] = _allPictures[i][label];
			}
			return listData;
		}
		
		public function getIndexByData( dataLabel:String, dataValue:String ):int
		{
			if (_allPictures)
			{
				var i:int = _allPictures.length;
				while ( --i > -1)
				{
					if ( _allPictures[i][dataLabel] == dataValue ) return i;
				}
			}
			
			return -1;
		}
		
		public function getData( indexPicture:int, dataLabel:String ):String
		{
			if(_allPictures && _allPictures[indexPicture] )	return _allPictures[indexPicture][dataLabel];
			return null;
		}
		
	}

}