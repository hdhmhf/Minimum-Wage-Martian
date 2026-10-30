var _stack = min(global.clean_plates, 6);
for (var i = 0; i < _stack; i++) global.draw_plate(x + 23, y - 9 - i * 1.5, 5, false);
var _dirty = min(global.sink_dirty - (washing ? 1 : 0), 6);
for (var i = 0; i < _dirty; i++) global.draw_plate(x - 23, y - 9 - i * 1.5, 5, true);
