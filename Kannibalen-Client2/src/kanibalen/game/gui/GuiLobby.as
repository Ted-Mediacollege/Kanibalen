package kanibalen.game.gui 
{
	import kanibalen.engine.gui.GuiScreen;
	import kanibalen.engine.gui.GuiButton;
	import kanibalen.engine.gui.GuiText;
	import kanibalen.game.Main;
	
	public class GuiLobby extends GuiScreen
	{
		public static var started:Boolean = false;
		public static var spawnX:int = 0;
		public static var spawnY:int = 0;
		
		public function GuiLobby() 
		{
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			started = false;
			
			var temp:GuiText = new GuiText(Main.CenterWidth, Main.CenterHeight, 25, 0xFFFFFF, "center");
			temp.setText("Waiting for other players to connect!");
			addChild(temp);
		}
		
		override public function tick():void
		{
			Main.connection.tick();
			
			if (started)
			{
				engine.switchGui(new GuiGame(spawnX, spawnY));
			}
		}
		
		override public function action(id:int):void
		{
			
		}
	}
}