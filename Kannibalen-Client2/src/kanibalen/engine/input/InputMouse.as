package kanibalen.engine.input 
{
	import flash.events.MouseEvent;
	import kanibalen.engine.Engine;
	
	public class InputMouse 
	{
		public static var mouseX:int;
		public static var mouseY:int;
		public static var mouseDown:Boolean;
		
		public function onMouseDown(e:MouseEvent):void
		{
			mouseDown = true;
			if (Engine.active)
			{
				Engine.activeGui.checkButtons(mouseX, mouseY);
			}
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			mouseDown = false;
		}
		
		public function onMouseMove(e:MouseEvent):void
		{
			mouseX = e.stageX;
			mouseY = e.stageY;
			if (Engine.active)
			{
				Engine.activeGui.checkHover(mouseX, mouseY);
			}
		}
		
		public function onMouseScroll(e:MouseEvent):void 
		{
			if (Engine.active)
			{
				Engine.activeGui.scroll(e.delta);
			}
		}
	}
}