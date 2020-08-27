package paddy.files;

// Editor
import paddy.data.Data.AssetData;
import paddy.data.Data.ScriptData;
import paddy.System;
// import sys.io.File;
import haxe.io.Bytes;
import haxe.Json;

class Export{

	#if kha_windows
	static var copycmd = "copy";
	#else
	static var copycmd = "cp";
	#end

	public static function exportPaddy(path:String = "") {
		System.command('mkdir $path/Assets');
		copyAssets('$path/Assets/');
		adjustObjectSpritePath(path);
		adjustAssetsPath(path);
		adjustScriptsPath(path, App.scene.scripts);
		for(obj in App.scene.objects) adjustScriptsPath(path, obj.scripts);
		if(App.paddydata.name =="") App.paddydata.name = "PaddyProject";
		if(App.paddydata.scene =="") App.paddydata.scene = "scene.json";
		if(App.paddydata.window =="") App.paddydata.window = "window.json";
		var newPath = path;
		if(path!="") newPath = path+"/";
		System.fileSaveBytes(newPath+"paddy.json", Bytes.ofString(Json.stringify(App.paddydata)));
		exportWindow(path);
		App.scene.assets = Assets.assets;
		exportScene(path);
		App.projectPath = path;
		paddy.Paddy.reloadUI();
	}

	public static function exportConfig() {
		App.configData.plugins = Plugin.getNames();
		trace(System.programPath());
		System.fileSaveBytes(System.programPath() +"/_config.json", Bytes.ofString(Json.stringify(App.configData)));
	}

	public static function copyAssets(path:String) {
		for(asset in Assets.assets){
			System.command('$copycmd ' + asset.path + ' $path');
		}
	}

	public static function exportScene(path:String = "") {
		var newPath = path;
		if(path!="") newPath = path+"/";
		for(asset in App.scene.assets) asset.value = null;
		System.fileSaveBytes(newPath+App.scene.name+".json", Bytes.ofString(Json.stringify(App.scene)));
	}

	public static function exportWindow(path:String = "") {
		var newPath = path;
		if(path!="") newPath = path+"/";
		System.fileSaveBytes(newPath+"window.json", Bytes.ofString(Json.stringify(App.window)));
	}

	public static function exportJsonFile(path:String, data:Dynamic) {
		System.fileSaveBytes(path, Bytes.ofString(Json.stringify(data)));
	}

	public static function exportFile(path:String, data:String) {
		System.fileSaveBytes(path, Bytes.ofString(data));
	}

	static function adjustAssetsPath(newPath:String){
		for(asset in Assets.assets) asset.path = 'Assets/' + asset.name;
	}

	static function adjustObjectSpritePath(newPath:String) {
		for (object in App.scene.objects){
			if(object.spriteRef!= null){
				var ref = object.spriteRef;
				var name = ref.split("/");
				var newName = name[name.length-1];
				object.spriteRef = newName;
			}
		}
	}

	static function adjustScriptsPath(newPath:String, scripts:Array<ScriptData>) {
		if(scripts!=null && scripts.length != 0){
			for(script in scripts){
				var ref = script.scriptRef;
				var name = ref.split("/");
				var newName = name[name.length-1];
				script.scriptRef = 'Assets/$newName';
			}
		}
	}
}
