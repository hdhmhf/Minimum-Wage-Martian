if (!open) exit;

var _t = (current_time - phase_t) / 400;
var _scene = true;
var _black = 0;
var _oy = 0;
if (phase == "in")
{
	if (_t < 0.4)
	{
		_scene = false;
		_black = _t / 0.4;
	}
	else
	{
		_black = 1 - (_t - 0.4) / 0.6;
		_oy = 24 * clamp(_black, 0, 1);
	}
}
else if (phase == "out")
{
	if (_t < 0.5)
	{
		_black = _t / 0.5;
		_oy = 24 * _black;
	}
	else
	{
		_scene = false;
		_black = 1 - (_t - 0.5) / 0.5;
	}
}
_black = clamp(_black, 0, 1);
if (_scene) draw_scene(_oy);
if (_black > 0)
{
	draw_set_alpha(_black);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, 320, 180, false);
	draw_set_alpha(1);
	draw_set_colour(c_white);
}
