package paddy.data;

// Zui
import zui.Nodes;
import zui.Nodes.TNodeCanvas;

typedef WindowData = {
	var name: String;
	var width: Int;
	var height: Int;
	var windowMode: Int;
	var clearColor: Array<Int>;
}

typedef SceneData = {
	var name: String;
	var objects: Array<ObjectData>;
	var assets: Array<AssetData>;
	var ?scripts: Array<ScriptData>;
	var ?canvasRef: String;
}

typedef AssetData = {
	var name:String;
	var type:AssetType;
	var value: Dynamic;
	var path:String;
}

@:enum abstract AssetType(Int) from Int to Int {
	var Image = 0;
	var Font = 0;
	var Sound = 1;
	var Blob = 1;
}

typedef ObjectData = {
	var id:Int;
	var name: String;
	var x: Float;
	var y: Float;
	var height: Float;
	var width: Float;
	var isSprite:Bool;
	var ?rotation:Float;
	var ?visible:Bool;
	var ?culled: Bool;
	var ?spriteRef: String;
	var ?color: Array<Int>;
	var ?scripts: Array<ScriptData>;
}

typedef NodeData = {
	var name: String;
	var nodes: Nodes;
	var nodeCanvas: TNodeCanvas;
}

typedef ScriptData = {
	var name: String;
	var scriptRef: String;
}
