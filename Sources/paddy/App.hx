package paddy;

// Kha
import paddy.ui.UIStatusBar;
import kha.Color;
import kha.Framebuffer;

// Zui
import zui.Ext;
import zui.Id;
import zui.Zui;

// Editor
import paddy.data.Data;
import paddy.ui.UIMenu;
import paddy.ui.UIAssets;
import paddy.ui.UIEditor;
import paddy.files.Export;
import paddy.ui.UIOutliner;
import paddy.ui.UIProperties;
import paddy.ui.UIPreference;

@:access(zui.Zui)
class App {

	public static var version = "2020.1.0";
	public static var ui:Zui;
	public static var uimodal:Zui;
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

	public static var fileBrowserW(get, null):Int;
	static function get_fileBrowserW() {
		return Std.int(kha.System.windowWidth()*0.2);
	}
	public static var fileBrowserH(get, null):Int;
	static function get_fileBrowserH() {
		return Std.int((kha.System.windowHeight()*0.3));
	}

	public static var assetsWinH = Id.handle();
	public static var selectedObj:ObjectData = null;

	public static var configData: ConfigData = {
		plugins: [],
		uiScale: 1.0
	}

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
		assets: [],
		scripts: []
	}

	static var assetPath = "";

	public static var assetHandle = Id.handle();
	public static var showFileBrowser = false;
	public static var fileBrowserPath = "";

	public static var selectedImage = null;

	public function new() {
		// kha.Assets.loadEverything(function (){
			kha.Assets.loadFontFromPath("mainfont.ttf", (font)->{

				ui = new Zui({font: font, scaleFactor: 1.7});
				uimodal = new Zui({font: font, scaleFactor:1.7});
				paddy.Paddy.changeTheme(ui, paddy.data.Themes.darkTheme);
				paddy.Paddy.changeTheme(uimodal, paddy.data.Themes.darkTheme);
				paddy.ObjectController.ui = ui;
				UIEditor.editorX = kha.System.windowWidth() - UIEditor.editorW - UIProperties.propsW;
				UIEditor.editorY = 60;
				coffX = UIEditor.editorX + 20;
				coffY = UIMenu.menuHeight*ui.SCALE()+UIEditor.editorH*ui.SCALE()+20;
			});
		// });
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
		if(ui == null) return;
		if(grid == null) drawGrid();

		var g = frame[0].g2;

		g.begin();
		// Draw grid
		if(UIEditor.editorMode == Game){
			g.drawImage(grid, coffX % 40 - 40, coffY % 40 - 40);
			g.drawRect(coffX, coffY, window.width, window.height);

			for (object in scene.objects){
				var sprite = Assets.getAsset(object.spriteRef, Image);
				// var sprite = Assets.getImage(object.spriteRef);
				if(sprite != null && object.visible) {
					g.pushRotation(object.rotation, coffX + object.x, coffY + object.y);
					if(object.animate) g.drawScaledSubImage(sprite, 0  % sprite.width, 0, object.width, object.height, coffX + object.x, coffY + object.y, object.width, object.height);
					else g.drawScaledImage(sprite, coffX + object.x, coffY + object.y, object.width, object.height);
					g.popTransformation();
				}
			}

			ObjectController.render(g);

		}

		var col = g.color;
		g.color = 0xff323232;
		g.fillRect(0, 30, UIOutliner.outlinerW, UIOutliner.outlinerH);
		g.fillRect(kha.System.windowWidth()-UIProperties.propsW, 30, UIProperties.propsW, kha.System.windowHeight());
		g.fillRect(fileBrowserW, UIOutliner.outlinerH, kha.System.windowWidth()-UIProperties.propsW-fileBrowserW, kha.System.windowHeight()-UIOutliner.outlinerH);
		g.fillRect(0, UIOutliner.outlinerH, fileBrowserW, kha.System.windowHeight()-UIOutliner.outlinerH);
		g.fillRect(0, 0, kha.System.windowWidth(), 30);
		g.color = col;
		g.end();

		ui.begin(g);

		UIOutliner.render(ui);

		UIEditor.render(ui);

		UIProperties.render(ui);

		UIStatusBar.render(ui);

		if(ui.window(assetsWinH, 0, UIOutliner.outlinerH, fileBrowserW, fileBrowserH-Std.int(UIStatusBar.barHeight*ui.SCALE()))){
			ui.g.color = ui.t.WINDOW_BG_COL;
			ui.g.fillRect(0, 0, kha.System.windowWidth(), kha.System.windowHeight());
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

					if(isImage) Assets.loadAssetFromPath(assetPath, Image);
					else if(isFont) Assets.loadAssetFromPath(assetPath, Font);
					else if(isSound) Assets.loadAssetFromPath(assetPath, Sound);
					else Assets.loadAssetFromPath(assetPath, Blob);
				}
				assetPath = Ext.fileBrowser(ui, assetHandle);
			}
		}

		UIAssets.render(ui);

		ui.end();

		g.begin(false);
		if (selectedImage != null) {
			var img = Assets.getAsset(selectedImage, Image);
			var w = Math.min(128, img.width);
			var ratio = w / img.width;
			var h = img.height * ratio;
			g.drawScaledImage(img, ui.inputX, ui.inputY, w, h);
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
		if(UIPreference.show) paddy.ui.UIPreference.render(uimodal, g);
	}

	public function update() {
		if(ui == null)return;

		if(ui.inputStarted && !paddy.util.Math.hitbox(ui, UIMenu.x, UIMenu.y, UIMenu.w, UIMenu.h, 0)){
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
