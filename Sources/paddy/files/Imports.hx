package paddy.files;

// Zui
import paddy.ui.UIStatusBar;
import paddy.ui.UIProperties;

// Editor
import paddy.data.Data;

class Imports {

	public static function importPaddy(path:String) {
		if(!StringTools.endsWith(path, "paddy.json")){
			UIStatusBar.error("Paddy file is incorrect. Make sure you are selecting 'paddy.json' file.", 4000);
			return;
		}
		kha.Assets.loadBlobFromPath(path, function(blob){
			var parsed: paddy.Paddy.PaddyData = haxe.Json.parse(blob.toString());
			App.paddydata = parsed;
			App.projectPath = path.substring(0, path.length - 10);
			App.assetHandle.text = path.substring(0, path.length - 10);
			importWindow(parsed.window);
			importScene(parsed.scene);
			paddy.Paddy.reloadUI();
		}, (err)->{
			UIStatusBar.error("Failed to project file.");
		});
	}

	public static function importConfig() {
		kha.Assets.loadBlobFromPath(System.programPath() + "/_config.json", function(blob){
			var parsed: paddy.data.Data.ConfigData = haxe.Json.parse(blob.toString());
			App.configData = parsed;
			if(App.configData.plugins != null) importPlugins(App.configData.plugins);
			App.ui.setScale(App.configData.uiScale);
			App.uimodal.setScale(App.configData.uiScale);
		}, (err)->{
			UIStatusBar.error("Failed to load config file. Ignore if config file isn't set.", 3500);
		});
	}


	public static function importScene(path:String) {
		kha.Assets.loadBlobFromPath(App.projectPath + path, function(blob){
			var scene:paddy.data.Data.SceneData = haxe.Json.parse(blob.toString());
			App.scene = scene;
			importObjectSprites(scene.assets);
		}, (err)->{
			UIStatusBar.error("Failed to load scene file.");
		});
	}

	public static function importWindow(path:String) {
		kha.Assets.loadBlobFromPath(App.projectPath + path, function(blob){
			var window:paddy.data.Data.WindowData = haxe.Json.parse(blob.toString());
			App.window = window;
		}, (err)->{
			UIStatusBar.error("Failed to load window file.");
		});
	}

	public static function importObjectSprites(paths:Array<AssetData>) {
		for(path in paths){
			if(path.type == Image) Assets.loadAssetFromPath(App.projectPath + path.path, Image);
		}
	}

	static function importPlugins(names:Array<String>) {
		for(name in names) Plugin.enable(name);
	}
}
