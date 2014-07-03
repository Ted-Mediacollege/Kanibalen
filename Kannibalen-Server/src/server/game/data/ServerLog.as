package server.game.data 
{
	import flash.text.TextField;
	import flash.display.Sprite;
	import server.engine.util.MathHelper;
	
	public class ServerLog extends Sprite
	{
		public static var update:Boolean;
		public static var historyLength:int = 32;
		
		public static var log:Vector.<String>;
		public static var color:Vector.<uint>;
		public var textfields:Vector.<LogText>;
		
		public function ServerLog()
		{
			log = new Vector.<String>(historyLength);
			color = new Vector.<uint>(historyLength);
			textfields = new Vector.<LogText>(historyLength);
			update = true;
			
			for (var i:int = 0; i < historyLength; i++ )
			{
				log[i] = "";
				color[i] = 0x000000;
				textfields[i] = new LogText(10, 10 + (i * 18), 15, 0x000000, "left");
				addChild(textfields[i]);
			}
		}
		
		public static function add(t:String, s:String, c:uint = 0x000000):void
		{
			var ls:String = "[" + t + "]: " + s; 
			trace(ls);
			
			for (var i:int = 1; i < historyLength; i++ )
			{
				log[i - 1] = log[i];
				color[i - 1] = color[i];
			}
			
			log[historyLength - 1] = ls;
			color[historyLength - 1] = c;
			update = true;
		}
		
		public function loop():void
		{
			if (update)
			{
				update = false;
				for (var i:int = 0; i < historyLength; i++ )
				{
					textfields[i].setText(log[i]);
					textfields[i].setColor(color[i]);
				}
			}
		}
	}
}