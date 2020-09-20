package paddy.ui;

import haxe.Timer;
import kha.Color;
import zui.Zui;
import zui.Id;
import zui.Ext;

class UIStatusBar {

	static var status = "";
	static var bgcolor = 0;
	static var txtcolor = 0;
	public static var handle = Id.handle();

	public static var barWidth(get, null):Int;
	static function get_barWidth() {
		return kha.System.windowWidth();
	}
	public static var barHeight(get, null):Int;
	static function get_barHeight() {
		return 30;
	}

	public static function render(ui:Zui) {
		var y = Std.int(kha.System.windowHeight()-(barHeight*ui.SCALE()));
		if (ui.window(handle, 3, y, barWidth, Std.int(barHeight*ui.SCALE()))) {
			ui.g.color = ui.t.WINDOW_BG_COL;
			ui.g.fillRect(3, y, barWidth, barHeight);
			var t = ui.t.TEXT_COL;
			ui.t.TEXT_COL = txtcolor;
			ui.text(status, Left, bgcolor);
			ui.t.TEXT_COL = t;
		}
	}

	public static function warn(text:String, wait_ms: Int = 2500) {
		status = text;
		txtcolor = Color.Black;
		bgcolor = Color.fromBytes(255, 216, 0);
		handle.redraws = 2;
		clear(wait_ms);
	}

	public static function success(text:String, wait_ms: Int = 2500) {
		status = text;
		txtcolor = Color.Black;
		bgcolor = Color.fromBytes(0, 230, 0);
		handle.redraws = 2;
		clear(wait_ms);
	}

	public static function error(text:String, wait_ms: Int = 2500) {
		status = text;
		txtcolor = Color.Black;
		bgcolor = Color.fromBytes(255, 0, 0);
		handle.redraws = 2;
		clear(wait_ms);
	}

	static function clear(wait_ms:Int = 2500) {
		Timer.delay(()->{
			status = "";
			bgcolor = Color.Transparent;
			handle.redraws = 2;
		}, wait_ms);
	}
}
