package paddy.ui;

import zui.Id;
import zui.Zui;

import paddy.data.PaddyData;
import paddy.data.Themes;

@:access(zui.Zui)
class UIProperties {

	public static var propTabHandle = Id.handle();
	public static var propPanelWinH = Id.handle({selected:true});
	public static var propPanelObjH = Id.handle({selected:true});
	public static var propPanelGridH = Id.handle({selected:true});
	public static var propPanelRotH = Id.handle({selected:true});

	public static var themesName = ["Light", "Dark"];
	public static var tthemes = [Themes.light, Themes.dark];

	public static function render(ui:Zui, idHandle:Handle, x:Int, y:Int, w:Int, h:Int) {
		var window = App.window;

		var selectedObj = App.selectedObj;

		if(ui.window(idHandle, x, y, w, h)){
			if(ui.tab(propTabHandle, "Properties")){
				if(ui.panel(propPanelWinH, "Window")){
					ui.indent();
					ui.row([1/4, 3/4]);
					ui.text("Name");
					window.name = ui.textInput(Id.handle({text: window.name}), Right);
					ui.row([1/4, 3/4]);
					ui.text("Width");
					window.width = Std.parseInt(ui.textInput(Id.handle({text: window.width+""}), Right));
					ui.row([1/4, 3/4]);
					ui.text("Height");
					window.height = Std.parseInt(ui.textInput(Id.handle({text: window.height+""}), Right));
					ui.row([1/4, 3/4]);
					ui.text("Mode");
					var windowHandle = Id.handle({position: 0});
					ui.combo(Id.handle({position: 0}), ["Windowed", "Fullscreen"], Right);
					if (windowHandle.changed) window.windowMode = windowHandle.position;

					for (value in paddy.Plugin.plugins) if (value.propWinPanelUI != null) value.propWinPanelUI(ui);

					ui.unindent();
				}
				if(selectedObj!=null){
					var obj = selectedObj;
					var id = obj.id;
					if (ui.panel(propPanelObjH, "Object")) {
						ui.indent();
						ui.row([2/6, 4/6]);
						ui.text("Name");
						obj.name = ui.textInput(Id.handle().nest(id, {text: obj.name}), Right);

						ui.row([2/6, 4/6]);
						ui.text("X");
						var handlex = Id.handle().nest(id, {text: obj.x + ""});
						handlex.text = obj.x + "";
						var strx = ui.textInput(handlex, Right);
						obj.x = Std.parseFloat(strx);

						ui.row([2/6, 4/6]);
						ui.text("Y");
						var handley = Id.handle().nest(id, {text: obj.y + ""});
						handley.text = obj.y + "";
						var stry = ui.textInput(handley, Right);
						obj.y = Std.parseFloat(stry);

						ui.row([2/6, 4/6]);
						ui.text("Width");
						var handlew = Id.handle().nest(id, {text: obj.width + ""});
						handlew.text = obj.width + "";
						var strw = ui.textInput(handlew, Right);
						obj.width = Std.int(Std.parseFloat(strw));

						ui.row([2/6, 4/6]);
						ui.text("Height");
						var handleh = Id.handle().nest(id, {text: obj.height + ""});
						handleh.text = obj.height + "";
						var strh = ui.textInput(handleh, Right);
						obj.height = Std.int(Std.parseFloat(strh));

						ui.row([2/6, 4/6]);
						ui.text("Rotation");
						var handlerot = Id.handle().nest(id, {value: paddy.util.Math.roundPrecision(paddy.util.Math.toDegrees(obj.rotation == null ? 0 : obj.rotation), 2)});
						handlerot.value = paddy.util.Math.roundPrecision(paddy.util.Math.toDegrees(obj.rotation), 2);
						if (handlerot.value >= 360) handlerot.value = 0;
						obj.rotation = paddy.util.Math.toRadians(ui.slider(handlerot, "", 0.0, 360.0));

						for (value in paddy.Plugin.plugins) if (value.propObjPanelUI != null) value.propObjPanelUI(ui);

						ui.unindent();
					}
				}
				for (value in paddy.Plugin.plugins) if (value.propTabUI != null) value.propTabUI(ui);
			}
			if(ui.tab(propTabHandle, "Editor")){
				if(ui.panel(Id.handle({selected:true}), "UI")){
					ui.indent();
						var mode = Id.handle({position: 1});
						ui.combo(mode, themesName, Right);
						if(mode.changed) PaddyData.changeTheme(ui, tthemes[mode.position]);
					ui.unindent();
				}
				if(ui.panel(propPanelGridH, "Grid")){
					ui.indent();
						App.gridSize = Std.parseInt(ui.textInput(Id.handle({text:App.gridSize+""}), "Size", Right));
						App.gridSnapPos = ui.check(Id.handle({selected:true}), "Snap Pos");
						App.gridSnapBounds = ui.check(Id.handle({selected:false}), "Snap Bounds");
						App.gridUseRelative = ui.check(Id.handle({selected:true}), "Use Relative");
						for (value in paddy.Plugin.plugins) if (value.editorGridPanelUI != null) value.editorGridPanelUI(ui);
					ui.unindent();
				}
				if(ui.panel(propPanelRotH, "Rotation")){
					ui.indent();
						App.useRotationSteps = ui.check(Id.handle({selected:true}), "Use Steps");
						if(App.useRotationSteps) App.rotationSteps = Std.parseInt(ui.textInput(Id.handle({text:App.rotationSteps+""}), "Steps", Right));
						for (value in paddy.Plugin.plugins) if (value.editorRotPanelUI != null) value.editorRotPanelUI(ui);
					ui.unindent();
				}

				for (value in paddy.Plugin.plugins) if (value.editorTabUI != null) value.editorTabUI(ui);

			}
			if(ui.tab(propTabHandle, "Plugins")){
				ui.row([3/5, 2/5]);
				var file = ui.textInput(Id.handle(), "Name");
				if(ui.button("Import") && file != ""){
					if(Plugin.plugins.exists(file)) return;
					Plugin.enable(file);
				}
				ui.row([3/5, 2/5]);
				var file2 = ui.textInput(Id.handle(), "Name");
				if(ui.button("Remove") && file2 != ""){
					if(!Plugin.plugins.exists(file2)) return;
					Plugin.disable(file2);
				}
			}
		}

		for (value in paddy.Plugin.plugins) if (value.propWinUI != null) value.propWinUI(ui);
	}
}
