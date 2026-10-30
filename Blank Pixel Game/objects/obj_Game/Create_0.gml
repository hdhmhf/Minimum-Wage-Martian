display_set_gui_size(320, 180);

global.money = 0;
global.mistakes = 0;
global.max_mistakes = 5;
global.game_over = "";
global.lose_reason = "";
global.tickets = [];
global.arrivals = [];
global.burn_times = [];
global.car_owned = false;
global.car_feedback = "";
global.car_feedback_until = 0;
global.order_mode = "restaurant";
global.neighborhood_orders = [];
global.orders_open = true;
global.orders_scale = min((display_get_gui_height() - 12) / 400, (display_get_gui_width() - 20) / 400);
global.orders_x = (display_get_gui_width() - 400 * global.orders_scale) / 2;
global.orders_y = (display_get_gui_height() - 400 * global.orders_scale) / 2;
global.tablet_open = false;
global.tablet_button_alpha = 1;
global.orders_dragging = false;
global.orders_resizing = false;
global.orders_drag_moved = false;
global.orders_drag_offset_x = 0;
global.orders_drag_offset_y = 0;
global.orders_drag_start_x = 0;
global.orders_drag_start_y = 0;

next_spawn = current_time + 3000;
next_neighborhood_order = current_time + 5000;
summary_lock = 0;

global.in_story = true;
global.tutorial_active = false;
story_frame = 0;
story_start_time = current_time;

global.day = 0;
global.max_days = 5;
global.day_state = "story";
global.day_length = 180000;
global.day_end = 0;
global.day_earned = 0;
global.day_passed = false;
global.day_serial = 0;
global.quotas = [40, 70, 100, 130, 160];
global.patience_by_day = [70000, 62000, 56000, 50000, 45000];
global.spawn_by_day = [[14000, 20000], [12000, 18000], [11000, 16000], [10000, 14000], [9000, 13000]];
global.plates_total = 5;
global.clean_plates = global.plates_total;
global.sink_dirty = 0;
global.plates_washed = 0;
global.board_open = false;
global.cart_ui_open = false;
global.tut_step = 0;
global.tut_moved = 0;
global.tut_until = 0;
global.tut_ticket = undefined;
global.tut_table = noone;
global.tut_wash_base = 0;

global.condiments = [
	{ id: "ketchup",     name: "Ketchup",      spr: spr_ketchup_bottle,         anim: spr_ketchup_animation,              colour: make_colour_rgb(214, 40, 40) },
	{ id: "bbq",         name: "BBQ Sauce",    spr: spr_bbq_dressing,           anim: spr_bbq_dressing_animation,         colour: make_colour_rgb(120, 52, 24) },
	{ id: "mustard",     name: "Mustard",      spr: spr_mustard_dressing,       anim: spr_mustard_dressing_animation,     colour: make_colour_rgb(232, 200, 48) },
	{ id: "hot_sauce",   name: "Hot Sauce",    spr: spr_hot_sauce_dressing,     anim: spr_hot_sauce_dressing_animation,   colour: make_colour_rgb(240, 120, 24) },
	{ id: "cheese",      name: "Cheese Sauce", spr: spr_cheese_dressing,        anim: spr_cheese_dressing_animation,      colour: make_colour_rgb(236, 206, 80) },
	{ id: "blue_cheese", name: "Blue Cheese",  spr: spr_blue_cheese_dressing,   anim: spr_blue_cheese_dressing_animation, colour: make_colour_rgb(200, 214, 200) },
	{ id: "caesar",      name: "Caesar",       spr: spr_ceasear_dressing,       anim: spr_ceasear_dressing_animation,     colour: make_colour_rgb(226, 214, 160) },
	{ id: "vinegar",     name: "Vinegar",      spr: spr_vinegar_bottle,         anim: spr_vinegar_animation,              colour: make_colour_rgb(220, 226, 230) },
	{ id: "basil",       name: "Basil",        spr: spr_basil_leaf_topping,     anim: -1,                                 colour: make_colour_rgb(70, 150, 60) },
	{ id: "chives",      name: "Chives",       spr: spr_pile_of_chives_topping, anim: -1,                                 colour: make_colour_rgb(110, 190, 70) },
];

global.condiment_by_id = function(_id)
{
	for (var i = 0; i < array_length(global.condiments); i++) if (global.condiments[i].id == _id) return global.condiments[i];
	return global.condiments[0];
}

global.food_label = function(_food, _state)
{
	if (_food == "Cookie" && _state == "raw") return "Cookie dough";
	return string_replace_all(_food, "_", " ");
}

global.topping_keys = function(_t)
{
	var _keys = variable_struct_get_names(_t);
	array_sort(_keys, true);
	return _keys;
}

global.toppings_lines = function(_t)
{
	var _keys = global.topping_keys(_t);
	var _lines = [];
	for (var i = 0; i < array_length(_keys); i++) array_push(_lines, global.condiment_by_id(_keys[i]).name + " x" + string(_t[$ _keys[i]]));
	return _lines;
}

global.draw_toppings = function(_t, _x, _y, _r)
{
	var _keys = global.topping_keys(_t);
	var _k = 0;
	for (var i = 0; i < array_length(_keys); i++)
	{
		var _c = global.condiment_by_id(_keys[i]);
		for (var j = 0; j < _t[$ _keys[i]]; j++)
		{
			var _a = (_k * 137.5) mod 360;
			var _d = _r * (0.2 + 0.55 * frac(_k * 0.618 + 0.3));
			var _px = _x + lengthdir_x(_d, _a);
			var _py = _y + lengthdir_y(_d, _a) * 0.6;
			if (_c.anim == -1) draw_sprite_ext(_c.spr, 0, _px, _py, _r / 100, _r / 100, _a, c_white, 1);
			else
			{
				draw_set_colour(_c.colour);
				draw_ellipse(_px - _r * 0.22, _py - _r * 0.12, _px + _r * 0.22, _py + _r * 0.12, false);
			}
			_k++;
		}
	}
	draw_set_colour(c_white);
}

global.draw_plate = function(_x, _y, _rx, _dirty)
{
	var _ry = _rx * 0.45;
	draw_set_colour(make_colour_rgb(160, 168, 180));
	draw_ellipse(_x - _rx, _y - _ry + 1, _x + _rx, _y + _ry + 1, false);
	draw_set_colour(c_white);
	draw_ellipse(_x - _rx, _y - _ry, _x + _rx, _y + _ry, false);
	draw_set_colour(make_colour_rgb(226, 230, 238));
	draw_ellipse(_x - _rx * 0.65, _y - _ry * 0.65, _x + _rx * 0.65, _y + _ry * 0.65, false);
	if (_dirty)
	{
		draw_set_colour(make_colour_rgb(150, 110, 70));
		draw_ellipse(_x - _rx * 0.55, _y - _ry * 0.35, _x - _rx * 0.1, _y + _ry * 0.2, false);
		draw_ellipse(_x + _rx * 0.1, _y - _ry * 0.45, _x + _rx * 0.45, _y, false);
		draw_set_colour(make_colour_rgb(200, 90, 60));
		draw_ellipse(_x - _rx * 0.1, _y + _ry * 0.05, _x + _rx * 0.25, _y + _ry * 0.45, false);
	}
	draw_set_colour(c_white);
}

global.make_order = function()
{
	var _food = global.fridge_foods[irandom(array_length(global.fridge_foods) - 1)];
	var _ids = [];
	for (var i = 0; i < array_length(global.condiments); i++) array_push(_ids, global.condiments[i].id);
	_ids = array_shuffle(_ids);
	var _t = {};
	var _n = irandom_range(1, clamp(global.day, 1, 3));
	for (var i = 0; i < _n; i++) _t[$ _ids[i]] = irandom_range(1, 3);
	return { food: _food, toppings: _t };
}

global.new_ticket = function(_patience)
{
	var _o = global.make_order();
	return { food: _o.food, toppings: _o.toppings, ends: current_time + _patience, patience: _patience, done: false, angry: false, tutorial: false, arrive: current_time };
}

global.score_toppings = function(_want, _got)
{
	var _tip = 0;
	var _exact = true;
	var _wk = variable_struct_get_names(_want);
	for (var i = 0; i < array_length(_wk); i++)
	{
		var _g = variable_struct_exists(_got, _wk[i]) ? _got[$ _wk[i]] : 0;
		if (_g == _want[$ _wk[i]]) _tip += 4;
		else
		{
			_exact = false;
			if (_g > 0) _tip += 1;
		}
	}
	var _gk = variable_struct_get_names(_got);
	for (var i = 0; i < array_length(_gk); i++)
	{
		if (!variable_struct_exists(_want, _gk[i]))
		{
			_exact = false;
			_tip -= 2;
		}
	}
	if (_exact) _tip += 5;
	return { tip: max(0, _tip), exact: _exact };
}

global.earn = function(_amount)
{
	global.money += _amount;
	global.day_earned += _amount;
}

reset_world = function()
{
	global.day_serial++;
	global.tickets = [];
	global.arrivals = [];
	global.burn_times = [];
	global.neighborhood_orders = [];
	global.clean_plates = global.plates_total;
	global.sink_dirty = 0;
	global.cart_ui_open = false;
	global.tut_table = noone;
	with (obj_Cart) dishes = [];
	with (obj_CuttingBoard) if (open) finish_close();
	with (obj_Fridge) if (menu_open) close_menu();
	with (obj_Sink) if (washing) stop_washing();
	with (obj_Customer)
	{
		if (instance_exists(table) && table.customer == id) table.customer = noone;
		instance_destroy();
	}
	with (obj_Table)
	{
		plate_food = "";
		plate_kind = "";
		plate_toppings = {};
		customer = noone;
		day_serial = global.day_serial;
	}
	with (obj_Stove)
	{
		state = "empty";
		food = "";
		day_serial = global.day_serial;
	}
	with (obj_Player)
	{
		holding = "";
		holding_food = "";
		holding_toppings = {};
		dirty_count = 0;
		sad_timer = 0;
		in_menu = false;
		scrubbing = false;
	}
}

start_day = function(_day)
{
	global.day = _day;
	global.day_state = "running";
	global.day_earned = 0;
	global.mistakes = 0;
	global.day_end = current_time + global.day_length;
	global.tut_step = 0;
	next_spawn = current_time + 3000;
	next_neighborhood_order = current_time + 20000;
}

end_story = function()
{
	global.in_story = false;
	global.day_state = "tutorial";
	global.tut_step = 1;
	global.tut_moved = 0;
	with (obj_Player) e_lock = 2;
	audio_stop_sound(snd_intro);
	audio_play_sound(snd_music, 1, true);
}

tut_text = function()
{
	switch (global.tut_step)
	{
		case 1: return "Welcome, little chef! Walk around with WASD or the arrow keys.";
		case 2: return "Head into the kitchen and open the fridge (E). Grab any food.";
		case 3: return "Put the food on a stove (E) to start cooking.";
		case 4: return "Watch the meter. When the needle hits the green, press E to plate it.";
		case 5: return "Take the dish to the cutting board on the counter and press E.";
		case 6: return "Click a bottle, then click to pour. Press E when you're done.";
		case 7: return "A customer is here! Serve them in the dining room: press E at their table.";
		case 8: return "They left a dirty plate. Pick it up from the table (E).";
		case 9: return "Wash it at the kitchen sink (E). You only have 5 plates!";
		case 10: return "Nice! Earn each day's quota for 5 days to keep your job. Day 1 starts now!";
	}
	return "";
}

tut_target = function()
{
	var _p = instance_find(obj_Player, 0);
	if (_p == noone) return noone;
	var _obj = noone;
	var _want_room = Kitchen;
	switch (global.tut_step)
	{
		case 2: _obj = obj_Fridge; break;
		case 3: case 4: _obj = obj_Stove; break;
		case 5: _obj = obj_CuttingBoard; break;
		case 7: case 8: _obj = obj_Table; _want_room = Dining_Area; break;
		case 9: _obj = obj_Sink; break;
		default: return noone;
	}
	if (global.tut_step == 9 && _p.holding != "dirty" && global.sink_dirty <= 0) return noone;
	if (room != _want_room)
	{
		var _door = noone;
		with (obj_door) if (target_room == _want_room) _door = id;
		return _door;
	}
	if (_obj == obj_Table)
	{
		if (global.tut_table != noone && instance_exists(global.tut_table)) return global.tut_table;
		return noone;
	}
	if (global.tut_step == 4)
	{
		var _s = noone;
		with (obj_Stove) if (state != "empty") _s = id;
		if (_s != noone) return _s;
	}
	return instance_nearest(_p.x, _p.y, _obj);
}

tut_spawn_customer = function()
{
	var _p = instance_find(obj_Player, 0);
	var _food = global.fridge_foods[0];
	var _tops = {};
	if (_p != noone && _p.has_dish())
	{
		_food = _p.holding_food;
		_tops = _p.holding_toppings;
	}
	global.tut_ticket = { food: _food, toppings: _tops, ends: current_time + 600000, patience: 600000, done: false, angry: false, tutorial: true, arrive: current_time - 10000 };
	array_push(global.tickets, global.tut_ticket);
	array_push(global.arrivals, global.tut_ticket);
}

tut_next = function()
{
	switch (global.tut_step)
	{
		case 6:
			tut_spawn_customer();
			break;
		case 9:
			global.tut_until = current_time + 4500;
			break;
		case 10:
			reset_world();
			start_day(1);
			return;
	}
	global.tut_step++;
}

tutorial_update = function()
{
	var _p = instance_find(obj_Player, 0);
	if (_p == noone) return;
	switch (global.tut_step)
	{
		case 1:
			global.tut_moved += point_distance(_p.x, _p.y, _p.xprevious, _p.yprevious);
			if (global.tut_moved > 60) global.tut_step = 2;
			break;
		case 2:
			if (_p.holding == "raw") global.tut_step = 3;
			break;
		case 3:
			var _cooking = false;
			with (obj_Stove) if (state != "empty") _cooking = true;
			if (_cooking) global.tut_step = 4;
			break;
		case 4:
			if (_p.has_dish()) global.tut_step = 5;
			break;
		case 5:
			if (global.board_open) global.tut_step = 6;
			break;
		case 6:
			if (!global.board_open)
			{
				tut_spawn_customer();
				global.tut_step = 7;
			}
			break;
		case 7:
			if (global.tut_ticket != undefined && global.tut_ticket.done) global.tut_step = 8;
			break;
		case 8:
			if (_p.holding == "dirty")
			{
				global.tut_step = 9;
				global.tut_wash_base = global.plates_washed;
			}
			break;
		case 9:
			if (global.plates_washed > global.tut_wash_base)
			{
				global.tut_step = 10;
				global.tut_until = current_time + 4500;
			}
			break;
		case 10:
			if (current_time >= global.tut_until)
			{
				reset_world();
				start_day(1);
			}
			break;
	}
}

audio_stop_sound(snd_music);
audio_play_sound(snd_intro, 1, true);
