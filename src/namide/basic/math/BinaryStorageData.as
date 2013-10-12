package namide.basic.math 
{
	/**
	 * DBinaryStorageData contains a uint value and a methods for binaries tests makes with this value.
	 * With this class you can optimise memory and the calculations for storage datas.
	 * Values must be pow of two ( 1, 2, 4, 8, 16, 32, 64... )
	 * 
	 * @author Damien Doussaud - namide.com
	 */
	public class BinaryStorageData 
	{
		protected var _data:uint;
		
		/**
		 * Initialise the value of DBinaryStorageData with a uint.
		 * 
		 * @param	value
		 */
		public function BinaryStorageData( value:uint = 0x0 ) 
		{
			_data = value;
		}
		
		/**
		 * The main binary value.
		 */
		public function get data():uint { return _data; }
		public function set data(value:uint):void {	_data = value; }
		
		/**
		 * Test if the binary value contains this value.
		 * 
		 * @param	value	Value for testing, values must be pow of two ( 1, 2, 4, 8, 16, 32, 64... )
		 * @return	true if the data value of DBinaryStorageData has the value; false if not. 
		 */
		public function has( value:uint ):Boolean { return (_data & value) == value; }
		
		/**
		 * Add a value in the data value of DBinaryStorageData
		 * @param	value	Value to add, values must be pow of two ( 1, 2, 4, 8, 16, 32, 64... )
		 */
		public function add( value:uint ):void { _data |= value; }
		
		/**
		 * Subtract a value in the data value of DBinaryStorageData
		 * @param	value	Value to subtract, values must be pow of two ( 1, 2, 4, 8, 16, 32, 64... )
		 */
		public function subtract( value:uint ):void	{ if ( has( value ) ) _data ^= value; }
		
		/**
		 * Change the data value of DBinaryStorageData to 0 (no datas).
		 */
		public function clear():void { _data = 0x0; }
	}

}