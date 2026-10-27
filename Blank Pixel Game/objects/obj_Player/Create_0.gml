move_speed = 2;

draw_scale = 1 / 3;
facing = "down";
in_car = false;
current_car = noone;
car_speed = 3.5;

find_walls = function()
{
	walls_tilemap = -1;
	var _walls = layer_get_id("Walls");
	if (_walls != -1)
	{
		walls_tilemap = layer_tilemap_get_id(_walls);
		show_debug_message("obj_Player: walls tilemap in " + room_get_name(room) + " = " + string(walls_tilemap));
	}
	else
	{
		show_debug_message("obj_Player: no \"Walls\" layer in " + room_get_name(room) + ", nothing is solid");
	}
}
find_walls();

hits_wall = function(_x, _y)
{
	if (place_meeting(_x, _y, obj_Solid)) return true;
	if (!in_car)
	{
		var _car = instance_nearest(_x, _y, obj_Car);
		if (_car != noone && room == _car.car_room && abs(_x - _car.x) < 18 && abs(_y - _car.y) < 22) return true;
	}
	if (walls_tilemap == -1) return false;

	var _left   = bbox_left   + (_x - x);
	var _right  = bbox_right  + (_x - x);
	var _top    = bbox_top    + (_y - y);
	var _bottom = bbox_bottom + (_y - y);

	return tilemap_get_at_pixel(walls_tilemap, _left,  _top)    > 0
		|| tilemap_get_at_pixel(walls_tilemap, _right, _top)    > 0
		|| tilemap_get_at_pixel(walls_tilemap, _left,  _bottom) > 0
		|| tilemap_get_at_pixel(walls_tilemap, _right, _bottom) > 0;
}

car_hits_wall = function(_x, _y)
{
	var _hw = 14;
	var _hh = 18;
	if (_x - _hw < 4 || _x + _hw > room_width - 4 || _y - _hh < 4 || _y + _hh > room_height - 20) return true;
	// In the parking lot, keep the car on the dark asphalt: the main lot and
	// its narrow center driveway are the only driveable areas. The driveway
	// remains open to the neighborhood exit at the bottom of the room.
	if (room == Parking_Lot)
	{
		var _in_lot = (_x - _hw >= 0 && _x + _hw <= 330 && _y - _hh >= 82 && _y + _hh <= 260);
		var _in_driveway = (_x - _hw >= 145 && _x + _hw <= 270 && _y - _hh >= 210 && _y + _hh <= room_height - 20);
		if (!_in_lot && !_in_driveway) return true;
	}
	if (collision_rectangle(_x - _hw, _y - _hh, _x + _hw, _y + _hh, obj_Solid, false, true) != noone) return true;
	if (walls_tilemap == -1) return false;
	return tilemap_get_at_pixel(walls_tilemap, _x - _hw, _y - _hh) > 0
		|| tilemap_get_at_pixel(walls_tilemap, _x + _hw, _y - _hh) > 0
		|| tilemap_get_at_pixel(walls_tilemap, _x - _hw, _y + _hh) > 0
		|| tilemap_get_at_pixel(walls_tilemap, _x + _hw, _y + _hh) > 0;
}

holding = "";
holding_food = "";

global.food_info = {
	egg:            { raw: spr_egg,                raw_frame: 0, cooked: spr_egg,                   cooked_frame: 1, scale: 0.5  },
	steak:          { raw: spr_raw_steak,          raw_frame: 0, cooked: spr_cooked_steak,          cooked_frame: 0, scale: 0.25 },
	fish:           { raw: spr_raw_fish,           raw_frame: 0, cooked: spr_cooked_fish,           cooked_frame: 0, scale: 0.25 },
	butter_chicken: { raw: spr_raw_butter_chicken, raw_frame: 0, cooked: spr_cooked_butter_chicken, cooked_frame: 0, scale: 0.25 },
};
global.fridge_foods = ["egg", "steak", "fish", "butter_chicken"];

global.draw_food = function(_food, _state, _x, _y, _mult)
{
	var _info = global.food_info[$ _food];
	if (_state == "burnt")    draw_sprite_ext(spr_burnt, 0, _x, _y, 0.5 * _mult, 0.5 * _mult, 0, c_white, 1);
	else if (_state == "raw") draw_sprite_ext(_info.raw, _info.raw_frame, _x, _y, _info.scale * _mult, _info.scale * _mult, 0, c_white, 1);
	else                      draw_sprite_ext(_info.cooked, _info.cooked_frame, _x, _y, _info.scale * _mult, _info.scale * _mult, 0, c_white, 1);
}
sad_timer = 0;
in_menu = false;
e_lock = 0;
if (!variable_global_exists("burn_times")) global.burn_times = [];

deliver_at_house = function(_x, _y)
{
	if (room != Neighborhood || array_length(global.neighborhood_orders) <= 0) return false;

	var _house_names = ["Red House", "Blue House", "Orange House", "Purple House"];
	// Front doors face away from the center road: the top homes face down,
	// and the bottom homes face toward the bottom edge of the neighborhood.
	var _door_x = [70, 408, 70, 408];
	var _door_y = [88, 88, 272, 272];
	// Only accept delivery near the front door of the house named on the order.
	var _order_index = -1;
	var _near_index = -1;
	var _near_dist = 32;
	for (var i = 0; i < array_length(global.neighborhood_orders); i++)
	{
		for (var h = 0; h < 4; h++)
		{
			if (global.neighborhood_orders[i].house != _house_names[h]) continue;
			var _dist = point_distance(_x, _y, _door_x[h], _door_y[h]);
			if (_dist <= _near_dist)
			{
				_order_index = i;
				_near_index = h;
				_near_dist = _dist;
			}
		}
	}
	if (_order_index < 0) return false;
	var _near_house = _house_names[_near_index];
	var _order = global.neighborhood_orders[_order_index];

	if (_order.food == holding_food && (holding == "good" || holding == "perfect"))
	{
		array_delete(global.neighborhood_orders, _order_index, 1);
		var _pay = irandom_range(30, 50);
		global.money += _pay;
		global.car_feedback = "Delivered to " + _near_house + "! +$" + string(_pay);
		global.car_feedback_until = current_time + 2500;
		holding = "";
		holding_food = "";
	}
	else if (holding != "")
	{
		global.mistakes++;
		audio_play_sound(snd_angry, 1, false);
		holding = "";
		holding_food = "";
		global.car_feedback = "Wrong delivery! +1 OOPS";
		global.car_feedback_until = current_time + 2500;
	}
	else
	{
		global.car_feedback = "Cook " + string_replace_all(_order.food, "_", " ") + " for " + _near_house;
		global.car_feedback_until = current_time + 2500;
	}
	return true;
}

near_order_house = function(_x, _y)
{
	if (room != Neighborhood) return undefined;
	var _names = ["Red House", "Blue House", "Orange House", "Purple House"];
	var _door_x = [70, 408, 70, 408];
	var _door_y = [88, 88, 272, 272];
	var _best = undefined;
	var _best_dist = 32;
	for (var i = 0; i < array_length(global.neighborhood_orders); i++)
	{
		for (var h = 0; h < 4; h++)
		{
			if (global.neighborhood_orders[i].house != _names[h]) continue;
			var _d = point_distance(_x, _y, _door_x[h], _door_y[h]);
			if (_d <= _best_dist)
			{
				_best_dist = _d;
				_best = { px: _door_x[h], py: _door_y[h] - 12, food: global.neighborhood_orders[i].food };
			}
		}
	}
	return _best;
}

get_prompt = function()
{
	if (in_menu || sad_timer > 0 || global.in_story || global.tutorial_active || global.game_over != "") return undefined;

	var _house = near_order_house(x, y);
	if (_house != undefined)
	{
		if (holding == "good" || holding == "perfect") return { key: true, line1: "Deliver", line2: "food", px: _house.px, py: _house.py };
		return { key: false, line1: "Order:", line2: string_replace_all(_house.food, "_", " "), px: _house.px, py: _house.py };
	}

	if (in_car) return { key: true, line1: "Get out", line2: "of car", px: x, py: y - 22 };

	var _car = instance_nearest(x, y, obj_Car);
	if (_car != noone && room == _car.car_room && !_car.occupied && point_distance(x, y, _car.x, _car.y) < 48)
	{
		if (global.car_owned) return { key: true, line1: "Drive", line2: "car", px: _car.x, py: _car.y - 22 };
		if (room != Parking_Lot) return undefined;
		if (global.money >= 100) return { key: true, line1: "Buy car", line2: "$100", px: _car.x, py: _car.y - 22 };
		return { key: false, line1: "Car: $100", line2: "need $" + string(100 - global.money) + " more", px: _car.x, py: _car.y - 22 };
	}

	var _fridge = instance_nearest(x, y, obj_Fridge);
	if (_fridge != noone && point_distance(x, y, _fridge.x, _fridge.y) < 28)
	{
		if (holding == "" || holding == "raw") return { key: true, line1: "Open", line2: "fridge", px: _fridge.x, py: _fridge.bbox_top };
		return { key: false, line1: "Hands", line2: "full", px: _fridge.x, py: _fridge.bbox_top };
	}

	var _stove = instance_nearest(x, y, obj_Stove);
	if (_stove != noone && point_distance(x, y, _stove.x, _stove.y) < 28)
	{
		var _sp = { key: false, line1: "Hands", line2: "full", px: _stove.x, py: _stove.bbox_top };
		if (_stove.state == "empty" && holding == "raw") _sp = { key: true, line1: "Cook", line2: string_replace_all(holding_food, "_", " "), px: _stove.x, py: _stove.bbox_top };
		else if (_stove.state == "empty" && holding == "") _sp = { key: false, line1: "Get food", line2: "from fridge", px: _stove.x, py: _stove.bbox_top };
		else if (_stove.state != "empty" && holding == "") _sp = { key: true, line1: "Take", line2: "food", px: _stove.x, py: _stove.bbox_top };
		if (_stove.state != "empty") _sp.meter = _stove;
		return _sp;
	}

	var _trash = instance_nearest(x, y, obj_Trash);
	if (_trash != noone && point_distance(x, y, _trash.x, _trash.y) < 28)
	{
		if (holding != "") return { key: true, line1: "Throw", line2: "away", px: _trash.x, py: _trash.bbox_top };
		return undefined;
	}

	var _table = instance_nearest(x, y, obj_Table);
	if (_table != noone && point_distance(x, y, _table.x, _table.y) < 36)
	{
		if (holding != "" && _table.plate_food == "") return { key: true, line1: "Serve", line2: "food", px: _table.x, py: _table.bbox_top };
	}
	return undefined;
}
