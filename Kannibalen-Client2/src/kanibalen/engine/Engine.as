package kanibalen.engine 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.ByteArray;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import kanibalen.engine.gui.GuiButton;
	import kanibalen.engine.gui.GuiScreen;
	import kanibalen.engine.gui.GuiText;
	import kanibalen.engine.input.InputKey;
	import kanibalen.engine.input.InputMouse;
	import flash.display.StageDisplayState;
	import kanibalen.engine.util.MathHelper;
	import kanibalen.game.Main;
	
	public class Engine extends Sprite
	{
		public static var main:Main;
		
		public static var activeGui:GuiScreen;
		public static var active:Boolean;
		
		public var mouse:InputMouse;
		public var key:InputKey;
		
		public function Engine(m:Main, st:Stage, gui:GuiScreen) 
		{
			main = m;
			switchGui(gui);
			
			//mouse events
			mouse = new InputMouse();
			st.addEventListener(MouseEvent.MOUSE_MOVE, mouse.onMouseMove);
			st.addEventListener(MouseEvent.MOUSE_DOWN, mouse.onMouseDown);
			st.addEventListener(MouseEvent.MOUSE_UP, mouse.onMouseUp);
			st.addEventListener(MouseEvent.MOUSE_WHEEL, mouse.onMouseScroll);
			
			//key events
			key = new InputKey();
			st.addEventListener(KeyboardEvent.KEY_DOWN, key.onKeyDown);
			st.addEventListener(KeyboardEvent.KEY_UP, key.onKeyUp);
			
			//focus events
			st.addEventListener(Event.DEACTIVATE, onUnFocus);
			
			//tick
			st.addEventListener(Event.ENTER_FRAME, tick);
		}

		public function switchGui(newGui:GuiScreen):void
		{
			active = false;
			if (activeGui != null)
			{
				removeChild(activeGui);
			}
			activeGui = newGui;
			addChildAt(newGui, 0);
			activeGui.saveEngine(this);
			activeGui.init();
			active = true;
		}
		
		public function tick(e:Event):void
		{
			if (active)
			{
				activeGui.tick();
			}
		}
		
		public function onUnFocus(e:Event):void
		{
			if (active)
			{
				activeGui.unFocus();
			}
		}
		
		public function setFullscreen(b:Boolean):void
		{
			if (b)
			{
				stage.displayState=StageDisplayState.FULL_SCREEN;
			}
			else
			{
				stage.displayState=StageDisplayState.NORMAL;
			}
		}
	}
}