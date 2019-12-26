package paddy.data;

import zui.Nodes;
import zui.Nodes.TNodeCanvas;
import kha.math.FastVector2;

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
	var assets: AssetData;
	var ?scripts: Array<ScriptData>;
	var ?canvasRef: String;
}

typedef AssetData = {
	var images: Array<String>;
	var ?fonts: Array<String>;
	var ?sounds: Array<String>;
	var ?blobs: Array<String>;
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
