package export;

class Export{

    static var scene = App.scene;
    static var window = App.window;

    public static function exportScene() {
        scene.assets = {
            images: Assets.getImagesName(),
            fonts: Assets.getFontsName(),
            sounds: Assets.getSoundsName(),
            blobs: Assets.getBlobsName()
        }
        #if kha_krom
        Krom.fileSaveBytes(scene.name+".json", haxe.io.Bytes.ofString(haxe.Json.stringify(scene)).getData());
        #elseif kha_debug_html5
            var fs = untyped __js__('require("fs");');
            var path = untyped __js__('require("path")');
            var filePath = path.resolve(untyped __js__('__dirname'), "../../"+scene.name+'.json');
            try { fs.writeFileSync(filePath, haxe.Json.stringify(scene)); }
            catch (x: Dynamic) { trace('saving "${filePath}" failed'+x); }
        #end
    }

    public static function exportWindow() {
        #if kha_krom
        Krom.fileSaveBytes("window.json", haxe.io.Bytes.ofString(haxe.Json.stringify(window)).getData());
        #elseif kha_debug_html5
            var fs = untyped __js__('require("fs");');
            var path = untyped __js__('require("path")');
            var filePath = path.resolve(untyped __js__('__dirname'), "../../"+'window.json');
            try { fs.writeFileSync(filePath, haxe.Json.stringify(window)); }
            catch (x: Dynamic) { trace('saving "${filePath}" failed'+x); }
        #end
    }
}
