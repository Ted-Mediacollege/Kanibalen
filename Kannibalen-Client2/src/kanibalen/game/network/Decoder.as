package kanibalen.game.network 
{
	import kanibalen.game.network.NetworkID;
	import kanibalen.game.gui.GuiConnecting;
	import kanibalen.game.data.Settings;
	import kanibalen.game.gui.GuiLobby;
	import kanibalen.game.world.Level;
	import kanibalen.game.world.PlayerOther;
	import kanibalen.game.world.ChatLog;
	import kanibalen.game.gui.GuiGame;
	
	public class Decoder
	{
		public static function decodeString(con:Connection):void
		{
			if (con.readQueue.length > 0)
			{
				var list:Array = (con.readQueue.shift()).split("@");
				for (var l:int = 0; l < list.length; l++ )
				{
					var sa:Array = (list[l] as String).split("#");
					
					var type:int = parseInt((sa[0] as String));
					if (type == NetworkID.SERVER_PLAYERPOS)
					{
						var ppa:Array = (sa[1] as String).split("&");
						
						if (Level.players.playerlist != null)
						{
							var po:PlayerOther = Level.players.playerlist[parseInt(ppa[0])];
							po.PosX = parseInt(ppa[1]);
							po.PosY = parseInt(ppa[2]);
							po.VelocityDirection = parseInt(ppa[3]) / 100;
							po.VelocitySpeed = parseInt(ppa[4]) / 100;
							po.flashlight = parseInt(ppa[5]);
						}
					}
					else if (type == NetworkID.SERVER_PLAYERSIZE)
					{
						var ppa2:Array = (sa[1] as String).split("&");
						var size1:int = parseInt((ppa2[0] as String));
						var size2:int = parseInt((ppa2[1] as String));
						Level.players.playerlist[size1].setEvolution(size2);
					}
					else if (type == NetworkID.SERVER_REJECT)
					{
						var para0:Array = (sa[1] as String).split("&");
						GuiConnecting.state = parseInt((para0[0] as String));
						GuiConnecting.time = parseInt((para0[1] as String));
					}
					else if (type == NetworkID.SERVER_WELCOME)
					{
						GuiConnecting.state = 2;
					}
					else if (type == NetworkID.SERVER_JOIN)
					{
						var nameParas:Array = (sa[1] as String).split("&");
						for (var names:int = 0; names < nameParas.length; names++ )
						{
							Level.players.playerlist[names].playerName = (nameParas[names] as String);
						}
					}
					else if (type == NetworkID.SERVER_LEAVE)
					{
						var leaveID:int = parseInt((sa[1] as String));
						Level.players.removeChild(Level.players.playerlist[leaveID]);
						Level.players.playerlist[leaveID].dis = true;
						ChatLog.addMessage("player" + Level.players.playerlist[leaveID].playerName + " disconnected");
					}
					else if (type == NetworkID.SERVER_LEADER)
					{
						//SCORE BOARD
					}
					else if (type == NetworkID.SERVER_MESSAGE)
					{
						ChatLog.addMessage((sa[1] as String));
					}
					else if (type == NetworkID.SERVER_SPAWN)
					{
						var para2:Array = (sa[1] as String).split("&");
						Level.players.player.PosX = parseInt((para2[0] as String));
						Level.players.player.PosY = parseInt((para2[1] as String));
					}
					else if (type == NetworkID.SERVER_END)
					{
						GuiGame.gameEnded = true;
					}
					else if (type == NetworkID.SERVER_SIZE)
					{
						var size:int = parseInt((sa[1] as String));
						Level.players.player.setEvolution(size);
					}
					else if (type == NetworkID.SERVER_KILL)
					{
					}
					else if (type == NetworkID.SERVER_DEATH)
					{
					}
					else if (type == NetworkID.SERVER_COLSPAWN)
					{
						var para3:Array = (sa[1] as String).split("&");
						var colID:int = parseInt(para3[0]);
						var colX:int = parseInt(para3[1]);
						var colY:int = parseInt(para3[2]);
						Level.collectables.Spawn(colID, colX, colY);
					}
					else if (type == NetworkID.SERVER_COLDESTROY)
					{
						Level.collectables.Destroy(parseInt((sa[1] as String)));
					}
					else if (type == NetworkID.SERVER_START)
					{	
						var para1:Array = (sa[1] as String).split("&");
						Settings.MAX_PLAYERS = parseInt((para1[0] as String));
						Settings.GAMELENGTH = parseInt((para1[1] as String));
						Settings.IGNORE = parseInt((para1[2] as String));
						GuiLobby.started = true;
						GuiLobby.spawnX = parseInt((para1[3] as String));
						GuiLobby.spawnY = parseInt((para1[4] as String));
					}
				}
			}
		}
	}
}