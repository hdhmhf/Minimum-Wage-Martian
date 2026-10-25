if (room != car_room && !occupied) exit;

var _sprite = spr_car_back;
var _scale = 0.06;

switch (car_facing)
{
	case "down":  _sprite = spr_car_front; break;
	case "left":  _sprite = spr_car_right; _scale = 0.14; break;
	case "right": _sprite = spr_car_left;  _scale = 0.14; break;
}

// Parked cars use the matching sprite without the alien in the driver's seat.
if (!occupied)
{
	switch (car_facing)
	{
		case "down":  _sprite = spr_car_front_no_alien; break;
		case "left":  _sprite = spr_car_right_no_alien; break;
		case "right": _sprite = spr_car_left_no_alien; break;
		// The existing back sprite is already the empty rear view;
		// the *_back_no_alien asset currently contains the alien.
		default:      _sprite = spr_car_back; break;
	}
}

draw_sprite_ext(
	_sprite,
	0,
	x - sprite_get_width(_sprite) * _scale * 0.5,
	y - sprite_get_height(_sprite) * _scale * 0.5,
	_scale,
	_scale,
	0,
	c_white,
	1
);
