depth = -y;
open = false;
chef = noone;
phase = "";
phase_t = 0;
skip_frame = false;
scroll = 0;
scroll_target = 0;
kb_index = 0;
hover = -1;
selected = -1;
sel_t = 0;
pour_frame = -1;
pour_id = 0;
pour_start = 0;
drops = [];
mouse_used = true;
last_mx = 0;
last_my = 0;
spacing = 34;
shelf_l = 24;
shelf_r = 296;
row_y = 152;
plate_x = 140;
plate_y = 110;
float_x = 192;
float_y = 31;
lift = array_create(array_length(global.condiments), 0);

bottle_x = function(_i)
{
	return shelf_l + 16 + _i * spacing - scroll;
}

use = function(_chef)
{
	if (!_chef.has_dish()) return;
	open = true;
	chef = _chef;
	_chef.in_menu = true;
	global.board_open = true;
	phase = "in";
	phase_t = current_time;
	selected = -1;
	pour_frame = -1;
	drops = [];
	skip_frame = true;
}

close = function()
{
	phase = "out";
	phase_t = current_time;
	selected = -1;
}

finish_close = function()
{
	open = false;
	phase = "";
	global.board_open = false;
	if (instance_exists(chef))
	{
		chef.in_menu = false;
		chef.e_lock = 2;
	}
}

add_topping = function(_id)
{
	var _t = chef.holding_toppings;
	_t[$ _id] = (variable_struct_exists(_t, _id) ? _t[$ _id] : 0) + 1;
}

pick = function(_i)
{
	if (pour_frame >= 0) return;
	if (_i == selected) selected = -1;
	else
	{
		selected = _i;
		sel_t = current_time;
	}
}

pour = function()
{
	if (selected < 0 || current_time - sel_t < 220) return;
	var _c = global.condiments[selected];
	if (_c.anim == -1)
	{
		if (array_length(drops) < 4) array_push(drops, { x: plate_x + random_range(-10, 10), y: 58, vy: 0, a: random(360), id: _c.id, spr: _c.spr });
	}
	else if (pour_frame < 0)
	{
		pour_frame = 0;
		pour_id = selected;
		pour_start = current_time;
	}
}

draw_scene = function(_oy)
{
	var _n = array_length(global.condiments);
	var _gold = make_colour_rgb(255, 203, 93);
	var _brown = make_colour_rgb(72, 43, 20);

	draw_set_colour(make_colour_rgb(58, 42, 34));
	draw_rectangle(0, 0, 320, 60 + _oy, false);
	draw_set_colour(make_colour_rgb(70, 52, 42));
	for (var i = 0; i < 5; i++)
	{
		var _ly = i * 12 + 6 + _oy;
		draw_line(0, _ly, 320, _ly);
		for (var j = 0; j < 12; j++) draw_line(j * 32 + ((i mod 2) * 16), _ly - 12, j * 32 + ((i mod 2) * 16), _ly);
	}
	draw_set_colour(make_colour_rgb(143, 86, 59));
	draw_rectangle(0, 60 + _oy, 320, 180, false);
	draw_set_colour(make_colour_rgb(123, 72, 48));
	for (var i = 0; i < 9; i++) draw_line(i * 40, 62 + _oy, i * 40 - 12, 180);
	draw_set_colour(make_colour_rgb(217, 160, 102));
	draw_rectangle(0, 58 + _oy, 320, 62 + _oy, false);

	draw_set_colour(make_colour_rgb(150, 100, 60));
	draw_roundrect(74, 86 + _oy, 206, 134 + _oy, false);
	draw_set_colour(make_colour_rgb(196, 138, 84));
	draw_roundrect(72, 84 + _oy, 204, 131 + _oy, false);

	global.draw_plate(plate_x, plate_y + _oy, 40, false);
	var _fy = plate_y - 6 + _oy;
	global.draw_food(chef.holding_food, chef.holding, plate_x, _fy, 2.2);
	global.draw_toppings(chef.holding_toppings, plate_x, _fy, 22);

	for (var i = 0; i < array_length(drops); i++)
	{
		var _d = drops[i];
		draw_sprite_ext(_d.spr, 0, _d.x, _d.y + _oy, 0.35, 0.35, _d.a, c_white, 1);
	}

	if (pour_frame >= 0)
	{
		var _pc = global.condiments[pour_id];
		draw_sprite_ext(_pc.anim, 1 + floor(pour_frame), 160, 75 + _oy, 1, 1, 0, c_white, 1);
	}

	draw_set_colour(make_colour_rgb(96, 58, 38));
	draw_rectangle(0, 126 + _oy, 320, 180, false);
	draw_set_colour(make_colour_rgb(130, 82, 54));
	draw_rectangle(0, 126 + _oy, 320, 128 + _oy, false);

	for (var i = 0; i < _n; i++)
	{
		if (i == selected) continue;
		var _bx = bottle_x(i);
		if (_bx < shelf_l - 20 || _bx > shelf_r + 20) continue;
		var _c = global.condiments[i];
		var _by = row_y - lift[i] + _oy;
		var _s = 0.75 * (1 + lift[i] / 60);
		if (_c.anim == -1)
		{
			global.draw_plate(_bx, row_y + 12 + _oy, 13, false);
			draw_sprite_ext(_c.spr, 0, _bx, _by + 4, _s * 0.55, _s * 0.55, 0, c_white, 1);
		}
		else draw_sprite_ext(_c.spr, 0, _bx, _by, _s, _s, 0, c_white, 1);
	}

	draw_set_colour(make_colour_rgb(96, 58, 38));
	draw_rectangle(0, 129 + _oy, shelf_l, 180, false);
	draw_rectangle(shelf_r, 129 + _oy, 320, 180, false);
	var _max_scroll = max(0, (_n - 1) * spacing + 32 - (shelf_r - shelf_l));
	draw_set_colour((scroll_target > 0) ? _gold : make_colour_rgb(130, 90, 60));
	draw_triangle(6, 152 + _oy, 16, 144 + _oy, 16, 160 + _oy, false);
	draw_set_colour((scroll_target < _max_scroll) ? _gold : make_colour_rgb(130, 90, 60));
	draw_triangle(314, 152 + _oy, 304, 144 + _oy, 304, 160 + _oy, false);

	if (selected >= 0)
	{
		var _c = global.condiments[selected];
		var _p = clamp((current_time - sel_t) / 220, 0, 1);
		_p = 1 - power(1 - _p, 3);
		var _tx = float_x, _ty = float_y, _ta = 135, _ts = 1;
		if (_c.anim == -1)
		{
			_tx = plate_x;
			_ty = 46;
			_ta = 0;
			_ts = 0.55;
		}
		else if (pour_frame >= 0) _ta += 6 * sin(current_time / 60);
		var _bob = sin(current_time / 300) * 2 * _p;
		var _s = lerp(0.75, _ts, _p);
		draw_sprite_ext(_c.spr, 0, lerp(bottle_x(selected), _tx, _p), lerp(row_y, _ty, _p) + _bob + _oy, _s, _s, lerp(0, _ta, _p), c_white, 1);
	}

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	if (hover >= 0 && hover != selected)
	{
		var _hn = global.condiments[hover].name;
		var _hx = clamp(bottle_x(hover), shelf_l + 20, shelf_r - 20);
		var _hw = string_width(_hn) * 0.3 + 6;
		draw_set_alpha(0.85);
		draw_set_colour(c_black);
		draw_roundrect(_hx - _hw / 2, 113 + _oy, _hx + _hw / 2, 122 + _oy, false);
		draw_set_alpha(1);
		draw_set_colour(c_white);
		draw_text_transformed(_hx, 114 + _oy, _hn, 0.3, 0.3, 0);
	}
	if (selected >= 0)
	{
		draw_set_colour(_gold);
		var _verb = (global.condiments[selected].anim == -1) ? "Click to sprinkle" : "Click to pour";
		draw_text_transformed(250, 62 + _oy, global.condiments[selected].name, 0.34, 0.34, 0);
		draw_set_colour(c_white);
		draw_text_transformed(250, 70 + _oy, _verb, 0.28, 0.28, 0);
	}
	draw_set_colour(make_colour_rgb(220, 200, 170));
	draw_text_transformed(132, 4 + _oy, "Click a bottle to pick it up", 0.27, 0.27, 0);
	draw_text_transformed(132, 11 + _oy, "A/D or wheel: slide", 0.27, 0.27, 0);
	draw_set_halign(fa_left);

	draw_set_alpha(0.9);
	draw_set_colour(_brown);
	draw_roundrect(4, 4 + _oy, 100, 70 + _oy, false);
	draw_set_alpha(1);
	draw_set_colour(_gold);
	draw_roundrect(4, 4 + _oy, 100, 70 + _oy, true);
	draw_text_transformed(8, 6 + _oy, "YOUR DISH", 0.3, 0.3, 0);
	draw_set_colour(c_white);
	draw_text_transformed(8, 14 + _oy, global.food_label(chef.holding_food, chef.holding), 0.36, 0.36, 0);
	var _lines = global.toppings_lines(chef.holding_toppings);
	if (array_length(_lines) == 0)
	{
		draw_set_colour(make_colour_rgb(200, 170, 120));
		draw_text_transformed(8, 25 + _oy, "No toppings yet", 0.28, 0.28, 0);
	}
	for (var i = 0; i < min(array_length(_lines), 6); i++) draw_text_transformed(8, 25 + i * 7 + _oy, _lines[i], 0.28, 0.28, 0);

	var _hot = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 4, 74, 60, 88);
	draw_set_colour(_hot ? make_colour_rgb(110, 70, 34) : make_colour_rgb(50, 34, 22));
	draw_roundrect(4, 74 + _oy, 60, 88 + _oy, false);
	draw_set_colour(_gold);
	draw_roundrect(4, 74 + _oy, 60, 88 + _oy, true);
	draw_set_halign(fa_center);
	draw_text_transformed(32, 77 + _oy, "E: Done", 0.34, 0.34, 0);
	draw_set_halign(fa_left);

	var _orders = [];
	for (var i = 0; i < array_length(global.tickets); i++)
	{
		var _tk = global.tickets[i];
		if (!_tk.done && _tk.food == chef.holding_food) array_push(_orders, _tk);
	}
	if (array_length(_orders) > 0)
	{
		var _oh = 14;
		for (var i = 0; i < min(array_length(_orders), 2); i++) _oh += 4 + 7 * max(1, array_length(global.topping_keys(_orders[i].toppings)));
		draw_set_alpha(0.9);
		draw_set_colour(_brown);
		draw_roundrect(226, 80 + _oy, 316, 80 + _oh + _oy, false);
		draw_set_alpha(1);
		draw_set_colour(_gold);
		draw_roundrect(226, 80 + _oy, 316, 80 + _oh + _oy, true);
		draw_text_transformed(230, 82 + _oy, "ORDERS FOR THIS", 0.28, 0.28, 0);
		var _oy2 = 91;
		for (var i = 0; i < min(array_length(_orders), 2); i++)
		{
			var _ol = global.toppings_lines(_orders[i].toppings);
			var _ok = global.topping_keys(_orders[i].toppings);
			for (var k = 0; k < array_length(_ol); k++)
			{
				var _id = _ok[k];
				var _have = variable_struct_exists(chef.holding_toppings, _id) ? chef.holding_toppings[$ _id] : 0;
				draw_set_colour((_have == _orders[i].toppings[$ _id]) ? make_colour_rgb(120, 220, 120) : c_white);
				draw_text_transformed(232, _oy2 + _oy, "- " + _ol[k], 0.28, 0.28, 0);
				_oy2 += 7;
			}
			_oy2 += 4;
		}
	}
	draw_set_colour(c_white);
}
