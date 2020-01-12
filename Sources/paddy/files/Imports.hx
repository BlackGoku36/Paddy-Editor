package paddy.files;

// Zui
import paddy.ui.UIProperties;
import zui.Nodes;

// Editor
import paddy.data.Data;

class Imports {

	public static function importPaddy(path:String) {
		kha.Assets.loadBlobFromPath(path, function(blob){
			if(!StringTools.endsWith(path, "paddy.json")) return;
			var parsed: paddy.Paddy.PaddyData = haxe.Json.parse(blob.toString());
			App.paddydata = parsed;
			App.projectPath = path.substring(0, path.length - 10);
			App.assetHandle.text = path.substring(0, path.length - 10);
			importWindow(parsed.window);
			importScene(parsed.scene);
			paddy.Paddy.reloadUI();
		});
	}
	
	public static function importConfig() {
		var parsed: paddy.data.Data.ConfigData = haxe.Json.parse(kha.Assets.blobs._config_json.toString());
		App.configData = parsed;
		if(App.configData.plugins != null) importPlugins(App.configData.plugins);
		paddy.ui.UIProperties.reScaleUI(App.configData.uiScale);
	}


	public static function importScene(path:String) {
		kha.Assets.loadBlobFromPath(App.projectPath + path, function(blob){
			var scene:paddy.data.Data.SceneData = haxe.Json.parse(blob.toString());
			App.scene = scene;
			importObjectSprites(scene.assets);
			if(scene.scripts.length != 0) importNodesFromScriptData(scene.scripts);
			for(obj in scene.objects) if(obj.scripts.length != 0) importNodesFromScriptData(obj.scripts);			
		});
	}

	public static function importWindow(path:String) {
		kha.Assets.loadBlobFromPath(App.projectPath + path, function(blob){
			var window:paddy.data.Data.WindowData = haxe.Json.parse(blob.toString());
			App.window = window;
		});
	}

	public static function importNodesFromScriptData(scripts: Array<ScriptData>) {
		for(script in scripts){
			kha.Assets.loadBlobFromPath(App.projectPath+script.scriptRef, function(blob){
				var nodeC:TNodeCanvas = haxe.Json.parse(blob.toString());
				var nodeData:NodeData = {
					name: Path.getNameFromPath(App.projectPath+script.scriptRef).split(".")[0],
					nodes: new Nodes(),
					nodeCanvas: nodeC
				};
				paddy.ui.UINodes.nodesArray.push(nodeData);
			});
		}
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
