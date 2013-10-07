package
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class DbManager
	{
		static private var manager:DbManager;
		private var state:SQLStatement = null;
		private var callBack:Function = null;
		
		public function DbManager()
		{
		}
		
		static public function getInstance():DbManager
		{
			if(!manager)
				manager = new DbManager;
			return manager;
		}
		
		public function openDb(state:SQLStatement):SQLConnection
		{
			var conn:SQLConnection = new SQLConnection;
			state.sqlConnection = conn;
			conn.addEventListener(SQLEvent.OPEN, function(e:SQLEvent){
				Console.getInstance().log("state excute");
				state.execute();
			});
			conn.addEventListener(SQLErrorEvent.ERROR, onDbError);
			
			var folder:File = File.applicationStorageDirectory;
			var db:File = folder.resolvePath("my.db");
			conn.openAsync(db);
			
			return conn;
		}
		public function closeDb(conn:SQLConnection):void
		{
			conn.close();
		}
		
		public function insertItem(name:String, num:Number):void
		{
			var date:Date = new Date;
			var sql:String = 
				"INSERT INTO account VALUES (?, ?, ?)";
			
			var state:SQLStatement = new SQLStatement;
			state.text = sql;
			state.parameters[0] = String(date.getTime());
			state.parameters[1] = name;
			state.parameters[2] = num;
			
			state.addEventListener(SQLEvent.RESULT, onDbOpen); 
			state.addEventListener(SQLErrorEvent.ERROR, onDbError);
			openDb(state);
		}
		public function deleteItem(itemTime:String):void
		{
			var sql:String = "DELETE FROM account WHERE time = '"+itemTime+"'";
			this.executeStatement(sql);
		}
		
		public function getAllItems(_callBack:Function):void
		{
			callBack = _callBack;
			var sql:String = "SELECT * FROM account";
			state = new SQLStatement;
			state.text = sql;
			
			state.addEventListener(SQLEvent.RESULT, onGetAll);
			state.addEventListener(SQLErrorEvent.ERROR, onDbError);
			openDb(state);
		}
		
		public function init():void
		{
			var sql:String = 
				"CREATE TABLE IF NOT EXISTS account("+
				"time TEXT PRIMARY KEY,"+
				"name TEXT,"+
				"num NUMERIC"+
				")";
			executeStatement(sql);
		}
		
		private function executeStatement(sql:String):void
		{
			var state:SQLStatement = new SQLStatement;
			state.text = sql;
			state.addEventListener(SQLEvent.RESULT, onDbSuccess); 
			state.addEventListener(SQLErrorEvent.ERROR, onDbError);
			
			openDb(state);
		}
		
		private function onDbSuccess(e:SQLEvent):void
		{
			Console.getInstance().log("db success");
		}
		private function onDbOpen(e:SQLEvent):void
		{
			
		}
		
		private function onDbError(e:SQLErrorEvent):void
		{
			Console.getInstance().log(e.error.details);
		}
		
		private function onGetAll(e:SQLEvent):void
		{
			if(!state)
				return;
			
			var result:SQLResult = state.getResult();
			callBack(result.data);
			state = null;
			callBack = null;
		}
		
		
	}
}