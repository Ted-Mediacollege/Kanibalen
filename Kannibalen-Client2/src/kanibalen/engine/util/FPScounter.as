package kanibalen.engine.util 
{
	import flash.utils.getTimer;
	
	public class FPScounter 
	{
		private static var last:uint = getTimer();
		private static var ticks:uint = 0;
		public static var fps:Number = 0;
		
		/** Calculate FPS every frame */
		public static function update():uint 
		{
			ticks++;
			
			var now:uint = getTimer();
			var delta:uint = now - last;
			
			if (delta >= 1000) 
			{
					fps = ticks / delta * 1000;
					ticks = 0;
					last = now;
			}
			
			return fps;
		}
	}
}