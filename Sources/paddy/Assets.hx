package paddy;

// Editor
import paddy.files.Path;
import paddy.data.Data.AssetType;
import paddy.data.Data.AssetData;

class Assets {

	public static var assets: Array<AssetData> = [];

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
		switch (type){
			case Image:
				kha.Assets.loadImageFromPath(path, true, function(image){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Image,
						value: image,
						path: path
					});
				});
			case Font:
				kha.Assets.loadFontFromPath(path, function(font){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Font,
						value: font,
						path: path
					});
				});
			case Sound:
				kha.Assets.loadSoundFromPath(path, function(sound){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Sound,
						value: sound,
						path: path
					});
				});
			case Blob:
				kha.Assets.loadBlobFromPath(path, function(blob){
					assets.push({
						name: Path.getNameFromPath(path),
						type: Blob,
						value: blob,
						path: path
					});
				});
		}
	}
}
