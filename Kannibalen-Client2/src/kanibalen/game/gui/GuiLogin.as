package kanibalen.game.gui 
{
	import kanibalen.engine.gui.GuiScreen;
	import kanibalen.engine.gui.GuiText;
	import kanibalen.engine.gui.GuiButton;
	import kanibalen.engine.gui.GuiTextInput;
	import kanibalen.game.Main;
	import kanibalen.game.network.Connection;
	
	public class GuiLogin extends GuiScreen
	{
		
		public var inputfield1:GuiTextInput;
		public var inputfield2:GuiTextInput;
		public var inputfield3:GuiTextInput;
			
		public function GuiLogin() 
		{
		}
		
		override public function init():void
		{
			buttonList = new Vector.<GuiButton>();
			
			var text_input1:GuiText = new GuiText(-180, 280, 20, 0xFFFFFF, "right");
			var text_input2:GuiText = new GuiText(-180, 340, 20, 0xFFFFFF, "right");
			var text_input3:GuiText = new GuiText(-180, 400, 20, 0xFFFFFF, "right");
			
			text_input1.setText("Your name:");
			text_input2.setText("IP:");
			text_input3.setText("PORT:");
			
			addChild(text_input1);
			addChild(text_input2);
			addChild(text_input3);
			
			inputfield1 = new GuiTextInput(630, 280, 20, 0xFFFFFF, "left", 15, "A-Za-z0-9");
			inputfield2 = new GuiTextInput(630, 340, 20, 0xFFFFFF, "left", 5, "0-9.");
			inputfield3 = new GuiTextInput(630, 400, 20, 0xFFFFFF, "left", 5, "0-9");
			
			inputfield1.setText("Guy1234");
			inputfield2.setText("172.17.57.245");
			inputfield3.setText("2022");
			
			addChild(inputfield1);
			addChild(inputfield2);
			addChild(inputfield3);
			
			var button_connect:GuiButton = new GuiButton(0, Main.CenterWidth - 100, Main.ScreenHeight - 200, 30, 200);
			button_connect.setText("Connect", 20, 0xFFFFFF);
			addChild(button_connect);
			buttonList.push(button_connect);
		}
		
		override public function tick():void
		{
		}
		
		override public function action(id:int):void
		{
			if (id == 0)
			{
				Connection.IP = inputfield2.tf.text;
				Connection.PORT = parseInt(inputfield3.tf.text);
				engine.switchGui(new GuiConnecting(inputfield1.tf.text));
			}
		}
	}
}