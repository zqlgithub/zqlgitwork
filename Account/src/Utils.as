package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class Utils
	{
		static public function createRect(w:int, h:int, color:uint, hasBorder:Boolean = false, 
										  anchorX:Number = 0.5, anchorY:Number = 0.5):Sprite
		{
			var rect:Sprite = new Sprite;
			if(hasBorder)
				rect.graphics.lineStyle(1);
			rect.graphics.beginFill(color);
			rect.graphics.drawRect(-w*anchorX, -h*anchorY, w, h);
			rect.graphics.endFill();
			return rect;
		}
		static public function createCircle(radius:int, color:uint, hasBorder:Boolean = false, 
											anchorX:Number = 0.5, anchorY:Number = 0.5):Sprite
		{
			var circle:Sprite = new Sprite;
			if(hasBorder)
				circle.graphics.lineStyle(1);
			circle.graphics.beginFill(color);
			circle.graphics.drawCircle(-radius+2*radius*anchorX, -radius+2*radius*anchorY, radius);
			circle.graphics.endFill();
			return circle;
		}
		
		static public function createLabel(content:String, size:int):TextField
		{
			var format:TextFormat = new TextFormat;
			format.size = size;
			format.bold = true;
			
			var label:TextField = new TextField;
			label.thickness = 2;
			label.type = TextFieldType.DYNAMIC;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = format;
			label.text = content;
			label.selectable = false;
			return label;
		}
	}
}