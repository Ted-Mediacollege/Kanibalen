package server.game.world 
{
	import flash.events.Event;
	import server.game.Main;
	import server.game.data.ServerLog;
	import server.game.network.client.Player;
	import server.game.network.NetworkID;
	import server.game.data.GameState;
	import server.game.data.Settings;
	import server.engine.util.MathHelper;
	
	public class World
	{	
		public static var levelSize:int = 4000;
		
		public var frameLeft:int;
		public var timeLeft:int;
		
		public var timer_ready:int;
		public var timer_pos:int;
		public var timer_col:int;
		public var timer_yolomode:int;
		
		public var nextcolID:int;
		
		public var collectableList:Vector.<Collectable>;
		
		public function World() 
		{
			GameState.LOBBY = true;
			GameState.PLAYING = false;
		}
		
		public function tick():void
		{
			if (GameState.PLAYING)
			{
				frameLeft--;
				if (frameLeft < 0)
				{
					timeLeft--;
					if (timeLeft < 0)
					{
						end();
						return;
					}
					frameLeft += 30;
				}
				
				timer_pos--;
				if (timer_pos < 0)
				{
					timer_pos = 15;
					Main.playerManager.sendAllPostitions();
				}
				
				timer_col--;
				if (timer_col < 0)
				{
					timer_col = 300;
					if (collectableList.length < 10)
					{
						var c:Collectable = new Collectable(nextcolID, 50 + MathHelper.nextInt(1500), 50 + MathHelper.nextInt(1500));
						collectableList.push(c);
						nextcolID++;
						Main.playerManager.sendMessageToAll(NetworkID.SERVER_COLSPAWN, c.id + "&" + c.posX + "&" + c.posY);
					}
				}
				
				for (var p7:int = 0; p7 < Main.playerManager.clients.length; p7++ )
				{
					if ((Main.playerManager.clients[p7] as Player).size > 8)
					{
						end();
						return;
					}
				}
				
				for (var p:int = 0; p < Main.playerManager.clients.length; p++ )
				{
					var px:Number = (Main.playerManager.clients[p] as Player).posX;
					var py:Number = (Main.playerManager.clients[p] as Player).posY;
					
					for (var cl:int = collectableList.length - 1; cl > -1; cl-- )
					{
						if (collectableList[cl].checkCollision(px, py))
						{
							if ((Main.playerManager.clients[p] as Player).size < 9)
							{
								(Main.playerManager.clients[p] as Player).size++;
								Main.playerManager.sendMessageToClient(NetworkID.SERVER_SIZE, "" + (Main.playerManager.clients[p] as Player).size, (Main.playerManager.clients[p] as Player).playerID);
								Main.playerManager.sendMessageToAllExcept(NetworkID.SERVER_PLAYERSIZE, (Main.playerManager.clients[p] as Player).playerID + "&" + (Main.playerManager.clients[p] as Player).size, (Main.playerManager.clients[p] as Player).playerID);
								Main.playerManager.sendMessageToAll(NetworkID.SERVER_COLDESTROY, "" + collectableList[cl].id);
							}
							collectableList.splice(cl, 1);
						}
					}
				}
				
				if ((Settings.MAX_PLAYERS != 1 && Main.playerManager.clients.length < 2) || Main.playerManager.clients.length < 1)
				{
					end();
					return;
				}
				
				for (var p2:int = 0; p2 < Main.playerManager.clients.length; p2++ )
				{
					var px2:Number = (Main.playerManager.clients[p2] as Player).posX;
					var py2:Number = (Main.playerManager.clients[p2] as Player).posY;
					
					if ((Main.playerManager.clients[p2] as Player).hitcooldown > 0)
					{
						(Main.playerManager.clients[p2] as Player).hitcooldown--;
					}
					
					for (var e:int = 0; e < Main.playerManager.clients.length; e++ )
					{
						if (p2 != e)
						{
							if ((Main.playerManager.clients[p2] as Player).hitcooldown == 0 && (Main.playerManager.clients[e] as Player).hitcooldown == 0)
							{
								if (MathHelper.dis2(px2, py2, (Main.playerManager.clients[e] as Player).posX, (Main.playerManager.clients[e] as Player).posY) < 80)
								{
									if ((Main.playerManager.clients[p2] as Player).size > (Main.playerManager.clients[e] as Player).size)
									{
										if ((Main.playerManager.clients[p2] as Player).size < 9)
										{
											(Main.playerManager.clients[p2] as Player).size++;
										}
										
										var randomX:int = 100 + MathHelper.nextInt(1400);
										var randomY:int = 100 + MathHelper.nextInt(1400);
										
										(Main.playerManager.clients[p2] as Player).hitcooldown = 30;
										Main.playerManager.sendMessageToClient(NetworkID.SERVER_SIZE, "" + (Main.playerManager.clients[p2] as Player).size, (Main.playerManager.clients[p2] as Player).playerID);
										Main.playerManager.sendMessageToClient(NetworkID.SERVER_SIZE, "" + 1, (Main.playerManager.clients[e] as Player).playerID);
										Main.playerManager.sendMessageToAllExcept(NetworkID.SERVER_PLAYERSIZE, (Main.playerManager.clients[p2] as Player).playerID + "&" + (Main.playerManager.clients[p2] as Player).size, (Main.playerManager.clients[p2] as Player).playerID);
										Main.playerManager.sendMessageToAllExcept(NetworkID.SERVER_PLAYERSIZE, (Main.playerManager.clients[e] as Player).playerID + "&" + 1, (Main.playerManager.clients[e] as Player).playerID);
										Main.playerManager.sendMessageToClient(NetworkID.SERVER_DEATH, "" + (Main.playerManager.clients[p2] as Player).playerID, (Main.playerManager.clients[e] as Player).playerID);
										Main.playerManager.sendMessageToClient(NetworkID.SERVER_KILL, "" + (Main.playerManager.clients[e] as Player).playerID, (Main.playerManager.clients[p2] as Player).playerID);
										Main.playerManager.sendMessageToClient(NetworkID.SERVER_SPAWN, randomX + "&" + randomY, (Main.playerManager.clients[e] as Player).playerID);
										Main.playerManager.sendMessageToAll(NetworkID.SERVER_MESSAGE, (Main.playerManager.clients[p2] as Player).playerName + " ate " + (Main.playerManager.clients[e] as Player).playerName);
										(Main.playerManager.clients[e] as Player).posX = randomX;
										(Main.playerManager.clients[e] as Player).posY = randomY;
										(Main.playerManager.clients[e] as Player).size = 1;
										(Main.playerManager.clients[e] as Player).hitcooldown = 30;
									}
								}
							}
						}
					}
				}
			}
			else
			{
				
				timer_ready--;
				if (timer_ready < 0)
				{
					if (readyCheck())
					{
						start();
					}
				}
			}
		}
		
		public function start():void
		{
			ServerLog.add("WORLD", "Starting game...");
			
			//CHANGE GAMESTATE
			GameState.LOBBY = false;
			GameState.PLAYING = true;
			
			//SET TIMERS
			timer_pos = 30;
			timer_col = 120;
			timeLeft = Settings.GAMELENGTH * 60;
			frameLeft = 30;
			
			//COLL ARRAY
			collectableList = new Vector.<Collectable>();
			nextcolID = 0;
			
			//SPAWN ALL PLAYERS
			var xxx:int = 50;
			var yyy:int = 0;
			
			var namesMessage:String = "";
			for (var p:int = 0; p < Main.playerManager.clients.length; p++ )
			{
				if (p != 0) { namesMessage += "&" + (Main.playerManager.clients[p] as Player).playerName; } else { namesMessage += "" + (Main.playerManager.clients[p] as Player).playerName; }
				Main.playerManager.sendMessageToClient(NetworkID.SERVER_START, Settings.MAX_PLAYERS + "&" + Settings.GAMELENGTH + "&" + (Main.playerManager.clients[p] as Player).playerID + "&" + (p * xxx + 0) + "&" + yyy, (Main.playerManager.clients[p] as Player).playerID);
				(Main.playerManager.clients[p] as Player).posX = (p * xxx + 0);
				(Main.playerManager.clients[p] as Player).posY = yyy;
				(Main.playerManager.clients[p] as Player).size = 1;
			}
			
			ServerLog.add("WORLD", "game started!");
		}
		
		public function end():void
		{
			ServerLog.add("WORLD", "Ending game...");
			
			//CHANGE GAMESTATE
			GameState.LOBBY = true;
			GameState.PLAYING = false;
			
			//SET TIMERS
			timer_ready = 300;
			
			//SEND ENDING
			Main.playerManager.sendMessageToAll(NetworkID.SERVER_END, "");
			
			ServerLog.add("WORLD", "game ended!");
		}
		
		public function readyCheck():Boolean
		{
			if (Main.playerManager.clients.length < Settings.MAX_PLAYERS)
			{
				return false;
			}
			
			for (var i:int = 0; i < Main.playerManager.clients.length; i++ )
			{
				if (!(Main.playerManager.clients[i] as Player).ready)
				{
					return false;
				}
			}
			
			return true;
		}
	}
}