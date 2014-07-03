package kanibalen.game.world 
{
	import kanibalen.engine.util.MathHelper;
	import flash.display.MovieClip;
	import flash.events.Event;
	import kanibalen.game.Main;
	/**
	 * ...
	 * @author Fabian Verkuijlen
	 */
	public class Collectables extends MovieClip
	{
		private var CollectablesList:Vector.<Collectable> = new Vector.<Collectable>();
		
		private var IdCollectable:int;
		
		public function Collectables() 
		{
			
		}
		
		public function loop():void 
		{
			for (var i:int = 0; i < CollectablesList.length; i++) 
			{
				CollectablesList[i].loop();
			}
		}
		
		public function Spawn(Id:int,PositionX:Number, PosistionY:Number):void
		{
			var collectable1:Collectable = new Collectable(Id, PositionX, PosistionY);
			CollectablesList.push(collectable1);
			addChild(collectable1);
		}
		
		public function Destroy(Id:int):void
		{
			for (var i:int = 0; i < CollectablesList.length; i++) 
			{
				if (CollectablesList[i].IdCollectable == Id)
				{
					removeChild(CollectablesList[i]);
					CollectablesList.splice(i, 1);
					break;
				}
			}
		}
	}

}