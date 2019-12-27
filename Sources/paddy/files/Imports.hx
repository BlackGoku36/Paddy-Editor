package paddy.files;

// Zui
import zui.Nodes;

// Editor
import paddy.data.Data;

class Imports {

	public static function importPaddy(path:String) {
		kha.Assets.loadBlobFromPath(path, function(blob){
			if(!StringTools.endsWith(path, "paddy.json")) return;
			var parsed: paddy.Paddy.PaddyData = haxe.Json.parse(blob.toString());
			App.paddydata = parsed;
			App.paddydata.name = parsed.name;
			App.paddydata.scene = parsed.scene;
			App.paddydata.window = parsed.window;
			importWindow(parsed.window);
			importScene(parsed.scene);
			App.projectPath = path.substring(0, path.length - 10);
			App.assetHandle.text = path.substring(0, path.length - 10);
			paddy.Paddy.reloadUI();
		});
	}


	public static function importScene(path:String) {
		kha.Assets.loadBlobFromPath(path, function(blob){
			var scene:paddy.data.Data.SceneData = haxe.Json.parse(blob.toString());
			App.scene = scene;
			importObjectSprites(scene.assets);
			if(scene.scripts.length != 0) importNodesFromScriptData(scene.scripts);
			for(obj in scene.objects) if(obj.scripts.length != 0) importNodesFromScriptData(obj.scripts);			
		});
	}

	public static function importWindow(path:String) {
		kha.Assets.loadBlobFromPath(path, function(blob){
			var parsed:paddy.data.Data.WindowData = haxe.Json.parse(blob.toString());
			App.window = parsed;
		});
	}

	public static function importNodesFromScriptData(scripts: Array<ScriptData>) {
		for(script in scripts){
			kha.Assets.loadBlobFromPath(script.scriptRef, function(blob){
				trace(blob.toString());
				var nodeC:TNodeCanvas = haxe.Json.parse(blob.toString());
				var nodeData:NodeData = {
					name: Path.getNameFromPath(script.scriptRef).split(".")[0],
					nodes: new Nodes(),
					nodeCanvas: nodeC
				};
				paddy.ui.UINodes.nodesArray.push(nodeData);
			});
		}
	}

	public static function importObjectSprites(paths:Array<AssetData>) {
		for(path in paths){
			if(path.type == Image) Assets.loadAssetFromPath(path.path, Image);
		}
	}
}
