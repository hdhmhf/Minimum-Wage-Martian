var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _gold = make_colour_rgb(255, 203, 93);
var _brown = make_colour_rgb(72, 43, 20);

if (global.in_story)
{
	var _ss = _gh / sprite_get_height(spr_story);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, _gw, _gh, false);
	draw_sprite_ext(spr_story, story_frame, (_gw - sprite_get_width(spr_story) * _ss) / 2, 0, _ss, _ss, 0, c_white, 1);
	draw_set_colour(c_white);
	draw_set_halign(fa_right);
	draw_text_transformed(_gw - 4, _gh - 10, "Esc: skip", 0.4, 0.4, 0);
	draw_set_halign(fa_left);
	exit;
}

if (global.game_over != "")
{
	var _spr = (global.game_over == "win") ? spr_win : spr_lose;
	var _s = _gh / sprite_get_height(_spr);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, _gw, _gh, false);
	draw_sprite_ext(_spr, 0, (_gw - sprite_get_width(_spr) * _s) / 2, 0, _s, _s, 0, c_white, 1);
	draw_set_colour(c_white);
	if (global.game_over == "lose" && global.lose_reason != "")
	{
		draw_set_halign(fa_center);
		draw_text_transformed(_gw / 2, _gh - 22, global.lose_reason, 0.42, 0.42, 0);
	}
	draw_set_halign(fa_right);
	draw_text_transformed(_gw - 4, _gh - 10, "R to play again", 0.4, 0.4, 0);
	draw_set_halign(fa_left);
	exit;
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_sprite_ext(spr_money, 0, 12, 10, 0.25, 0.25, 0, c_white, 1);
draw_set_colour(c_white);
draw_text_transformed(21, 5, "$" + string(global.money), 0.5, 0.5, 0);

if (global.day_state == "running" || global.day_state == "summary")
{
	var _secs = max(0, ceil((global.day_end - current_time) / 1000));
	if (global.day_state == "summary") _secs = 0;
	var _clock = string(_secs div 60) + ":" + ((_secs mod 60 < 10) ? "0" : "") + string(_secs mod 60);
	draw_set_colour((_secs <= 25 && global.day_state == "running") ? make_colour_rgb(255, 150, 60) : c_white);
	draw_text_transformed(5, 16, "Day " + string(global.day) + "/" + string(global.max_days) + "  " + _clock, 0.38, 0.38, 0);
	var _quota = global.quotas[max(0, global.day - 1)];
	var _fill = clamp(global.day_earned / _quota, 0, 1);
	draw_set_colour(make_colour_rgb(50, 34, 22));
	draw_rectangle(5, 25, 65, 30, false);
	draw_set_colour((_fill >= 1) ? make_colour_rgb(80, 200, 90) : _gold);
	if (_fill > 0) draw_rectangle(5, 25, 5 + 60 * _fill, 30, false);
	draw_set_colour(c_white);
	draw_text_transformed(68, 24, "$" + string(global.day_earned) + "/" + string(_quota), 0.3, 0.3, 0);
}
else if (global.day_state == "tutorial")
{
	draw_set_colour(_gold);
	draw_text_transformed(5, 16, "Tutorial", 0.38, 0.38, 0);
}
global.draw_plate(10, 37, 5, false);
draw_set_colour(c_white);
draw_text_transformed(18, 34, string(global.clean_plates) + " clean plates", 0.3, 0.3, 0);

var _seg = 8;
var _gap = 2;
var _w = global.max_mistakes * (_seg + _gap) - _gap;
var _x1 = _gw - _w - 6;
draw_set_halign(fa_right);
draw_text_transformed(_x1 - 3, 5, "OOPS", 0.5, 0.5, 0);
draw_set_halign(fa_left);
for (var i = 0; i < global.max_mistakes; i++)
{
	var _sx = _x1 + i * (_seg + _gap);
	draw_set_colour((i < global.mistakes) ? c_red : make_colour_rgb(60, 60, 70));
	draw_rectangle(_sx, 6, _sx + _seg - 1, 13, false);
}
draw_set_colour(c_white);

var _ry = 18;
var _shown = 0;
for (var i = 0; i < array_length(global.tickets) && _shown < 6; i++)
{
	var _t = global.tickets[i];
	if (_t.done) continue;
	var _keys = global.topping_keys(_t.toppings);
	var _tw = 18 + array_length(_keys) * 15;
	var _tx = _gw - _tw - 4;
	draw_set_alpha(0.85);
	draw_set_colour(_brown);
	draw_roundrect(_tx, _ry, _gw - 4, _ry + 16, false);
	draw_set_alpha(1);
	draw_set_colour(_gold);
	draw_roundrect(_tx, _ry, _gw - 4, _ry + 16, true);
	global.draw_food(_t.food, "good", _tx + 9, _ry + 7, 0.4);
	for (var k = 0; k < array_length(_keys); k++)
	{
		var _c = global.condiment_by_id(_keys[k]);
		var _cx = _tx + 19 + k * 15;
		draw_sprite_ext(_c.spr, 0, _cx + 3, _ry + 7, 0.17, 0.17, 0, c_white, 1);
		draw_set_colour(c_white);
		draw_text_transformed(_cx + 8, _ry + 3, string(_t.toppings[$ _keys[k]]), 0.3, 0.3, 0);
	}
	var _left = _t.tutorial ? 1 : clamp((_t.ends - current_time) / _t.patience, 0, 1);
	draw_set_colour(merge_colour(c_red, c_lime, _left));
	draw_rectangle(_tx + 2, _ry + 13, _tx + 2 + (_gw - 8 - _tx) * _left, _ry + 14, false);
	_ry += 19;
	_shown++;
}
draw_set_colour(c_white);

var _icon_x = 5 - 30 * (1 - global.ui.tablet_button_alpha);
var _icon_y = (_gh - 38) * 0.5;
draw_set_alpha(global.ui.tablet_button_alpha);
draw_set_colour(make_colour_rgb(65, 44, 0));
draw_roundrect(_icon_x, _icon_y, _icon_x + 38, _icon_y + 38, false);
draw_set_colour(c_white);
draw_roundrect(_icon_x, _icon_y, _icon_x + 38, _icon_y + 38, true);
var _icon_s = 0.075;
draw_sprite_ext(spr_delivery_tablet, 0,
	_icon_x + 4 + sprite_get_xoffset(spr_delivery_tablet) * _icon_s,
	_icon_y + 4 + sprite_get_yoffset(spr_delivery_tablet) * _icon_s,
	_icon_s, _icon_s, 0, c_white, 1);
draw_set_alpha(1);

if (global.ui.tablet_open)
{
	var _tablet_x = global.ui.orders_x;
	var _tablet_y = global.ui.orders_y;
	var _tablet_s = global.ui.orders_scale;
	draw_sprite_ext(spr_delivery_tablet, 0,
		_tablet_x + sprite_get_xoffset(spr_delivery_tablet) * _tablet_s,
		_tablet_y + sprite_get_yoffset(spr_delivery_tablet) * _tablet_s,
		_tablet_s, _tablet_s, 0, c_white, 1);
	var _screen_x = _tablet_x + 34 * _tablet_s;
	var _screen_y = _tablet_y + 119 * _tablet_s;
	draw_set_colour(c_black);
	draw_text_transformed(_screen_x, _screen_y, "Orders", 0.38, 0.38, 0);
	if (!global.ui.orders_open)
	{
		draw_text_transformed(_screen_x, _screen_y + 20 * _tablet_s, "Tap Orders to open", 0.34, 0.34, 0);
	}
	else if (global.order_mode == "neighborhood" && global.car_owned)
	{
		var _orders = global.neighborhood_orders;
		if (array_length(_orders) == 0)
			draw_text_transformed(_screen_x, _screen_y + 20 * _tablet_s, "Waiting for orders...", 0.34, 0.34, 0);
		else
		{
			for (var i = 0; i < min(3, array_length(_orders)); i++)
			{
				var _order = _orders[i];
				var _row_y = _tablet_y + (139 + i * 62) * _tablet_s;
				var _food_name = string_replace_all(_order.food, "_", " ");
				var _seconds_left = ceil(max(0, (_order.deadline - current_time) / 1000));
				draw_text_transformed(_screen_x, _row_y, "Cooked: " + _food_name, 0.34, 0.34, 0);
				draw_text_transformed(_screen_x, _row_y + 18 * _tablet_s, "To: " + _order.house + "  " + string(_seconds_left) + "s", 0.34, 0.34, 0);
				draw_text_ext_transformed(_screen_x, _row_y + 36 * _tablet_s, global.toppings_text(_order.toppings), 14 * _tablet_s / 0.3, 330 * _tablet_s / 0.3, 0.3, 0.3, 0);
			}
		}
	}
	else if (!global.car_owned)
	{
		draw_text_transformed(_screen_x, _screen_y + 20 * _tablet_s, "Buy the car to unlock deliveries", 0.32, 0.32, 0);
	}
	else
	{
		var _rows = 0;
		for (var i = 0; i < array_length(global.tickets) && _rows < 3; i++)
		{
			var _ticket = global.tickets[i];
			if (_ticket.done) continue;
			var _row_y = _tablet_y + (139 + _rows * 62) * _tablet_s;
			var _name = global.food_label(_ticket.food, "good");
			if (!_ticket.tutorial) _name += "  " + string(ceil(max(0, (_ticket.ends - current_time) / 1000))) + "s";
			draw_text_transformed(_screen_x, _row_y, _name, 0.34, 0.34, 0);
			draw_text_ext_transformed(_screen_x, _row_y + 18 * _tablet_s, global.toppings_text(_ticket.toppings), 14 * _tablet_s / 0.3, 330 * _tablet_s / 0.3, 0.3, 0.3, 0);
			_rows++;
		}
		if (_rows == 0) draw_text_transformed(_screen_x, _screen_y + 20 * _tablet_s, "No orders yet", 0.34, 0.34, 0);
	}

	var _mode_y = _tablet_y + 342 * _tablet_s;
	draw_set_colour(make_colour_rgb(92, 62, 0));
	draw_roundrect(_tablet_x + 37 * _tablet_s, _mode_y, _tablet_x + 364 * _tablet_s, _mode_y + 25 * _tablet_s, false);
	draw_set_colour(c_white);
	draw_set_halign(fa_center);
	var _mode_label = (global.order_mode == "restaurant") ? "MODE: RESTAURANT  >" : "MODE: NEIGHBORHOOD  >";
	draw_text_transformed(_tablet_x + 200 * _tablet_s, _mode_y + 5 * _tablet_s, _mode_label, 0.34, 0.34, 0);
	draw_set_halign(fa_left);
}


if (global.car_feedback != "" && current_time < global.car_feedback_until)
{
	draw_set_halign(fa_center);
	var _fw = string_width(global.car_feedback) * 0.42 + 8;
	draw_set_alpha(0.8);
	draw_set_colour(c_black);
	draw_roundrect(_gw / 2 - _fw / 2, 130, _gw / 2 + _fw / 2, 141, false);
	draw_set_alpha(1);
	draw_set_colour(c_white);
	draw_text_transformed(_gw / 2, 131, global.car_feedback, 0.42, 0.42, 0);
	draw_set_halign(fa_left);
}

if (global.day_state == "tutorial" && global.tut_step > 0)
{
	var _target = tut_target();
	if (_target != noone && view_enabled && view_camera[0] != -1)
	{
		var _cam = view_camera[0];
		var _px = (_target.x - camera_get_view_x(_cam)) * _gw / camera_get_view_width(_cam);
		var _py = (_target.bbox_top - camera_get_view_y(_cam)) * _gh / camera_get_view_height(_cam);
		_px = clamp(_px, 8, _gw - 8);
		_py = clamp(_py - 6 - abs(sin(current_time / 200)) * 5, 10, _gh - 8);
		draw_set_colour(c_black);
		draw_triangle(_px - 6, _py - 8, _px + 6, _py - 8, _px, _py + 1, false);
		draw_set_colour(_gold);
		draw_triangle(_px - 4, _py - 7, _px + 4, _py - 7, _px, _py - 1, false);
	}
	var _text = tut_text();
	var _bw = 176;
	var _bx = (_gw - _bw) / 2;
	var _th = string_height_ext(_text, -1, (_bw - 10) / 0.34) * 0.34;
	var _bh = _th + 16;
	draw_set_alpha(0.92);
	draw_set_colour(_brown);
	draw_roundrect(_bx, 4, _bx + _bw, 4 + _bh, false);
	draw_set_alpha(1);
	draw_set_colour(_gold);
	draw_roundrect(_bx, 4, _bx + _bw, 4 + _bh, true);
	draw_text_transformed(_bx + 5, 6, "TUTORIAL " + string(min(global.tut_step, 9)) + "/9", 0.3, 0.3, 0);
	draw_set_halign(fa_right);
	draw_set_colour(make_colour_rgb(200, 170, 120));
	draw_text_transformed(_bx + _bw - 5, 6, "Space: next   Esc: skip", 0.3, 0.3, 0);
	draw_set_halign(fa_left);
	draw_set_colour(c_white);
	draw_text_ext_transformed(_bx + 5, 13, _text, -1, (_bw - 10) / 0.34, 0.34, 0.34, 0);
}

if (global.day_state == "summary")
{
	draw_set_alpha(0.6);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, _gw, _gh, false);
	draw_set_alpha(1);
	var _sx1 = 60, _sy1 = 40, _sx2 = 260, _sy2 = 140;
	draw_set_colour(_brown);
	draw_roundrect(_sx1, _sy1, _sx2, _sy2, false);
	draw_set_colour(_gold);
	draw_roundrect(_sx1, _sy1, _sx2, _sy2, true);
	draw_set_halign(fa_center);
	var _cx2 = (_sx1 + _sx2) / 2;
	draw_text_transformed(_cx2, _sy1 + 6, "DAY " + string(global.day) + " OVER", 0.6, 0.6, 0);
	draw_line(_sx1 + 10, _sy1 + 22, _sx2 - 10, _sy1 + 22);
	draw_set_colour(c_white);
	draw_text_transformed(_cx2, _sy1 + 30, "Earned today: $" + string(global.day_earned), 0.42, 0.42, 0);
	draw_text_transformed(_cx2, _sy1 + 44, "Quota: $" + string(global.quotas[global.day - 1]), 0.42, 0.42, 0);
	if (global.day_passed)
	{
		draw_set_colour(make_colour_rgb(80, 200, 90));
		draw_text_transformed(_cx2, _sy1 + 60, (global.day >= global.max_days) ? "You survived all 5 days!" : "Quota met! You keep your job.", 0.42, 0.42, 0);
	}
	else
	{
		draw_set_colour(make_colour_rgb(230, 70, 60));
		draw_text_transformed(_cx2, _sy1 + 60, "Quota missed...", 0.42, 0.42, 0);
	}
	draw_set_colour(make_colour_rgb(200, 170, 120));
	draw_text_transformed(_cx2, _sy2 - 14, (global.day_passed && global.day < global.max_days) ? "Press E to start day " + string(global.day + 1) : "Press E", 0.36, 0.36, 0);
	draw_set_halign(fa_left);
	draw_set_colour(c_white);
}
