package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class ImageStorageIOTest extends Sprite
	{
		private var imageStore:ImageStorageIO = new ImageStorageIO();
		public function ImageStorageIOTest()
		{
			imageStore.online = false;
			imageStore.connect(root.stage,"bounceroom");
			imageStore.addEventListener(Event.CONNECT,
				function(e:Event):void {
					var data:ByteArray = new ByteArray();
					data.writeUTF("Hello, sir!");
					imageStore.sendBinary("test8",data);
					imageStore.loadBinary("test8",
						function(bytes:ByteArray):void {
							trace(bytes.readUTF());
						});
				});
		}
	}
}