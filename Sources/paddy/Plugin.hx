package paddy;

@:keep
class Plugin {

	public static var plugins:Map<String, Plugin> = [];
	static var pluginName:String;
	public var executeRunUI: Void->Void = null;
	public var propWinUI: zui.Zui->Void = null;
	public var propTabUI: zui.Zui->Void = null;
	public var propObjPanelUI: zui.Zui->Void = null;
	public var propWinPanelUI: zui.Zui->Void = null;
	public var editorTabUI: zui.Zui->Void = null;
	public var editorGridPanelUI: zui.Zui->Void = null;
	public var editorRotPanelUI: zui.Zui->Void = null;
	public var nodeMenuUI: zui.Zui->Void = null;
	public var assetWinUI: zui.Zui->Void = null;
	public var outlinerWinUI: zui.Zui->Void = null;
	public var update:Void->Void = null;
	public var onRemove:Void->Void = null;

	public var name:String;

	public function new() {
		name = pluginName;
		plugins.set(name, this);
	}

	public static function enable(string:String) {
		kha.Assets.loadBlobFromPath("plugins/"+string+".js", function (blob){
			pluginName = string;
			#if js
			untyped __js__("(1, eval)({0})", blob.toString());
			#end
		});
		paddy.Paddy.reloadUI();
	}

	public static function disable(string:String) {
		var p = plugins.get(string);
		if (p != null && p.onRemove != null) p.onRemove();
		plugins.remove(string);
		paddy.Paddy.reloadUI();
	}
}

@:expose("paddy")
class PaddyBridge {
	public static var App = paddy.App;
	public static var Plugin = paddy.Plugin;
	public static var Assets = paddy.Assets;
	public static var UtilMath = paddy.util.Math;
	public static var Export = paddy.files.Export;
	public static var NodeCreator = paddy.nodes.NodeCreator;
	public static var UIAssets = paddy.ui.UIAssets;
	public static var UIProperties = paddy.ui.UIProperties;
	public static var UIOutliner = paddy.ui.UIOutliner;
	public static var UINodes = paddy.ui.UINodes;
	public static var UIFileBrowser = paddy.ui.UIFileBrowser;
	public static var Path = paddy.files.Path;
}

@:expose("zui")
class UIBridge {
	public static var UI = zui.Zui;
	public static var Handle = zui.Zui.Handle;
}

@:expose("kha")
class KhaBridge {
	public static var Assets = kha.Assets;
	public static var TKrom = Krom;
	public static var FastVector2 = kha.math.FastVector2;
}

@:expose("std")
class HaxeBridge {
	public static var Math = std.Math;
	public static var Json = haxe.Json;
	public static var Bytes = haxe.io.Bytes;
}
