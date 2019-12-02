package;

import data.SceneData.ObjectData;
import zui.Ext;
import kha.Assets;
import kha.Window;
import zui.Id;
import zui.Zui;
import kha.Framebuffer;

@:access(zui.Zui)
class Project {

    var ui:Zui;
    var objects:Array<String> = [];
    var at = 0;

    var ww = kha.System.windowWidth();
	var wh = kha.System.windowHeight();

    var lastW = 0;
	var lastH = 0;

    static var coffX = 70.0;
	static var coffY = 50.0;

    static var grid:kha.Image = null;
    var gridSize:Int = 20;

    var sceneW = 200; var sceneH = 600;
    var editorW = 300; var editorH = 300;
    var propsW = 200; var propsH = 600;
    var assetW = 500; var assetH = 100;
    var fileW = 200; var fileH = 100;

    var propwin = Id.handle();
    var selectedObj:ObjectData = null;

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

    function resize() {
		if (grid != null) {
			grid.unload();
			grid = null;
		}
	}

    function drawGrid() {
		var doubleGridSize = gridSize * 2;
		var ww = kha.System.windowWidth();
		var wh = kha.System.windowHeight();
		var w = ww + doubleGridSize * 2;
		var h = wh + doubleGridSize * 2;
		grid = kha.Image.createRenderTarget(w, h);
		grid.g2.begin(true, 0xff242424);
		for (i in 0...Std.int(h / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(0, i * doubleGridSize, w, i * doubleGridSize);
			grid.g2.color = 0xff323232;
			grid.g2.drawLine(0, i * doubleGridSize + gridSize, w, i * doubleGridSize + gridSize);
		}
		for (i in 0...Std.int(w / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(i * doubleGridSize, 0, i * doubleGridSize, h);
			grid.g2.color = 0xff323232;
			grid.g2.drawLine(i * doubleGridSize + gridSize, 0, i * doubleGridSize + gridSize, h);
		}

		grid.g2.end();
	}

    public function render(frame:Array<Framebuffer>) {
        if(grid==null)drawGrid();
        var g = frame[0].g2;
        g.begin();
        g.drawImage(grid, coffX % 40 - 40, coffY % 40 - 40);
        var col = g.color;
        g.color = 0xff323232;
        g.fillRect(0, 30, sceneW, sceneH);
        g.fillRect(kha.System.windowWidth()-propsW, 30, propsW, propsH);
        g.fillRect(fileW, sceneH, kha.System.windowWidth()-propsW-fileW, kha.System.windowHeight()-sceneH-20);
        g.fillRect(0, sceneH, fileW, kha.System.windowHeight()-sceneH-20);
        g.color = col;
        g.end();
        ui.begin(g);
        if(ui.window(Id.handle(), 0, 30, Std.int(sceneW*ui.SCALE()), sceneH)){
            var htab = Id.handle({position: 0});
            if(ui.tab(htab, "Scene")){
                ui.row([3/4, 1/4]);
                ui.textInput(Id.handle(), "Search");
                if(ui.button("+")){
                    scene.objects.push({
                        name: "object"+at,
                        x: Math.random(), y:Math.random(),
                        width: Math.random(), height:Math.random()
                    });
                    at++;
                }
                function drawList(h:zui.Zui.Handle, objData:ObjectData) {
                    if (selectedObj == objData) {
                        ui.g.color = 0xff205d9c;
                        ui.g.fillRect(0, ui._y, ui._windowW, ui.t.ELEMENT_H);
                        ui.g.color = 0xffffffff;
                    }
                    var started = ui.getStarted();
                    // Select
                    if (started && !ui.inputDownR) {
                        selectedObj = objData;
                    }
                    ui._x += 18; // Sign offset
                    ui.text(objData.name);
                    ui._x -= 18;
                }
                for (i in 0...scene.objects.length) {
                    var objData = scene.objects[scene.objects.length - 1 - i];
                    drawList(Id.handle(), objData);
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
        if(ui.window(Id.handle(), sceneW, 30, kha.System.windowWidth()-propsW-sceneW, editorH)){
            var editorTabH = Id.handle();
            if(ui.tab(editorTabH, "2D")){}
            if(ui.tab(editorTabH, "Nodes")){}
        }
        propwin.redraws = 2;
        if(ui.window(propwin, kha.System.windowWidth()-propsW, 30, Std.int(propsW*ui.SCALE()), propsH)){
            if(ui.tab(Id.handle(), "Properties")){
                if(selectedObj!=null){
                    // ui.row([1/4, 3/4]);
                    // ui.text("Name");
                    var name = ui.textInput(Id.handle({text:selectedObj.name}), "Name", Right);
                    selectedObj.name = name;
                    // ui.text(selectedObj.name);
                    ui.row([1/4, 3/4]);
                    ui.text("X:");
                    ui.text(selectedObj.x+"");
                    ui.row([1/4, 3/4]);
                    ui.text("Y:");
                    ui.text(selectedObj.y+"");
                    ui.row([1/4, 3/4]);
                    ui.text("Height");
                    ui.text(selectedObj.height+"");
                    ui.row([1/4, 3/4]);
                    ui.text("Width");
                    ui.text(selectedObj.width+"");
                }
            }
        }
        if(ui.window(Id.handle(), 0, sceneH, fileW, kha.System.windowHeight()-sceneH-20)){
            #if kha_debug_html5
            var path = untyped __js__('require("path")');
            var filePath = path.resolve(untyped __js__('__dirname'), "../../");
            #else
            var filePath = "";
            #end
            if(ui.tab(Id.handle(), "File Browser")){
                var path = Ext.fileBrowser(ui, Id.handle({text:filePath}));
                if(StringTools.endsWith(path, "Assets")){
                    // std.Assets.loadImages(path);
                    // std.Assets.loadFonts(path);
                    // std.Assets.loadSounds(path);
                    // std.Assets.loadBlobs(path);
                }
            }
        }
        if(ui.window(Id.handle(), fileW, sceneH, kha.System.windowWidth()-propsW-fileW, kha.System.windowHeight()-sceneH-20)){
            var assetTabH = Id.handle();
            if(ui.tab(assetTabH, "Assets")){
                for (font in std.Assets.fonts) for (name => value in font) ui.text(name);
                for (image in std.Assets.images) for (name => value in image) ui.text(name);
                for (sound in std.Assets.sounds) for (name => value in sound) ui.text(name);
                for (blob in std.Assets.blobs) for (name => value in blob) ui.text(name);
                ui.image(grid, 0xffffffff, null, 0, 0, 50, 50);
            }
            if(ui.tab(assetTabH, "Terminal")){}
        }
        ui.end();
        if (ui.changed && !ui.inputDown) {
			drawGrid();
		}
        if (lastW > 0 && (lastW != kha.System.windowWidth() || lastH != kha.System.windowHeight())) {
			resize();
		}
		lastW = kha.System.windowWidth();
		lastH = kha.System.windowHeight();
    }
}