package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class Console extends Sprite
	{
		private var label:TextField;
		static private var o:Console;
		static private var _stage:Stage;
		
		public function Console()
		{
			var format:TextFormat = new TextFormat;
			format.size = 50;
			format.color = 0xff0000;
			
			label = new TextField;
			label.border = true;
			label.type = TextFieldType.DYNAMIC;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
		}
		
		public function init(s:Stage):void
		{
			o.x = 50;
			o.y = Config.ScreenWidth-100;
			s.addChild(o);
		}
		
		static public function getInstance():Console
		{
			
			if(!o)
			{
				o = new Console;
			}
			return o;
		}
		
		public function log(value:String):void
		{
			label.text = label.text+"\n"+value;
		}
	}
}