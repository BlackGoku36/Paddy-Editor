package;

import kha.input.KeyCode;
import kha.math.Vector2;
import data.SceneData;
import data.SceneData.ObjectData;
import zui.Ext;
import kha.Assets;
import kha.Window;
import zui.Id;
import zui.Zui;
import kha.Framebuffer;
using kha.graphics2.GraphicsExtension;

@:access(zui.Zui)
class Project {

	var ui:Zui;
	var objects:Array<String> = [];
	var at = 0;

	var ww = kha.System.windowWidth();
	var wh = kha.System.windowHeight();

	var lastW = 0;
	var lastH = 0;

	public static var coffX = 220.0;
	public static var coffY = 80.0;

	static var grid:kha.Image = null;
	public static var gridSize:Int = 20;

	var sceneW = 200; var sceneH = 600;
	var editorW = 300; var editorH = 300;
	var propsW = 200; var propsH = 600;
	var assetW = 500; var assetH = 100;
	var fileW = 200; var fileH = 100;
	var editorX = 0; var editorY = 0;

	var buildMode = 0;

	public static var propwin = Id.handle();
	public static var sceneHandle = Id.handle();
	public static var editorHandle = Id.handle();
	public static var selectedObj:ObjectData = null;

	var window:data.SceneData.WindowData = {
		name: "Window",
		width: 1440,
		height: 900,
		windowMode: 0,
		clearColor: [0, 0, 0, 255]
	}

	var scene:data.SceneData = {
		name: "scene",
		objects: []
	}

	public function new() {
		Assets.loadFontFromPath("hn.ttf", function (fnt){
			ui = new Zui({font: fnt});
			ObjectController.ui = ui;
		});
		editorX = kha.System.windowWidth() - editorW - propsW;
		editorY = 60;
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
		// Draw grid
		g.drawImage(grid, coffX % 40 - 40, coffY % 40 - 40);
		// Draw window in editor
		g.drawRect(coffX, coffY, window.width*0.5, window.height*0.5);

		ObjectController.render(g);

		var col = g.color;
		g.color = 0xff323232;
		g.fillRect(0, 30, sceneW, sceneH);
		g.fillRect(kha.System.windowWidth()-propsW, 30, propsW, kha.System.windowHeight());
		g.fillRect(fileW, sceneH, kha.System.windowWidth()-propsW-fileW, kha.System.windowHeight()-sceneH-20);
		g.fillRect(0, sceneH, fileW, kha.System.windowHeight()-sceneH-20);
		g.fillRect(0, 0, kha.System.windowWidth(), 30);
		g.color = 0xff252525;
		g.fillRect(0, kha.System.windowHeight()-20, kha.System.windowWidth(), 20);
		g.color = col;
		g.end();

		ui.begin(g);
		if(ui.window(Id.handle(), kha.System.windowWidth()-500, 0, 200, 30)){
			ui.row([1/5, 4/5]);
			if(ui.button("{}")){
				if(buildMode == 0){
					#if kha_krom
					Krom.fileSaveBytes(scene.name+".json", haxe.io.Bytes.ofString(haxe.Json.stringify(scene)).getData());
					#elseif kha_debug_html5
						var fs = untyped __js__('require("fs");');
						var path = untyped __js__('require("path")');
						var filePath = path.resolve(untyped __js__('__dirname'), "../../"+scene.name+'.json');
						try { fs.writeFileSync(filePath, haxe.Json.stringify(scene)); }
						catch (x: Dynamic) { trace('saving "${filePath}" failed'+x); }
					#end
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
			var mode = Id.handle({position: 0});
			ui.combo(Id.handle({position: 0}), ["Build", "Play"], Right);
			if (mode.changed) buildMode = mode.position;
		}
		if(ui.window(sceneHandle, 0, 30, Std.int(sceneW*ui.SCALE()), sceneH)){
			var htab = Id.handle({position: 0});
			if(ui.tab(htab, "Scene")){
				ui.row([3/4, 1/4]);
				ui.textInput(Id.handle(), "Search");
				if(ui.button("+")){
					var object:data.SceneData.ObjectData = {
						id: getObjectId(scene),
						name: "object"+at,
						x: 0, y: 0,
						width: 100, height: 100,
						rotation: 0
					}
					scene.objects.push(object);
					selectedObj = object;
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
		}
		if(ui.window(Id.handle(), sceneW, 30, kha.System.windowWidth()-propsW-sceneW, editorH)){
			var editorTabH = Id.handle();
			if(ui.tab(editorTabH, "2D")){}
			if(ui.tab(editorTabH, "Nodes")){}
		}

		if(ui.window(propwin, kha.System.windowWidth()-propsW, 30, Std.int(propsW*ui.SCALE()), propsH)){
			if(ui.tab(Id.handle(), "Properties")){
				if(ui.panel(Id.handle({selected:true}), "Window")){
					ui.indent();
					ui.row([1/4, 3/4]);
					ui.text("Name");
					window.name = ui.textInput(Id.handle({text: window.name}), Right);
					ui.row([1/4, 3/4]);
					ui.text("Width");
					window.width = Std.parseInt(ui.textInput(Id.handle({text: window.width+""}), Right));
					ui.row([1/4, 3/4]);
					ui.text("Height:");
					window.height = Std.parseInt(ui.textInput(Id.handle({text: window.height+""}), Right));
					ui.row([1/4, 3/4]);
					ui.text("Mode:");
					var windowHandle = Id.handle({position: 0});
					ui.combo(Id.handle({position: 0}), ["Windowed", "Fullscreen"], Right);
					if (windowHandle.changed) window.windowMode = windowHandle.position;
					ui.unindent();
				}
				if(selectedObj!=null){
					var obj = selectedObj;
					var id = obj.id;
					if (ui.panel(Id.handle({selected: true}), "Object")) {
						ui.indent();
						ui.row([1/4, 3/4]);
						ui.text("Name");
						obj.name = ui.textInput(Id.handle().nest(id, {text: obj.name}), Right);

						ui.row([1/4, 3/4]);
						ui.text("X:");
						var handlex = Id.handle().nest(id, {text: obj.x + ""});
						handlex.text = obj.x + "";
						var strx = ui.textInput(handlex, Right);
						obj.x = Std.parseFloat(strx);

						ui.row([1/4, 3/4]);
						ui.text("Y:");
						var handley = Id.handle().nest(id, {text: obj.y + ""});
						handley.text = obj.y + "";
						var stry = ui.textInput(handley, Right);
						obj.y = Std.parseFloat(stry);

						ui.row([1/4, 3/4]);
						ui.text("Width");
						var handlew = Id.handle().nest(id, {text: obj.width + ""});
						handlew.text = obj.width + "";
						var strw = ui.textInput(handlew, Right);
						obj.width = Std.int(Std.parseFloat(strw));

						ui.row([1/4, 3/4]);
						ui.text("Height");
						var handleh = Id.handle().nest(id, {text: obj.height + ""});
						handleh.text = obj.height + "";
						var strh = ui.textInput(handleh, Right);
						obj.height = Std.int(Std.parseFloat(strh));

						ui.row([1/4, 3/4]);
						ui.text("Rot");
						var handler = Id.handle().nest(id, {text: obj.rotation + ""});
						handler.text = obj.rotation + "";
						var strr = ui.textInput(handler, Right);
						obj.rotation = Std.int(Std.parseFloat(strr));
						ui.unindent();
					}
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
				ui.row([9/10, 1/10]);
				ui.textInput(Id.handle(), "Search", Right);
				ui.button("Enter");
				for (font in std.Assets.fonts) for (name => value in font) ui.text(name);
				for (image in std.Assets.images) for (name => value in image) ui.text(name);
				for (sound in std.Assets.sounds) for (name => value in sound) ui.text(name);
				for (blob in std.Assets.blobs) for (name => value in blob) ui.text(name);
				// ui.image(grid, 0xffffffff, null, 0, 0, 50, 50);
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

	public function update() {
		if(ui == null)return;

		if(selectedObj!=null) propwin.redraws = 2;

		if(!ObjectController.isManipulating && ui.inputDownR) {
			coffX += Std.int(ui.inputDX);
			coffY += Std.int(ui.inputDY);
		}

		ObjectController.update();

		if (ui.inputStartedR && ui.inputDownR) {
			for (object in scene.objects) {
				if (util.Math.hitbox(ui, coffX + object.x, coffY + object.y, object.width, object.height, object.rotation) &&
						selectedObj != object) {
					selectedObj = object;
					sceneHandle.redraws = 2;
					break;
				}
			}
		}
	}

	static var elemId = -1;
	public static function getObjectId(scene: SceneData): Int {
		if (elemId == -1) for (e in scene.objects) if (elemId < e.id) elemId = e.id;
		return ++elemId;
	}
}
