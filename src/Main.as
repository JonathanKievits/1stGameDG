package  src{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	
	public class Main extends MovieClip {

		private var t:Timer = new Timer(1000, 0);
		private var speedUp:Timer = new Timer(7000, 0);
		private var newSpeed:int = -30;
		private var Player:player = new player;
		private var PlayerAlive = true;
		
		public var arrows:Array = [];
		
		public function Main() {
			
			addChild(Player)
			
			t.addEventListener(TimerEvent.TIMER, tijd);
			speedUp.addEventListener(TimerEvent.TIMER, speedIsKey);
			addEventListener(Event.ENTER_FRAME, loop);
			
			Player.y = 200;
			Player.x = 100;
			
			t.start();
			speedUp.start();
		}
		function tijd(te:TimerEvent):void{
			arrows.push(new arrow());
			arrows[arrows.length-1].speed = newSpeed;
			addChild(arrows[arrows.length -1]);
			arrows[arrows.length -1].addEventListener(arrow.ARROW_OUT_OF_BOUNDS, deleteArrow);
		}
		function speedIsKey(te:TimerEvent):void
		{
			for(var i:int = 0; i < arrows.length; i++){
				newSpeed += -5;
				trace(newSpeed);
			}
		}
	
		function deleteArrow(e:Event):void{
			var Arrow:arrow = e.target as arrow;
			removeChild(Arrow);
			arrows.splice(arrows.indexOf(Arrow),1);
		}
		function loop(e:Event):void
		{
				for (var i =0; i < arrows.length; i++)
			{
				if (Player.hitTestObject(arrows[i])){
					removeChild(arrows[i]);
					arrows.splice(arrows[i]);
					PlayerAlive = false;
				}
			}
			
			if (PlayerAlive == false)
			{
				t.stop();
				speedUp.stop();
				t.removeEventListener(TimerEvent.TIMER, tijd);
				newSpeed = -30;
			}
		}
	}
	
}
