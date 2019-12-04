package;

import zui.Zui;
import kha.input.KeyCode;
import kha.math.Vector2;
import kha.graphics2.Graphics;
using kha.graphics2.GraphicsExtension;

class ObjectController{

    public static var ui:Zui;

    static var handleSize = 8;

    public static var isManipulating = false;
    static var transformInitInput:Vector2;
	static var transformInitPos:Vector2;
	static var transformInitRot:Float;
	static var transformInitSize:Vector2;
	// Was the transformation editing started by dragging the mouse
	static var transformStartedMouse = false;
	static var drag = false;
	static var dragLeft = false;
	static var dragTop = false;
	static var dragRight = false;
	static var dragBottom = false;
	static var grab = false;
	static var grabX = false;
	static var grabY = false;
	static var rotate = false;

    public static function render(g:Graphics) {
        var selectedObj = App.selectedObj;
        var coffX = App.coffX;
        var coffY = App.coffY;
        if (selectedObj != null) {
			g.color = 0xffffffff;
			// Resize rects
			var ex = selectedObj.x;
			var ey = selectedObj.y;
			var ew = selectedObj.width;
			var eh = selectedObj.height;
			// object center
			var cx = coffX + ex + ew / 2;
			var cy = coffY + ey + eh / 2;
			g.pushRotation(selectedObj.rotation, cx, cy);

			g.drawRect(coffX + ex, coffY + ey, ew, eh);
			g.color = 0xff000000;
			g.drawRect(coffX + ex + 1, coffY + ey + 1, ew, eh);
			g.color = 0xffffffff;

			// Rotate mouse coords in opposite direction as the object
			var rotatedInput:Vector2 = util.Math.rotatePoint(ui.inputX, ui.inputY, cx, cy, -selectedObj.rotation);

			// Draw corner drag handles
			for (handlePosX in 0...3) {
				// 0 = Left, 0.5 = Center, 1 = Right
				var handlePosX:Float = handlePosX / 2;

				for (handlePosY in 0...3) {
					// 0 = Top, 0.5 = Center, 1 = Bottom
					var handlePosY:Float = handlePosY / 2;

					if (handlePosX == 0.5 && handlePosY == 0.5) {
						continue;
					}

					var hX = coffX + ex + ew * handlePosX - handleSize / 2;
					var hY = coffY + ey + eh * handlePosY - handleSize / 2;

					// Check if the handle is currently dragged (not necessarily hovered!)
					var dragged = false;

					if (handlePosX == 0 && dragLeft) {
						if (handlePosY == 0 && dragTop) dragged = true;
						else if (handlePosY == 0.5 && !(dragTop || dragBottom)) dragged = true;
						else if (handlePosY == 1 && dragBottom) dragged = true;
					} else if (handlePosX == 0.5 && !(dragLeft || dragRight)) {
						if (handlePosY == 0 && dragTop) dragged = true;
						else if (handlePosY == 1 && dragBottom) dragged = true;
					} else if (handlePosX == 1 && dragRight) {
						if (handlePosY == 0 && dragTop) dragged = true;
						else if (handlePosY == 0.5 && !(dragTop || dragBottom)) dragged = true;
						else if (handlePosY == 1 && dragBottom) dragged = true;
					}
					dragged = dragged && drag;


					// Hover
					if (rotatedInput.x > hX && rotatedInput.x < hX + handleSize || dragged) {
						if (rotatedInput.y > hY && rotatedInput.y < hY + handleSize || dragged) {
							g.color = 0xff205d9c;
							g.fillRect(hX, hY, handleSize, handleSize);
							g.color = 0xffffffff;
						}
					}

					g.drawRect(hX, hY, handleSize, handleSize);
				}
			}

			// Draw rotation handle
			g.drawLine(cx, coffY + ey, cx, coffY + ey - handleSize * 2);

			var rotHandleCenter = new Vector2(cx, coffY + ey - handleSize * 2);
			if (rotatedInput.sub(rotHandleCenter).length <= handleSize / 2 || rotate) {
				g.color = 0xff205d9c;
				g.fillCircle(rotHandleCenter.x, rotHandleCenter.y, handleSize / 2);
				g.color = 0xffffffff;
			}
			g.drawCircle(rotHandleCenter.x, rotHandleCenter.y, handleSize / 2);

			g.popTransformation();
		}
        
    }

    public static function update() {
        var selectedObj = App.selectedObj;

        var coffX = App.coffX;
        var coffY = App.coffY;

    	var gridSize = App.gridSize;
		var gridSnapPos = App.gridSnapPos;
		var useRotationSteps = App.useRotationSteps;
		var rotationSteps = App.rotationSteps;

        if (selectedObj != null) {
			var obj = selectedObj;
			var ex = selectedObj.x;
			var ey = selectedObj.y;
			var ew = selectedObj.width;
			var eh = selectedObj.height;
			var rotatedInput:Vector2 = util.Math.rotatePoint(ui.inputX, ui.inputY, coffX + ex + ew / 2, coffY + ey + eh / 2, -obj.rotation);

			if (ui.inputStarted && ui.inputDown) {
				// Drag selected object
				if (util.Math.hitbox(ui, coffX + ex - handleSize / 2, coffY + ey - handleSize / 2, ew + handleSize, eh + handleSize, selectedObj.rotation)) {
					drag = true;
					// Resize
					dragLeft = dragRight = dragTop = dragBottom = false;
					if (rotatedInput.x > coffX + ex + ew - handleSize) dragRight = true;
					else if (rotatedInput.x < coffX + ex + handleSize) dragLeft = true;
					if (rotatedInput.y > coffY + ey + eh - handleSize) dragBottom = true;
					else if (rotatedInput.y < coffY + ey + handleSize) dragTop = true;

					startObjectManipulation(true);

				} else {
					var rotHandleCenter = new Vector2(coffX + ex + ew / 2, coffY + ey - handleSize * 2);
					var inputPos = rotatedInput.sub(rotHandleCenter);

					// Rotate selected object
					if (inputPos.length <= handleSize) {
						rotate = true;
						startObjectManipulation(true);
					}
				}
			}

			if (isManipulating) {
				App.propwin.redraws = 2;

				// Confirm
				if ((transformStartedMouse && ui.inputReleased) || (!transformStartedMouse && ui.inputStarted)) {
					endObjectManipulation();

				// Reset
				} else if ((ui.isKeyPressed && ui.isEscapeDown) || ui.inputStartedR) {
					endObjectManipulation(true);

				} else if (drag) {
					var transformDelta = new Vector2(ui.inputX, ui.inputY).sub(transformInitInput);

					if (!transformStartedMouse) {
						if (ui.isKeyPressed && ui.key == KeyCode.X) {
							obj.width = Std.int(transformInitSize.x);
							obj.height = Std.int(transformInitSize.y);
							dragRight = true;
							dragBottom = !dragBottom;
						}
						if (ui.isKeyPressed && ui.key == KeyCode.Y) {
							obj.width = Std.int(transformInitSize.x);
							obj.height = Std.int(transformInitSize.y);
							dragBottom = true;
							dragRight = !dragRight;
						}
					}

					if (dragRight) {
						transformDelta.x = calculateTransformDelta(transformDelta.x, transformInitPos.x + transformInitSize.x);
						obj.width = Std.int(transformInitSize.x + transformDelta.x);
					} else if (dragLeft) {
						transformDelta.x = calculateTransformDelta(transformDelta.x, transformInitPos.x);
						obj.x = transformInitPos.x + transformDelta.x;
						obj.width = Std.int(transformInitSize.x - transformDelta.x);
					}
					if (dragBottom) {
						transformDelta.y = calculateTransformDelta(transformDelta.y, transformInitPos.y + transformInitSize.y);
						obj.height = Std.int(transformInitSize.y + transformDelta.y);
					}
					else if (dragTop) {
						transformDelta.y = calculateTransformDelta(transformDelta.y, transformInitPos.y);
						obj.y = transformInitPos.y + transformDelta.y;
						obj.height = Std.int(transformInitSize.y - transformDelta.y);
					}


					if (!dragLeft && !dragRight && !dragBottom && !dragTop) {
						grab = true;
						grabX = true;
						grabY = true;
						drag = false;
					} else {
						// Ensure there the delta is 0 on unused axes
						if (!dragBottom && !dragTop) transformDelta.y = 0;
						else if (!dragLeft && !dragRight) transformDelta.y = 0;
					}

				} else if (grab) {
					var transformDelta = new Vector2(ui.inputX, ui.inputY).sub(transformInitInput);

					if (ui.isKeyPressed && ui.key == KeyCode.X) {
						obj.x = transformInitPos.x;
						obj.y = transformInitPos.y;
						grabX = true;
						grabY = !grabY;
					}
					if (ui.isKeyPressed && ui.key == KeyCode.Y) {
						obj.x = transformInitPos.x;
						obj.y = transformInitPos.y;
						grabY = true;
						grabX = !grabX;
					}

					if (grabX) {
						transformDelta.x = calculateTransformDelta(transformDelta.x, transformInitPos.x);
						obj.x = Std.int(transformInitPos.x + transformDelta.x);
					}
					if (grabY) {
						transformDelta.y = calculateTransformDelta(transformDelta.y, transformInitPos.y);
						obj.y = Std.int(transformInitPos.y + transformDelta.y);
					}

					// Ensure there the delta is 0 on unused axes
					if (!grabX) transformDelta.x = 0;
					else if (!grabY) transformDelta.y = 0;

				} else if (rotate) {
					var elemCenter = new Vector2(coffX + ex + ew / 2, coffY + ey + eh / 2);
					var inputPos = new Vector2(ui.inputX, ui.inputY).sub(elemCenter);

					// inputPos.x and inputPos.y are both positive when the mouse is in the lower right
					// corner of the Objects center, so the positive x axis used for the angle calculation
					// in atan2() is equal to the global negative y axis. That's why we have to invert the
					// angle and add Pi to get the correct rotation. atan2() also returns an angle in the
					// intervall (-PI, PI], so we don't have to calculate the angle % PI*2 anymore.
					var inputAngle = -Math.atan2(inputPos.x, inputPos.y) + Math.PI;

					// Ctrl toggles rotation step mode
					if ((ui.isKeyDown && ui.key == Control) != useRotationSteps) {
						inputAngle = Math.round(inputAngle / util.Math.toRadians(rotationSteps)) * util.Math.toRadians(rotationSteps);
					}

					obj.rotation = inputAngle;
				}
			}

			if (ui.isKeyPressed && !ui.isTyping) {
				if (!grab && ui.key == G){startObjectManipulation(); grab = true; grabX = true; grabY = true;}
				if (!drag && ui.key == S) {startObjectManipulation(); drag = true; dragLeft = false; dragTop = false; dragRight = true; dragBottom = true;}
				if (!rotate && ui.key == R) {startObjectManipulation(); rotate = true;}

				if (!isManipulating) {
					// Move with arrows
					if (ui.key == KeyCode.Left) gridSnapPos ? obj.x -= gridSize : obj.x--;
					if (ui.key == KeyCode.Right) gridSnapPos ? obj.x += gridSize : obj.x++;
					if (ui.key == KeyCode.Up) gridSnapPos ? obj.y -= gridSize : obj.y--;
					if (ui.key == KeyCode.Down) gridSnapPos ? obj.y += gridSize : obj.y++;
                    //TODO: do below
					// if (ui.isBackspaceDown || ui.isDeleteDown) removeSelectedElem();
					// else if (ui.key == KeyCode.D) selectedObj = duplicateElem(obj);
				}
			}
		} else {
			endObjectManipulation();
		}
    }

    static function startObjectManipulation(?mousePressed=false) {
        var selectedObj = App.selectedObj;
		if (isManipulating) endObjectManipulation(true);

		transformInitInput = new Vector2(ui.inputX, ui.inputY);
		transformInitPos = new Vector2(selectedObj.x, selectedObj.y);
		transformInitSize = new Vector2(selectedObj.width, selectedObj.height);
		transformInitRot = selectedObj.rotation;
		transformStartedMouse = mousePressed;

		isManipulating = true;
	}

	static function endObjectManipulation(reset=false) {
        var selectedObj = App.selectedObj;
		if (reset) {
			selectedObj.x = transformInitPos.x;
			selectedObj.y = transformInitPos.y;
			selectedObj.width = Std.int(transformInitSize.x);
			selectedObj.height = Std.int(transformInitSize.y);
			selectedObj.rotation = transformInitRot;
		}

		isManipulating = false;

		grab = false;
		drag = false;
		rotate = false;

		transformStartedMouse = false;
	}

    static function calculateTransformDelta(value:Float, ?offset=0.0):Float {
		var gridSize = App.gridSize;
		var gridSnapPos = App.gridSnapPos;
		var gridUseRelative = App.gridUseRelative;

		var precisionMode = ui.isKeyDown && ui.key == Shift;
		var enabled = gridSnapPos != (ui.isKeyDown && (ui.key == Control));
		var useOffset = gridUseRelative != (ui.isKeyDown && (ui.key == Alt));

		if (!enabled) return precisionMode ? value / 2 : value;

		// Round the delta value to steps of gridSize
		value = Math.round(value / gridSize) * gridSize;

		if (precisionMode) value /= 2;

		// Apply an offset
		if (useOffset && offset != 0) {
			offset = offset % gridSize;

			// Round to nearest grid position instead of rounding off
			if (offset > gridSize / 2) {
				offset = -(gridSize - offset);
			}

			value -= offset;
		}
		return value;
	}

}