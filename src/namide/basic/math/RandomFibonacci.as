package namide.basic.math 
{
	/**
	 * Create a sequence of pseudo-random integers.
	 * A seed change the sequence : a new seed for a new sequence.
	 *
	 * @author Namide
	 */
	public class RandomFibonacci
	{
 
		private var _seed:uint = 0;
		
		private var _nbre_f1:Number;	// U(n-1)
		private var _nbre_f2:Number;	// U(n)
		private var _loop:Number;
 
		private static var INSTANCE:RandomFibonacci;
		
		public function RandomFibonacci(pSeed:uint = 0)
		{
			seed = pSeed;
		}
 
		/**
		 * Need of the sequence.
		 */
		public function get seed():uint				{ return _seed; }
		public function set seed(input:uint):void
		{
			_seed = input;
			
			_nbre_f1 = 1;
			_nbre_f2 = _seed;
 
			_loop = 0;
		}
		
 
		/**
		 * returns a pseudo-random integer between 0 and getrandmax().
		 * 
		 * @param	min		Minimum for the generated number. min <= number < mod
		 * @param	max		Maximum for the generated number. min <= number < mod
		 * @return			Pseudo random integer between min and max
		 */
		public function between(min:int = 0, max:int = int.MAX_VALUE):void
		{
			return min + random(max - min);
		}
		
		/**
		 * Get a pseudo random number.
		 * 
		 * @param	mod		Maximum for the generated number. 0 <= number < mod.
		 * @return			Pseudo random integer between 0 and mod.
		 */
		public function random(mod:int = 1000):Number
		{
			if(_nbre_f1 == Infinity && _nbre_f2 == Infinity)
			{
				_loop++;
				_nbre_f1 = 1;
				_nbre_f2 = _loop;
			}
 
			var nbreSuiv:Number = _nbre_f1+_nbre_f2;
 
			if(nbreSuiv == Infinity)
			{
				_loop++;
				_nbre_f1 = 1;
				_nbre_f2 = _loop;
				nbreSuiv = _nbre_f1 + _nbre_f2;
			}
			
			_nbre_f1 = _nbre_f2;
			_nbre_f2 = nbreSuiv;
 
			return _nbre_f2 % mod;
		}
		
		/**
		 * Get a general instance of DRandomFibonacci like a singleton.
		 * 
		 * @return 	The general instance of DRandomFibonacci
		 */
		public static function getInstance():RandomFibonacci
		{
			if ( !INSTANCE ) INSTANCE = new RandomFibonacci();
			return INSTANCE;
		}
		
 
	}

}