package paddy.data;

import zui.Themes;

typedef PData = {
	var name: String;
	var window: String;
	var scene: String;
	var ?theme: zui.Themes.TTheme;
}

class PaddyData {

	public static function darkTheme(ui:zui.Zui){
		ui.t.FONT_SIZE = 13;
		ui.t.ELEMENT_W = 100;
		ui.t.ELEMENT_H = 24;
		ui.t.ELEMENT_OFFSET = 4;
		ui.t.ARROW_SIZE = 5;
		ui.t.BUTTON_H = 22;
		ui.t.CHECK_SIZE = 15;
		ui.t.CHECK_SELECT_SIZE = 8;
		ui.t.SCROLL_W = 6;
		ui.t.TEXT_OFFSET = 8;
		ui.t.TAB_W = 12;
		ui.t.FILL_WINDOW_BG = false;
		ui.t.FILL_BUTTON_BG = true;
		ui.t.FILL_ACCENT_BG = false;
		ui.t.WINDOW_BG_COL = 0xff333333;
		ui.t.WINDOW_TINT_COL = 0xffffffff;
		ui.t.ACCENT_COL = 0xff444444;
		ui.t.ACCENT_HOVER_COL = 0xff494949;
		ui.t.ACCENT_SELECT_COL = 0xff606060;
		ui.t.BUTTON_COL = 0xff464646;
		ui.t.BUTTON_TEXT_COL = 0xffe8e7e5;
		ui.t.BUTTON_HOVER_COL = 0xff494949;
		ui.t.BUTTON_PRESSED_COL = 0xff1b1b1b;
		ui.t.TEXT_COL = 0xffe8e7e5;
		ui.t.LABEL_COL = 0xffc8c8c8;
		ui.t.SEPARATOR_COL = 0xff272727;
		ui.t.HIGHLIGHT_COL = 0xff205d9c;
		ui.t.CONTEXT_COL = 0xff222222;
	};

	public static function lightTheme(ui:zui.Zui){
		ui.t.FONT_SIZE = 13;
		ui.t.ELEMENT_W = 100;
		ui.t.ELEMENT_H = 24;
		ui.t.ELEMENT_OFFSET = 4;
		ui.t.ARROW_SIZE = 5;
		ui.t.BUTTON_H = 22;
		ui.t.CHECK_SIZE = 15;
		ui.t.CHECK_SELECT_SIZE = 8;
		ui.t.SCROLL_W = 6;
		ui.t.TEXT_OFFSET = 8;
		ui.t.TAB_W = 12;
		ui.t.FILL_WINDOW_BG = false;
		ui.t.FILL_BUTTON_BG = true;
		ui.t.FILL_ACCENT_BG = false;
		ui.t.WINDOW_BG_COL = 0xffefefef;
		ui.t.WINDOW_TINT_COL = 0xff222222;
		ui.t.ACCENT_COL = 0xffeeeeee;
		ui.t.ACCENT_HOVER_COL = 0xffbbbbbb;
		ui.t.ACCENT_SELECT_COL = 0xffaaaaaa;
		ui.t.BUTTON_COL = 0xffcccccc;
		ui.t.BUTTON_TEXT_COL = 0xff222222;
		ui.t.BUTTON_HOVER_COL = 0xffb3b3b3;
		ui.t.BUTTON_PRESSED_COL = 0xffb1b1b1;
		ui.t.TEXT_COL = 0xff999999;
		ui.t.LABEL_COL = 0xffaaaaaa;
		ui.t.SEPARATOR_COL = 0xff999999;
		ui.t.HIGHLIGHT_COL = 0xff205d9c;
		ui.t.CONTEXT_COL = 0xffaaaaaa;
	};

}
