if (!washing && array_length(bubbles) == 0) exit;

var _cam = view_camera[0];
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _k = _gw / camera_get_view_width(_cam);
var _sx = (x - camera_get_view_x(_cam)) * _k;
var _sy = (y - camera_get_view_y(_cam)) * (_gh / camera_get_view_height(_cam));

draw_set_colour(c_white);
for (var i = 0; i < array_length(bubbles); i++)
{
	var _b = bubbles[i];
	var _bx = (_b.x - camera_get_view_x(_cam)) * _k;
	var _by = (_b.y - camera_get_view_y(_cam)) * _k;
	draw_set_alpha(min(1, _b.life / 15));
	draw_circle(_bx, _by, _b.r, true);
}
draw_set_alpha(1);

if (!washing) exit;

var _w = 64, _h = 50;
var _x1 = round(clamp(_sx - _w / 2, 2, _gw - _w - 2));
var _y1 = round(clamp(_sy + 14, 2, _gh - _h - 2));
var _cx = _x1 + _w / 2;
var _gold = make_colour_rgb(255, 203, 93);
draw_set_colour(make_colour_rgb(72, 43, 20));
draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, false);
draw_set_colour(_gold);
draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, true);

draw_set_colour(make_colour_rgb(120, 170, 210));
draw_roundrect(_x1 + 5, _y1 + 5, _x1 + _w - 5, _y1 + 33, false);
var _t = current_time / 1000;
var _prog = clamp((current_time - wash_start) / wash_each, 0, 1);
var _wob = sin(_t * 18) * 1.5;
global.draw_plate(_cx + _wob, _y1 + 20, 16, false);
if (_prog < 0.85)
{
	draw_set_alpha(1 - _prog);
	draw_set_colour(make_colour_rgb(150, 110, 70));
	draw_ellipse(_cx - 8 + _wob, _y1 + 17, _cx - 2 + _wob, _y1 + 21, false);
	draw_set_colour(make_colour_rgb(200, 90, 60));
	draw_ellipse(_cx + 2 + _wob, _y1 + 19, _cx + 8 + _wob, _y1 + 23, false);
	draw_set_alpha(1);
}
var _spx = _cx + cos(_t * 12) * 8;
var _spy = _y1 + 19 + sin(_t * 12) * 3;
draw_set_colour(make_colour_rgb(250, 220, 70));
draw_rectangle(_spx - 4, _spy - 3, _spx + 4, _spy + 2, false);
draw_set_colour(make_colour_rgb(90, 170, 90));
draw_rectangle(_spx - 4, _spy - 3, _spx + 4, _spy - 2, false);
draw_set_colour(c_white);
for (var i = 0; i < 6; i++)
{
	var _a = _t * 90 + i * 60;
	draw_circle(_cx + lengthdir_x(14 + sin(_t * 5 + i) * 3, _a), _y1 + 20 + lengthdir_y(6, _a), 1.5, true);
}
if (current_time < sparkle_until)
{
	draw_set_colour(_gold);
	var _sp = (sparkle_until - current_time) / 400;
	for (var i = 0; i < 4; i++)
	{
		var _a = i * 90 + 45;
		draw_line(_cx + lengthdir_x(6, _a), _y1 + 20 + lengthdir_y(4, _a), _cx + lengthdir_x(6 + 10 * (1 - _sp), _a), _y1 + 20 + lengthdir_y(4 + 6 * (1 - _sp), _a));
	}
}
draw_set_colour(make_colour_rgb(50, 34, 22));
draw_rectangle(_x1 + 5, _y1 + 37, _x1 + _w - 5, _y1 + 40, false);
draw_set_colour(_gold);
draw_rectangle(_x1 + 5, _y1 + 37, _x1 + 5 + (_w - 10) * _prog, _y1 + 40, false);
draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_text_transformed(_cx, _y1 + 41, "Washing: " + string(global.sink_dirty) + " left", 0.28, 0.28, 0);
draw_set_halign(fa_left);
