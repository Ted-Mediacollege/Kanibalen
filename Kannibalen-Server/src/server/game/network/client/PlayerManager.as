package server.game.network.client 
{
	import server.engine.network.client.ClientManager;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import server.game.Main;
	import server.game.data.GameState;
	import server.game.network.NetworkID;
	import server.game.data.ServerLog;
	import server.engine.util.MathHelper;
	import server.game.data.Settings;
	
	public class PlayerManager extends ClientManager
	{
		public var sendTimer:int;
		
		public function PlayerManager() 
		{
			super();
		}
		
		override public function onIncommingConnection(e:ServerSocketConnectEvent):void
		{
			if(GameState.PLAYING) //REJECT IF NOT IN LOBBY
			{
				ServerLog.add("NETWORK", "Rejected connection " + e.socket.remoteAddress + " , REASON: " + NetworkID.REJECT_PLAYING);
				e.socket.writeUTF(NetworkID.SERVER_REJECT + "#" + NetworkID.REJECT_PLAYING + "&" + 2);
				e.socket.flush();
			}
			else
			{
				var nextID:int = getNextAvailibleID();
				
				if (nextID >= Settings.MAX_PLAYERS) //REJECT IF FULL
				{ 
					ServerLog.add("NETWORK", "Rejected connection " + e.socket.remoteAddress + " , REASON: " + NetworkID.REJECT_FULL);
					e.socket.writeUTF(NetworkID.SERVER_REJECT + "#" + NetworkID.REJECT_FULL + "&" + 0);
					e.socket.flush();
				}
				else //WELCOME PLAYER AND ASK FOR NAME
				{
					ServerLog.add("NETWORK", "Incomming connection " + e.socket.remoteAddress + " , PlayerID: " + nextID);
					e.socket.writeUTF(NetworkID.SERVER_WELCOME + "#");
					e.socket.flush();
					clients.push(new Player(e.socket, nextID));
				}
			}
		}
		
		override public function tick():void
		{
			sendTimer--;
			if (sendTimer < 0)
			{
				sendTimer = 15;
				for (var j:int = clients.length - 1; j > -1; j-- )
				{
					if (clients[j] != null)
					{
						if (clients[j].disconnected)
						{
							clients[j] = null;
							clients.splice(j, 1);
						}
						else
						{
							(clients[j] as Player).flushQueue();
						}
					}
					else
					{
						clients.splice(j, 1);
					}
				}
			}
			
			for (var i:int = clients.length - 1; i > -1; i-- )
			{
				(clients[i] as Player).posX = MathHelper.nextX((clients[i] as Player).posX, (clients[i] as Player).velD, (clients[i] as Player).velS);
				(clients[i] as Player).posY = MathHelper.nextX((clients[i] as Player).posY, (clients[i] as Player).velD, (clients[i] as Player).velS);
				
				if (clients[i] != null)
				{
					if (clients[i].disconnected)
					{
						clients[i] = null;
						clients.splice(i, 1);
					}
					else
					{
						(clients[i] as Player).read();
					}
				}
				else
				{
					clients.splice(i, 1);
				}
			}
		}
		
		public function sendAllPostitions():void
		{
			for (var i:int = 0; i < clients.length; i++) 
			{
				if ((clients[i] as Player).newPos)
				{
					sendMessageToAllExcept(NetworkID.SERVER_PLAYERPOS, 
						(clients[i] as Player).playerID + "&" + 
						(clients[i] as Player).posX + "&" + 
						(clients[i] as Player).posY + "&" + 
						int(Math.floor((clients[i] as Player).velD * 100)) + "&" + 
						int(Math.floor((clients[i] as Player).velS * 100)) + "&" + 
						(clients[i] as Player).flashlight,
					(clients[i] as Player).playerID);
				}
			}
			
			for (var j:int = 0; j < clients.length; j++) 
			{
				(clients[j] as Player).newPos = false;
			}
		}
		
		public function sendMessageToAll(id:int, message:String):void
		{
			sendMessageToAllExcept(id, message, -1);
		}
		
		public function sendMessageToAllExcept(id:int, message:String, playerID:int):void
		{
			for (var i:int = 0; i < clients.length; i++ )
			{
				if ((clients[i] as Player).playerID != playerID)
				{
					(clients[i] as Player).sendQueue.push(id + "#" + message);
				}
			}
		}
		
		public function sendMessageToClient(id:int, message:String, c:int):void
		{
			if (c < clients.length)
			{
				(clients[c] as Player).sendQueue.push(id + "#" + message);
			}
		}
		
		public function getNextAvailibleID():int
		{
			if (clients.length == 0)
			{
				return 0;
			}
			
			for (var id:int = 0; id < 100; id++ )
			{
				for (var p:int = 0; p < clients.length; p++ )
				{
					if (id == (clients[p] as Player).playerID)
					{
						break;
					}
					if (p == clients.length - 1)
					{
						return id;
					}
				}
			}
			return -1;
		}
	}
}