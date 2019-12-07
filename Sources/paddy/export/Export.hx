package paddy.export;

class Export{

	static var scene = App.scene;
	static var window = App.window;

	public static function exportScene() {
		#if kha_krom
		Krom.fileSaveBytes(scene.name+".json", haxe.io.Bytes.ofString(haxe.Json.stringify(scene)).getData());
		#end
	}

	public static function exportWindow() {
		#if kha_krom
		Krom.fileSaveBytes("window.json", haxe.io.Bytes.ofString(haxe.Json.stringify(window)).getData());
		#end
	}
	public static function exportJsonFile(name:String, data:String) {
		#if kha_krom
		Krom.fileSaveBytes(name, haxe.io.Bytes.ofString(haxe.Json.stringify(data)).getData());
		#end
	}
	public static function exportFile(name:String, data:String) {
		#if kha_krom
		Krom.fileSaveBytes(name, haxe.io.Bytes.ofString(data).getData());
		#end
	}
}
