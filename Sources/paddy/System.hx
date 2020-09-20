package paddy;

#if cpp
import sys.io.File;
#end

class System {
	#if kha_windows
	public static var platform = "windows";
	#elseif kha_linux
	public static var platform = "linux";
	#else
	public static var platform = "osx";
	#end

	public static function command(cmd:String) {
		#if cpp
		Sys.command(cmd);
		#elseif kha_krom
		Krom.sysCommand(cmd);
		#else
		throw 'This target is not supported';
		#end
	}

	public static function fileSaveBytes(path:String, bytes:haxe.io.Bytes) {
		#if cpp
		File.saveBytes(path, bytes);
		#elseif kha_krom
		Krom.sysCommand(path, bytes.getData());
		#else
		throw 'This target is not supported';
		#end
	}

	public static function programPath():String{
		#if cpp
		var path = Sys.programPath();
		return path.substr(0, path.length - 13);// '/Paddy-Editor'
		#elseif kha_krom
		return Krom.getFilesLocation();
		#else
		throw 'This target is not supported';
		#end
	}
}
