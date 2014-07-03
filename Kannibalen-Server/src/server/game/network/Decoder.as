package server.game.network 
{
	import server.game.network.client.Player;
	import server.game.Main;
	import server.game.network.NetworkID;
	
	public class Decoder 
	{
		public static function decodeString(player:Player):void
		{
			if (player.readQueue.length > 0)
			{
				var list:Array = (player.readQueue.shift()).split("@");
				for (var l:int = 0; l < list.length; l++)
				{
					var sa:Array = (list[l] as String).split("#");
					
					var type:int = parseInt((sa[0] as String));
					if (type == NetworkID.CLIENT_UPDATE)
					{
						var para:Array = sa[1].split("&");
						
						player.posX = parseInt(para[0]);
						player.posY = parseInt(para[1]);
						player.velD = parseInt(para[2]) / 100;
						player.velS = parseInt(para[3]) / 100;
						player.flashlight = parseInt(para[4]);
						
						player.newPos = true;
					}
					else if (type == NetworkID.CLIENT_NAME)
					{
						player.playerName = sa[1];
						player.ready = true;
					}
				}
			}
		}
	}
}