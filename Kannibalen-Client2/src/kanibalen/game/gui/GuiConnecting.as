package kanibalen.game.gui 
{
	import kanibalen.engine.gui.GuiScreen;
	import kanibalen.engine.gui.GuiText;
	import kanibalen.game.network.NetworkID;
	import kanibalen.game.Main;
	import kanibalen.engine.gui.GuiButton;
	import kanibalen.engine.util.MathHelper;
	
	public class GuiConnecting extends GuiScreen
	{
		public static var state:int = -1;
		public static var time:int = 0;
		
		public static var text_status:GuiText;
		public var playername:String = "";
		
		public var fallbacktimer:int = -2;
		
		public function GuiConnecting(n:String) 
		{
			playername = n;
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			state = -1;
			time = -1;
			Main.connection.connect();
			
			text_status = new GuiText(Main.CenterWidth, Main.CenterHeight, 25, 0xFFFFFF, "center");
			text_status.setText("Connecting...");
			addChild(text_status);
		}
		
		override public function tick():void
		{
			Main.connection.tick();
			
			if (fallbacktimer > 0)
			{
				fallbacktimer--;
				if (fallbacktimer == 0)
				{
					engine.switchGui(new GuiLogin());
				}
			}
			
			if (state > -1)
			{
				if (state == NetworkID.REJECT_FULL)
				{
					text_status.setText("Server is full, please try again in a few minutes");
					fallbacktimer = 120;
					state = -1;
				}
				else if (state == NetworkID.REJECT_PLAYING)
				{
					text_status.setText("You can't join right now, match will end in " + time + " minutes!");
					time = -1;
					state = -1;
					fallbacktimer = 120;
				}
				else if (state == 2)
				{
					state = -1;
					Main.connection.send(NetworkID.CLIENT_NAME, playername);
					engine.switchGui(new GuiLobby());
				}
			}
		}
		
		override public function action(id:int):void
		{
			
		}
	}
}