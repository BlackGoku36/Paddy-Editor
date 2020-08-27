package paddy.ui;

// Zui
import kha.Color;
import zui.Id;
import zui.Zui;

// Editor
import paddy.data.Data;

@:access(zui.Zui)
class UIOutliner {

	public static var outlinerW(get, null):Int;
	static function get_outlinerW() {
		return Std.int(kha.System.windowWidth()*0.2);
	}
	public static var outlinerH(get, null):Int;
	static function get_outlinerH() {
		return Std.int(kha.System.windowHeight()*0.7);
	}
    public static var outlinerHandle = Id.handle();
    public static var outlinerTab = Id.handle({position: 0});
    
    public static function render(ui: Zui) {

        if(ui.window(outlinerHandle, 0, Std.int(UIMenu.menuHeight*ui.SCALE()), outlinerW, outlinerH-Std.int(UIMenu.menuHeight*ui.SCALE()))){
			ui.g.color = ui.t.WINDOW_BG_COL;
			ui.g.fillRect(0, 0, kha.System.windowWidth(), kha.System.windowHeight());
			if(ui.tab(outlinerTab, "Scene")){
				ui.row([3/4, 1/4]);
				var name = ui.textInput(Id.handle({text:"Object"}), "Name");
				if(ui.button("+")){
					var object: ObjectData = {
						id: getObjectId(App.scene),
						name: name,
						x: 0, y: 0,
						width: 100, height: 100,
						rotation: 0,
						animate: false,
						scripts: []
					}
					App.scene.objects.push(object);
					App.selectedObj = object;
				}
				function drawList(h:zui.Zui.Handle, objData:ObjectData) {
					var started = ui.getStarted();
					// Select
					if (started && !ui.inputDownR) {
						App.selectedObj = objData;
					}

					ui.row([1/6, 1/3, 1/6, 1/6, 1/6]);
					if(objData!=null){
						objData.visible = ui.check(Id.handle().nest(objData.id, {selected: true}), "");
						if (App.selectedObj == objData) {
							ui.text(objData.name, Left, 0xff205d9c);
						}else{
							ui.text(objData.name);
						}
						if(ui.button("Up")) moveObjectInList(1);
						if(ui.button("Down")) moveObjectInList(-1);
						if(ui.button("X")){
							App.scene.objects.remove(objData);
							App.selectedObj = null;
						}
					}
				}
				for (i in 0...App.scene.objects.length) {
					var objData = App.scene.objects[App.scene.objects.length - 1 - i];
					drawList(Id.handle(), objData);
				}
			}

			for (value in paddy.Plugin.plugins) if (value.outlinerWinUI != null) value.outlinerWinUI(ui);

		}
    }

    static var elemId = -1;
	static function getObjectId(scene: SceneData): Int {
		if (elemId == -1) for (e in scene.objects) if (elemId < e.id) elemId = e.id;
		return ++elemId;
	}

	static function moveObjectInList(d:Int) {
		var ar = App.scene.objects;
		var i = ar.indexOf(App.selectedObj);

		while (true) {
			i += d;
			if (i < 0 || i >= ar.length) break;
			ar.remove(App.selectedObj);
			ar.insert(i, App.selectedObj);
			break;
		}
	}
}