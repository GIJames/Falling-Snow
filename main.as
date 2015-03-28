stage.align = StageAlign.TOP_LEFT;
var my_menu:ContextMenu = new ContextMenu();
my_menu.hideBuiltInItems();

var credit = new ContextMenuItem("Rubber NAND 2015");
credit.enabled = false;

var soundcloud = new ContextMenuItem("Soundcloud");
function openSCLink(e:ContextMenuEvent):void {
	navigateToURL(new URLRequest("https://soundcloud.com/9c5"));
}
soundcloud.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openSCLink);
soundcloud.separatorBefore = true;

var bandcamp = new ContextMenuItem("Bandcamp");
function openBCLink(e:ContextMenuEvent):void {
	navigateToURL(new URLRequest("https://jamesjerram.bandcamp.com/"));
}
bandcamp.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, openBCLink);

var cpu = new ContextMenuItem("Help! My CPU can't handle this!");
function cpusaver(e:ContextMenuEvent):void {
	var toremove = Math.round(flakeShape.length/2);
	var discard = flakeShape.splice(0, toremove);
	for (var i = 0; i < discard.length; i++) {
		stage.removeChild(discard[i]);
	}
	flakeData.splice(0, toremove);
}
cpu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, cpusaver);
cpu.separatorBefore = true;

var more = new ContextMenuItem("I've got cycles to spare! Bring it on!");
function morepain(e:ContextMenuEvent):void {
	populate(flakeShape.length);
}
more.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, morepain);

my_menu.customItems.push(credit, soundcloud, bandcamp, cpu, more);
contextMenu = my_menu;

import FlakeData2;
var sc:SoundChannel = new SoundChannel();
var mus:music = new music();
sc = mus.play(0, int.MAX_VALUE);
var tempo = 500;
var maxwidth = stage.stageWidth;
var maxheight = stage.stageHeight;


var mouseIsOver = false;
//mouse check from Riccardo Bartoli
stage.addEventListener(Event.MOUSE_LEAVE, leaveHandler);
stage.addEventListener(MouseEvent.MOUSE_MOVE, returnHandler);

function leaveHandler(event:Event):void {
	stage.addEventListener(MouseEvent.MOUSE_MOVE, returnHandler);
	mouseIsOver = false;
}

function returnHandler(event:MouseEvent):void {
	stage.removeEventListener(MouseEvent.MOUSE_MOVE, returnHandler);
	mouseIsOver = true;
}

var mouseMode = false;
stage.addEventListener(MouseEvent.CLICK, clickHandler);
function clickHandler(e:MouseEvent){
	mouseMode = !mouseMode;
}

var goingright = 1;

/*var tl = new Shape();
tl.graphics.beginFill(0xFF0000);
tl.graphics.drawRect(0,0,1,10);
tl.graphics.endFill();
stage.addChild(tl);

var tr = new Shape();
tr.graphics.beginFill(0x00FF00);
tr.graphics.drawRect(0,0,1,10);
tr.graphics.endFill();
stage.addChild(tr);*/
/*
var br = new Shape();
br.graphics.beginFill(0x0000FF);
br.graphics.drawCircle(1275,715,5);
br.graphics.endFill();
sprite.addChild(br);

var bl = new Shape();
bl.graphics.beginFill(0xFFFFFF);
bl.graphics.drawCircle(5,715,5);
bl.graphics.endFill();
sprite.addChild(bl);*/

var snowglow:GlowFilter = new GlowFilter();
snowglow.color = 0xFFFFFF;
snowglow.alpha = 0.7;
snowglow.blurX = 10;
snowglow.blurY = 10;
snowglow.quality = BitmapFilterQuality.LOW;

var flakeShape:Array = new Array();
var flakeData:Array = new Array();

function initphys(f:Number) {
	flakeData[f].velocityX = (Math.random() - .5) * flakeData[f].flakeRadius;
	flakeData[f].velocityY = 1 + Math.random() * 2;
	flakeShape[f].x = 0;
	flakeShape[f].y = 0;
}

function randomix(f:Number) {
	flakeShape[f].x = Math.round(Math.random() * maxwidth);
	flakeShape[f].y = Math.round(Math.random() * maxheight);
}
var xd:Number;
var yd:Number;
var distance:Number;
var opp:Number;
var adj:Number;
var angle:Number;
var impulse:Number;
var impulseX:Number;
var impulseY:Number;

function updatephys(f:Number) {
	//react to mouse
	if (mouseIsOver) {
		xd = flakeShape[f].x - stage.mouseX;
		yd = flakeShape[f].y - stage.mouseY;
		distance = Math.sqrt(Math.pow(xd, 2) + Math.pow(yd, 2));
		if (distance > 0) {
			opp = (yd);
			if (opp == 0) {
				opp = .01;
			}//can't div by 0
			adj = (xd);
			angle = Math.atan(Math.abs(opp/adj));
			impulse = 30/(distance * flakeData[f].flakeRadius);
			impulseX = impulse * Math.cos(angle);
			impulseY = impulse * Math.sin(angle);
			if (flakeShape[f].x < stage.mouseX) {
				impulseX = -1 * impulseX;
			}
			if (flakeShape[f].y < stage.mouseY) {
				impulseY = -1 * impulseY;
			}
			
			if(mouseMode){
				impulseY = -1 * impulseY;
				impulseX = -1 * impulseX;
			}
			
			flakeData[f].velocityX = flakeData[f].velocityX + impulseX;
			flakeData[f].velocityY = flakeData[f].velocityY + impulseY;
		}
	}
	//X velocity slow
	if (Math.abs(flakeData[f].velocityX) > flakeData[f].flakeRadius) {
		flakeData[f].velocityX = flakeData[f].velocityX * .8;
	} else if (Math.random() < .3) {
		flakeData[f].velocityX = flakeData[f].velocityX + Math.random() -.5;
	}
	if ((goingright * flakeData[f].velocityX < 0) && (Math.random() < .7)) {
		//if moving counter to direction
		flakeData[f].velocityX = -1 * flakeData[f].velocityX;
	}
	//Y velocity slow
	if (Math.abs(flakeData[f].velocityY) > 4) {
		flakeData[f].velocityY = flakeData[f].velocityY * .8;
	} else if (flakeData[f].velocityY < 4) {
		flakeData[f].velocityY = flakeData[f].velocityY + Math.random()*(.3/flakeData[f].flakeRadius);
	}

	//set temporary values
	flakeShape[f].y = Math.round(flakeShape[f].y + flakeData[f].velocityY);
	flakeShape[f].x = Math.round(flakeShape[f].x + flakeData[f].velocityX);

	//clean up if out of bounds
	if (flakeShape[f].y > maxheight) {
		flakeShape[f].y = 0;
		flakeShape[f].x = Math.random() * maxwidth;
	}
	else if (flakeShape[f].x > maxwidth) {//more likely; check first
		flakeShape[f].x = 0;
		flakeShape[f].y = Math.random() * maxheight;
	}
	else if (flakeShape[f].x < 0) {
		flakeShape[f].x = maxwidth;
		flakeShape[f].y = Math.random() * maxheight;
	}
}

function initdraw(f:Number) {
	flakeShape[f].graphics.beginFill(0xFFFFFF, .3+ (Math.random()*.7)); 
	flakeShape[f].graphics.drawCircle(flakeShape[f].x, flakeShape[f].y, flakeData[f].flakeRadius);
	flakeShape[f].graphics.endFill();
	stage.addChild(flakeShape[f]);
	flakeShape[f].filters = [snowglow];
}

function initialize(f:Number) {
	flakeData[f].flakeRadius = Math.round(Math.random() * 3);
	if (flakeData[f].flakeRadius == 0) {
		flakeData[f].flakeRadius = 1;
	}
	initphys(f);
	initdraw(f);
	randomix(f);
}

function populate(n) {
	var start = flakeShape.length;
	for (var i = 0; i < n; i++) {
		flakeShape.push(new Shape());
		flakeData.push(new FlakeData2());
		initialize(start + i);
	}
}
var icount;
function updateAll(begin, end) {
	for (icount = begin; icount < end; icount++){
		updatephys(icount);
		
	}
}

/*var framecount = 0;


fps.text = "0";
trace(fps);

var myTimer:Timer = new Timer(1000);
myTimer.addEventListener("timer", timerHandler);
myTimer.start();


function timerHandler(event:TimerEvent):void {
	fps.text = String(framecount);
	framecount = 0;
	trace(fps);
	myTimer.reset();
	myTimer.start();
}
*/
/*var longest = 0;
var ms, st, diff, diff2;*/

populate(5000);
gotoAndPlay(2);
