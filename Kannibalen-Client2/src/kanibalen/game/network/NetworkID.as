package kanibalen.game.network 
{
	public class NetworkID 
	{
		//CLIENT -> SERVER
		public static var CLIENT_NAME:int = 0; //X
		public static var CLIENT_UPDATE:int = 1; //X

		//SERVER -> CLIENT
		public static var SERVER_REJECT:int = 0; //X
		public static var SERVER_WELCOME:int = 1; //X
		public static var SERVER_JOIN:int = 2; 
		public static var SERVER_LEAVE:int = 3; //X
		public static var SERVER_LEADER:int = 4;
		public static var SERVER_MESSAGE:int = 5;
		public static var SERVER_SPAWN:int = 6; //X
		public static var SERVER_END:int = 7; //X
		public static var SERVER_SIZE:int = 8; //X
		public static var SERVER_KILL:int = 9; //X
		public static var SERVER_DEATH:int = 10; //X
		public static var SERVER_PLAYERPOS:int = 11; //X
		public static var SERVER_PLAYERSIZE:int = 12; //X
		public static var SERVER_COLSPAWN:int = 13; //X
		public static var SERVER_COLDESTROY:int = 14; //X
		public static var SERVER_START:int = 15; //X
		
		//REJECT REASON
		public static var REJECT_FULL:int = 0;
		public static var REJECT_PLAYING:int = 1;
	}
}