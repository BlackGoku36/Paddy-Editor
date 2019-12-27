package paddy.ui;

// Zui
import zui.Id;
import zui.Zui;

class UIEditor {

	public static var editorX = 0;
	public static var editorY = 0;
	public static var editorW = 300;
	public static var editorH = 600;

	public static var editorLocked:Bool = false;

	public static var editorMode = 0;

	public static var editorHandle = Id.handle();
	public static var editorTabH = Id.handle();

	public static function render(ui: Zui){
		if(ui.window(editorHandle, UIOutliner.outlinerW, 30, kha.System.windowWidth()-UIProperties.propsW-UIOutliner.outlinerW, editorH)){
			if(ui.tab(editorTabH, "2D")){
				editorMode = 0;
				ui.row([1/20, 1/15, 1/10]);
				ui.text("Editor");
				editorLocked = ui.check(Id.handle({selected:false}), "Lock");
				if(ui.button("Reset Pos")){
					App.coffX = 220.0;
					App.coffY = 110.0;
				}
			}
			if(ui.tab(editorTabH, "Nodes")){
				editorMode = 1;
				paddy.ui.UINodes.renderNodes(ui);
			}
		}
	}
}
