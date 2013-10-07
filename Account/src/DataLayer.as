package
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	public class DataLayer extends Sprite
	{
		private var label:TextField;
		private var items:Vector.<DataItem>;
		private var accountData:Array;
		private var content:Sprite;
		private const MarkHeight:int = 70;
		private var itemsNumPerDay:Vector.<int>;
		private var itemsNumPerMon:Vector.<int>;
		private var curDisplayType:int = 0;
		private var maxDayCost:Number = 0.0;
		private var maxMonthCost:Number = 0.0;
		private var yearLabel:TextField;
		private var limitLabel:StageText;
		private var cutLine:Sprite;
		
		public function DataLayer()
		{	
			items = new Vector.<DataItem>;
			itemsNumPerDay = new Vector.<int>;
			itemsNumPerMon = new Vector.<int>;
			
			content = new Sprite;
			var scrollView:ScrollView = new ScrollView(content, new Rectangle(0, 0, Config.ScreenWidth, Config.ScreenHeight-100));
			scrollView.y = 100;
			addChild(scrollView);
			
			var bar:Sprite = Utils.createRect(Config.ScreenWidth, 100, 0x36B7CB, false, 0, 0);
			addChild(bar);
			
			var rect:Rectangle = new Rectangle(Config.ScreenWidth-120, 10, 100, 60);
			limitLabel = new StageText;
			limitLabel.fontSize = 44;
			limitLabel.editable = true;
			limitLabel.softKeyboardType = SoftKeyboardType.NUMBER;
			limitLabel.returnKeyLabel = ReturnKeyLabel.GO;
			limitLabel.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			limitLabel.viewPort = rect;
			limitLabel.text = String(Config.shared().dailyCut);
			
			var cutLabelBg:Sprite = Utils.createRect(rect.width, rect.height, 0xffffff);
			cutLabelBg.x = rect.x+rect.width*0.5;
			cutLabelBg.y = rect.y+rect.height*0.5;
			addChild(cutLabelBg);
			
			cutLine = Utils.createCircle(15, 0xff0000);
			cutLine.graphics.lineStyle(2, 0xff0000);
			cutLine.graphics.moveTo(0, 0);
			cutLine.graphics.lineTo(0, Config.ScreenHeight);
			cutLine.x = 330;
			cutLine.y = 90;
			addChild(cutLine);
			
			/*yearLabel = Utils.createLabel("", 44);
			yearLabel.border = true;
			yearLabel.backgroundColor = 0xffffff;
			yearLabel.text = "1000年";
			yearLabel.x = 270-yearLabel.width;
			yearLabel.y = 100-yearLabel.height;
			addChild(yearLabel);*/
			
			var displayTypeBtn:Sprite = Utils.createCircle(45, 0xffff00);
			displayTypeBtn.x = 80;
			displayTypeBtn.y = Config.ScreenHeight - 280;
			displayTypeBtn.addEventListener(MouseEvent.CLICK, reDisplay);
			this.addChild(displayTypeBtn);
			 
		}
		public function setLabelVisible(value:Boolean):void
		{
			limitLabel.visible = value;
			limitLabel.stage = value ? stage : null;
		}
		public function updateData():void
		{
			DbManager.getInstance().getAllItems(initData);
		}
		public function initData(data:Array):void
		{
			accountData = data;
			curDisplayType = 0;
			items.splice(0, items.length);
			itemsNumPerDay.splice(0, itemsNumPerDay.length);
			itemsNumPerMon.splice(0, itemsNumPerMon.length);
			
			var date:Date = new Date;
			var preDate:Date = new Date;
			var dayCount:Number = 0.0;
			var monthCount:Number = 0.0;
			var item:DataItem;
			content.removeChildren();
			for(var i:int = 0; i < accountData.length; i++)
			{
				var dataItem:Object = accountData[i];
				date.setTime(dataItem.time); 
				if(i == 0)
					preDate.setTime(dataItem.time);
				//create day and month mark,month is included in day.
				if(i>0 && preDate.toLocaleDateString() != date.toLocaleDateString())
				{
					item = new DataItem(String(preDate.getMonth()+1)+"月"+String(preDate.getDate())+"日",
										"$"+dayCount.toFixed(2), dayCount);
					content.addChild(item);
					items.push(item);
					itemsNumPerDay.push(items.length-1);
					if(dayCount > maxDayCost)
						maxDayCost = dayCount;
					dayCount = 0.0;
					
					if(preDate.getFullYear()!=date.getFullYear() || preDate.getMonth()!=date.getMonth())
					{
						item = new DataItem(String(preDate.getMonth()+1)+"月",
							"$"+monthCount.toFixed(2), monthCount, true);
						content.addChild(item);
						items.push(item);
						itemsNumPerDay.push(items.length-1);
						itemsNumPerMon.push(items.length-1);
						//getMaxMonthCount
						if(monthCount > maxMonthCost)
							maxMonthCost = monthCount;
						monthCount = 0.0;
					}
					preDate.setTime(date.getTime());
				}
				item = new DataItem(String(date.getHours())+":"+String(date.getMinutes()), 
												 dataItem.name+" $"+dataItem.num, dataItem.num); 
				content.addChild(item);
				items.push(item);
				dayCount += dataItem.num;
				monthCount += dayCount;
			}
			item = new DataItem(String(date.getMonth()+1)+"月"+String(date.getDate())+"日",
				"$"+dayCount.toFixed(2), dayCount);
			content.addChild(item);
			items.push(item);
			itemsNumPerDay.push(items.length-1);
			if(dayCount > maxDayCost)
				maxDayCost = dayCount;
			
			item = new DataItem(String(date.getMonth()+1)+"月",
				"$"+monthCount.toFixed(2), monthCount, true);
			content.addChild(item);
			items.push(item);
			itemsNumPerDay.push(items.length-1);
			itemsNumPerMon.push(items.length-1);
			if(monthCount > maxMonthCost)
				maxMonthCost = monthCount;
			
			reDisplay();
		}
		
		private var totalDisplayTypes:int = 3;
		private var tweens:Vector.<Tween> = new Vector.<Tween>;
		private function reDisplay(e:MouseEvent = null):void
		{
			for each(var t:Tween in tweens)
			{
				t.fforward();
				t.stop(); 
			}
			tweens.splice(0, tweens.length);
			if(e)
				curDisplayType = (++curDisplayType)%totalDisplayTypes;
			DataItem.Max = curDisplayType == 0 ? maxDayCost : maxMonthCost;
			updateCutLine();
			var desIndex:Number = 0.0;
			for(var i:int = 0; i < items.length; i++)
			{
				var desAlpha:Number = -1.0;
				if(curDisplayType == 0)
				{
					desIndex = items.length-1-i;
					if(!isItemAMonth(i))
						desAlpha = 1.0;
					else
						items[i].hidePrice(true);
				}
				else if(curDisplayType == 1)
				{
					desIndex = itemsNumPerDay.length-1-getDayIndexOfItem(i);
					if(!isItemADay(i))
						desAlpha = 0;
					else if(isItemAMonth(i))
						items[i].hidePrice(false);
				}
				else
				{
					desIndex = itemsNumPerMon.length-1-getMonIndexOfItem(i);
					if(!isItemADay)
					{
						items[i].y = 35+desIndex*DataItem.MarkHeight;
						return;
					}
					else if(isItemADay(i) && !isItemAMonth(i))
						desAlpha = 0.0;
					else
					{
						items[i].hidePrice(false);
					}
				}
				
				if(e)
				{
					var tween1:Tween = new Tween(items[i], "y",  Regular.easeOut, items[i].y, 35+desIndex*DataItem.MarkHeight, 0.2, true);
					tweens.push(tween1);
					tween1.start();
					if(desAlpha >= 0.0)
					{
						var tween2:Tween = new Tween(items[i], "alpha",  Regular.easeOut, 1-desAlpha, desAlpha, 0.2, true);
						tweens.push(tween2);
						tween2.start();
					}
				}
				else
				{
					items[i].x = 300;
					items[i].y = 35+desIndex*DataItem.MarkHeight;
					items[i].alpha = 1;
				}
				items[i].showBar(true);
			}
		}
		private function getDesY(type:int):void
		{
			
		}
		private function getDayIndexOfItem(indexOfItem:int):int
		{
			for(var i:int = 0; i < itemsNumPerDay.length; i++)
				if(itemsNumPerDay[i] >= indexOfItem)
					return i;
			return -1;
		}
		private function isItemADay(indexOfItem:int):Boolean
		{
			return itemsNumPerDay.indexOf(indexOfItem) != -1;
		}
		private function getMonIndexOfItem(indexOfItem:int):int
		{
			for(var i:int = 0; i < itemsNumPerMon.length; i++)
				if(itemsNumPerMon[i] >= indexOfItem)
					return i;
			return -1;
		}
		private function isItemAMonth(indexOfItem:int):Boolean
		{
			return itemsNumPerMon.indexOf(indexOfItem) != -1;
		}

		private function updateCutLine():void
		{
			var targetX:Number = Math.min(330+(Config.shared().dailyCut/DataItem.Max)*DataItem.maxBarLength, 330+DataItem.maxBarLength);
			if(cutLine.x != targetX)
			{
				var tween:Tween = new Tween(cutLine, "x",  Regular.easeOut, cutLine.x, targetX, 0.3, true);
				tween.start();
			}
		}
		private function reArrange():void
		{
			var h:int = 50;
			for(var i:int = 0; i < items.length; i++)
			{
				items[i].y = h; 
				h += items[i].height+5;
			}
		}
		private function onKeyUp(e:KeyboardEvent):void
		{
			Config.shared().dailyCut = int(limitLabel.text);
			Config.shared().save();
			updateCutLine();
			for each(var item:DataItem in items)
				item.updateBarColor();
		}
		
		private function onItemClick(e:MouseEvent):void
		{
			var target:DataItem = e.currentTarget as DataItem;
			if(target)
			{
				for(var i:int = 0; i < items.length; i++)
					if(items[i] == target)
					{
						items.splice(i, 1);
						break;
					}
				this.removeChild(target);
				reArrange();
				DbManager.getInstance().deleteItem(target.time);
			}
		}
	}
}
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

class DataItem extends Sprite
{
	static public var Max:Number = 0.0;
	static public var MarkHeight:int = 70;
	static public var maxBarLength:Number = 300;
	public var time:String;
	public var _value:Number;
	
	
	private var label:TextField;
	private var valueBar:Shape;
	private var valueBg:Sprite;
	
	public function DataItem(title:String, content:String, value:Number = 0.0, isBold:Boolean = false)
	{
		_value = value;
		
		graphics.lineStyle(3);
		graphics.moveTo(-20, 0);
		graphics.lineTo(20, 0);
		graphics.moveTo(0, 0);
		graphics.lineTo(0, MarkHeight);
		
		var format:TextFormat = new TextFormat;
		format.size = 40;
		format.bold = true;
		
		label = new TextField;
		label.thickness = 5;
		label.width = Config.ScreenWidth-100;
		label.type = TextFieldType.DYNAMIC;
		label.autoSize = TextFieldAutoSize.LEFT;
		label.defaultTextFormat = format;
		label.text = content;
		label.selectable = false;
		label.x = 30;
		label.y = -label.height*0.5;
		addChild(label);
		
		valueBg = Utils.createRect(maxBarLength, label.height, 0x4ADB8E, false, 0, 0);
		valueBg.x = 30;
		valueBg.y = -label.height*0.5;
		valueBg.alpha = 0.3;
		this.addChildAt(valueBg, 0);
		valueBar = new Shape;
		valueBar.graphics.beginFill(0x4ADB8E);
		valueBar.graphics.drawRect(0, 0, maxBarLength, label.height);
		valueBar.graphics.endFill();
		valueBg.addChild(valueBar);
		
		var titleSize:int = isBold ? 45 : 28;
		var titleLabel:TextField = Utils.createLabel(title, titleSize);
		titleLabel.autoSize = TextFieldAutoSize.RIGHT;
		titleLabel.x = -30-titleLabel.width;
		titleLabel.y = -titleLabel.height*0.5;
		addChild(titleLabel);
		
	}
	
	public function hidePrice(value:Boolean):void
	{
		label.visible = !value;
		showBar(!value);
	}
	
	public function showBar(isShow:Boolean = true):void
	{
		valueBar.visible = valueBg.visible = isShow && label.visible;
		valueBar.scaleX = _value > 0 ? Math.max(_value/Max, 0.05) : 0;
		updateBarColor();
	}
	public function updateBarColor():void
	{
		var color:uint = _value <= Config.shared().dailyCut ? 0x4ADB8E : 0xD43921;
		var colorTran:ColorTransform = new ColorTransform;
		colorTran.color = color;
		valueBar.transform.colorTransform = colorTran;
	}
}
