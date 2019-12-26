package paddy.ui;

import zui.Zui;
import zui.Id;
import zui.Ext;

class UIFileBrowser {

	static var modalW = 655;
	static var modalH = 550;
	static var modalHeaderH = 66;
	static var modalRectW = 625; // No shadow
	static var modalRectH = 545;

	public static var onDone: String->Void = null;

	static var path = "/";

	public static function render(ui:Zui, g:kha.graphics2.Graphics) {
		var appw = kha.System.windowWidth();
		var apph = kha.System.windowHeight();
		var left = appw / 2 - modalW / 2;
		var top = apph / 2 - modalH / 2;

		g.begin(false);
		g.color = 0xff202020;
		g.fillRect(left, top, modalW, modalH);
		g.end();

		var leftRect = Std.int(appw / 2 - modalRectW / 2);
		var rightRect = Std.int(appw / 2 + modalRectW / 2);
		var topRect = Std.int(apph / 2 - modalRectH / 2);
		var bottomRect = Std.int(apph / 2 + modalRectH / 2);
		topRect += modalHeaderH;

		ui.begin(g);
		if (ui.window(Id.handle(), leftRect, topRect, modalRectW, modalRectH - 100)) {
			if(ui.panel(Id.handle(), "Operations")){
				ui.row([4/5, 1/5]);
				var pathHandle = Id.handle({text:path});
				pathHandle.text = path;
				var dirLoc = ui.textInput(pathHandle, "Path");
				if(ui.button("Create Directory")) if(dirLoc!="") Krom.sysCommand('mkdir $dirLoc');
			}
			path = Ext.fileBrowser(ui, Id.handle());
		}
		ui.end(false);

		g.begin(false);

		ui.beginRegion(g, rightRect - 100, bottomRect - 30, 100);
		if (ui.button("OK")) {
			if (onDone!=null) onDone(path);
			App.showFileBrowser = false;
		}
		ui.endRegion(false);

		ui.beginRegion(g, rightRect - 200, bottomRect - 30, 100);
		if (ui.button("Cancel")) {
			App.showFileBrowser = false;
		}
		ui.endRegion();

		g.end();
	}
}
