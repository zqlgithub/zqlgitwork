package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.ui.Keyboard;
	
	public class InputLayer extends Sprite
	{
		private var inputLabel:StageText;
		private var nameLabel:StageText;
		
		public function InputLayer()
		{
			graphics.beginFill(0x36B7CB);
			graphics.drawRect(0, 0, Config.ScreenWidth, Config.ScreenHeight);
			graphics.endFill();
			
			var rect:Rectangle = new Rectangle(Config.ScreenWidth*0.5-180, Config.ScreenHeight*0.5-220, 360, 90);
			inputLabel = new StageText;
			inputLabel.fontSize = 80;
			inputLabel.editable = true;
			inputLabel.softKeyboardType = SoftKeyboardType.DEFAULT;
			inputLabel.returnKeyLabel = ReturnKeyLabel.GO;
			inputLabel.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			inputLabel.viewPort = rect;
			inputLabel.restrict = "0123456789.";
			
			var border:Sprite = Utils.createRect(rect.width, rect.height, 0xffffff, true);
			border.x = rect.x+rect.width*0.5;
			border.y = rect.y+rect.height*0.5;
			addChild(border);
			
			rect = new Rectangle(Config.ScreenWidth*0.5-180, Config.ScreenHeight*0.5-120, 360, 90);
			nameLabel = new StageText;
			nameLabel.fontSize = 80;
			nameLabel.editable = true;
			nameLabel.softKeyboardType = SoftKeyboardType.DEFAULT;
			nameLabel.returnKeyLabel = ReturnKeyLabel.GO;
			nameLabel.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			nameLabel.viewPort = rect;
			
			var border2:Sprite = Utils.createRect(rect.width, rect.height, 0xffffff, true);
			border2.x = rect.x+rect.width*0.5;
			border2.y = rect.y+rect.height*0.5;
			addChild(border2);
			
			var btn:Sprite = Utils.createRect(120, 80, 0x202020);
			btn.x = Config.ScreenWidth*0.5;
			btn.y = Config.ScreenHeight*0.5+30;
			btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			addChild(btn);
		}
		public function setLabelVisible(value:Boolean):void
		{
			inputLabel.visible = nameLabel.visible = value;
			inputLabel.stage = nameLabel.stage = value ? stage : null;
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			if(inputLabel.text.length == 0)
				return;
			
			DbManager.getInstance().insertItem(nameLabel.text,Number(inputLabel.text));
			inputLabel.text = "";
			nameLabel.text = "";
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SEARCH)
			{
				
			}
		}
	}
}