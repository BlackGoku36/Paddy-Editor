package paddy.ui;

// Zui
import kha.System;
import zui.Zui;
import zui.Id;
import zui.Ext;

// Editor
import paddy.files.Export;
import paddy.files.Imports;

enum MenuType {
	File;
}

@:access(zui.Zui)
class UIMenu {

	static var modalW = 655;
	static var modalH = 550;
	static var modalHeaderH = 66;
	static var modalRectW = 625;
	static var modalRectH = 545;

	public static var onDone: String->Void = null;

	static var path = "/";

	public static var menu:MenuType = null;

	public static var outx = 0;
	public static var outy = 0;
	public static var outw = 0;
	public static var outh = 0;
	public static var menuWidth(get, null):Int;
	static function get_menuWidth() {
		return System.windowWidth();
	}
	public static var menuHeight(get, null):Int;
	static function get_menuHeight() {
		return 25;
	}

	public static function render(ui:Zui, g:kha.graphics2.Graphics) {

		ui.begin(g);
		if (ui.window(Id.handle(), 3, 5, menuWidth, Std.int(menuHeight*ui.SCALE()))) {
			ui.g.color = ui.t.WINDOW_BG_COL;
			ui.g.fillRect(3, 5, menuWidth, menuHeight);
			ui.row([1/15, 1/15]);
			if (ui.button("File")) menu = File;
			if (ui.button("Preference")) UIPreference.show = true;
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
				App.paddydata = { name: "", window: "", scene: ""}
				App.scene = { name: "scene", objects: [], assets: []}
				App.window = { name: "Window", width: 1440, height: 900, windowMode: 0, clearColor: [0, 0, 0, 255] }
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
