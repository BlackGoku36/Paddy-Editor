package paddy.files;

class Export{

	static var paddy = App.paddydata;
	static var scene = App.scene;
	static var window = App.window;

	public static function exportPaddy(path:String = "") {
		adjustObjectSpritePath(path);
		scene.assets = {
			images: adjustImagePath(path),
			fonts: []
		}
		if(paddy.name =="") paddy.name = "PaddyProject";
		if(paddy.scene =="") paddy.scene = path+"/"+scene.name+".json";
		if(paddy.window =="") paddy.window = path+"/"+"window.json";
		#if kha_krom
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+"paddy.json", haxe.io.Bytes.ofString(haxe.Json.stringify(paddy)).getData());
		exportScene(path);
		exportWindow(path);
		Krom.sysCommand('mkdir $path/Assets');
		copyAssets('$path/Assets');
		#end
	}

	public static function copyAssets(path:String) {
		for (imagepath in Assets.imagesPaths){
			var imageNameA = imagepath.split("/");
			var imageName = imageNameA[imageNameA.length - 1];
			#if kha_krom
			Krom.sysCommand('cp $imagepath $path/$imageName');
			#end
		}
	}

	public static function exportScene(path:String = "") {
		#if kha_krom
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+scene.name+".json", haxe.io.Bytes.ofString(haxe.Json.stringify(scene)).getData());
		#end
	}

	public static function exportWindow(path:String = "") {
		#if kha_krom
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+"window.json", haxe.io.Bytes.ofString(haxe.Json.stringify(window)).getData());
		#end
	}

	public static function exportJsonFile(name:String, data:String) {
		#if kha_krom
		Krom.fileSaveBytes(name, haxe.io.Bytes.ofString(data).getData());
		#end
	}

	public static function exportFile(name:String, data:String) {
		#if kha_krom
		Krom.fileSaveBytes(name, haxe.io.Bytes.ofString(data).getData());
		#end
	}

	static function adjustImagePath(newPath:String) {
		var adjustedImagePath:Array<String> = [];
		for (image in Assets.imagesPaths){
			var name = image.split("/");
			var newName = name[name.length-1];
			adjustedImagePath.push('$newPath/Assets/$newName');
		}
		return adjustedImagePath;
	}

	static function adjustObjectSpritePath(newPath:String) {
		for (object in scene.objects){
			var ref = object.spriteRef;
			var name = ref.split("/");
			var newName = name[name.length-1];
			object.spriteRef = '$newPath/Assets/$newName';
		}
	}
}
