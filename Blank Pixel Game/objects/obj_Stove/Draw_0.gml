draw_self();

if (state == "cooking")
{
	var _state = "good";
	if (progress < perfect_min - 0.25) _state = "raw";
	else if (progress >= 0.95) _state = "burnt";
	global.draw_food(food, _state, x, y - 12, 1);

	var _w = 24, _h = 3;
	var _x1 = x - _w / 2, _y1 = bbox_top - 6;
	draw_set_colour(c_dkgray); draw_rectangle(_x1 - 1, _y1 - 1, _x1 + _w + 1, _y1 + _h + 1, false);
	draw_set_colour(c_lime);   draw_rectangle(_x1 + _w * perfect_min, _y1, _x1 + _w * perfect_max, _y1 + _h, false);
	draw_set_colour(c_red);    draw_rectangle(_x1 + _w * 0.95, _y1, _x1 + _w, _y1 + _h, false);
	draw_set_colour(c_white);
	var _nx = _x1 + _w * progress;
	draw_line(_nx, _y1 - 2, _nx, _y1 + _h + 2);
}