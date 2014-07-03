package kanibalen.game.world 
{
	import kanibalen.engine.util.MathHelper;
	import flash.display.MovieClip;
	import kanibalen.game.Main;

	public class Player extends PlayerOther
	{
		public function Player() 
		{
			super();
			art.x = Main.CenterWidth;
			art.y = Main.CenterHeight;
		}
		
		override public function setEvolution(e:int):void
		{
			Evolution = e;
		}
		
		override public function loop():void
		{
			art.gotoAndStop(Evolution);
			PosX = MathHelper.nextX(PosX, VelocityDirection, VelocitySpeed);
			PosY = MathHelper.nextY(PosY, VelocityDirection, VelocitySpeed);
			
			if (PosX < 0)
			{
				PosX = 0;
			}
			if (PosX > 1408 - 300 + 640)
			{
				PosX = 1408 - 300 + 640;
			}
			if (PosY < 0)
			{
				PosY = 0;
			}
			if (PosY > 1688 - 300 + 360)
			{
				PosY = 1688 - 300 + 360;
			}
			
			art.rotationZ = VelocityDirection;
		}
	}
}