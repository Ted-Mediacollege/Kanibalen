package server.engine.network.client 
{
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	
	public class ClientManager 
	{
		public var connectionSocket:ServerSocket;
		public var clients:Vector.<ClientConnection>;
		
		public function ClientManager() 
		{
			connectionSocket = new ServerSocket();
			connectionSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onIncommingConnection);
			connectionSocket.bind(2022);
			connectionSocket.listen();
			
			clients = new Vector.<ClientConnection>();
		}

		public function onIncommingConnection(e:ServerSocketConnectEvent):void
		{
			trace("[NETWORK]: Incomming connection " + e.socket.remoteAddress);
			clients.push(new ClientConnection(e.socket));
		}
		
		public function tick():void
		{
			for (var i:int = clients.length - 1; i > -1; i-- )
			{
				if (clients[i] != null)
				{
					if (clients[i].disconnected)
					{
						clients[i] = null;
						clients.splice(i, 1);
					}
				}
				else
				{
					clients.splice(i, 1);
				}
			}
		}
	}
}