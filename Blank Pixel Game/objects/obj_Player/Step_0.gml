if (global.game_over != "" || global.in_story || global.tutorial_active) exit;

for (var i = array_length(global.burn_times) - 1; i >= 0; i--)
{
	if (current_time >= global.burn_times[i])
	{
		array_delete(global.burn_times, i, 1);
		sad_timer = game_get_speed(gamespeed_fps) * 2;
		global.mistakes++;
	}
}

if (sad_timer > 0)
{
	sad_timer--;
	sprite_index = spr_chef_sad;
	image_speed = 0;
	image_index = 0;
	depth = -(y + 9);
	exit;
}

if (e_lock > 0) e_lock--;

if (in_menu)
{
	image_speed = 0;
	depth = -(y + 9);
	exit;
}

var right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var down  = keyboard_check(vk_down)  || keyboard_check(ord("S"));
var up    = keyboard_check(vk_up)    || keyboard_check(ord("W"));

var hor = right - left;
var ver = down - up;

if (in_car)
{
	if (!instance_exists(current_car))
	{
		in_car = false;
		current_car = noone;
	}
	else
	{
		var _car = current_car;
		var _next_x = _car.x + hor * car_speed;
		var _next_y = _car.y + ver * car_speed;
		if (hor != 0 && !car_hits_wall(_next_x, _car.y)) _car.x = _next_x;
		if (ver != 0 && !car_hits_wall(_car.x, _next_y)) _car.y = _next_y;

		if (hor > 0) _car.car_facing = "right";
		else if (hor < 0) _car.car_facing = "left";
		else if (ver > 0) _car.car_facing = "down";
		else if (ver < 0) _car.car_facing = "up";

		x = _car.x;
		y = _car.y;
		depth = -(y + 18);
		_car.depth = depth;

		// Enter the neighborhood through the parking lot's south road opening.
		// Trigger before the car reaches the invisible room-edge collision.
		if (room == Parking_Lot && _car.y >= room_height - 64 && _car.x >= 145 && _car.x <= 270)
		{
			_car.car_room = Neighborhood;
			_car.x = 240;
			_car.y = 68;
			global.spawn_x = _car.x;
			global.spawn_y = _car.y;
			room_goto(Neighborhood);
			exit;
		}
		// Return through the neighborhood's north road opening.
		if (room == Neighborhood && _car.y <= 40 && _car.x >= 200 && _car.x <= 280)
		{
			_car.car_room = Parking_Lot;
			_car.x = 164;
			_car.y = 205;
			global.spawn_x = _car.x;
			global.spawn_y = _car.y;
			room_goto(Parking_Lot);
			exit;
		}

		if (keyboard_check_pressed(ord("E")))
		{
			if (deliver_at_house(_car.x, _car.y)) exit;
			_car.occupied = false;
			in_car = false;
			current_car = noone;
			var _exit_x = _car.x + 24;
			var _exit_y = _car.y;
			if (hits_wall(_exit_x, _exit_y)) _exit_x = _car.x - 24;
			if (hits_wall(_exit_x, _exit_y)) { _exit_x = _car.x; _exit_y = _car.y + 27; }
			x = _exit_x;
			y = _exit_y;
			e_lock = 12;
		}
		exit;
	}
}

var xspd = hor * move_speed;
var yspd = ver * move_speed;

if (hits_wall(x + xspd, y))
{
	while (!hits_wall(x + sign(xspd), y)) x += sign(xspd);
	xspd = 0;
}
x += xspd;

if (hits_wall(x, y + yspd))
{
	while (!hits_wall(x, y + sign(yspd))) y += sign(yspd);
	yspd = 0;
}
y += yspd;

x = clamp(x, 6, room_width - 6);
y = clamp(y, 15, room_height - 10);

var door = instance_place(x, y, obj_door);
var _is_car_only_gate = (room == Parking_Lot && door != noone && door.target_room == Neighborhood)
	|| (room == Neighborhood && door != noone && door.target_room == Parking_Lot);
if (door != noone && !_is_car_only_gate)
{
	global.spawn_x = door.target_x;
	global.spawn_y = door.target_y;
	room_goto(door.target_room);
}

if (hor > 0) facing = "right";
else if (hor < 0) facing = "left";
else if (ver > 0) facing = "down";
else if (ver < 0) facing = "up";

var moving = (hor != 0 || ver != 0);
switch (facing)
{
	case "down":  sprite_index = moving ? spr_chef_walk_down : spr_chef_idle; break;
	case "up":    sprite_index = spr_chef_walk_up;    break;
	case "left":  sprite_index = spr_chef_walk_left;  break;
	case "right": sprite_index = spr_chef_walk_right; break;
}

if (!moving && facing != "down")
{
	image_speed = 0;
	image_index = 0;
}
else
{
	image_speed = 1;
}

if (keyboard_check_pressed(ord("E")) && e_lock == 0)
{
	if (deliver_at_house(x, y)) exit;

	var _nearby_car = instance_nearest(x, y, obj_Car);
	if (_nearby_car != noone && room == _nearby_car.car_room && !_nearby_car.occupied && point_distance(x, y, _nearby_car.x, _nearby_car.y) < 48)
	{
		if (!global.car_owned && room == Parking_Lot)
		{
			if (global.money >= 100)
			{
				global.money -= 100;
				global.car_owned = true;
				global.car_feedback = "Car purchased for $100";
				global.car_feedback_until = current_time + 2500;
			}
			else
			{
				global.car_feedback = "The car costs $100";
				global.car_feedback_until = current_time + 2500;
			}
		}
		if (global.car_owned)
		{
			in_car = true;
			current_car = _nearby_car;
			_nearby_car.occupied = true;
			x = _nearby_car.x;
			y = _nearby_car.y;
			facing = _nearby_car.car_facing;
		}
	}
	else
	{
		var fridge = instance_nearest(x, y, obj_Fridge);
		var stove = instance_nearest(x, y, obj_Stove);
		var trash = instance_nearest(x, y, obj_Trash);
		var table = instance_nearest(x, y, obj_Table);
		if (fridge != noone && point_distance(x, y, fridge.x, fridge.y) < 28) fridge.use(id);
		else if (stove != noone && point_distance(x, y, stove.x, stove.y) < 28) stove.use(id);
		else if (trash != noone && point_distance(x, y, trash.x, trash.y) < 28) trash.use(id);
		else if (table != noone && point_distance(x, y, table.x, table.y) < 36) table.serve(id);
	}
}

depth = -(y + 9);
