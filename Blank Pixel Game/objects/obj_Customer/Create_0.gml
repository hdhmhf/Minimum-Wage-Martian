sprite_index = choose(spr_customer_1, spr_customer_2, spr_customer_3, spr_customer_4);
image_xscale = 0.125;
image_yscale = 0.125;
image_speed = 0;
depth = -y;

state = "walking";
walk_speed = 1;
spot_x = table.x - 32;
spot_y = table.y + 1;
exit_x = 160;
exit_y = 186;

wants = global.fridge_foods[irandom(array_length(global.fridge_foods) - 1)];
patience_ms = 30000;
ticket = { ends: 0, done: false, angry: false };
eat_end = 0;

leave = function()
{
	state = "leaving";
	table.customer = noone;
}

walk_to = function(_x, _y)
{
	if (point_distance(x, y, _x, _y) <= walk_speed)
	{
		x = _x;
		y = _y;
		return true;
	}
	var _dir = point_direction(x, y, _x, _y);
	x += lengthdir_x(walk_speed, _dir);
	y += lengthdir_y(walk_speed, _dir);
	return false;
}
