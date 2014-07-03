package kanibalen.game.network 
{
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import kanibalen.game.Main;
	import kanibalen.engine.util.MathHelper;
	
	public class Connection 
	{
		public var socket:Socket;
		public var connected:Boolean;
		
		public static var IP:String;
		public static var PORT:int;
		
		public var sendQueue:Vector.<String>;
		public var readQueue:Vector.<String>;
		
		public var flushtimer:int;
		
		public function Connection() 
		{
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.addEventListener(Event.CLOSE, onDisconnect);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onRecieveData);
			
			sendQueue = new Vector.<String>();
			readQueue = new Vector.<String>();
		}
		
		public function connect():void
		{
			try
			{
				socket.connect(IP, PORT);
			}
			catch (e:Error)
			{
				trace("connection error");
			}
		}
		
		public function onConnect(e:Event):void
		{
			connected = true;
		}
		
		public function onDisconnect(e:Event):void
		{
			connected = false;
		}
		
		public function onRecieveData(e:ProgressEvent):void
		{
			var m:String = socket.readUTF();
			readQueue.push(m);
		}
		
		public function tick():void
		{
			read();
			flushtimer--;
			if (flushtimer < 0)
			{
				flushtimer = 6;
				flushQueue();
			}
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
		
		public function send(id:int, message:String):void
		{
			sendQueue.push(id + "#" + message);
		}
	}
}