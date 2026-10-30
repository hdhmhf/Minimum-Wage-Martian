if (!menu_open) exit;

var _n = array_length(global.fridge_foods);
var _cols = min(_n, menu_cols);
var _rows = ceil(_n / _cols);
var _slot = 22;
var _gap = 3;
var _pad = 8;
var _grid_w = _cols * _slot + (_cols - 1) * _gap;
var _grid_h = _rows * _slot + (_rows - 1) * _gap;
var _th = string_height("A");
var _title_h = _th * 0.5;
var _name_h = _th * 0.45;
var _hint_h = _th * 0.3;
var _w = _grid_w + _pad * 2;
var _h = round(4 + _title_h + 6 + _grid_h + 5 + _name_h + 2 + _hint_h + 5);
var _x1 = (display_get_gui_width() - _w) div 2;
var _y1 = 6;
var _cx = _x1 + _w / 2;
var _gold = make_colour_rgb(255, 203, 93);

var _wanted = [];
with (obj_Customer) if (state == "waiting") array_push(_wanted, wants);
for (var i = 0; i < array_length(global.neighborhood_orders); i++) array_push(_wanted, global.neighborhood_orders[i].food);

draw_set_alpha(0.92);
draw_set_colour(make_colour_rgb(72, 43, 20));
draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, false);
draw_set_alpha(1);
draw_set_colour(_gold);
draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_transformed(_cx, _y1 + 4, "FRIDGE", 0.5, 0.5, 0);
var _line_y = round(_y1 + 4 + _title_h + 2);
draw_line(_x1 + _pad, _line_y, _x1 + _w - _pad, _line_y);

var _gx = _x1 + _pad;
var _gy = _line_y + 4;
for (var i = 0; i < _n; i++)
{
	var _sx = _gx + (i mod _cols) * (_slot + _gap);
	var _sy = _gy + (i div _cols) * (_slot + _gap);
	var _sel = (i == menu_index);
	draw_set_colour(_sel ? make_colour_rgb(110, 70, 34) : make_colour_rgb(50, 34, 22));
	draw_roundrect(_sx, _sy, _sx + _slot, _sy + _slot, false);
	if (_sel)
	{
		draw_set_colour(_gold);
		draw_roundrect(_sx, _sy, _sx + _slot, _sy + _slot, true);
		draw_roundrect(_sx - 1, _sy - 1, _sx + _slot + 1, _sy + _slot + 1, true);
	}
	var _bob = _sel ? round(sin(current_time / 150)) : 0;
	global.draw_food(global.fridge_foods[i], "raw", _sx + _slot / 2, _sy + _slot / 2 + _bob, _sel ? 0.95 : 0.8);
	if (array_contains(_wanted, global.fridge_foods[i]))
	{
		draw_set_colour(_gold);
		draw_circle(_sx + _slot - 3, _sy + 3, 2, false);
	}
}

var _food = global.fridge_foods[menu_index];
var _name_y = _gy + _grid_h + 5;
var _is_wanted = array_contains(_wanted, _food);
draw_set_colour(_is_wanted ? _gold : c_white);
draw_text_transformed(_cx, _name_y, global.food_label(_food, "raw") + (_is_wanted ? " - ordered!" : ""), 0.45, 0.45, 0);
draw_set_colour(make_colour_rgb(200, 170, 120));
draw_text_transformed(_cx, _name_y + _name_h + 2, "Arrows: choose    E: take    Q: close", 0.3, 0.3, 0);
draw_set_colour(c_white);
draw_set_halign(fa_left);
