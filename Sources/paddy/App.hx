package paddy;

import zui.Ext;
// import kha.Assets;
import zui.Id;
import zui.Zui;
import kha.Framebuffer;

import paddy.ui.UIAssets;
import paddy.ui.UIProperties;
import paddy.data.Data;
import paddy.export.Export;

import paddy.Assets;

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
	public static var htab = Id.handle({position: 0});
	public static var editorHandle = Id.handle();
	public static var selectedObj:ObjectData = null;
	// static var showObjectList = false;

	public static var window: WindowData = {
		name: "Window",
		width: 1440,
		height: 900,
		windowMode: 0,
		clearColor: [0, 0, 0, 255]
	}

	public static var scene: SceneData = {
		name: "scene",
		objects: []
	}

	static var assetPath = "";
	public static var selectedImage = null;

	public function new() {
		kha.Assets.loadEverything(function (){
			ui = new Zui({font: kha.Assets.fonts.hn});
			uimodal = new Zui({font: kha.Assets.fonts.hn});
			paddy.ObjectController.ui = ui;
			// Plugins.run();
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
			var sprite = Assets.getImage(object.spriteRef);
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
					Export.exportScene();
					Export.exportWindow();
				}
			}
			var mode = Id.handle({position: 0});
			ui.combo(Id.handle({position: 0}), ["Build", "Play"], Right);
			if (mode.changed) buildMode = mode.position;
		}
		if(ui.window(sceneHandle, 0, 30, Std.int(sceneW*ui.SCALE()), sceneH)){
			if(ui.tab(htab, "Scene")){
				ui.row([3/4, 1/4]);
				ui.textInput(Id.handle(), "Search");
				if(ui.button("+")){
					// addbtnX = ui._x+(sceneW*3/4);
					// addbtnY = ui._y+ui.buttonOffsetY+ui.BUTTON_H()+5;
					// showObjectList = true;
					var object: ObjectData = {
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
						if(ui.button("X")){
							scene.objects.remove(objData);
							selectedObj = null;
						}
					}
					ui._x -= 18;
				}
				for (i in 0...scene.objects.length) {
					var objData = scene.objects[scene.objects.length - 1 - i];
					drawList(Id.handle(), objData);
				}
			}

			for (value in paddy.Plugin.plugins) if (value.sceneWinUI != null) value.sceneWinUI(ui);

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

		UIProperties.render(ui, propwin, kha.System.windowWidth()-propsW, 30, Std.int(propsW*ui.SCALE()), propsH);

		if(ui.window(Id.handle(), 0, sceneH, fileW, kha.System.windowHeight()-sceneH-20)){
			if(ui.tab(Id.handle(), "File Browser")){
				ui.row([3/5, 2/5]);
				ui.textInput(Id.handle(), "Search", Right);
				if(ui.button("Import")){
					var isImage = StringTools.endsWith(assetPath, ".jpg") ||
					  StringTools.endsWith(assetPath, ".png") ||
					  StringTools.endsWith(assetPath, ".hdr");
					var isFont = StringTools.endsWith(assetPath, ".ttf");
					var isSound = StringTools.endsWith(assetPath, ".ogg");

					if(isImage) Assets.loadImage(assetPath);
					else if(isFont) Assets.loadFont(assetPath);
					else if(isSound) Assets.loadSound(assetPath);
					else Assets.loadBlob(assetPath);
				}
				assetPath = Ext.fileBrowser(ui, Id.handle({text:""}));
			}
		}
		UIAssets.render(ui, fileW, sceneH, kha.System.windowWidth()-propsW-fileW, kha.System.windowHeight()-sceneH-20);

		ui.end();

		g.begin(false);
		if (selectedImage != null) {
			var w = Math.min(128, Assets.getImage(selectedImage).width);
			var ratio = w / Assets.getImage(selectedImage).width;
			var h = Assets.getImage(selectedImage).height * ratio;
			g.drawScaledImage(Assets.getImage(selectedImage), ui.inputX, ui.inputY, w, h);
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
			if (selectedObj!=null && paddy.util.Math.hitbox(ui, coffX + selectedObj.x, coffY + selectedObj.y, selectedObj.width, selectedObj.height, selectedObj.rotation)) {
				selectedObj.spriteRef = selectedImage;
			}
			selectedImage = null;
		}

		if(selectedObj!=null) propwin.redraws = 2;

		if(!editorLocked && !ObjectController.isManipulating && ui.inputDownR) {
			coffX += Std.int(ui.inputDX);
			coffY += Std.int(ui.inputDY);
		}

		ObjectController.update();

		if (ui.inputStartedR && ui.inputDownR) {
			for (object in scene.objects) {
				if (paddy.util.Math.hitbox(ui, coffX + object.x, coffY + object.y, object.width, object.height, object.rotation) &&
						selectedObj != object) {
					selectedObj = object;
					sceneHandle.redraws = 2;
					break;
				}
			}
		}

		for (value in paddy.Plugin.plugins) if(value.update != null) value.update();
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
