package paddy;

// Editor
import paddy.ui.UIStatusBar;
import kha.Image;
import paddy.files.Path;
import paddy.data.Data.AssetType;
import paddy.data.Data.AssetData;

class Assets {

	public static var assets: Array<AssetData> = [];

	public static var codeImg:Image;
	public static var docImg:Image;
	public static var jsonImg:Image;
	public static var soundImg:Image;
	public static var fontImg:Image;

	public static function getAssetNamesOfType(type:AssetType): Array<String> {
		var names:Array<String> = [];
		for(asset in assets) if(asset.type == type) names.push(asset.name);
		return names;
	}

	public static function getAsset(name:String, type:AssetType) {
		var value:Dynamic = null;
		for(asset in assets){
			if(asset.type == type && asset.name == name){
				value = asset.value;
			}
		}
		return value;
	}

	public static function loadAssetFromPath(path:String, type:AssetType) {
		var name = Path.getNameFromPath(path);
		switch (type){
			case Image:
				kha.Assets.loadImageFromPath(path, true, function(image){
					assets.push({
						name: name,
						type: Image,
						value: image,
						path: path
					});
				}, (err)->{
					UIStatusBar.error('Failed to load image Asset (${name}).');
				});
			case Font:
				kha.Assets.loadFontFromPath(path, function(font){
					assets.push({
						name: name,
						type: Font,
						value: font,
						path: path
					});
				}, (err)->{
					UIStatusBar.error('Failed to load font Asset (${name}).');
				});
				if(fontImg == null){
					kha.Assets.loadImage("font", function (img){
						fontImg = img;
					});
				}
			case Sound:
				kha.Assets.loadSoundFromPath(path, function(sound){
					assets.push({
						name: name,
						type: Sound,
						value: sound,
						path: path
					});
				}, (err)->{
					UIStatusBar.error('Failed to load sound Asset (${name}).');
				});
				if(soundImg == null){
					kha.Assets.loadImage("sound", function (img){
						soundImg = img;
					});
				}
			case Blob:
				kha.Assets.loadBlobFromPath(path, function(blob){
					assets.push({
						name: name,
						type: Blob,
						value: blob,
						path: path
					});
				}, (err)->{
					UIStatusBar.error('Failed to load blob Asset (${name}).');
				});
				var type = getTextImageTypeFromExt(path);
				switch (type){
					case "document":
						if(docImg == null){
							kha.Assets.loadImage(type, function (img){
								docImg = img;
							});
						}
					case "json":
						if(jsonImg == null){
							kha.Assets.loadImage(type, function (img){
								jsonImg = img;
							});
						}
					case "code":
						if(codeImg == null){
							kha.Assets.loadImage(type, function (img){
								codeImg = img;
							});
						}
				}
		}
	}

	public static function getTextImageTypeFromExt(name:String) {
		var string = null;
		if(StringTools.endsWith(name, "txt")
			|| StringTools.endsWith(name, "md")) string = "document";
		else if(StringTools.endsWith(name, "json")) string = "json";
		else if(StringTools.endsWith(name, "hx")) string = "code";
		return string;
	}
}
