package paddy.files;

import paddy.data.Data.ScriptData;
import paddy.ui.UINodes;
import paddy.data.Data.AssetData;

class Export{

	#if kha_windows
	static var copycmd = "copy";
	#else
	static var copycmd = "cp";
	#end

	public static function exportPaddy(path:String = "") {
		adjustObjectSpritePath(path);
		App.scene.assets = adjustAssetsPath(path);
		adjustScriptsPath(path, App.scene.scripts);
		for(obj in App.scene.objects) adjustScriptsPath(path, obj.scripts);
		if(App.paddydata.name =="") App.paddydata.name = "PaddyProject";
		if(App.paddydata.scene =="") App.paddydata.scene = path+"/"+"scene.json";
		if(App.paddydata.window =="") App.paddydata.window = path+"/"+"window.json";
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+"paddy.json", haxe.io.Bytes.ofString(haxe.Json.stringify(App.paddydata)).getData());
		exportWindow(path);
		exportScene(path);
		Krom.sysCommand('mkdir $path/Assets');
		copyAssets('$path/Assets');
		exportNodes('$path/Assets');
		App.projectPath = path;
	}

	public static function copyAssets(path:String) {
		for (imagepath in Assets.imagesPaths){
			var imageNameA = imagepath.split("/");
			var imageName = imageNameA[imageNameA.length - 1];
			Krom.sysCommand('$copycmd $imagepath $path/$imageName');
		}
	}

	public static function exportScene(path:String = "") {
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+App.scene.name+".json", haxe.io.Bytes.ofString(haxe.Json.stringify(App.scene)).getData());
	}

	public static function exportWindow(path:String = "") {
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+"window.json", haxe.io.Bytes.ofString(haxe.Json.stringify(App.window)).getData());
	}

	public static function exportNodes(path:String = "") {
		var newPath = path;
		if(path!="") newPath = path+"/";
		for(nodes in UINodes.nodesArray){
			var name = nodes.name;
			Krom.fileSaveBytes(newPath+'LN$name.json', haxe.io.Bytes.ofString(haxe.Json.stringify(nodes.nodeCanvas)).getData());
		}
	}

	public static function exportJsonFile(name:String, data:String) {
		Krom.fileSaveBytes(name, haxe.io.Bytes.ofString(data).getData());
	}

	public static function exportFile(name:String, data:String) {
		Krom.fileSaveBytes(name, haxe.io.Bytes.ofString(data).getData());
	}

	static function adjustAssetsPath(newPath:String): AssetData{

		var adjustedImagesPath:Array<String> = [];
		var adjustedFontsPath:Array<String> = [];
		var adjustedSoundsPath:Array<String> = [];
		var adjustedBlobsPath:Array<String> = [];

		for (image in Assets.imagesPaths) adjustedImagesPath.push('$newPath/Assets/' + Path.getNameFromPath(image));
		for (font in Assets.fontsPaths) adjustedFontsPath.push('$newPath/Assets/' + Path.getNameFromPath(font));
		for (sound in Assets.soundsPaths) adjustedSoundsPath.push('$newPath/Assets/' + Path.getNameFromPath(sound));
		for (blob in Assets.blobsPaths) adjustedBlobsPath.push('$newPath/Assets/' + Path.getNameFromPath(blob));

		var adjustedAssetsPath:AssetData = {
			images: adjustedImagesPath,
			fonts: adjustedFontsPath,
			sounds: adjustedSoundsPath,
			blobs: adjustedBlobsPath
		}
		return adjustedAssetsPath;
	}

	static function adjustObjectSpritePath(newPath:String) {
		for (object in App.scene.objects){
			if(object.spriteRef!= null){
				var ref = object.spriteRef;
				var name = ref.split("/");
				var newName = name[name.length-1];
				object.spriteRef = '$newPath/Assets/$newName';
			}
		}
	}

	static function adjustScriptsPath(newPath:String, scripts:Array<ScriptData>) {
		if(scripts!=null && scripts.length != 0){
			for(script in scripts){
				var ref = script.scriptRef;
				var name = ref.split("/");
				var newName = name[name.length-1];
				script.scriptRef = '$newPath/Assets/$newName';
			}
		}
	}
}
