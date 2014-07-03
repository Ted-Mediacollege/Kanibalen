package server.engine.network.policy 
{
	import flash.geom.Point;
	import flash.net.ServerSocket;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.ProgressEvent;
	
	public class PolicyManager 
	{
		public var policySocket:ServerSocket;
		public var requests:Vector.<PolicyRequest>;
		
		public function PolicyManager(port:int = 843) 
		{
			policySocket = new ServerSocket();
			policySocket.addEventListener(ServerSocketConnectEvent.CONNECT, onPolicyRequest);
			policySocket.bind(port);
			policySocket.listen();
			
			requests = new Vector.<PolicyRequest>();
		}
		
		public function onPolicyRequest(e:ServerSocketConnectEvent):void
		{
			requests.push(new PolicyRequest(e.socket));
		}
		
		public function tick():void
		{
			for (var i:int = requests.length - 1; i > -1; i-- )
			{
				if (requests[i].done)
				{
					requests.splice(i, 1);
				}
			}
		}
	}
}