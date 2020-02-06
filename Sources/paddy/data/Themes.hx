package paddy.data;

// Kha
import kha.Color;

// Zui
import zui.Themes.TTheme;

class Themes {

	public static var darkTheme: TTheme = {
		NAME: "Dark Theme",
		FONT_SIZE: 14,
		ELEMENT_W: 100,
		ELEMENT_H: 24,
		ELEMENT_OFFSET: 4,
		ARROW_SIZE: 5,
		BUTTON_H: 22,
		CHECK_SIZE: 15,
		CHECK_SELECT_SIZE: 8,
		SCROLL_W: 6,
		TEXT_OFFSET: 8,
		TAB_W: 12,
		FILL_WINDOW_BG: true,
		FILL_BUTTON_BG: true,
		FILL_ACCENT_BG: false,

		WINDOW_BG_COL: 0xff333333,
		WINDOW_TINT_COL: 0xffffffff,
		ACCENT_COL: 0xff444444,
		ACCENT_HOVER_COL: 0xff494949,
		ACCENT_SELECT_COL: 0xff606060,
		BUTTON_COL: 0xff464646,
		BUTTON_TEXT_COL: 0xffe8e7e5,
		BUTTON_HOVER_COL: 0xff494949,
		BUTTON_PRESSED_COL: 0xff1b1b1b,
		TEXT_COL: 0xffe8e7e5,
		LABEL_COL: 0xffc8c8c8,
		SEPARATOR_COL: 0xff272727,
		HIGHLIGHT_COL: 0xff205d9c,
		CONTEXT_COL: 0xff222222,
	};

	public static var lightTheme: TTheme = {
		NAME: "Light Theme",
		FONT_SIZE: 14,
		ELEMENT_W: 100,
		ELEMENT_H: 24,
		ELEMENT_OFFSET: 4,
		ARROW_SIZE: 5,
		BUTTON_H: 22,
		CHECK_SIZE: 15,
		CHECK_SELECT_SIZE: 8,
		SCROLL_W: 6,
		TEXT_OFFSET: 8,
		TAB_W: 12,
		FILL_WINDOW_BG: true,
		FILL_BUTTON_BG: true,
		FILL_ACCENT_BG: false,

		WINDOW_BG_COL: Color.fromBytes(240, 240, 240),
		WINDOW_TINT_COL: 0xffffffff,
		ACCENT_COL: Color.fromBytes(33, 231, 182),
		ACCENT_HOVER_COL: Color.fromBytes(23, 221, 172),
		ACCENT_SELECT_COL: Color.fromBytes(13, 211, 162),
		BUTTON_COL: Color.fromBytes(33, 231, 182),
		BUTTON_TEXT_COL: Color.White,
		BUTTON_HOVER_COL: Color.fromBytes(23, 221, 172),
		BUTTON_PRESSED_COL: Color.fromBytes(13, 211, 162),
		TEXT_COL: Color.fromBytes(33, 231, 182),
		LABEL_COL: Color.fromBytes(30, 228, 179),
		SEPARATOR_COL: Color.fromBytes(220, 220, 220),
		HIGHLIGHT_COL: Color.fromBytes(33, 231, 182),
		CONTEXT_COL: Color.Black,
	};
}
