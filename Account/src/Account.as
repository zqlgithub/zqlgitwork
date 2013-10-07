package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	public class Account extends Sprite
	{
		private var inputLayer:InputLayer;
		private var dataLayer:DataLayer;
		private var content:Sprite;
		private var _curLayerFlag:Boolean;
		
		public function Account()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Config.ScreenWidth = stage.stageWidth;
			Config.ScreenHeight = stage.stageHeight;
			//Console.getInstance().init(stage);
			DbManager.getInstance().init();
			initUI();
			
		}
		
		public function get curLayerFlag():Boolean
		{
			return _curLayerFlag;
		}

		private var inputTween:Tween;
		private var dataTween:Tween;
		public function set curLayerFlag(value:Boolean):void
		{
			_curLayerFlag = value;
			//inputLayer.visible = value;
			inputLayer.setLabelVisible(value);
			dataLayer.setLabelVisible(!value);
			//dataLayer.visible = !value;
			var from:Number = value ? 1000: 0.0;
			if(!value)
				dataLayer.updateData();
			if(inputTween)
			{
				inputTween.stop();
				dataTween.stop();
			}
			inputTween = new Tween(inputLayer, "x", Regular.easeOut, from, 1000-from, 0.2, true);
			dataTween = new Tween(dataLayer, "x", Regular.easeIn, 1000-from, from, 0.2, true);
			inputTween.start();
			dataTween.start();
		}

		private function initUI():void
		{
			content = new Sprite;
			addChild(content);
			
			dataLayer = new DataLayer;
			content.addChild(dataLayer);
			
			inputLayer = new InputLayer;
			content.addChild(inputLayer);
			inputLayer.setLabelVisible(true);
			
			var switchBtn:Sprite = Utils.createCircle(45, 0x202020, true);
			switchBtn.x = 80;
			switchBtn.y = Config.ScreenHeight-150;
			switchBtn.addEventListener(MouseEvent.CLICK, onSwitch);
			addChild(switchBtn);
			
			curLayerFlag = true;
		}
		
		private function onSwitch(e:MouseEvent):void
		{
			curLayerFlag = !curLayerFlag;
		}
		
		private var curX:Number = 0.0;
		private var curY:Number = 0.0;
		private var isMouseDown:Boolean;
		private function onMouseDown(e:MouseEvent):void
		{
			isMouseDown = true;
		}
		private function onMouseMove(e:MouseEvent):void
		{
			var delta:Number = e.stageY-curY;
			
		}
		private function onMouseUp(e:MouseEvent):void
		{
			
		}
		
		private function onKeyboardClose(e:SoftKeyboardEvent):void
		{
			//Console.getInstance().log("close");
		}
	}
}