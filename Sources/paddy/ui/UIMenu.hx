package paddy.ui;

import paddy.files.Export;
import paddy.files.Imports;
import zui.Zui;
import zui.Id;
import zui.Ext;

enum MenuType {
	File;
	Editor;
}

@:access(zui.Zui)
class UIMenu {

	static var modalW = 655;
	static var modalH = 550;
	static var modalHeaderH = 66;
	static var modalRectW = 625; // No shadow
	static var modalRectH = 545;

	public static var onDone: String->Void = null;

	static var path = "/";

	public static var menu:MenuType = null;

	public static var outx = 0;
	public static var outy = 0;
	public static var outw = 0;
	public static var outh = 0;

	public static function render(ui:Zui, g:kha.graphics2.Graphics) {
		var appw = kha.System.windowWidth();
		var apph = kha.System.windowHeight();
		var menuWidth = 600;

		ui.begin(g);
		if (ui.window(Id.handle(), 3, 5, menuWidth, 25)) {
			ui.row([1/10, 1/10]);
			if (ui.button("File")) {
				menu = File;
			}
			ui.button("Editor");
		}
		if(ui.inputStarted) menu == null;
		ui.end(false);

		if(menu == File){
			g.begin(false);

			g.color = 0xff202020;
			g.fillRect(3, 30, 120, 100);
			outx = 3; outy = 30; outw = 120; outh = 100;

			g.end();

			ui.beginRegion(g, 5, 32, 116);
	
			if (ui.button("New")) {
				if(App.projectPath!="") App.projectPath = "";
				App.paddydata = { name: "", window: "", scene: "" }
				App.scene = { name: "scene", objects: [], assets: {
					images: paddy.Assets.imagesPaths,
					fonts:  paddy.Assets.fontsPaths,
					sounds: paddy.Assets.soundsPaths,
					blobs:  paddy.Assets.blobsPaths}}
				App.window = { name: "Window", width: 1440, height: 900, windowMode: 0, clearColor: [0, 0, 0, 255] }
				Assets.images.resize(0);
				Assets.imagesPaths.resize(0);
				Assets.fonts.resize(0);
				Assets.fontsPaths.resize(0);
				Assets.sounds.resize(0);
				Assets.soundsPaths.resize(0);
				Assets.blobs.resize(0);
				Assets.blobsPaths.resize(0);
			}

			if(ui.button("Open")){
				App.showFileBrowser = true;
				paddy.ui.UIFileBrowser.onDone = function(path){
					Imports.importPaddy(path);
				}
			}

			if(ui.button("Save")){
				if(App.projectPath!="") Export.exportPaddy(App.projectPath);
				else{
					App.showFileBrowser = true;
					paddy.ui.UIFileBrowser.onDone = function(path){
						Export.exportPaddy(path);
					}
				}
			}

			ui.endRegion(false);
		}
	}
}
