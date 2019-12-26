package paddy;

import paddy.ui.UIOutliner;
import paddy.ui.UINodes;
import paddy.ui.UIMenu;
import paddy.ui.UIEditor;
import zui.Ext;
import zui.Id;
import zui.Zui;
import kha.Framebuffer;

import paddy.ui.UIAssets;
import paddy.ui.UIProperties;
import paddy.data.Data;
import paddy.files.Export;

@:access(zui.Zui)
class App {

	var ui:Zui;
	var uimodal:Zui;
	var objects:Array<String> = [];
	var at = 0;

	public static var projectPath:String = "";

	var ww = kha.System.windowWidth();
	var wh = kha.System.windowHeight();

	var lastW = 0;
	var lastH = 0;

	public static var coffX = 220.0;
	public static var coffY = 110.0;

	public static var grid:kha.Image = null;
	public static var gridSize:Int = 20;
	public static var gridSnapBounds:Bool = false;
	public static var gridSnapPos:Bool = true;
	public static var gridUseRelative:Bool = true;
	public static var useRotationSteps:Bool = false;
	public static var rotationSteps:Int = 15;

	var assetW = 500; var assetH = 100;
	public static var fileW = 200;
	public static var fileH = 100;

	public static var assetsWinH = Id.handle();
	public static var selectedObj:ObjectData = null;

	public static var paddydata: paddy.Paddy.PaddyData = {
		name: "",
		window: "",
		scene: "",
	}

	public static var window: WindowData = {
		name: "Window",
		width: 1440,
		height: 900,
		windowMode: 0,
		clearColor: [0, 0, 0, 255]
	}

	public static var scene: SceneData = {
		name: "scene",
		objects: [],
		assets: {
			images: paddy.Assets.imagesPaths,
			fonts:  paddy.Assets.fontsPaths,
			sounds: paddy.Assets.soundsPaths,
			blobs:  paddy.Assets.blobsPaths
		},
		scripts: []
	}

	static var assetPath = "";

	public static var assetHandle = Id.handle();
	public static var showFileBrowser = false;
	public static var fileBrowserPath = "";

	public static var selectedImage = null;

	public static var modeHandle = Id.handle();
	public static var buildOptions = ["Build"];
	public static var buildMode = 0;
	public static var modeComboHandle = Id.handle({position: 0});

	public function new() {
		kha.Assets.loadEverything(function (){
			ui = new Zui({font: kha.Assets.fonts.mainfont, theme: paddy.data.Themes.dark});
			uimodal = new Zui({font: kha.Assets.fonts.mainfont, theme: paddy.data.Themes.dark});
			paddy.ObjectController.ui = ui;
		});
		UIEditor.editorX = kha.System.windowWidth() - UIEditor.editorW - UIProperties.propsW;
		UIEditor.editorY = 60;
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
		grid.g2.color = 0xff202020;
		grid.g2.fillRect(0, 0, w, h);
		for (i in 0...Std.int(h / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(0, i * doubleGridSize, w, i * doubleGridSize, 2);
			grid.g2.color = 0xff323232;
			grid.g2.drawLine(0, i * doubleGridSize + gridSize, w, i * doubleGridSize + gridSize);
		}
		for (i in 0...Std.int(w / doubleGridSize) + 1) {
			grid.g2.color = 0xff282828;
			grid.g2.drawLine(i * doubleGridSize, 0, i * doubleGridSize, h, 2);
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
		if(UIEditor.editorMode == 0) g.drawImage(grid, coffX % 40 - 40, coffY % 40 - 40);
		else {
			var nodePanX = 0.0;
			var nodePanY = 0.0;
			if(UINodes.selectedNode != null) {
				nodePanX = UINodes.selectedNode.nodes.panX * UINodes.selectedNode.nodes.SCALE() % 40 - 40;
				nodePanY = UINodes.selectedNode.nodes.panY * UINodes.selectedNode.nodes.SCALE() % 40 - 40;
			}
			g.drawImage(grid, nodePanX, nodePanY);
		}

		if(UIEditor.editorMode == 0){
			// Draw window in editor
			g.drawRect(coffX, coffY, window.width/2, window.height/2);

			for (object in scene.objects){
				var sprite = Assets.getImage(object.spriteRef);
				if(sprite != null && object.visible) {
					g.pushRotation(object.rotation, coffX + object.x+(object.width/4), coffY + object.y+(object.height/4));
					g.drawScaledImage(sprite, coffX + object.x, coffY + object.y, object.width/2, object.height/2);
					g.popTransformation();
				}
			}

			ObjectController.render(g);
		}

		var col = g.color;
		g.color = 0xff323232;
		g.fillRect(0, 30, UIOutliner.outlinerW, UIOutliner.outlinerH);
		g.fillRect(kha.System.windowWidth()-UIProperties.propsW, 30, UIProperties.propsW, kha.System.windowHeight());
		g.fillRect(fileW, UIOutliner.outlinerH, kha.System.windowWidth()-UIProperties.propsW-fileW, kha.System.windowHeight()-UIOutliner.outlinerH-20);
		g.fillRect(0, UIOutliner.outlinerH, fileW, kha.System.windowHeight()-UIOutliner.outlinerH-20);
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
				}else{
					for (plug in Plugin.plugins) plug.executeRunUI();
				}
			}
			ui.combo(modeComboHandle, buildOptions, Right);
			if (modeComboHandle.changed) buildMode = modeComboHandle.position;
		}

		UIOutliner.render(ui);

		UIEditor.render(ui);

		UIProperties.render(ui);

		if(ui.window(assetsWinH, 0, UIOutliner.outlinerH, fileW, kha.System.windowHeight()-UIOutliner.outlinerH-20)){
			if(ui.tab(Id.handle(), "File Browser")){
				ui.row([3/5, 2/5]);
				if(ui.button("Open Browser")){
					showFileBrowser = true;
					paddy.ui.UIFileBrowser.onDone = function(path){
						assetHandle.text = fileBrowserPath;
					}
				}
				if(ui.button("Import")){
					var isImage = StringTools.endsWith(assetPath, ".jpg") ||
					  StringTools.endsWith(assetPath, ".png");
					var isFont = StringTools.endsWith(assetPath, ".ttf");
					var isSound = StringTools.endsWith(assetPath, ".ogg");

					if(isImage) Assets.loadImage(assetPath);
					else if(isFont) Assets.loadFont(assetPath);
					else if(isSound) Assets.loadSound(assetPath);
					else Assets.loadBlob(assetPath);
				}
				assetPath = Ext.fileBrowser(ui, assetHandle);
			}
		}

		UIAssets.render(ui);

		if(UIEditor.editorMode == 1) UINodes.renderNodesMenu(ui);

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

		if(showFileBrowser) paddy.ui.UIFileBrowser.render(uimodal, g);
		paddy.ui.UIMenu.render(uimodal, g);
	}

	public function update() {
		if(ui == null)return;

		if(ui.inputStarted && !paddy.util.Math.hitbox(ui, UIMenu.outx, UIMenu.outy, UIMenu.outw, UIMenu.outh, 0)){
			if(UIMenu.menu != null) UIMenu.menu = null;
		}

		if(ui.inputReleased && selectedImage != null){
			if (selectedObj!=null && paddy.util.Math.hitbox(ui, coffX + selectedObj.x, coffY + selectedObj.y, selectedObj.width, selectedObj.height, selectedObj.rotation)) {
				selectedObj.spriteRef = selectedImage;
			}
			selectedImage = null;
		}

		if(selectedObj!=null) UIProperties.propsHandle.redraws = 2;

		if(!UIEditor.editorLocked && !ObjectController.isManipulating && ui.inputDownR) {
			coffX += Std.int(ui.inputDX);
			coffY += Std.int(ui.inputDY);
		}

		ObjectController.update();

		if (ui.inputStartedR && ui.inputDownR) {
			for (object in scene.objects) {
				if (paddy.util.Math.hitbox(ui, coffX + object.x, coffY + object.y, object.width, object.height, object.rotation) &&
						selectedObj != object) {
					selectedObj = object;
					UIOutliner.outlinerHandle.redraws = 2;
					break;
				}
			}
		}

		for (value in paddy.Plugin.plugins) if(value.update != null) value.update();
	}
}
