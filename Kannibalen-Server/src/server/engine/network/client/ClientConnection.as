package server.engine.network.client 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	public class ClientConnection 
	{
		public var socket:Socket;
		public var remoteAdress:String;
		public var disconnected:Boolean;
		
		public function ClientConnection(s:Socket) 
		{
			socket = s;
			socket.addEventListener(Event.CLOSE, onClientLost);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onNetworkError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onRecieveData);
			
			remoteAdress = socket.remoteAddress;
			disconnected = false;
		}
		
		public function onClientLost(e:Event):void
		{
			trace("[NETWORK]: Lost connection " + remoteAdress);
			disconnected = true;
		}
		
		public function onNetworkError(e:IOErrorEvent):void
		{
			trace("[NETWORK][ERROR]: Lost client due to network error " + remoteAdress);
			socket.close();
			disconnected = true;
		}
		
		public function onRecieveData(e:ProgressEvent):void
		{
		}
	}
}