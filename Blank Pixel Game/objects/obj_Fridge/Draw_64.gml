if (!menu_open) exit;

var _n = array_length(global.fridge_foods);
var _cell = 24;
var _w = _n * _cell + 8;
var _h = _cell + 8;
var _x1 = (display_get_gui_width() - _w) div 2;
var _y1 = 6;

draw_set_alpha(0.85);
draw_set_colour(make_colour_rgb(30, 34, 48));
draw_rectangle(_x1, _y1, _x1 + _w, _y1 + _h, false);
draw_set_alpha(1);
draw_set_colour(make_colour_rgb(180, 190, 210));
draw_rectangle(_x1, _y1, _x1 + _w, _y1 + _h, true);

for (var i = 0; i < _n; i++)
{
	var _cx = _x1 + 4 + i * _cell + _cell div 2;
	var _cy = _y1 + 4 + _cell div 2;
	if (i == menu_index)
	{
		draw_set_colour(c_yellow);
		draw_rectangle(_cx - _cell div 2, _cy - _cell div 2, _cx + _cell div 2 - 1, _cy + _cell div 2 - 1, true);
	}
	global.draw_food(global.fridge_foods[i], "raw", _cx, _cy, 1);
}

draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_text_transformed(_x1 + _w / 2, _y1 + _h + 2, string_replace_all(global.fridge_foods[menu_index], "_", " "), 0.5, 0.5, 0);
draw_set_halign(fa_left);
