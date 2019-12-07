package paddy.ui;

import zui.Id;
import zui.Zui;

import paddy.Assets;

@:access(zui.Zui)
class UIAssets {

    public static var assetTabH = Id.handle();

    public static function render(ui:Zui, x:Int, y:Int, w:Int, h:Int) {
        if(ui.window(Id.handle(), x, y, w, h)){
            if(ui.tab(assetTabH, "Assets")){
                if(ui.panel(Id.handle(), "Images")){
                    ui.indent();
                    for (image in Assets.images) for (name => value in image){
                        ui.row([1/5, 4/5]);
                        var state = ui.image(value, 0xffffffff, 50, 0, 0, value.width, value.height);
                        ui.text(name, Center);
                        if(state == 2) App.selectedImage = name;
                        ui._y += Std.int(value.height/50*ui.SCALE()+25);
                    }
                    ui.unindent();
                }
                if(ui.panel(Id.handle(), "Sounds")){
                    ui.indent();
                    for (sound in Assets.sounds) for (name => value in sound){
                        ui.row([1/5, 4/5]);
                        var image = kha.Assets.images.get(name.split(".")[1]);
                        ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
                        ui.text(name, Center);
                        ui._y += Std.int(image.height/50*ui.SCALE()+25);
                    }
                    ui.unindent();
                }
                if(ui.panel(Id.handle(), "Fonts")){
                    ui.indent();
                    for (font in Assets.fonts) for (name => value in font){
                        ui.row([1/5, 4/5]);
                        var image = kha.Assets.images.get(name.split(".")[1]);
                        ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
                        ui.text(name, Center);
                        ui._y += Std.int(image.height/50*ui.SCALE()+25);
                    }
                    ui.unindent();
                }
                if(ui.panel(Id.handle(), "Codes")){
                    ui.indent();
                    for (blob in Assets.blobs) for (name => value in blob){
                        ui.row([1/5, 4/5]);
                        var image = kha.Assets.images.get(getTextImageTypeFromExt(name));
                        ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
                        ui.text(name, Center);
                        ui._y += Std.int(image.height/50*ui.SCALE()+25);
                    }
                    ui.unindent();
                }
            }
            if(ui.tab(assetTabH, "Terminal")){}

            for (value in paddy.Plugin.plugins) if (value.assetWinUI != null) value.assetWinUI(ui);
    
        }
	}

    static function getTextImageTypeFromExt(name:String) {
        var string = null;
        if(StringTools.endsWith(name, "txt")
            || StringTools.endsWith(name, "md")) string = "document";
        else if(StringTools.endsWith(name, "json")) string = "json";
        else if(StringTools.endsWith(name, "hx")) string = "code";
        return string;
    }
}