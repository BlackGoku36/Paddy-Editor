package paddy.ui;

import paddy.files.Path;
import zui.Id;
import zui.Zui;

import paddy.Assets;

@:access(zui.Zui)
class UIAssets {

	public static var assetHandle = Id.handle();
	public static var assetTabH = Id.handle();

	static var lines:Array<String> = [];

	public static function render(ui:Zui) {
		if(ui.window(assetHandle, App.fileW, UIOutliner.outlinerH, kha.System.windowWidth()-UIProperties.propsW-App.fileW, kha.System.windowHeight()-UIOutliner.outlinerH-20)){
			if(ui.tab(assetTabH, "Assets")){
				if(ui.panel(Id.handle(), "Images")){
					ui.indent();
					for(asset in Assets.assets) if(asset.type == Image){
						ui.row([1/5, 4/5]);
						var state = ui.image(asset.value, 0xffffffff, 50, 0, 0, asset.value.width, asset.value.height);
						ui.text(Path.getNameFromPath(asset.path), Center);
						if(state == 2) App.selectedImage = asset.name;
						ui._y += Std.int(asset.value.height/50*ui.SCALE()+25);
					}
					ui.unindent();
				}
				if(ui.panel(Id.handle(), "Sounds")){
					ui.indent();
					for(asset in Assets.assets) if(asset.type == Sound){
						ui.row([1/5, 4/5]);
						var image = kha.Assets.images.get(asset.path);
						ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
						ui.text(Path.getNameFromPath(asset.path), Center);
						ui._y += Std.int(image.height/50*ui.SCALE()+25);
					}
					ui.unindent();
				}
				if(ui.panel(Id.handle(), "Fonts")){
					ui.indent();
					for(asset in Assets.assets) if(asset.type == Font){
						ui.row([1/5, 4/5]);
						var image = kha.Assets.images.get(asset.path);
						ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
						ui.text(Path.getNameFromPath(asset.path), Center);
						ui._y += Std.int(image.height/50*ui.SCALE()+25);
					}
					ui.unindent();
				}
				if(ui.panel(Id.handle(), "Codes")){
					ui.indent();
					for(asset in Assets.assets) if(asset.type == Blob){
						ui.row([1/5, 4/5]);
						var image = kha.Assets.images.get(getTextImageTypeFromExt(asset.path));
						ui.image(image, 0xffffffff, 50, 0, 0, image.width, image.height);
						ui.text(Path.getNameFromPath(asset.path), Center);
						ui._y += Std.int(image.height/50*ui.SCALE()+25);
					}
					ui.unindent();
				}
			}
			if(ui.tab(assetTabH, ">_")){
				ui.row([8/10, 1/10, 1/10]);
				var input = ui.textInput(Id.handle(), "Terminal");
				if(ui.button("Enter")){
					var save = Krom.getFilesLocation() + "/temp.txt";
					Krom.sysCommand('$input > $save');
					var file = haxe.io.Bytes.ofData(Krom.loadBlob(save)).toString();
					if(file!="") lines.push(file);
				}
				if(ui.button("Reset")) lines.resize(0);
				for(line in lines) ui.text(line);
			}

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
