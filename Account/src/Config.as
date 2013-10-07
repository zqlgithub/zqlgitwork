package
{
	import flash.net.SharedObject;

	public class Config
	{
		static public var USE_SIMULATOR:Boolean = false;
		static public var ScreenWidth:int;
		static public var ScreenHeight:int;
		
		public var dailyCut:int;
		
		static private var o:Config;
		
		public static function shared():Config
		{
			if(!o)
			{
				o = new Config;
				o.init();
			}
			return o;
		}
		private function init():void
		{
			var obj:SharedObject = SharedObject.getLocal("temp");
			dailyCut = obj.data.dailycut;
			obj.close();
		}
		public function save():void
		{
			var obj:SharedObject = SharedObject.getLocal("temp");
			obj.data.dailycut = dailyCut;
			obj.flush();
			obj.close();
		}
		
	}
}