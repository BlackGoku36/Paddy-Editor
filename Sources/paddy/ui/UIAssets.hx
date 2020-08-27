package paddy.ui;

//Zui
import kha.Image;
import zui.Id;
import zui.Zui;

// Editor
import paddy.Assets;
import paddy.files.Path;

@:access(zui.Zui)
class UIAssets {

	public static var assetW(get, null):Int;
	static function get_assetW() {
		return Std.int(kha.System.windowWidth() * 0.6);
	}
	public static var assetH(get, null):Int;
	static function get_assetH() {
		return Std.int(kha.System.windowHeight() * 0.3);
	}

	public static var assetHandle = Id.handle();
	public static var assetTabH = Id.handle();

	static var lines:Array<String> = [];

	public static function render(ui:Zui) {
		if(ui.window(assetHandle, App.fileBrowserW, UIOutliner.outlinerH, assetW, Std.int(assetH-(UIStatusBar.barHeight*ui.SCALE())))){
			ui.g.color = ui.t.WINDOW_BG_COL;
			ui.g.fillRect(0, 0, kha.System.windowWidth(), kha.System.windowHeight());
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
						var image = Assets.soundImg;
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
						var image = Assets.fontImg;
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
						switch (Assets.getTextImageTypeFromExt(asset.path)){
							case "document":
								ui.image(Assets.docImg, 0xffffffff, 50, 0, 0, Assets.docImg.width, Assets.docImg.height);
								ui.text(Path.getNameFromPath(asset.path), Center);
								ui._y += Std.int(Assets.docImg.height/50*ui.SCALE()+25);
							case "json":
								ui.image(Assets.jsonImg, 0xffffffff, 50, 0, 0, Assets.jsonImg.width, Assets.jsonImg.height);
								ui.text(Path.getNameFromPath(asset.path), Center);
								ui._y += Std.int(Assets.docImg.height/50*ui.SCALE()+25);
							case "code":
								ui.image(Assets.codeImg, 0xffffffff, 50, 0, 0, Assets.codeImg.width, Assets.codeImg.height);
								ui.text(Path.getNameFromPath(asset.path), Center);
								ui._y += Std.int(Assets.docImg.height/50*ui.SCALE()+25);
						}
					}
					ui.unindent();
				}
			}
			if(ui.tab(assetTabH, ">_")){
				ui.row([8/10, 1/10, 1/10]);
				var input = ui.textInput(Id.handle(), "Terminal");
				if(ui.button("Enter")){
					var path = System.programPath() + "/temp.txt";
					System.command('$input > $path');
					kha.Assets.loadBlobFromPath(path, function(blob){
						var file = blob.toString();
						if(file!="") lines.push(file);
					});
				}
				if(ui.button("Reset")) lines.resize(0);
				for(line in lines) ui.text(line);
			}

			for (value in paddy.Plugin.plugins) if (value.assetWinUI != null) value.assetWinUI(ui);

		}
	}
}
