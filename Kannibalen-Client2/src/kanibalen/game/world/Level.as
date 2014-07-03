package kanibalen.game.world
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Shape;
	import kanibalen.engine.util.MathHelper;
	import kanibalen.game.Main;
	import kanibalen.game.data.Settings;

	public class Level extends Sprite
	{
		private var background:Background = new Background();
		public static var players:Players;
		public static var collectables:Collectables;
		public var levelmask:Shape = new Shape();
		
		public function Level(spawnX:int, spawnY:int) 
		{
			players = new Players(spawnX, spawnY);
			collectables = new Collectables();
			addChild(background);
			addChild(collectables);
			addChild(players);
			background.x = -players.player.PosX;
			background.y = -players.player.PosY;
			addChild(levelmask);
			this.mask = levelmask;
		}
		
		public function loop():void
		{
			background.x = -players.player.PosX - 150 + 640;
			background.y = -players.player.PosY - 150 + 360;
			collectables.loop();
			players.loop();
			
			levelmask.graphics.clear();
			if (players.player.flashlight == 1)
			{
				drawLight(Main.CenterWidth, Main.CenterHeight, players.player.VelocityDirection);
			}
			for (var i:int = 0; i < players.playerlist.length; i++ )
			{
				if (i != Settings.IGNORE)
				{
					if (players.playerlist[i].flashlight == 1 && players.playerlist[i].dis == false)
					{
						drawLight( -players.player.PosX + players.playerlist[i].smoothX + Main.CenterWidth, -players.player.PosY + players.playerlist[i].smoothY + Main.CenterHeight, players.playerlist[i].smoothDirection);
					}
				}
			}
		}
		
		public function drawLight(px:int, py:int, d:Number):void
		{
			levelmask.graphics.beginFill(0x000000);
			levelmask.graphics.drawCircle(MathHelper.nextX(px, d, 50), MathHelper.nextY(py, d, 50), 60);
			levelmask.graphics.drawCircle(MathHelper.nextX(px, d, 290), MathHelper.nextY(py, d, 290), 120);
			var vecs:Vector.<Number> = new Vector.<Number>(8);
			vecs[0] = MathHelper.nextX(MathHelper.nextX(px, d, 42), d - 90, 60);
			vecs[2] = MathHelper.nextX(MathHelper.nextX(px, d, 275), d - 90, 120);
			vecs[4] = MathHelper.nextX(MathHelper.nextX(px, d, 275), d + 90, 120);
			vecs[6] = MathHelper.nextX(MathHelper.nextX(px, d, 42), d + 90, 60);
			vecs[1] = MathHelper.nextY(MathHelper.nextY(py, d, 42), d - 90, 60);
			vecs[3] = MathHelper.nextY(MathHelper.nextY(py, d, 275), d - 90, 120);
			vecs[5] = MathHelper.nextY(MathHelper.nextY(py, d, 275), d + 90, 120);
			vecs[7] = MathHelper.nextY(MathHelper.nextY(py, d, 42), d + 90, 60);
			levelmask.graphics.moveTo(vecs[6], vecs[7]);
			for (var i:int = 0; i < 8; i+=2 )
			{
				levelmask.graphics.lineTo(vecs[i], vecs[1 + i]);
			}
			levelmask.graphics.endFill();
		}
	}
}