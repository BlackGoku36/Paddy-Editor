package paddy.export;

class Export{

	static var scene = App.scene;
	static var window = App.window;

	public static function exportScene() {
		scene.assets = {
			images: paddy.Assets.getImagesName(),
			fonts:  paddy.Assets.getFontsName(),
			sounds: paddy.Assets.getSoundsName(),
			blobs:  paddy.Assets.getBlobsName()
		}
		#if kha_krom
		Krom.fileSaveBytes(scene.name+".json", haxe.io.Bytes.ofString(haxe.Json.stringify(scene)).getData());
		#end
	}

	public static function exportWindow() {
		#if kha_krom
		Krom.fileSaveBytes("window.json", haxe.io.Bytes.ofString(haxe.Json.stringify(window)).getData());
		#end
	}
}
