package namide.basic.geom 
{
	import flash.geom.Vector3D;
	
	/**
	 * The DUtils3D class contains static methods that simplify the implementation of certain three-dimensional Vector3D operations.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10
	 * 
	 * @author namide.com
	 */
	public class UtilsVector3D 
	{
		
		public function UtilsVector3D( key:Key ) {}
		
		/**
		 * Determines a vector3D between two specified vector3D.
		 * The parameter f determines where the new interpolated point is located relative to the two end points specified by parameters v1 and v2.
		 * The closer the value of the parameter f is to 1.0, the closer the interpolated point is to the first point (parameter v1).
		 * The closer the value of the parameter f is to 0, the closer the interpolated point is to the second point (parameter v2).
		 * 
		 * @param	v1	The first vector3D.
		 * @param	v2	The second vector3D.
		 * @param	f	The level of interpolation between the two points. Indicates where the new point will be, along the line between v1 and v2. If f=1, v2 is returned; if f=0, v1 is returned.
		 * @return	The new, interpolated vector3D.
		 */
		public static function interpolate( v1:Vector3D, v2:Vector3D, f:Number ):Vector3D
		{
			var v3:Vector3D = new Vector3D();
			v3.x = v1.x * (1 - f) + v2.x * f;
			v3.y = v1.y * (1 - f) + v2.y * f;
			v3.z = v1.z * (1 - f) + v2.z * f;
			
			return v3;
		}
		
	}

}

internal class Key{}