package paddy.ui;

import paddy.files.Path;
import zui.Id;
import zui.Zui;

import paddy.Assets;

@:access(zui.Zui)
class UIAssets {

	public static var assetHandle = Id.handle();
	public static var assetTabH = Id.handle();

	public static function render(ui:Zui) {
		if(ui.window(assetHandle, App.fileW, UIOutliner.outlinerH, kha.System.windowWidth()-UIProperties.propsW-App.fileW, kha.System.windowHeight()-UIOutliner.outlinerH-20)){
			if(ui.tab(assetTabH, "Assets")){
				if(ui.panel(Id.handle(), "Images")){
					ui.indent();
					for (image in Assets.images) for (path => value in image){
						ui.row([1/5, 4/5]);
						var state = ui.image(value, 0xffffffff, 50, 0, 0, value.width, value.height);
						ui.text(Path.getNameFromPath(path), Center);
						if(state == 2) App.selectedImage = path;
						ui._y += Std.int(value.height/50*ui.SCALE()+25);
					}
					ui.unindent();
				}
				if(ui.panel(Id.handle(), "Sounds")){
					ui.indent();
					for (sound in Assets.sounds) for (path => value in sound){
						ui.row([1/5, 4/5]);
						var image = kha.Assets.images.get(path);
						ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
						ui.text(Path.getNameFromPath(path), Center);
						ui._y += Std.int(image.height/50*ui.SCALE()+25);
					}
					ui.unindent();
				}
				if(ui.panel(Id.handle(), "Fonts")){
					ui.indent();
					for (font in Assets.fonts) for (path => value in font){
						ui.row([1/5, 4/5]);
						var image = kha.Assets.images.get(path);
						ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
						ui.text(Path.getNameFromPath(path), Center);
						ui._y += Std.int(image.height/50*ui.SCALE()+25);
					}
					ui.unindent();
				}
				if(ui.panel(Id.handle(), "Codes")){
					ui.indent();
					for (blob in Assets.blobs) for (path => value in blob){
						ui.row([1/5, 4/5]);
						var image = kha.Assets.images.get(getTextImageTypeFromExt(path));
						ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
						ui.text(Path.getNameFromPath(path), Center);
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
