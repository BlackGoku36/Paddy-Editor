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

    public static function loadImages(path:String){
        var fs = untyped __js__('require("fs");');
        fs.readdir(path, (err, file) -> {
            var files:Array<String> = file;
            if(images.length == files.length) return;
            if(files != null) for (image in files){
                if(!StringTools.endsWith(path, ".png")) return;
                kha.Assets.loadImageFromPath(image, true, function (img){
                    images.push([image.split(".")[0] => img]);
                }, function (error){
                    throw error + 'Can`t find image $image, make sure path is correct and image is in `Assets` folder';
                });
            }
        });
    }

    public static function loadFonts(path:String){
        var fs = untyped __js__('require("fs");');
        fs.readdir(path, (err, file) -> {
            var files:Array<String> = file;
            if(fonts.length == files.length) return;
            if(files != null) for (font in files){
                if(StringTools.endsWith(path, ".ttf")) return;
                kha.Assets.loadFontFromPath(font, function (fnt){
                    fonts.push([font.split(".")[0] => fnt]);
                }, function (error){
                    throw error + 'Can`t find font $font, make sure path is correct and font is in `Assets` folder';
                });
            }
        });
    }

    public static function loadSounds(path:String){
        var fs = untyped __js__('require("fs");');
        fs.readdir(path, (err, file) -> {
            var files:Array<String> = file;
            if(sounds.length == files.length) return;
            if(files != null) for (sound in files){
                if(!StringTools.endsWith(path, ".ogg")) return;
                kha.Assets.loadSoundFromPath(sound, function (snd){
                    sounds.push([sound.split(".")[0] => snd]);
                }, function (error){
                    throw error + 'Can`t find sound $sound, make sure path is correct and sound is in `Assets` folder';
                });
            }
        });
    }

    public static function loadBlobs(path:String){
        var fs = untyped __js__('require("fs");');
        fs.readdir(path, (err, file) -> {
            var files:Array<String> = file;
            if(blobs.length == files.length) return;
            if(files != null) for (blob in files){
                if(StringTools.endsWith(path, ".png")||StringTools.endsWith(path, ".ttf")||StringTools.endsWith(path, ".ogg")) return;
                kha.Assets.loadBlobFromPath(blob, function (blb){
                    blobs.push([blob.split(".")[0] => blb]);
                }, function (error){
                    throw error + 'Can`t find blob $blob, make sure path is correct and blob is in `Assets` folder';
                });
            }
        });
    }
}