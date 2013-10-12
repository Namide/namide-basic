package namide.tools.lightSlideshow.transitions
{
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Damien Doussaud - namide.com
	 */
	public interface PicturesTransition 
	{
		function PicturesTransition( w:int, h:int );
		
		function getPictures():Vector.<Bitmap>;
		
		function get content():Bitmap
		
		function get value():Number;
		function set value( valueTranstion:Number ):void;
		
		function get width():int;
		function set width( value:int ):void;
		
		function get height():int;
		function set height( value:int ):void;
		
		function size( width:int, height:int ):void;
		
		function addPicture( pict:Bitmap ):void;
		function swapPictures():void;
		
		function refresh():void;
	}
	
}