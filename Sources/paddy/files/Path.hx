package paddy.files;

class Path {
    
    public static function getNameFromPath(name:String):String {
		var nameArr = name.split("/");
		return nameArr[nameArr.length-1];
	}
}