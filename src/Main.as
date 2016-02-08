package  src{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	public class Main extends MovieClip {

		private var t:Timer = new Timer(1000, 0);
		private var speedUp:Timer = new Timer(6000, 0);
		private var tOver:Timer = new Timer(0,1);
		private var newSpeed:int = -30;
		private var Player:player = new player;
		private var gOScreen:goScreen = new goScreen;
		private var sScreen:startScreen = new startScreen;
		private var PlayerAlive:Boolean = true;
		private var pPlace:int = 0;
		private var score:Number = 0;
		private var dead:Boolean = false;
		private var Sstart:Boolean = true;
		
		public var arrows:Array = [];
		
		public function Main() {
			
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, deadManWalking);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, start);
			
			addChild(Player)
			addChild(sScreen);
			sScreen.x = 275;
			sScreen.y = 200;
			
			Player.y = 100;
			Player.x = 100;
		}
			function start(event:KeyboardEvent):void {
			
			if (Sstart == true){
				if (event.keyCode == Keyboard.SPACE){
					removeChild(sScreen);
					t.start();
					speedUp.start();
					t.addEventListener(TimerEvent.TIMER, tijd);
					speedUp.addEventListener(TimerEvent.TIMER, speedIsKey);
					tOver.addEventListener(TimerEvent.TIMER, gameOver);
					Sstart = false;
				}
			} else if (Sstart == false){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, start);
			}
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
			}
			
			if (newSpeed < -150)
			{
				speedUp.removeEventListener(TimerEvent.TIMER, speedIsKey);
			}
		}
	
		function deleteArrow(e:Event):void{
			var Arrow:arrow = e.target as arrow;
			removeChild(Arrow);
			arrows.splice(arrows.indexOf(Arrow),1);
			score++;
		}
		
		function pMove(event:KeyboardEvent):void{
			if(pPlace == 1){
				if (event.keyCode == Keyboard.SPACE){
					Player.y = 100;
					pPlace = 0;
				}
			} else if(pPlace == 0){
				if (event.keyCode == Keyboard.SPACE){
					Player.y = 300;
					pPlace = 1;
				}
			}
		}
		
		function loop(e:Event):void
		{
			scoreb.text = new String(score);
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
				removeChild(Player);
				t.stop();
				speedUp.stop();
				t.removeEventListener(TimerEvent.TIMER, tijd);
				speedUp.removeEventListener(TimerEvent.TIMER, speedIsKey);
				newSpeed = -30;
				score = 0;
				PlayerAlive = true;
				tOver.start();
			}
		}
		function gameOver(e:Event):void
		{
			tOver.stop();
			addChild(gOScreen);
			gOScreen.x = 275;
			gOScreen.y = 200;
			dead = true;
		}
		function deadManWalking(event:KeyboardEvent):void {
			if (dead == true){
				if (event.keyCode == Keyboard.SPACE){
					addChild(Player);
					t.addEventListener(TimerEvent.TIMER, tijd);
					speedUp.addEventListener(TimerEvent.TIMER, speedIsKey);
					t.start();
					speedUp.start();
					removeChild(gOScreen);
					dead = false;
				}
			}
		}
	}
	
}