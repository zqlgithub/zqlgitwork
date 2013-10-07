package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Slider extends Sprite
	{
		private var start:Sprite;
		private var end:Sprite;
		private var curr:Sprite;
		private var isGrab:Boolean = false;
		private var prevX:Number = 0.0;
		private var vX:Number = 0.0;
		private var barLength:int;
		
		public function Slider(length:int)
		{
			var bg:Sprite = Utils.createRect(length, 30, 0xc0c0c0);
			addChild(bg);
			
			barLength = length;
			start = Utils.createCircle(25, 0x404040);
			start.x = -length*0.5;
			start.y = 0;
			addChild(start);
			
			end = Utils.createCircle(25, 0x404040);
			end.x = length*0.5;
			end.y = 0;
			addChild(end);
			
			curr = Utils.createCircle(30, 0xff0000);
			addChild(curr);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if(isGrab)
			{
				var des:Number = curr.x + vX;
				curr.x = Math.min(Math.max(des, -barLength*0.5), barLength*0.5);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if(curr.hitTestPoint(e.stageX, e.stageY))
			{
				prevX = e.stageX;
				isGrab = true;
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			if(curr.hitTestPoint(e.stageX, e.stageY))
			{
				vX = e.stageX - prevX;
				isGrab = true;
				prevX = vX;
			}
			else
			{
				vX = 0.0;
				isGrab = false;
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			isGrab = false;
		}
	}
}