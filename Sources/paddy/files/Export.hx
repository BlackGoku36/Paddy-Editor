package paddy.files;

import paddy.ui.UINodes;
import paddy.data.Data.AssetData;

class Export{

	public static function exportPaddy(path:String = "") {
		adjustObjectSpritePath(path);
		App.scene.assets = adjustAssetsPath(path);
		if(App.paddydata.name =="") App.paddydata.name = "PaddyProject";
		if(App.paddydata.scene =="") App.paddydata.scene = path+"/"+"scene.json";
		if(App.paddydata.window =="") App.paddydata.window = path+"/"+"window.json";
		#if kha_krom
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+"paddy.json", haxe.io.Bytes.ofString(haxe.Json.stringify(App.paddydata)).getData());
		exportScene(path);
		exportWindow(path);
		Krom.sysCommand('mkdir $path/Assets');
		copyAssets('$path/Assets');
		App.projectPath = path;
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
		Krom.fileSaveBytes(newPath+App.scene.name+".json", haxe.io.Bytes.ofString(haxe.Json.stringify(App.scene)).getData());
		#end
	}

	public static function exportWindow(path:String = "") {
		#if kha_krom
		var newPath = path;
		if(path!="") newPath = path+"/";
		Krom.fileSaveBytes(newPath+"window.json", haxe.io.Bytes.ofString(haxe.Json.stringify(App.window)).getData());
		#end
	}

	public static function exportNodes(path:String = "") {
		#if kha_krom
		var newPath = path;
		if(path!="") newPath = path+"/";
		for(nodes in UINodes.nodesArray){
			var name = nodes.name;
			Krom.fileSaveBytes(newPath+'LN$name.json', haxe.io.Bytes.ofString(haxe.Json.stringify(nodes.nodeCanvas)).getData());
		}
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
}
