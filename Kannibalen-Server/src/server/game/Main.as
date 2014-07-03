package server.game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import server.engine.network.policy.PolicyManager;
	import server.game.network.client.PlayerManager;
	import server.game.world.World;
	import server.game.data.ServerLog;
	import server.engine.util.FPSCounter;
	
	public class Main extends Sprite 
	{
		public var log:ServerLog;
		public var policyManager:PolicyManager;
		public static var playerManager:PlayerManager;
		public static var world:World;
		
		public function Main():void 
		{
			log = new ServerLog();
			addChild(log);
			
			ServerLog.add("SERVER", "Starting server...", 0xFF0000);
			
			policyManager = new PolicyManager();
			playerManager = new PlayerManager();
			world = new World();
			
			ServerLog.add("SERVER", "Server is ready!", 0xFF0000);
			
			stage.addEventListener(Event.ENTER_FRAME, tick);
		}
		
		public function tick(e:Event):void 
		{
			policyManager.tick();
			playerManager.tick();
			world.tick();
			log.loop();
		}
	}
}