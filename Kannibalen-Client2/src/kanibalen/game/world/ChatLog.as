package kanibalen.game.world 
{
	import flash.display.Sprite;
	import kanibalen.engine.gui.GuiText

	public class ChatLog extends Sprite
	{
		public static var messages:Vector.<GuiText>;
		public static var texten:Vector.<String>;
		
		public function ChatLog() 
		{
			messages = new Vector.<GuiText>();
			texten = new Vector.<String>();
			
			for (var i:int = 0; i < 5; i++) 
			{
				var m:GuiText = new GuiText(460, 600 + (i * 18), 15, 0xFFFFFF, "right");
				m.setText("");
				addChild(m);
				messages.push(m);
				texten.push("");
			}
		}
		
		public static function addMessage(s:String):void
		{
			texten.push(s);
			texten.shift();
			
			for (var i:int = 0; i < messages.length; i++) 
			{
				messages[i].setText(texten[i]);
			}
		}
	}
}