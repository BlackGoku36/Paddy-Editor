package paddy.files;

class Imports {

    public static function importPaddy(path:String) {
        kha.Assets.loadBlobFromPath(path, function(blob){
            if(!StringTools.endsWith(path, "paddy.json")) return;
            var parsed: paddy.data.Data.PaddyData = haxe.Json.parse(blob.toString());
            App.paddydata = parsed;
            App.paddydata.name = parsed.name;
            App.paddydata.scene = parsed.scene;
            App.paddydata.window = parsed.window;
            importWindow(parsed.window);
            importScene(parsed.scene);
            App.projectPath = path.substring(0, path.length - 10);
            App.propWinH.redraws = 2;
            App.sceneWinH.redraws = 2;
            App.assetsWinH.redraws = 2;
            App.editorWinH.redraws = 2;
        });
    }

    public static function importScene(path:String) {
        kha.Assets.loadBlobFromPath(path, function(blob){
            var parsed:paddy.data.Data.SceneData = haxe.Json.parse(blob.toString());
            App.scene = parsed;
            importObjectSprites(parsed.assets.images);
        });
    }

    public static function importWindow(path:String) {
        kha.Assets.loadBlobFromPath(path, function(blob){
            var parsed:paddy.data.Data.WindowData = haxe.Json.parse(blob.toString());
            App.window = parsed;
        });
    }

    public static function importObjectSprites(paths:Array<String>) {
        for(path in paths){
            Assets.loadImage(path);
        }
    }
}