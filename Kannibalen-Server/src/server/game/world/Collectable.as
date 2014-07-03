package server.game.world 
{
	import server.engine.util.MathHelper;
	
	public class Collectable 
	{
		public var posX:int;
		public var posY:int;
		public var id:int;
		
		public function Collectable(i:int, px:int, py:int) 
		{
			id = i;
			posX = px;
			posY = py;
		}
		
		public function checkCollision(x:Number, y:Number):Boolean
		{
			if (MathHelper.dis2(x, y, posX, posY) < 80)
			{
				return true;
			}
			return false;
		}
	}
}