package;

import kha.graphics2.Graphics;
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
class App {

	var ui:Zui;
	var uimodal:Zui;
	var objects:Array<String> = [];
	var at = 0;

	var ww = kha.System.windowWidth();
	var wh = kha.System.windowHeight();

	var lastW = 0;
	var lastH = 0;

	public static var coffX = 220.0;
	public static var coffY = 110.0;

	static var grid:kha.Image = null;
	public static var gridSize:Int = 20;
	public static var gridSnapBounds:Bool = false;
	public static var gridSnapPos:Bool = true;
	public static var gridUseRelative:Bool = true;
	public static var useRotationSteps:Bool = false;
	public static var rotationSteps:Int = 15;

	public static var editorLocked:Bool = false;

	var sceneW = 200; var sceneH = 600;
	var editorW = 300; var editorH = 300;
	var propsW = 200; var propsH = 600;
	var assetW = 500; var assetH = 100;
	var fileW = 200; var fileH = 100;
	var editorX = 0; var editorY = 0;

	// var addbtnX = 0.0;
	// var addbtnY = 0.0;

	var buildMode = 0;

	public static var propwin = Id.handle();
	public static var sceneHandle = Id.handle();
	public static var editorHandle = Id.handle();
	public static var selectedObj:ObjectData = null;
	// static var showObjectList = false;

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

	static var assetPath = "";
	static var selectedImage = null;

	public function new() {
		Assets.loadFontFromPath("hn.ttf", function (fnt){
			ui = new Zui({font: fnt});
			uimodal = new Zui({font: fnt});
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

		for (object in scene.objects){
			var sprite = std.Assets.getImage(object.spriteRef);
			if(sprite != null && object.visible) {
				g.pushRotation(object.rotation, coffX + object.x+(object.width/2), coffY + object.y+(object.height/2));
				g.drawScaledImage(sprite, coffX + object.x, coffY + object.y, object.width, object.height);
				g.popTransformation();
			}
		}

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
			if(ui.button("=>")){
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
					// addbtnX = ui._x+(sceneW*3/4);
					// addbtnY = ui._y+ui.buttonOffsetY+ui.BUTTON_H()+5;
					// showObjectList = true;
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
						ui.g.fillRect(0, ui._y-2, ui._windowW, ui.t.ELEMENT_H+4);
						ui.g.color = 0xffffffff;
					}
					var started = ui.getStarted();
					// Select
					if (started && !ui.inputDownR) {
						selectedObj = objData;
					}
					ui._x += 18; // Sign offset
					ui.row([1/7, 1/3, 1/7, 1/7, 1/7]);
					if(objData!=null){
						objData.visible = ui.check(Id.handle().nest(objData.id, {selected: true}), "");
						ui.text(objData.name);
						if(ui.button("<")) moveObjectInList(1);
						if(ui.button(">")) moveObjectInList(-1);
						if(ui.button("X")) scene.objects.remove(objData);
					}
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
			if(ui.tab(editorTabH, "2D")){
				ui.row([1/20, 1/15, 1/10]);
				ui.text("Editor");
				editorLocked = ui.check(Id.handle({selected:false}), "Lock");
				if(ui.button("Reset Pos")){
					coffX = 220.0;
					coffY = 110.0;
				}
			}
			if(ui.tab(editorTabH, "Nodes")){}
		}

		if(ui.window(propwin, kha.System.windowWidth()-propsW, 30, Std.int(propsW*ui.SCALE()), propsH)){
			var propTabHandle = Id.handle();
			if(ui.tab(propTabHandle, "Properties")){
				if(ui.panel(Id.handle({selected:true}), "Window")){
					ui.indent();
					ui.row([1/4, 3/4]);
					ui.text("Name");
					window.name = ui.textInput(Id.handle({text: window.name}), Right);
					ui.row([1/4, 3/4]);
					ui.text("Width");
					window.width = Std.parseInt(ui.textInput(Id.handle({text: window.width+""}), Right));
					ui.row([1/4, 3/4]);
					ui.text("Height");
					window.height = Std.parseInt(ui.textInput(Id.handle({text: window.height+""}), Right));
					ui.row([1/4, 3/4]);
					ui.text("Mode");
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
						ui.row([2/6, 4/6]);
						ui.text("Name");
						obj.name = ui.textInput(Id.handle().nest(id, {text: obj.name}), Right);

						ui.row([2/6, 4/6]);
						ui.text("X");
						var handlex = Id.handle().nest(id, {text: obj.x + ""});
						handlex.text = obj.x + "";
						var strx = ui.textInput(handlex, Right);
						obj.x = Std.parseFloat(strx);

						ui.row([2/6, 4/6]);
						ui.text("Y");
						var handley = Id.handle().nest(id, {text: obj.y + ""});
						handley.text = obj.y + "";
						var stry = ui.textInput(handley, Right);
						obj.y = Std.parseFloat(stry);

						ui.row([2/6, 4/6]);
						ui.text("Width");
						var handlew = Id.handle().nest(id, {text: obj.width + ""});
						handlew.text = obj.width + "";
						var strw = ui.textInput(handlew, Right);
						obj.width = Std.int(Std.parseFloat(strw));

						ui.row([2/6, 4/6]);
						ui.text("Height");
						var handleh = Id.handle().nest(id, {text: obj.height + ""});
						handleh.text = obj.height + "";
						var strh = ui.textInput(handleh, Right);
						obj.height = Std.int(Std.parseFloat(strh));

						ui.row([2/6, 4/6]);
						ui.text("Rotation");
						var handlerot = Id.handle().nest(id, {value: util.Math.roundPrecision(util.Math.toDegrees(obj.rotation == null ? 0 : obj.rotation), 2)});
						handlerot.value = util.Math.roundPrecision(util.Math.toDegrees(obj.rotation), 2);
						if (handlerot.value >= 360) handlerot.value = 0;
						obj.rotation = util.Math.toRadians(ui.slider(handlerot, "", 0.0, 360.0));
						ui.unindent();
					}
				}
			}
			if(ui.tab(propTabHandle, "Editor")){
				if(ui.panel(Id.handle(), "Grid")){
					ui.indent();
						gridSize = Std.parseInt(ui.textInput(Id.handle({text:gridSize+""}), "Size", Right));
						gridSnapPos = ui.check(Id.handle({selected:true}), "Snap Pos");
						gridSnapBounds = ui.check(Id.handle({selected:false}), "Snap Bounds");
						gridUseRelative = ui.check(Id.handle({selected:true}), "Use Relative");
					ui.unindent();
				}
				if(ui.panel(Id.handle(), "Rotation")){
					ui.indent();
						useRotationSteps = ui.check(Id.handle({selected:true}), "Use Steps");
						if(useRotationSteps) rotationSteps = Std.parseInt(ui.textInput(Id.handle({text:rotationSteps+""}), "Steps", Right));
					ui.unindent();
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
				ui.row([3/5, 2/5]);
				ui.textInput(Id.handle(), "Search", Right);
				if(ui.button("Import")){
					var isImage = StringTools.endsWith(assetPath, ".jpg") ||
					  StringTools.endsWith(assetPath, ".png") ||
					  StringTools.endsWith(assetPath, ".hdr");
					var isFont = StringTools.endsWith(assetPath, ".ttf");
					var isSound = StringTools.endsWith(assetPath, ".ogg");

					if(isImage) std.Assets.loadImage(assetPath);
					else if(isFont) std.Assets.loadFont(assetPath);
					else if(isSound) std.Assets.loadSound(assetPath);
					else std.Assets.loadBlob(assetPath);
				}
				assetPath = Ext.fileBrowser(ui, Id.handle({text:filePath}));
			}
		}
		if(ui.window(Id.handle(), fileW, sceneH, kha.System.windowWidth()-propsW-fileW, kha.System.windowHeight()-sceneH-20)){
			var assetTabH = Id.handle();
			if(ui.tab(assetTabH, "Assets")){
				ui.row([9/10, 1/10]);
				ui.textInput(Id.handle(), "Search", Right);
				ui.button("Enter");
				for (image in std.Assets.images) for (name => value in image){
					ui.row([1/5, 4/5]);
					var state = ui.image(value, 0xffffffff, 50, 0, 0, value.width, value.height);
					ui.text(name, Center);
					if(state == 2) selectedImage = name;
					ui._y += Std.int(value.height/50*ui.SCALE()+10);
				}
				// for (image in std.Assets.fonts) for (name => value in image) ui.text(name);
				// for (sound in std.Assets.sounds) for (name => value in sound) ui.text(name);
				// for (blob in std.Assets.blobs) for (name => value in blob) ui.text(name);
			}
			if(ui.tab(assetTabH, "Terminal")){}
		}
		ui.end();

		g.begin(false);
		if (selectedImage != null) {
			var w = Math.min(128, std.Assets.getImage(selectedImage).width);
			var ratio = w / std.Assets.getImage(selectedImage).width;
			var h = std.Assets.getImage(selectedImage).height * ratio;
			g.drawScaledImage(std.Assets.getImage(selectedImage), ui.inputX, ui.inputY, w, h);
		}
		g.end();

		if (ui.changed && !ui.inputDown) {
			drawGrid();
		}

		if (lastW > 0 && (lastW != kha.System.windowWidth() || lastH != kha.System.windowHeight())) {
			resize();
		}
		lastW = kha.System.windowWidth();
		lastH = kha.System.windowHeight();

		// if(showObjectList) renderObjectList(g);
	}

	public function update() {
		if(ui == null)return;

		if(ui.inputReleased && selectedImage != null){
			if (selectedObj!=null && util.Math.hitbox(ui, coffX + selectedObj.x, coffY + selectedObj.y, selectedObj.width, selectedObj.height, selectedObj.rotation)) {
				selectedObj.spriteRef = selectedImage;
			}
			selectedImage = null;
		}
		// if(ui.inputReleased) selectedImage = null;

		if(selectedObj!=null) propwin.redraws = 2;

		if(!editorLocked && !ObjectController.isManipulating && ui.inputDownR) {
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

	// function renderObjectList(g:Graphics) {
	// 	var x = Std.int(addbtnX);
	// 	var y = Std.int(addbtnY);
	// 	var width = 150;
	// 	var height = 200;

	// 	g.begin(false);
	// 	var col = g.color;
	// 	g.color = 0xff202020;
	// 	g.fillRect(x-5, y+5, width+10, height+3);
	// 	g.color = 0xff353535;
	// 	g.fillRect(x, y, width+10, height);
	// 	g.color = col;
	// 	uimodal.beginRegion(g, x+5, y+5, width);
	// 	if (uimodal.button("OK")) {
	// 	}
	// 	uimodal.endRegion(false);

	// 	g.end();
	// }

	static var elemId = -1;
	public static function getObjectId(scene: SceneData): Int {
		if (elemId == -1) for (e in scene.objects) if (elemId < e.id) elemId = e.id;
		return ++elemId;
	}

	function moveObjectInList(d:Int) {
		var ar = scene.objects;
		var i = ar.indexOf(selectedObj);

		while (true) {
			i += d;
			if (i < 0 || i >= ar.length) break;
			ar.remove(selectedObj);
			ar.insert(i, selectedObj);
			break;
		}
	}
}
