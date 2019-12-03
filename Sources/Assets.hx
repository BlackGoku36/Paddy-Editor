package;

class Assets {

    public static var images: Array<Map<String, kha.Image>> = [];
    public static var fonts: Array<Map<String, kha.Font>> = [];
    public static var sounds: Array<Map<String, kha.Sound>> = [];
    public static var blobs: Array<Map<String, kha.Blob>> = [];

    public static function getImage(imageRef:String) {
        var newImage:kha.Image = null;
        for (image in images){
            if(image.exists(imageRef)) newImage = image.get(imageRef);
        }
        return newImage;
    }

	public static function getImagesName(){
		var names:Array<String> = [""];
		for (image in images){
			for (key => value in image) {
				names.push(key);
			}
		}
		return names;
	}

    public static function getFont(fontRef:String) {
        var newFont:kha.Font = null;
        for (font in fonts){
            if(font.exists(fontRef)) newFont = font.get(fontRef);
        }
        return newFont;
    }

    public static function getSound(soundRef:String) {
        var newSound:kha.Sound = null;
        for (sound in sounds){
            if(sound.exists(soundRef)) newSound = sound.get(soundRef);
        }
        return newSound;
    }

    public static function getBlob(blobRef:String) {
        var newBlob:kha.Blob = null;
        for (blob in blobs){
            if(blob.exists(blobRef)) newBlob = blob.get(blobRef);
        }
        return newBlob;
    }

    public static function loadImage(path:String){
		kha.Assets.loadImageFromPath(path, true, function (img){
			var splited = path.split("/");
			images.push([splited[splited.length-1].split(".")[0] => img]);
		}, function (error){
			throw error;
		});
    }

    public static function loadFont(path:String){
		kha.Assets.loadFontFromPath(path, function (fnt){
			var splited = path.split("/");
			fonts.push([splited[splited.length-1].split(".")[0] => fnt]);
		}, function (error){
			throw error;
		});
    }

    public static function loadSound(path:String){
		kha.Assets.loadSoundFromPath(path, function (snd){
			var splited = path.split("/");
			sounds.push([splited[splited.length-1].split(".")[0] => snd]);
		}, function (error){
			throw error;
		});
    }

    public static function loadBlob(path:String){
		kha.Assets.loadBlobFromPath(path, function (blb){
			var splited = path.split("/");
			blobs.push([splited[splited.length-1].split(".")[0] => blb]);
		}, function (error){
			throw error;
		});
    }
}