package kanibalen.game.gui 
{
	import kanibalen.engine.gui.GuiScreen;
	import kanibalen.game.world.Level;
	import kanibalen.engine.gui.GuiButton;
	import flash.ui.Keyboard;

	public class GuiTest extends GuiScreen
	{
		public var level:Level;
		
		public function GuiTest() 
		{
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			level = new Level(0, 0);
			addChild(level);
		}
		
		override public function tick():void
		{
			level.loop();
		}
		
		override public function action(id:int):void
		{
		}
		
		override public function onKeyPress(key:int):void 
		{
			if (key == Keyboard.F)
			{
				if (level != null)
				{
					if (Level.players.player != null)
					{
						if (Level.players.player.flashlight == 0)
						{
							Level.players.player.flashlight = 1;
						}
						else
						{
							Level.players.player.flashlight = 0;
						}
					}
				}
			}
		}
	}
}