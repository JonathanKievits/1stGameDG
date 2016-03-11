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
	import flash.net.SharedObject;
	
	public class Main extends MovieClip {

		private var t:Timer = new Timer(1000, 0);
		private var t2:Timer = new Timer(1750, 0);
		private var speedUp:Timer = new Timer(7000, 0);
		private var tOver:Timer = new Timer(0,1);
		private var newSpeed:int = -30;
		private var Player:player = new player;
		private var Cloud:cloud = new cloud;
		private var sPlayer:SPlayer = new SPlayer;
		private var SpeedyUp:SpeedUp = new SpeedUp;
		private var gOScreen:goScreen = new goScreen;
		private var sScreen:startScreen = new startScreen;
		private var mScreen:soundScreen = new soundScreen;
		private var fScreen:Timer = new Timer(3000, 1);
		private var PlayerAlive:Boolean = true;
		private var pPlace:int = 0;
		private var score:Number = 0;
		private var Hscore:Number = 0;
		private var Tscore:TextField = new TextField;
		private var speedM:TextField = new TextField;
		private var GDO:TextField = new TextField;
		private var UtLosts:TextField = new TextField;
		private var UtLosts2:TextField = new TextField;
		private var Tformat:TextFormat = new TextFormat;
		private var Tformat2:TextFormat = new TextFormat;
		private var dead:Boolean = false;
		private var cL:Boolean = false;
		private var Sstart:Boolean = true;
		private var GetDO:Boolean = false;
		private var SUHello:Boolean = true;
		private var req:URLRequest = new URLRequest("music/GDO.mp3");
		private var gj:URLRequest = new URLRequest("music/GJ.mp3");
		private var bgm:URLRequest = new URLRequest("music/BgM.mp3");
		private var lost:URLRequest = new URLRequest("music/Lost.mp3");
		private var loser:URLRequest = new URLRequest("music/Loser.mp3");
		private var CGJ:SoundChannel = new SoundChannel();
		private var CBgM:SoundChannel = new SoundChannel();
		private var volumeAdjust:SoundTransform = new SoundTransform();
		private var sGDO:Sound = new Sound(req);
		private var GJ:Sound = new Sound(gj);
		private var BgM:Sound = new Sound(bgm);
		private var UtLost:Sound = new Sound(lost);
		private var NLoser:Sound = new Sound(loser);
		private var UT:Boolean = false;
		private var UTL:Boolean = false;
		private var save:SharedObject;
		
		public var arrows:Array = [];
		
		public function Main() {
			addEventListener(Event.ENTER_FRAME, loop);
			addEventListener(Event.ENTER_FRAME, musicP);
			addEventListener(Event.ENTER_FRAME, UTActivated);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, deadManWalking);
			fScreen.addEventListener(TimerEvent.TIMER, fstart);
			
			getData();
			
			volumeAdjust.volume = 0.3;
			
			
			addChild(sPlayer)
			addChild(mScreen);
			mScreen.x = 275;
			mScreen.y = 200;
			
			sPlayer.y = 100;
			sPlayer.x = 100;
			fScreen.start();
		}
			function fstart(te:TimerEvent):void {
				removeChild(mScreen);
				fScreen.stop();
				addChild(sScreen);
				sScreen.x = 275;
				sScreen.y = 200;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, start);
				fScreen.removeEventListener(TimerEvent.TIMER, fstart);
			}
			function start(event:KeyboardEvent):void {
			
			if (Sstart == true){
				if (event.keyCode == Keyboard.SPACE){
					removeChild(sScreen);
					t.start();
					t2.start();
					speedUp.start();
					t.addEventListener(TimerEvent.TIMER, tijd);
					t2.addEventListener(TimerEvent.TIMER, tijd2);
					speedUp.addEventListener(TimerEvent.TIMER, speedIsKey);
					tOver.addEventListener(TimerEvent.TIMER, gameOver);
					Sstart = false;
					addChild(speedM);
					speedM.x = 50;
					speedM.y = 370;
				}
			} else if (Sstart == false){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, start);
			}
		}
		function getData():void{
			save = SharedObject.getLocal("save");
			if (save.data.Highscore != null){
				Hscore = save.data.Highscore;
			}else{
				save.data.Highscore = 0;
				Hscore = save.data.Highscore;
				save.flush(10000);
			}
			save.close();
		}
		function setData():void{
			save.data.Highscore = Hscore;
			save.flush(1000);
			save.close();
		}
		function UTActivated(e:Event):void{
			if(score > 49){
				if(dead == true){
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
						SoundMixer.stopAll();
						CGJ = GJ.play();
						CGJ.soundTransform = volumeAdjust;
						removeEventListener(Event.ENTER_FRAME,musicP);
						
					}
				}else if (UT == false){
					if (score > 0)
					{
						SoundMixer.stopAll();
						CBgM = BgM.play();
						CBgM.soundTransform = volumeAdjust;
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
		function tijd2(te:TimerEvent):void{
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
			if(SUHello == true)
				{
					addChild(SpeedyUp);
					SpeedyUp.x = 450;
					SpeedyUp.y = 30;
					SUHello = false;
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
			if(SUHello == false)
			{
				removeChild(SpeedyUp);
				SUHello = true;
			}
		}
		
		function pMove(event:KeyboardEvent):void{
			if(pPlace == 1){
				if (event.keyCode == Keyboard.SPACE){
					if (UT == false){
						sPlayer.y = 100;
						if(cL == false)
						{
							addChild(Cloud);
							Cloud.x = 100
							Cloud.y = 150
							cL = true
						}
					}else if (UT == true){
						Player.y = 100;
					}
					pPlace = 0;
				}
			} else if(pPlace == 0){
				if (event.keyCode == Keyboard.SPACE){
					if (UT == false){
						sPlayer.y = 200;
						if(cL == true)
							{
								Cloud.y = 250
							}
					}else if (UT == true){
						Player.y = 200;
					}
					pPlace = 2;
				}
			} else if(pPlace == 2){
				if (event.keyCode == Keyboard.SPACE){
					if (UT == false){
						sPlayer.y = 300;
						if(cL == true)
							{
								removeChild(Cloud);
								cL = false
							}
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
						arrows.splice(i,1);
						PlayerAlive = false;
					}
				}else if (UT == true){
					if (Player.hitTestObject(arrows[i])){
						removeChild(arrows[i]);
						arrows.splice(i, 1);
						PlayerAlive = false;
					}
				}
			}
			
			if (score > Hscore)
				{
					Hscore = score;
					setData();
				}
			
			if (PlayerAlive == false)
			{
				if (UT == false){
					removeChild(sPlayer);
				}else if (UT == true){
					removeChild(Player);
				}
				t.stop();
				t2.stop();
				speedUp.stop();
				t.removeEventListener(TimerEvent.TIMER, tijd);
				t2.removeEventListener(TimerEvent.TIMER, tijd2);
				speedUp.removeEventListener(TimerEvent.TIMER, speedIsKey);
				newSpeed = -30;
				PlayerAlive = true;
				tOver.start();
				removeChild(speedM);
			}
			Tscore.text = "High score: "+ Hscore;
				speedM.text = "Arrow speed: "+ (newSpeed *-1);
			GDO.text = "geeettttttt dunked on!!!";
			UtLosts.text = "You can not give up just yet...";
			UtLosts2.text = "Stay determined...";
			Tscore.textColor = 0xFFFFFF;
			speedM.textColor = 0xFFFFFF;
			GDO.textColor = 0xFFFFFF;
			UtLosts.textColor = 0xFFFFFF;
			UtLosts2.textColor = 0xFFFFFF;
			Tformat.font = "Comic Sans MS";
			Tformat2.font = "8-Bit Madness";
			Tformat.size = 24;
			Tformat2.size = 30;
			Tscore.width = 300;
			speedM.width = 300;
			GDO.width = 300;
			UtLosts.width = 600;
			UtLosts2.width = 300;
			Tscore.defaultTextFormat = Tformat;
			speedM.defaultTextFormat = Tformat2;
			GDO.defaultTextFormat = Tformat;
			UtLosts.defaultTextFormat = Tformat2;
			UtLosts2.defaultTextFormat = Tformat2;
		}
		function gameOver(e:Event):void
		{
			SoundMixer.stopAll()
			tOver.stop();
			addChild(gOScreen);
			gOScreen.x = 275;
			gOScreen.y = 200;
			addChild(Tscore);
			Tscore.x = 190;
			Tscore.y = 350;
			for(var i:int = 0; i < arrows.length; i++){
				removeChild(arrows[i]);
				arrows.splice(i,1);
			}
			if(UT == true){
				if (score == 0)
				{
					addChild(GDO);
					GetDO = true;
					GDO.x = 145;
					GDO.y = 280;
					sGDO.play();
				}else{
					addChild(UtLosts);
					addChild(UtLosts2);
					UtLosts.x = 100;
					UtLosts2.x = 160;
					UtLosts.y = 260;
					UtLosts2.y = 300;
					UtLost.play();
					UTL = true
				}
			}else{
				NLoser.play()
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
						if(cL == true){
							removeChild(Cloud);
							cL = false;
						}
					}
					t.addEventListener(TimerEvent.TIMER, tijd);
					t2.addEventListener(TimerEvent.TIMER, tijd2);
					speedUp.addEventListener(TimerEvent.TIMER, speedIsKey);
					addEventListener(Event.ENTER_FRAME, musicP);
					t.start();
					t2.start();
					speedUp.start();
					if(SUHello == false){
						removeChild(SpeedyUp);
						SUHello = true;
					}
					removeChild(gOScreen);
					removeChild(Tscore);
					addChild(speedM);
					speedM.x = 50;
					speedM.y = 370;
					dead = false;
					if (GetDO == true)
					{
						removeChild(GDO);
						GetDO = false;
						SoundMixer.stopAll()
					}else if (UTL == true){
						removeChild(UtLosts);
						removeChild(UtLosts2);
						SoundMixer.stopAll()
						UTL = false
					}else{
						SoundMixer.stopAll()
					}
				}
			}
		}
	}
}