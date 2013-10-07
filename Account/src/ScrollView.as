package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ScrollView extends Sprite
	{
		private var content:Sprite;
		private var isGrab:Boolean = false;
		private var v:Number = 0;
		private var friction:Number = 1;
		private var prevY:int;
		
		public function ScrollView(_content:Sprite, viewPort:Rectangle)
		{
			content = _content;
			addChild(content)
			this.scrollRect = viewPort;
			
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
				content.y += v;
			}
			else if(content.y > 0)
			{
				easing(0);
				v = 0;
			}
			else if(content.y < this.scrollRect.height-content.height)
			{
				easing(Math.min(this.scrollRect.height-content.height, 0));
				v = 0;
			}
			else if(v != 0)
			{
				var v0:int = Math.abs(v);
				var direction:int = v/v0;
				v0 = Math.max(v0-friction, 0);
				v = direction*v0;
				content.y += v;
			}
		}
		private function easing(pos:Number):void
		{
			if(content.y == pos)
				return;
			content.y += (pos-content.y)*0.3;
			if(Math.abs(pos-content.y) < 0.2)
				content.y = pos;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if(this.hitTestPoint(e.stageX, e.stageY))
			{
				prevY = e.stageY;
				isGrab = true;
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			if(this.hitTestPoint(e.stageX, e.stageY))
			{
				v = Math.max(e.stageY - prevY, 3);
				prevY = e.stageY;
				isGrab = true;
			}
			else
			{
				v = 0;
				isGrab = false;
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			isGrab = false;
		}
	}
}