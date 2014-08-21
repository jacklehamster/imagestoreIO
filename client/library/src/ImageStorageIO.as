package
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import by.blooddy.crypto.image.PNGEncoder;
	
	import playerio.Client;
	import playerio.Connection;
	import playerio.Message;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;

	[Event(name="connect", type="flash.events.Event")]
	[Event(name="receiveBinary", type="BinaryReceivedEvent")]
	public class ImageStorageIO extends EventDispatcher
	{
		private static const GAME_ID:String = "dobukiland-ymhkxklve0qg9ksunqrsq";
		private static const ip_address:String = "192.168.1.5:8184";
		private var room:String;
		public var online:Boolean = true;
		public var roomType:String = "Dobukiland";
		public var binaries:Object = {};
		
		private var connection:Connection, client:Client;
		
		public function connect(stage:Stage,room:String,username:String=null):void {
			this.room = room;
			var user:String = username?username:"guest_"+Math.random();
			
			PlayerIO.connect(
				stage,								//Referance to stage
				GAME_ID,							//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				user,								//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);
		}
		
		private function handleError(error:PlayerIOError):void{
			trace(error);
		}
		
		private function handleConnect(client:Client):void {
			trace("Sucessfully connected to Yahoo Games Network");
			this.client = client;
			//Set developmentsever (Comment out to connect to your server online)
			if(!online)
				client.multiplayer.developmentServer = ip_address;
			client.multiplayer.createJoinRoom(room,roomType,true,{},{},onJoin,handleError);
		}
		
		private function onJoin(connection:Connection):void {
			trace("Sucessfully joined room:",connection.roomId);
			connection.addMessageHandler("receiveBinary",function(m:Message,id:String,bytes:ByteArray):void {
				binaries[id] = bytes;
				dispatchEvent(new BinaryReceivedEvent(id,bytes));
			});
			this.connection = connection;	
			dispatchEvent(new Event(Event.CONNECT));
		}
		
		public function sendBinary(id:String,bytes:ByteArray):void {
			connection.send("saveBinary",id,bytes);
		}
		
		public function loadBinary(id:String,callback:Function=null):void {
			connection.send("loadBinary",id);
			if(callback!=null) {
				addEventListener(BinaryReceivedEvent.RECEIVE_BINARY,
					function(e:BinaryReceivedEvent):void {
						if(e.id==id) {
							e.currentTarget.removeEventListener(e.type,arguments.callee);
							callback(e.bytes);
						}					
					});
			}
		}
	}
}