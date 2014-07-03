package kanibalen.game 
{
	import flash.display.MovieClip;
	import kanibalen.engine.Engine;
	import kanibalen.game.gui.GuiLogin;
	import kanibalen.game.network.Connection;
	import kanibalen.game.gui.GuiTest;
	import kanibalen.engine.input.InputKey;
	import flash.ui.Keyboard;

	public class Main extends MovieClip
	{
		public static var ScreenWidth:int;
		public static var ScreenHeight:int;
		public static var CenterWidth:int;
		public static var CenterHeight:int;
		
		public static var connection:Connection;
		
		public function Main() 
		{
			ScreenWidth = stage.stageWidth;
			ScreenHeight = stage.stageHeight;
			CenterWidth = ScreenWidth / 2;
			CenterHeight = ScreenHeight / 2;
			
			connection = new Connection();
			
			var engine:Engine = new Engine(this, stage, new GuiLogin());//new GuiLogin() new GuiTest()
			addChild(engine);
		}
	}
}