if (room != cart_room) exit;

var _spr = spr_cart_front;
if (facing == "up") _spr = spr_cart_back;
else if (facing == "left") _spr = spr_cart_left;
else if (facing == "right") _spr = spr_cart_right;
draw_sprite_ext(_spr, 0, x, y, draw_scale, draw_scale, 0, c_white, 1);

var _n = array_length(dishes);
for (var i = 0; i < _n; i++)
{
	var _dx = x + (i - (_n - 1) / 2) * 8;
	global.draw_plate(_dx, y - 10, 4, false);
	global.draw_food(dishes[i].food, dishes[i].state, _dx, y - 12, 0.45);
}
