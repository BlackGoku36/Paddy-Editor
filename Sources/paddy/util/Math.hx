package paddy.util;

import zui.Zui;
import kha.math.FastVector2;

class Math {
	public static inline function toDegrees(radians:Float):Float { return radians * 57.29578; }
	public static inline function toRadians(degrees:Float):Float { return degrees * 0.0174532924; }

	public static function hitbox(ui:Zui, x:Float, y:Float, w:Float, h:Float, ?rotation:Float):Bool {
		var rotatedInput:FastVector2 = rotatePoint(ui.inputX, ui.inputY, x + w / 2, y + h / 2, -rotation);
		return rotatedInput.x > x && rotatedInput.x < x + w && rotatedInput.y > y && rotatedInput.y < y + h;
	}

	public static function rotatePoint(pointX: Float, pointY: Float, centerX: Float, centerY: Float, angle:Float): FastVector2 {
		pointX -= centerX;
		pointY -= centerY;

		var x = pointX * std.Math.cos(angle) - pointY * std.Math.sin(angle);
		var y = pointX * std.Math.sin(angle) + pointY * std.Math.cos(angle);

		return new FastVector2(centerX + x, centerY + y);
	}

	public static function roundPrecision(v:Float, ?precision=0):Float {
		v *= std.Math.pow(10, precision);

		v = Std.int(v) * 1.0;
		v /= std.Math.pow(10, precision);

		return v;
	}
}
