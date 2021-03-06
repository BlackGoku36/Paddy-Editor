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

	public static var onDone: String->Void = null;

	static var path = "/";

	public static var menu:MenuType = null;

	public static var x = 5;
	public static var y = 50;
	public static var w = 200;
	public static var h = 200;

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

			ui.begin(g);
			if(ui.window(Id.handle(), x, y, w, h)){

				g.color = 0xff202020;
				ui.g.fillRect(x, y, w, h);

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
			}

			ui.end();
		}
	}
}
