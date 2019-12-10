package paddy;

import paddy.files.Path;

class Assets {

	public static var images: Array<Map<String, kha.Image>> = [];
	public static var imagesPaths: Array<String> = [];
	public static var fonts: Array<Map<String, kha.Font>> = [];
	public static var fontsPaths: Array<String> = [];
	public static var sounds: Array<Map<String, kha.Sound>> = [];
	public static var soundsPaths: Array<String> = [];
	public static var blobs: Array<Map<String, kha.Blob>> = [];
	public static var blobsPaths: Array<String> = [];

	public static function getImage(imageRef:String) {
		var newImage:kha.Image = null;
		for (image in images) if(image.exists(imageRef)) newImage = image.get(imageRef);
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
		for (sound in sounds) if(sound.exists(soundRef)) newSound = sound.get(soundRef);
		return newSound;
	}

	public static function getBlob(blobRef:String) {
		var newBlob:kha.Blob = null;
		for (blob in blobs) if(blob.exists(blobRef)) newBlob = blob.get(blobRef);
		return newBlob;
	}

	public static function loadImage(path:String){
		kha.Assets.loadImageFromPath(path, true, function (img){
			for (image in images) if(image.exists(path)) return;
			images.push([path => img]);
			imagesPaths.push(path);
		});
	}

	public static function loadFont(path:String){
		kha.Assets.loadFontFromPath(path, function (fnt){
			for (font in fonts) if(font.exists(path)) return;
			fonts.push([path => fnt]);
			fontsPaths.push(path);
		});
	}

	public static function loadSound(path:String){
		kha.Assets.loadSoundFromPath(path, function (snd){
			for (sound in sounds) if(sound.exists(path)) return;
			sounds.push([path => snd]);
			fontsPaths.push(path);
		});
	}

	public static function loadBlob(path:String){
		kha.Assets.loadBlobFromPath(path, function (blb){
			for (blob in blobs) if(blob.exists(path)) return;
			blobs.push([path => blb]);
			blobsPaths.push(path);
		});
	}
}
