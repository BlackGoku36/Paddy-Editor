package paddy.ui;

import paddy.data.Themes;
import zui.Id;
import zui.Zui;
import kha.graphics2.Graphics;
import zui.Popup;

@:access(zui.Zui)
class UIPreference {

    public static var show = false;
    static var w = 900;
    static var h = 200;
    static var titleHandle = Id.handle();

    public static var themesName = ["-!-Light-!-", "Dark"];
    public static var tthemes:Array<zui.Themes.TTheme> = [Themes.lightTheme, Themes.darkTheme];
	public static var winHandle = Id.handle();
	public static var tabhandle = Id.handle({position:0});
    static var propPanelGridH = Id.handle({selected:true});
	static var propPanelRotH = Id.handle({selected:true});
    
    public static function render(ui:Zui, g:Graphics) {
        var appW = kha.System.windowWidth();
        var appH = kha.System.windowHeight();
        var x = Std.int(appW / 2 - (w * ui.SCALE()) / 2);
		var y = Std.int(appH / 2 - (h * ui.SCALE()) / 2);
        
        ui.begin(g);
        if(ui.window(titleHandle, x, y, w, 28)){
            ui.row([1/13, 12/13]);
            if(ui.button("X")) show = false;
            ui.text("Preference", Align.Center);
        }
        if(ui.window(winHandle, x, y+28, w, 250)){
            if(ui.tab(tabhandle, "Editor", true)){
                if(ui.panel(Id.handle({selected:true}), "UI")){
					ui.indent();
						var mode = Id.handle({position: 1});
						ui.combo(mode, themesName, Left);
						if(mode.changed){
							paddy.Paddy.changeTheme(ui, tthemes[mode.position]);
							paddy.Paddy.changeTheme(App.uimodal, tthemes[mode.position]);
						}
						var scaleHandle = Id.handle({value: App.configData.uiScale});
						App.configData.uiScale = ui.slider(scaleHandle, "Scale", 0.9, 2.0, true, Left); 
						if(scaleHandle.changed) reScaleUI(App.configData.uiScale);
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
                if (ui.button("Export Config", Align.Left)) paddy.files.Export.exportConfig();
                if (ui.button("Refresh UI", Align.Left)) paddy.Paddy.reloadUI();
            }
            if(ui.tab(tabhandle, "Export")){
                ui.text("File Type:");
                var exportTypeHandle = Id.handle({position:0});
                var json = ui.radio(exportTypeHandle, 0, "Json");
                var pdy = ui.radio(exportTypeHandle, 1, "Binary");
            }
            if(ui.tab(tabhandle, "Plugins")){
                ui.row([4/5, 1/5]);
				var file = ui.textInput(Id.handle(), "Name");
				if(ui.button("Import") && file != "" && !Plugin.plugins.exists(file)){
					Plugin.enable(file);
				}
				for(name => value in Plugin.plugins){
					ui.highlightNextRow();
					ui.row([1/10, 9/10]);
					if(ui.button("X")) Plugin.disable(name);
					ui.text(name, Right);
				}
			}
			for (value in paddy.Plugin.plugins) if (value.propWinUI != null) value.prefWinUI(ui);
        }
		ui.end();
		
		g.begin(false);
		g.drawLine(x, y+25, x+w, y+25, 0.3);
		g.end();
    }
    public static function reScaleUI(factor:Float) {
		App.ui.setScale(factor);
		App.uimodal.setScale(factor);
		Paddy.reloadUI();
	}
}