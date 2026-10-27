var _p = get_prompt();
if (_p == undefined) exit;

var _cam = view_camera[0];
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _gx = (_p.px - camera_get_view_x(_cam)) * _gw / camera_get_view_width(_cam);
var _gy = (_p.py - camera_get_view_y(_cam)) * _gh / camera_get_view_height(_cam);

var _ts = 0.3;
var _ks = 0.55;
var _line_h = string_height("E") * _ts;
var _key = _p.key ? string_height("E") * _ks + 2 : 0;
var _meter = variable_struct_exists(_p, "meter") ? _p.meter : noone;
var _w = round(max(_key, string_width(_p.line1) * _ts, string_width(_p.line2) * _ts, (_meter != noone) ? 28 : 0) + 8);
var _h = round(4 + _key + (_p.key ? 3 : 0) + _line_h * 2 + 5 + ((_meter != noone) ? 10 : 0));
var _x1 = round(clamp(_gx - _w / 2, 2, _gw - _w - 2));
var _y1 = round(clamp(_gy - _h - 3, 2, _gh - _h - 2));
var _cx = _x1 + _w / 2;
var _gold = make_colour_rgb(255, 203, 93);

draw_set_colour(make_colour_rgb(72, 43, 20));
draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, false);
draw_set_colour(_gold);
draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
var _ty = _y1 + 4;
if (_p.key)
{
	var _kx = round(_cx - _key / 2);
	draw_set_colour(make_colour_rgb(50, 34, 22));
	draw_rectangle(_kx, _ty, _kx + _key, _ty + _key, false);
	draw_set_colour(_gold);
	draw_rectangle(_kx, _ty, _kx + _key, _ty + _key, true);
	draw_set_colour(c_white);
	draw_text_transformed(_cx, _ty + 1, "E", _ks, _ks, 0);
	_ty += _key + 3;
}
draw_set_colour(c_white);
draw_text_transformed(_cx, _ty, _p.line1, _ts, _ts, 0);
draw_text_transformed(_cx, _ty + _line_h + 1, _p.line2, _ts, _ts, 0);
if (_meter != noone && instance_exists(_meter)) _meter.draw_meter(round(_cx - 13), round(_ty + _line_h * 2 + 6));
draw_set_halign(fa_left);
