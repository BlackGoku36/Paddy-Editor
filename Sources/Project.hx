package;

import kha.Assets;
import kha.Window;
import zui.Id;
import zui.Zui;
import kha.Framebuffer;

class Project {

    var ui:Zui;
    var objects:Array<String> = [];
    var at = 0;

    var scene:data.SceneData = {
        name: "scene",
        objects: []
    }

    public function new() {
        Assets.loadFontFromPath("hn.ttf", function (fnt){
            ui = new Zui({font: fnt});
        });
    }

    public function update() {
        // trace("update");
    }

    public function render(frame:Array<Framebuffer>) {
        var g = frame[0].g2;
        g.begin();
        g.end();
        ui.begin(g);
        if(ui.window(Id.handle(), 0, 30, Std.int(140*ui.SCALE()), 600)){
            var htab = Id.handle({position: 0});
            if(ui.tab(htab, "Scene")){
                if(ui.button("Add")){
                    scene.objects.push({
                        name: "object"+at,
                        x: Math.random(), y:Math.random(),
                        width: Math.random(), height:Math.random()
                    });
                    // objects.push("NewStr: "+at);
                    at++;
                }
                for (obj in scene.objects){
                    ui.text(obj.name);
                }
            }
            if(ui.tab(htab, "Project")){
                if(ui.button("save")){
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
            }
        }
        ui.end();
    }
}