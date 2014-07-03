package kanibalen.game.world 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import kanibalen.engine.util.MathHelper;
	import kanibalen.game.Main;
	import kanibalen.game.data.Settings;
	import kanibalen.game.network.NetworkID;

	public class Players extends MovieClip
	{
		public var player:Player;
		public var playerlist:Vector.<PlayerOther>;
		
		public var timer_pos:int;
		
		public function Players(spawnX:int, spawnY:int) 
		{
			timer_pos = 10;
			
			playerlist = new Vector.<PlayerOther>();
			for (var i:int = 0; i < Settings.MAX_PLAYERS; i++) 
			{
				var p:PlayerOther = new PlayerOther();
				if (i != Settings.IGNORE)
				{
					addChild(p);
				}
				p.PosY = i * 20;
				playerlist.push(p);
			}
			
			player = new Player();
			player.PosX = spawnX;
			player.PosY = spawnY;
			addChild(player);
		}
		
		public function loop():void 
		{
			player.loop();
			
			player.VelocitySpeed = MathHelper.dis2(Main.CenterWidth, Main.CenterHeight, mouseX, mouseY) / 20;
			var max:Number = 3 - (player.Evolution / 6);
			if (player.VelocitySpeed > max)
			{
				player.VelocitySpeed = max;
			}
			player.VelocityDirection = MathHelper.pointToDegree(Main.CenterWidth, Main.CenterHeight , mouseX, mouseY);
			
			for (var i:int = playerlist.length - 1; i > -1; i--) 
			{
				playerlist[i].loop();
			}
			
			timer_pos--;
			if (timer_pos < 0)
			{
				timer_pos = 15;
				Main.connection.send(NetworkID.CLIENT_UPDATE, int(Math.floor(player.PosX)) + "&" + int(Math.floor(player.PosY)) + "&" + int(Math.floor(player.VelocityDirection * 100)) + "&" + int(Math.floor(player.VelocitySpeed * 100)) + "&" + player.flashlight);
			}
		}
	}
}