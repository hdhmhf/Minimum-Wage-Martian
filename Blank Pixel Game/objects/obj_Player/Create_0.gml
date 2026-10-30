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
	Egg:            { raw: spr_egg,                raw_frame: 0, cooked: spr_egg,                   cooked_frame: 1, scale: 0.5  },
	Steak:          { raw: spr_raw_steak,          raw_frame: 0, cooked: spr_cooked_steak,          cooked_frame: 0, scale: 0.25 },
	Fish:           { raw: spr_raw_fish,           raw_frame: 0, cooked: spr_cooked_fish,           cooked_frame: 0, scale: 0.25 },
	Butter_Chicken: { raw: spr_raw_butter_chicken, raw_frame: 0, cooked: spr_cooked_butter_chicken, cooked_frame: 0, scale: 0.25},
	Carrot:         { raw: spr_raw_carrot,         raw_frame: 0, cooked: spr_cooked_carrot,         cooked_frame: 0, scale: 0.8, cooked_scale: 1 },
	Potato:         { raw: spr_raw_potato,         raw_frame: 0, cooked: spr_cooked_potato,         cooked_frame: 0, scale: 0.25},
	Cookie:         { raw: spr_raw_cookie,         raw_frame: 0, cooked: spr_cooked_cookie,         cooked_frame: 0, scale: 0.25},
	Beetroot:       { raw: spr_raw_beetroot,       raw_frame: 0, cooked: spr_cooked_beetroot,       cooked_frame: 0, scale: 0.3 },
	Bread:          { raw: spr_raw_bread,          raw_frame: 0, cooked: spr_cooked_bread,          cooked_frame: 0, scale: 0.3 },
	Corn:           { raw: spr_raw_corn,           raw_frame: 0, cooked: spr_cooked_corn,           cooked_frame: 0, scale: 0.3 },
	Mushroom:       { raw: spr_raw_mushroom,       raw_frame: 0, cooked: spr_cooked_mushroom,       cooked_frame: 0, scale: 0.3 },
	Pasta:          { raw: spr_raw_pasta,          raw_frame: 0, cooked: spr_cooked_pasta,          cooked_frame: 0, scale: 0.3 },
	Cabbage:        { raw: spr_raw_cabbage,        raw_frame: 0, cooked: spr_cooked_cabbage,        cooked_frame: 0, scale: 0.3 },
};
global.fridge_foods = ["Egg", "Steak", "Fish", "Butter_Chicken", "Carrot", "Potato", "Cookie", "Beetroot", "Bread", "Corn", "Mushroom", "Pasta", "Cabbage"];

global.draw_food = function(_food, _state, _x, _y, _mult)
{
	var _info = global.food_info[$ _food];
	var _cs = variable_struct_exists(_info, "cooked_scale") ? _info.cooked_scale : _info.scale;
	if (_state == "burnt")    draw_sprite_ext(spr_burnt, 0, _x, _y, 0.5 * _mult, 0.5 * _mult, 0, c_white, 1);
	else if (_state == "raw") draw_sprite_ext(_info.raw, _info.raw_frame, _x, _y, _info.scale * _mult, _info.scale * _mult, 0, c_white, 1);
	else                      draw_sprite_ext(_info.cooked, _info.cooked_frame, _x, _y, _cs * _mult, _cs * _mult, 0, c_white, 1);
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
		global.earn(_pay);
		global.clean_plates++;
		global.car_feedback = "Delivered to " + _near_house + "! +$" + string(_pay);
		global.car_feedback_until = current_time + 2500;
		holding = "";
		holding_food = "";
	}
	else if (holding != "" && holding != "dirty")
	{
		if (has_dish()) global.clean_plates++;
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

pushing_cart = noone;
holding_toppings = {};
dirty_count = 0;
scrubbing = false;

cart_offset = function(_facing)
{
	switch (_facing)
	{
		case "up":    return [0, -6];
		case "left":  return [-15, 2];
		case "right": return [15, 2];
	}
	return [0, 10];
}

cart_blocked = function(_x, _y)
{
	var _o = cart_offset(facing);
	var _l = _x + _o[0] - 7;
	var _r = _x + _o[0] + 7;
	var _t = _y + _o[1] + 4;
	var _b = _y + _o[1] + 9;
	if (collision_rectangle(_l, _t, _r, _b, obj_Solid, false, true) != noone) return true;
	if (walls_tilemap == -1) return false;
	return tilemap_get_at_pixel(walls_tilemap, _l, _t) > 0
		|| tilemap_get_at_pixel(walls_tilemap, _r, _t) > 0
		|| tilemap_get_at_pixel(walls_tilemap, _l, _b) > 0
		|| tilemap_get_at_pixel(walls_tilemap, _r, _b) > 0;
}

move_blocked = function(_x, _y)
{
	if (hits_wall(_x, _y)) return true;
	return pushing_cart != noone && cart_blocked(_x, _y) && !cart_blocked(x, y);
}

near_cart = function()
{
	var _cart = instance_nearest(x, y, obj_Cart);
	if (_cart != noone && _cart.cart_room == room && point_distance(x, y, _cart.x, _cart.y) < 18) return _cart;
	return noone;
}

cart_table = function()
{
	var _table = instance_nearest(x, y, obj_Table);
	if (_table != noone && point_distance(x, y, _table.x, _table.y) < 36 && _table.plate_food == "") return _table;
	return noone;
}

cart_trash = function()
{
	var _trash = instance_nearest(x, y, obj_Trash);
	if (_trash != noone && point_distance(x, y, _trash.x, _trash.y) < 28) return _trash;
	return noone;
}

cart_for_taking = function()
{
	if (holding != "") return noone;
	var _cart = (pushing_cart != noone) ? pushing_cart : near_cart();
	if (_cart != noone && array_length(_cart.dishes) > 0) return _cart;
	return noone;
}

take_from_cart = function(_cart, _i)
{
	var _d = _cart.dishes[_i];
	array_delete(_cart.dishes, _i, 1);
	holding = _d.state;
	holding_food = _d.food;
	holding_toppings = _d.toppings;
	pushing_cart = noone;
	global.cart_ui_open = false;
	e_lock = 2;
}

has_dish = function()
{
	return holding == "good" || holding == "perfect" || holding == "burnt";
}

near = function(_obj, _range)
{
	var _i = instance_nearest(x, y, _obj);
	if (_i != noone && point_distance(x, y, _i.x, _i.y) < _range) return _i;
	return noone;
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

act = function(_key, _line1, _line2, _px, _py, _kind, _target)
{
	return { key: _key, line1: _line1, line2: _line2, px: _px, py: _py, kind: _kind, target: _target, quiet: false };
}

find_action = function()
{
	if (in_menu || sad_timer > 0 || global.in_story || global.game_over != "" || global.day_state == "summary") return undefined;

	var _house = near_order_house(x, y);
	if (_house != undefined)
	{
		if (holding == "good" || holding == "perfect") return act(true, "Deliver", "food", _house.px, _house.py, "house", noone);
		return act(false, "Order:", global.food_label(_house.food, "good"), _house.px, _house.py, "house", noone);
	}

	if (in_car) return act(true, "Get out", "of car", x, y - 22, "car_exit", noone);

	if (pushing_cart != noone)
	{
		var _dishes = pushing_cart.dishes;
		var _ct = cart_table();
		if (_ct != noone && array_length(_dishes) > 0) return act(true, "Serve", global.food_label(_dishes[pushing_cart.pick_dish(_ct)].food, "good"), _ct.x, _ct.bbox_top, "cart_serve", _ct);
		var _tr = cart_trash();
		if (_tr != noone && array_length(_dishes) > 0) return act(true, "Throw away", "last dish", _tr.x, _tr.bbox_top, "cart_trash", _tr);
		var _release = act(true, "Let go", "of cart", x, y - 22, "cart_release", noone);
		_release.quiet = keyboard_check(vk_left) || keyboard_check(vk_right) || keyboard_check(vk_up) || keyboard_check(vk_down)
			|| keyboard_check(ord("A")) || keyboard_check(ord("D")) || keyboard_check(ord("W")) || keyboard_check(ord("S"));
		return _release;
	}

	var _pc = near_cart();
	if (_pc != noone && holding != "raw" && holding != "dirty")
	{
		if (holding == "") return act(true, "Push", "cart", _pc.x, _pc.y - 12, "cart_push", _pc);
		if (array_length(_pc.dishes) < _pc.max_dishes) return act(true, "Put on", "cart", _pc.x, _pc.y - 12, "cart_load", _pc);
		return act(false, "Cart", "full", _pc.x, _pc.y - 12, "none", _pc);
	}

	var _car = instance_nearest(x, y, obj_Car);
	if (_car != noone && room == _car.car_room && !_car.occupied && point_distance(x, y, _car.x, _car.y) < 48)
	{
		if (global.car_owned) return act(true, "Drive", "car", _car.x, _car.y - 22, "car_drive", _car);
		if (room != Parking_Lot) return undefined;
		if (global.money >= 100) return act(true, "Buy car", "$100", _car.x, _car.y - 22, "car_buy", _car);
		return act(false, "Car: $100", "need $" + string(100 - global.money) + " more", _car.x, _car.y - 22, "car_cost", _car);
	}

	var _fridge = near(obj_Fridge, 28);
	if (_fridge != noone)
	{
		if (holding == "" || holding == "raw") return act(true, "Open", "fridge", _fridge.x, _fridge.bbox_top, "station", _fridge);
		return act(false, "Hands", "full", _fridge.x, _fridge.bbox_top, "none", _fridge);
	}

	var _stove = near(obj_Stove, 28);
	if (_stove != noone)
	{
		var _sp = act(false, "Hands", "full", _stove.x, _stove.bbox_top, "none", _stove);
		if (_stove.state == "empty" && holding == "raw") _sp = act(true, "Cook", global.food_label(holding_food, "raw"), _stove.x, _stove.bbox_top, "station", _stove);
		else if (_stove.state == "empty" && holding == "") _sp = act(false, "Get food", "from fridge", _stove.x, _stove.bbox_top, "none", _stove);
		else if (_stove.state != "empty" && holding == "")
		{
			if (global.clean_plates > 0) _sp = act(true, "Plate", "food", _stove.x, _stove.bbox_top, "station", _stove);
			else _sp = act(false, "No plates!", "Wash dishes", _stove.x, _stove.bbox_top, "station", _stove);
		}
		if (_stove.state != "empty") _sp.meter = _stove;
		return _sp;
	}

	var _sink = near(obj_Sink, 26);
	if (_sink != noone)
	{
		if (holding == "dirty" || (holding == "" && global.sink_dirty > 0)) return act(true, "Wash", "dishes", _sink.x, _sink.y - 16, "station", _sink);
		if (holding == "") return act(false, "No dirty", "dishes", _sink.x, _sink.y - 16, "none", _sink);
	}

	var _board = near(obj_CuttingBoard, 26);
	if (_board != noone)
	{
		if (has_dish()) return act(true, "Add", "toppings", _board.x, _board.y - 16, "station", _board);
		if (holding == "") return act(false, "Bring a", "cooked dish", _board.x, _board.y - 16, "none", _board);
		if (holding == "raw") return act(false, "Cook it", "first", _board.x, _board.y - 16, "none", _board);
	}

	var _trash = near(obj_Trash, 28);
	if (_trash != noone && holding != "" && holding != "dirty") return act(true, "Throw", "away", _trash.x, _trash.bbox_top, "station", _trash);

	var _table = near(obj_Table, 36);
	if (_table != noone)
	{
		if (has_dish() && _table.plate_food == "") return act(true, "Serve", global.food_label(holding_food, holding), _table.x, _table.bbox_top, "table", _table);
		if (_table.plate_food == "dirty" && (holding == "" || (holding == "dirty" && dirty_count < 3))) return act(true, "Pick up", "dirty plate", _table.x, _table.bbox_top, "table", _table);
		if (_table.plate_food == "" && holding == "raw") return act(false, "Cook it", "first", _table.x, _table.bbox_top, "none", _table);
	}
	return undefined;
}

get_prompt = function()
{
	var _a = find_action();
	if (_a == undefined || _a.quiet) return undefined;
	return _a;
}

do_action = function(_a)
{
	switch (_a.kind)
	{
		case "house":
			deliver_at_house(x, y);
			break;
		case "cart_serve":
			pushing_cart.serve_table(_a.target);
			break;
		case "cart_trash":
			array_pop(pushing_cart.dishes);
			global.sink_dirty++;
			break;
		case "cart_release":
			pushing_cart = noone;
			break;
		case "cart_push":
			pushing_cart = _a.target;
			break;
		case "cart_load":
			array_push(_a.target.dishes, { food: holding_food, state: holding, toppings: holding_toppings });
			holding = "";
			holding_food = "";
			holding_toppings = {};
			break;
		case "car_cost":
			global.car_feedback = "The car costs $100";
			global.car_feedback_until = current_time + 2500;
			break;
		case "car_buy":
			global.money -= 100;
			global.car_owned = true;
			global.car_feedback = "Car purchased for $100";
			global.car_feedback_until = current_time + 2500;
		case "car_drive":
			in_car = true;
			current_car = _a.target;
			_a.target.occupied = true;
			x = _a.target.x;
			y = _a.target.y;
			facing = _a.target.car_facing;
			break;
		case "station":
			_a.target.use(id);
			break;
		case "table":
			_a.target.serve(id);
			break;
	}
}
