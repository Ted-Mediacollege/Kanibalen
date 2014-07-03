package kanibalen.game.world 
{
	import flash.display.MovieClip;
	import kanibalen.engine.util.MathHelper;
	import kanibalen.game.Main;

	public class PlayerOther extends MovieClip
	{
		public var art:MovieClip;
		public var PosX:Number;
		public var PosY:Number;
		public var Evolution:int;
		public var VelocityDirection:Number;
		public var VelocitySpeed:Number;
		public var flashlight:int;
		public var dis:Boolean;
		public var playerName:String;
		
		public var smoothX:Number;
		public var smoothY:Number;
		public var smoothDirection:Number;
		public var smoothSpeed:Number;
		
		public function PlayerOther() 
		{
			PosX = 0;
			PosY = 0;
			Evolution = 1;
			VelocityDirection = 0;
			VelocitySpeed = 0;
			flashlight = 1;
			dis = false;
			playerName = "";
			
			smoothX = 0;
			smoothY = 0;
			smoothDirection = 0;
			smoothSpeed = 0;
			
			art = new Characters();
			addChild(art);
			art.gotoAndStop(Evolution);
		}
		
		public function setEvolution(e:int):void
		{
			Evolution = e;
		}
		
		public function loop():void
		{
			//UPDATE POS FROM SERVER
			PosX = MathHelper.nextX(PosX, VelocityDirection, VelocitySpeed);
			PosY = MathHelper.nextY(PosY, VelocityDirection, VelocitySpeed);
			
			//UPDATE OUR POS
			smoothX = ((smoothX * 4) + PosX) / 5;
			smoothY = ((smoothY * 4) + PosY) / 5;
			smoothSpeed = ((smoothSpeed * 4) + VelocitySpeed) / 5;
			smoothDirection -= (smoothDirection - VelocityDirection) / 5;
			
			art.gotoAndStop(Evolution);
			art.rotationZ = smoothDirection;
			art.x = -Level.players.player.PosX + smoothX + Main.CenterWidth;
			art.y = -Level.players.player.PosY + smoothY + Main.CenterHeight;
		}
	}
}