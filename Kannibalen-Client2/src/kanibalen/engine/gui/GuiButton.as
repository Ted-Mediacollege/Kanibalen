package kanibalen.engine.gui 
{
	import flash.display.Sprite;
	
	public class GuiButton extends Sprite
	{
		public var text:GuiText;
		
		public var posX:int;
		public var posY:int;
		public var box:Vector.<int>;
		
		public var buttoncolor:int;
		public var id:int;
		public var enabled:Boolean;
		
		public function GuiButton(i:int, px:int, py:int, bh:int, bw:int) 
		{
			posX = px;
			posY = py;
			box = new Vector.<int>(2);
			box[0] = bw;
			box[1] = bh;
			
			id = i;
			enabled = false;
			
			graphics.clear();
			graphics.lineStyle(3, 0x000000);
			graphics.drawRoundRect(posX, posY, box[0], box[1], 10);
		}
		
		public function setText(t:String, s:int, c:uint):void
		{
			text = new GuiText(posX + int(Math.floor(box[0] / 2)), posY, s, c, "center");
			text.setText(t);
			addChild(text);
			buttoncolor = c;
		}
		
		public function updateText(t:String):void
		{
			if (text != null) 
			{
				text.setText(t);
			}
		}
		
		public function hover(hovering:Boolean):void
		{
			graphics.clear();
			if (hovering)
			{
				text.setColor(0xFF0000);
				graphics.lineStyle(3, 0xFF0000);
				graphics.drawRoundRect(posX, posY, box[0], box[1], 10);
			}
			else
			{
				text.setColor(buttoncolor);
				graphics.lineStyle(3, buttoncolor);
				graphics.drawRoundRect(posX, posY, box[0], box[1], 10);
			}
		}
	}
}