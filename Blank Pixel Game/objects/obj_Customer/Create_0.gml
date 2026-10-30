sprite_index = choose(spr_customer_1, spr_customer_2, spr_customer_3, spr_customer_4);
image_xscale = 0.125;
image_yscale = 0.125;
image_speed = 0;
depth = -y;

state = "walking";
walk_speed = 1;
spot_x = table.x - 18;
spot_y = table.y + 1;
exit_x = 160;
exit_y = 186;

if (!variable_instance_exists(id, "ticket")) ticket = global.new_ticket(global.patience_by_day[max(0, global.day - 1)]);
wants = ticket.food;
wants_toppings = ticket.toppings;
eat_end = 0;
pay_text = "";
pay_until = 0;
day_serial = global.day_serial;
if (ticket.tutorial) global.tut_table = table;
if (variable_instance_exists(id, "seated") && seated)
{
	x = spot_x;
	y = spot_y;
	state = "waiting";
}

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
