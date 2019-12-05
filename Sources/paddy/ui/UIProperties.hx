package paddy.ui;

import zui.Id;
import zui.Zui;

@:access(zui.Zui)
class UIProperties {

    public static function render(ui:Zui, idHandle:Handle, x:Int, y:Int, w:Int, h:Int) {
        var window = App.window;

        var gridSize = App.gridSize;
	    var gridSnapBounds = App.gridSnapBounds;
	    var gridSnapPos = App.gridSnapPos;
	    var gridUseRelative = App.gridUseRelative;
	    var useRotationSteps = App.useRotationSteps;
	    var rotationSteps = App.rotationSteps;

        var selectedObj = App.selectedObj;

        if(ui.window(idHandle, x, y, w, h)){
            var propTabHandle = Id.handle();
            if(ui.tab(propTabHandle, "Properties")){
                if(ui.panel(Id.handle({selected:true}), "Window")){
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
                    ui.unindent();
                }
                if(selectedObj!=null){
                    var obj = selectedObj;
                    var id = obj.id;
                    if (ui.panel(Id.handle({selected: true}), "Object")) {
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
                        ui.unindent();
                    }
                }
            }
            if(ui.tab(propTabHandle, "Editor")){
                if(ui.panel(Id.handle(), "Grid")){
                    ui.indent();
                        gridSize = Std.parseInt(ui.textInput(Id.handle({text:gridSize+""}), "Size", Right));
                        gridSnapPos = ui.check(Id.handle({selected:true}), "Snap Pos");
                        gridSnapBounds = ui.check(Id.handle({selected:false}), "Snap Bounds");
                        gridUseRelative = ui.check(Id.handle({selected:true}), "Use Relative");
                    ui.unindent();
                }
                if(ui.panel(Id.handle(), "Rotation")){
                    ui.indent();
                        useRotationSteps = ui.check(Id.handle({selected:true}), "Use Steps");
                        if(useRotationSteps) rotationSteps = Std.parseInt(ui.textInput(Id.handle({text:rotationSteps+""}), "Steps", Right));
                    ui.unindent();
                }
            }
            if(ui.tab(propTabHandle, "Plugins Manager")){
                if(ui.panel(Id.handle(), "Plugins List")){
                    ui.row([3/5, 2/5]);
                    var file = ui.textInput(Id.handle(), "File Name");
                    if(ui.button("Import") && file != ""){
                        var plug = new Plugin(file);
                        plug.enable();
                        trace(Plugin.plugins);
                    }
                    for (p in paddy.Plugin.plugins){
                        for (key => value in p) {
                            ui.row([4/5, 1/5]);
                            if(value.name!=null){
                                ui.text(value.name);
                                if(ui.button("X")) value.disable();
                                trace(Plugin.plugins);
                            }
                        }
                    }
                }
            }
        }

    }
}
