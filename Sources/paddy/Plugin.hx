package paddy;

@:keep
class Plugin {

    public static var plugins:Array<Map<String, Plugin>> = [];
    static var pluginName:String;
    public var drawUI: zui.Zui->Void = null;
    public var onRemove:Void->Void = null;

    public var name:String;

    public function new(name:String) {
        this.name = name;
        plugins.push([this.name => this]);
        // plugins.set(name, this);
    }

    public function enable() {
        kha.Assets.loadBlobFromPath(name+".js", function (blob){
            #if js
            untyped __js__("(1, eval)({0})", blob.toString());
            #end
        });
    }

    public function disable() {
        for(plugin in plugins){
            var p = plugin.get(name);
		    if(p.name == name){
                if (p != null && p.onRemove != null) p.onRemove();
                plugins.remove(plugin);
            }
        }
	}
}

@:expose("paddy")
class PaddyBridge {
    public static var App = paddy.App;
    public static var Plugin = paddy.Plugin;
    public static var Assets = paddy.Assets;
    public static var UtilMath = paddy.util.Math;
    public static var Export = paddy.export.Export;
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

@:expose("std")
class HaxeBridge {
    public static var Math = std.Math;
    public static var Json = haxe.Json;
}
