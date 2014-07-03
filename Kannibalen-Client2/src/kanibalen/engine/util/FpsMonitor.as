package kanibalen.engine.util 
{
	import flash.display.Sprite;
	
	/*
	 * DEZE CLASS HEEFT DE FPSCounter class nodig! (moet in zelfde package staan)
	 * 
	 * made by ted80
	 */
	
	public class FpsMonitor extends Sprite
	{
		public var posX:int;
		public var posY:int;
		public var sizeX:int;
		public var sizeY:int;
		public var historyLength:int;
		public var maxFPS:int;
		public var critFPS:int;
		
		public var history:Vector.<Number>;
		
		/* 
		 * px:int = x positie van de monitor
		 * py:int = y positie van de monitor
		 * sx:int = x size van de monitor
		 * sy:int = y size van de monitor
		 * h:int = hoeveel frames terug in de tijd behouden (default = 120 (4 sec op 30fps))
		 * m:int = het maximaal aantal frames (default = 30)
		 * c:int = onder welke fps de monitor rood mag worden (default = 20)
		 * 
		 */
		public function FpsMonitor(px:int, py:int, sx:int, sy:int, h:int = 120, m:int = 30, c:int = 25) 
		{
			posX = px;
			posY = py;
			sizeX = sx;
			sizeY = sy;
			historyLength = h;
			maxFPS = m;
			critFPS = c;
			
			history = new Vector.<Number>(historyLength);
		}
		
		public function tick():void
		{
			for (var fh:int = 1; fh < historyLength; fh++ )
			{
				history[fh - 1] = history[fh];
			}
			history[historyLength - 1] = FPScounter.fps;
			
			graphics.clear();
			if (history[historyLength - 1] <= critFPS)
			{
				graphics.beginFill(0xFF0000, 0.5);
			}
			else
			{
				graphics.beginFill(0x00FF00, 0.5);
			}
			graphics.moveTo(posX, posY + sizeY - (history[0] * sizeY / maxFPS));
			
			for (var i:int = 0; i < historyLength; i++ )
			{
				if (history[i] <= critFPS)
				{
					graphics.lineStyle(2, 0xFF0000);
				}
				else
				{
					graphics.lineStyle(2, 0x00FF00);
				}
				graphics.lineTo(posX + (i * sizeX / historyLength), posY + sizeY - (history[i] * sizeY / maxFPS));
			}
			graphics.lineTo(posX + sizeX, posY + sizeY);
			graphics.lineTo(posX, posY + sizeY);
			graphics.lineTo(posX,  posY + sizeY - (history[0] * sizeY / maxFPS));
			graphics.endFill();
		}
	}
}