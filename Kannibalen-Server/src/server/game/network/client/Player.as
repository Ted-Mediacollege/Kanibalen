package server.game.network.client 
{
	import flash.net.Socket;
	import server.engine.network.client.ClientConnection;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import server.game.Main;
	import server.game.network.Decoder;
	import server.game.data.ServerLog;
	import server.game.network.NetworkID;
	
	public class Player extends ClientConnection
	{
		public var playerID:int;
		public var playerName:String;
		public var ready:Boolean;
		
		public var posX:Number;
		public var posY:Number;
		public var velD:Number;
		public var velS:Number;
		public var size:int;
		public var hitcooldown:int;
		public var flashlight:int;
		
		public var newPos:Boolean;
		
		public var sendQueue:Vector.<String>;
		public var readQueue:Vector.<String>;
		
		public function Player(s:Socket, id:int) 
		{
			super(s);
			
			posX = 0;
			posY = 0;
			velD = 0;
			velS = 0;
			size = 0;
			hitcooldown = 0;
			flashlight = 1;
			
			newPos = true;
			ready = false;
			playerID = id;
			sendQueue = new Vector.<String>();
			readQueue = new Vector.<String>();
		}
		
		override public function onClientLost(e:Event):void
		{
			Main.playerManager.sendMessageToAllExcept(NetworkID.SERVER_LEAVE, "" + playerID, playerID);
			ServerLog.add("NETWORK", "Lost connection " + remoteAdress);
			disconnected = true;
		}
		
		override public function onNetworkError(e:IOErrorEvent):void
		{
			Main.playerManager.sendMessageToAllExcept(NetworkID.SERVER_LEAVE, "" + playerID, playerID);
			ServerLog.add("ERROR", "Lost client due to network error!" + remoteAdress, 0xFF0000);
			socket.close();
			disconnected = true;
		}
		
		override public function onRecieveData(e:ProgressEvent):void
		{			
			var m:Object = socket.readUTF();
			readQueue.push(m);
		}
		
		public function flushQueue():void
		{
			if (sendQueue.length > 0)
			{
				var sendString:String = "";
				var f:Boolean = true;
				while (sendQueue.length > 0)
				{
					if (f)
					{
						sendString += sendQueue.shift();
						f = false;
					}
					else
					{
						sendString += "@" + sendQueue.shift();
					}
				}
				socket.writeUTF(sendString);
				socket.flush();
			}
		}
		
		public function read():void
		{
			Decoder.decodeString(this);
		}
	}
}