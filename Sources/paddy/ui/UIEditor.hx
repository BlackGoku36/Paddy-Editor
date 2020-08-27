package paddy.ui;

// Zui
import zui.Ext;
import paddy.files.Export;
import zui.Id;
import zui.Zui;

enum EditorMode {
	Game;
}

class UIEditor {

	@:isVar public static var editorX(get, set):Int;
	static function get_editorX() {
		return UIOutliner.outlinerW;
	}
	static function set_editorX(x):Int{
		return editorX = x;
	}

	@:isVar public static var editorY(get, set):Int;
	static function get_editorY() {
		return 30;
	}
	static function set_editorY(x):Int{
		return editorY = x;
	}

	public static var editorW(get, null):Int;
	static function get_editorW() {
		return Std.int(kha.System.windowWidth() * 0.6);
	}

	public static var editorH(get, null):Int;
	static function get_editorH() {
		return 60;
	}

	public static var editorLocked:Bool = false;

	public static var editorMode = Game;

	public static var editorHandle = Id.handle();
	public static var editorTabH = Id.handle();

	public static var modeHandle = Id.handle();
	public static var buildOptions = ["Build"];
	public static var buildMode = 0;
	public static var modeComboHandle = Id.handle({position: 0});

	public static function render(ui: Zui){
		if(ui.window(editorHandle, editorX, Std.int(UIMenu.menuHeight*ui.SCALE()), editorW, Std.int(editorH*ui.SCALE()))){
			ui.g.color = ui.t.WINDOW_BG_COL;
			ui.g.fillRect(0, 0, kha.System.windowWidth(), kha.System.windowHeight());
			if(ui.tab(editorTabH, "Game")){
				editorMode = Game;
				ui.row([1/8, 1/8, 1/8, 1/8, 1/8, 1/8, 1/8, 1/8]);
				ui.text("Editor");
				editorLocked = ui.check(Id.handle({selected:false}), "Lock");
				if(ui.button("Reset Pos")){
					App.coffX = editorX + 20;
					App.coffY = UIMenu.menuHeight*ui.SCALE()+editorH*ui.SCALE()+20;
				}
				ui.text("");
				ui.text("");
				ui.text("");
				if(ui.button("=>")){
					if(buildMode == 0){
						if(App.projectPath == ""){
							UIStatusBar.warn("Oopsie!, You need to save the project first!");
						}else{
							Export.exportScene(App.projectPath);
							Export.exportWindow(App.projectPath);
						}
					}else{
						for (plug in Plugin.plugins) plug.executeRunUI();
					}
				}
				ui.combo(modeComboHandle, buildOptions, Right);
				if (modeComboHandle.changed) buildMode = modeComboHandle.position;
			}
		}
	}
}
