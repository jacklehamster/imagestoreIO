package
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class BinaryReceivedEvent extends Event
	{
		static public const RECEIVE_BINARY:String = "receiveBinary";
		
		public var id:String;
		public var bytes:ByteArray;
		
		public function BinaryReceivedEvent(id:String,bytes:ByteArray)
		{
			super(RECEIVE_BINARY);
			this.id = id;
			this.bytes = bytes;
		}
	}
}