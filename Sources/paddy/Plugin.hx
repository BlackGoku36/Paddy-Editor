package paddy;

@:keep
class Plugin {

	public static var plugins:Map<String, Plugin> = [];
	static var pluginName:String;
	public var propWinUI: zui.Zui->Void = null;
	public var propTabUI: zui.Zui->Void = null;
	public var propObjPanelUI: zui.Zui->Void = null;
	public var propWinPanelUI: zui.Zui->Void = null;
	public var editorTabUI: zui.Zui->Void = null;
	public var editorGridPanelUI: zui.Zui->Void = null;
	public var editorRotPanelUI: zui.Zui->Void = null;
	public var assetWinUI: zui.Zui->Void = null;
	public var sceneWinUI: zui.Zui->Void = null;
	public var update:Void->Void = null;
	public var onRemove:Void->Void = null;

	public var name:String;

	public function new() {
		name = pluginName;
		plugins.set(name, this);
	}

	public static function enable(string:String) {
		kha.Assets.loadBlobFromPath(string+".js", function (blob){
			#if js
			untyped __js__("(1, eval)({0})", blob.toString());
			#end
		});
	}

	public static function disable(string:String) {
		var p = plugins.get(string);
		if (p != null && p.onRemove != null) p.onRemove();
		plugins.remove(string);
	}
}

@:expose("paddy")
class PaddyBridge {
	public static var App = paddy.App;
	public static var Plugin = paddy.Plugin;
	public static var Assets = paddy.Assets;
	public static var UtilMath = paddy.util.Math;
	public static var Export = paddy.files.Export;
}

@:expose("ui")
class UIBridge {
	public static var UI = zui.Zui;
	public static var Handle = zui.Zui.Handle;
	public static var UIAssets = paddy.ui.UIAssets;
	public static var UIProperties = paddy.ui.UIProperties;
}

@:expose("kha")
class KhaBridge {
	public static var Assets = kha.Assets;
}

#if kha_krom
@:expose("krom")
class KromBridge {
	public static var Kromx = Krom;
}
#end

@:expose("std")
class HaxeBridge {
	public static var Math = std.Math;
	public static var Json = haxe.Json;
	public static var Bytes = haxe.io.Bytes;
}
