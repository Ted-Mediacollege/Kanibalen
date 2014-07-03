package kanibalen.game.gui 
{
	import kanibalen.engine.gui.GuiScreen;
	import kanibalen.game.world.Level;
	import kanibalen.engine.gui.GuiButton;
	import kanibalen.game.Main;
	import kanibalen.engine.gui.GuiText;
	import kanibalen.game.world.ChatLog;
	import kanibalen.game.data.Settings;
	import flash.ui.Keyboard;
	
	public class GuiGame extends GuiScreen
	{
		public static var chatlog:ChatLog;
		public var level:Level;
		public var spawnX:int;
		public var spawnY:int;
		public static var gameEnded:Boolean;
		
		public var text_time:GuiText;
		public var timeleft:int;
		public var frametime:int;
		
		public function GuiGame(sx:int, sy:int) 
		{
			spawnX = sx;
			spawnY = sy;
			gameEnded = false;
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			chatlog = new ChatLog();
			level = new Level(spawnX, spawnY);
			addChild(level);
			addChild(chatlog);
			
			timeleft = Settings.GAMELENGTH * 60;
			frametime = 30;
			text_time = new GuiText(Main.ScreenWidth - 850, 20, 25, 0xFFFFFF, "right");
			text_time.setText("Time left: -");
			addChild(text_time);
		}
		
		override public function tick():void
		{
			Main.connection.tick();
			
			level.loop();
			
			frametime--;
			if (frametime < 0)
			{
				if (timeleft > 0)
				{
					timeleft--;
					text_time.setText("Time left: " + timeleft);
				}
				frametime += 30;
			}
			
			if (gameEnded)
			{
				engine.switchGui(new GuiLobby());
			}
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
		
		override public function action(id:int):void
		{
			
		}
	}
}