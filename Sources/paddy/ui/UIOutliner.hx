package paddy.ui;

import zui.Nodes;
import zui.Id;
import zui.Zui;

import paddy.data.Data;

@:access(zui.Zui)
class UIOutliner {

    public static var outlinerW = 200; 
    public static var outlinerH = 600;
    public static var outlinerHandle = Id.handle();
    public static var outlinerTab = Id.handle({position: 0});
    
    public static function render(ui: Zui) {

        if(ui.window(outlinerHandle, 0, 30, Std.int(outlinerW*ui.SCALE()), outlinerH)){
			if(ui.tab(outlinerTab, "Scene")){
				ui.row([3/4, 1/4]);
				ui.textInput(Id.handle(), "Search");
				if(ui.button("+")){
					var object: ObjectData = {
						id: getObjectId(App.scene),
						name: "object"+getObjectId(App.scene),
						x: 0, y: 0,
						width: 100, height: 100,
						rotation: 0,
						isSprite: false,
						scripts: []
					}
					App.scene.objects.push(object);
					App.selectedObj = object;
				}
				function drawList(h:zui.Zui.Handle, objData:ObjectData) {
					if (App.selectedObj == objData) {
						ui.g.color = 0xff205d9c;
						ui.g.fillRect(0, ui._y-2, ui._windowW, ui.t.ELEMENT_H+4);
						ui.g.color = 0xffffffff;
					}
					var started = ui.getStarted();
					// Select
					if (started && !ui.inputDownR) {
						App.selectedObj = objData;
					}
					ui._x += 18; // Sign offset
					ui.row([1/7, 1/3, 1/7, 1/7, 1/7]);
					if(objData!=null){
						objData.visible = ui.check(Id.handle().nest(objData.id, {selected: true}), "");
						ui.text(objData.name);
						if(ui.button("<")) moveObjectInList(1);
						if(ui.button(">")) moveObjectInList(-1);
						if(ui.button("X")){
							App.scene.objects.remove(objData);
							App.selectedObj = null;
						}
					}
					ui._x -= 18;
				}
				for (i in 0...App.scene.objects.length) {
					var objData = App.scene.objects[App.scene.objects.length - 1 - i];
					drawList(Id.handle(), objData);
				}
			}

			if(ui.tab(outlinerTab, "Nodes")){
				ui.row([3/4, 1/4]);
				var nodeName = ui.textInput(Id.handle({text: "NodeGroup"}), "Name");
				if(ui.button("+")){
					var nData = {
						name: nodeName,
						nodes: new Nodes(),
						nodeCanvas: {
							name: "My Nodes",
							nodes: [],
							links: []
						}
					}
					UINodes.nodesArray.push(nData);
					UINodes.selectedNode = nData;
				}

				function drawList(h:zui.Zui.Handle, nodeData:NodeData) {
					if (UINodes.selectedNode == nodeData) {
						ui.g.color = 0xff205d9c;
						ui.g.fillRect(0, ui._y-2, ui._windowW, ui.t.ELEMENT_H+4);
						ui.g.color = 0xffffffff;
					}
					var started = ui.getStarted();
					// Select
					if (started && !ui.inputDownR) {
						UINodes.selectedNode = nodeData;
					}
					ui._x += 18; // Sign offset
					if(nodeData!=null){
						ui.row([3/5, 1/5]);
						ui.text(nodeData.name);
						if(ui.button("X")){
							UINodes.nodesArray.remove(nodeData);
							UINodes.selectedNode = null;
						}
					}
					ui._x -= 18;
				}
				for (i in 0...UINodes.nodesArray.length) {
					var nodeData = UINodes.nodesArray[UINodes.nodesArray.length - 1 - i];
					drawList(Id.handle(), nodeData);
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