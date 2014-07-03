package server.engine.network.policy 
{
	import flash.net.Socket;
	import flash.events.ProgressEvent;
	
	public class PolicyRequest
	{
		public var socket:Socket;
		public var done:Boolean = false;
		
		public function PolicyRequest(s:Socket) 
		{
			socket = s;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onRecieveRequest);
		}
		
		public function onRecieveRequest(e:ProgressEvent):void
		{
			socket.writeUTFBytes('<cross-domain-policy><allow-access-from domain="*" to-ports="2022" /></cross-domain-policy>');
			socket.writeByte(0);
			socket.flush();
			socket.close();
			done = true;
		}
	}
}