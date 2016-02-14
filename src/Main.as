package  src{
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.media.SoundMixer;
	
	public class Main extends MovieClip {

		private var t:Timer = new Timer(1000, 0);
		private var speedUp:Timer = new Timer(6000, 0);
		private var tOver:Timer = new Timer(0,1);
		private var newSpeed:int = -30;
		private var Player:player = new player;
		private var sPlayer:SPlayer = new SPlayer;
		private var gOScreen:goScreen = new goScreen;
		private var sScreen:startScreen = new startScreen;
		private var mScreen:soundScreen = new soundScreen;
		private var PlayerAlive:Boolean = true;
		private var pPlace:int = 0;
		private var score:Number = 0;
		private var Hscore:Number = 0;
		private var Tscore:TextField = new TextField;
		private var GDO:TextField = new TextField;
		private var Tformat:TextFormat = new TextFormat;
		private var dead:Boolean = false;
		private var Sstart:Boolean = true;
		private var GetDO:Boolean = false;
		private var req:URLRequest = new URLRequest("music/GDO.mp3");
		private var gj:URLRequest = new URLRequest("music/GJ.mp3");
		private var bgm:URLRequest = new URLRequest("music/BgM.mp3");
		private var sGDO:Sound = new Sound(req);
		private var GJ:Sound = new Sound(gj);
		private var BgM:Sound = new Sound(bgm);
		private var UT:Boolean = false;
		
		public var arrows:Array = [];
		
		public function Main() {
			
			addEventListener(Event.ENTER_FRAME, loop);
			addEventListener(Event.ENTER_FRAME, musicP);
			addEventListener(Event.ENTER_FRAME, UTActivated);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, deadManWalking);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, fstart);
			
			
			addChild(sPlayer)
			addChild(mScreen);
			mScreen.x = 275;
			mScreen.y = 200;
			
			sPlayer.y = 100;
			sPlayer.x = 100;
		}
			function fstart(event:KeyboardEvent):void {
				if(event.keyCode == Keyboard.SPACE){
					removeChild(mScreen);
					addChild(sScreen);
					sScreen.x = 275;
					sScreen.y = 200;
					stage.addEventListener(KeyboardEvent.KEY_DOWN, start);
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, fstart);
				}
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
		function UTActivated(e:Event):void{
			if(dead == true){
			if(score > 60){
				UT = true;
				Player.x = 100;
				removeEventListener(Event.ENTER_FRAME, UTActivated);
		  }
		  }
		}
		function musicP(e:Event):void{
			if(UT == true){
				if (score > 0)
					{
						SoundMixer.stopAll()
						GJ.play()
						removeEventListener(Event.ENTER_FRAME,musicP);
					}
				}else if (UT == false){
					if (score > 0)
					{
						SoundMixer.stopAll()
						BgM.play()
						removeEventListener(Event.ENTER_FRAME,musicP);
					}
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
					if (UT == false){
						sPlayer.y = 100;
					}else if (UT == true){
						Player.y = 100;
					}
					pPlace = 0;
				}
			} else if(pPlace == 0){
				if (event.keyCode == Keyboard.SPACE){
					if (UT == false){
						sPlayer.y = 300;
					}else if (UT == true){
						Player.y = 300;
					}
					pPlace = 1;
				}
			}
		}
		
		function loop(e:Event):void
		{
			scoreb.text = new String(score);
			for (var i =0; i < arrows.length; i++)
			{
				if(UT == false){
					if (sPlayer.hitTestObject(arrows[i])){
						removeChild(arrows[i]);
						arrows.splice(arrows[i]);
						PlayerAlive = false;
					}
				}else if (UT == true){
					if (Player.hitTestObject(arrows[i])){
						removeChild(arrows[i]);
						arrows.splice(arrows[i]);
						PlayerAlive = false;
					}
				}
			}
			
			if (score > Hscore)
				{
					Hscore = score;
				}
			
			if (PlayerAlive == false)
			{
				if (UT == false){
					removeChild(sPlayer);
				}else if (UT == true){
					removeChild(Player);
				}
				t.stop();
				speedUp.stop();
				t.removeEventListener(TimerEvent.TIMER, tijd);
				speedUp.removeEventListener(TimerEvent.TIMER, speedIsKey);
				newSpeed = -30;
				PlayerAlive = true;
				tOver.start();
			}
			Tscore.text = "High score: "+ Hscore;
			GDO.text = "geeettttttt dunked on!!!";
			Tscore.textColor = 0xFFFFFF;
			GDO.textColor = 0xFFFFFF;
			Tformat.font = "Comic Sans MS";
			Tformat.size = 24;
			Tscore.width = 300;
			GDO.width = 300;
			Tscore.defaultTextFormat = Tformat;
			GDO.defaultTextFormat = Tformat;
		}
		function gameOver(e:Event):void
		{
			SoundMixer.stopAll()
			tOver.stop();
			addChild(gOScreen);
			gOScreen.x = 275;
			gOScreen.y = 200;
			addChild(Tscore);
			Tscore.x = 210;
			Tscore.y = 350;
			if(UT == true){
				if (score == 0)
				{
					addChild(GDO);
					GetDO = true;
					GDO.x = 145;
					GDO.y = 280;
					sGDO.play();
				}
			}
			dead = true;
		}
		function deadManWalking(event:KeyboardEvent):void {
			if (dead == true){
				if (event.keyCode == Keyboard.SPACE){
					score = 0;
					if(UT == false){
						addChild(sPlayer);
					}else if (UT == true){
						addChild(Player);
					}
					t.addEventListener(TimerEvent.TIMER, tijd);
					speedUp.addEventListener(TimerEvent.TIMER, speedIsKey);
					addEventListener(Event.ENTER_FRAME, musicP);
					t.start();
					speedUp.start();
					removeChild(gOScreen);
					removeChild(Tscore);
					dead = false;
					if (GetDO == true)
					{
						removeChild(GDO);
						GetDO = false;
						SoundMixer.stopAll()
					}
				}
			}
		}
	}
}