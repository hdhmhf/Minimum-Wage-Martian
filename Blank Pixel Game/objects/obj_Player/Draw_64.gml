var _p = get_prompt();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _gold = make_colour_rgb(255, 203, 93);
var _brown = make_colour_rgb(72, 43, 20);

if (_p != undefined)
{
	var _cam = view_camera[0];
	var _gx = (_p.px - camera_get_view_x(_cam)) * _gw / camera_get_view_width(_cam);
	var _gy = (_p.py - camera_get_view_y(_cam)) * _gh / camera_get_view_height(_cam);

	var _ts = 0.3;
	var _ks = 0.55;
	var _line_h = string_height("E") * _ts;
	var _key = _p.key ? string_height("E") * _ks + 2 : 0;
	var _meter = variable_struct_exists(_p, "meter") ? _p.meter : noone;
	var _w = round(max(_key, string_width(_p.line1) * _ts, string_width(_p.line2) * _ts, (_meter != noone) ? 28 : 0) + 8);
	var _h = round(4 + _key + (_p.key ? 3 : 0) + _line_h * 2 + 5 + ((_meter != noone) ? 10 : 0));
	var _x1 = round(clamp(_gx - _w / 2, 2, _gw - _w - 2));
	var _y1 = round(clamp(_gy - _h - 3, 2, _gh - _h - 2));
	var _cx = _x1 + _w / 2;

	draw_set_colour(_brown);
	draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, false);
	draw_set_colour(_gold);
	draw_roundrect(_x1, _y1, _x1 + _w, _y1 + _h, true);

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	var _ty = _y1 + 4;
	if (_p.key)
	{
		var _kx = round(_cx - _key / 2);
		draw_set_colour(make_colour_rgb(50, 34, 22));
		draw_rectangle(_kx, _ty, _kx + _key, _ty + _key, false);
		draw_set_colour(_gold);
		draw_rectangle(_kx, _ty, _kx + _key, _ty + _key, true);
		draw_set_colour(c_white);
		draw_text_transformed(_cx, _ty + 1, "E", _ks, _ks, 0);
		_ty += _key + 3;
	}
	draw_set_colour(c_white);
	draw_text_transformed(_cx, _ty, _p.line1, _ts, _ts, 0);
	draw_text_transformed(_cx, _ty + _line_h + 1, _p.line2, _ts, _ts, 0);
	if (_meter != noone && instance_exists(_meter)) _meter.draw_meter(round(_cx - 13), round(_ty + _line_h * 2 + 6));
	draw_set_halign(fa_left);
}

if (global.in_story || global.game_over != "" || global.day_state == "summary" || global.ui.board_open) exit;

var _hints = [];
if (scrubbing) array_push(_hints, "Washing dishes...");
else if (!in_menu)
{
	array_push(_hints, "WASD / Arrows: Move");
	var _a = find_action();
	if (_a != undefined && _a.kind != "none") array_push(_hints, "E: " + _a.line1 + " " + _a.line2);
	else array_push(_hints, "E: Interact");
	if (pushing_cart != noone) array_push(_hints, "F: " + (global.ui.cart_ui_open ? "Hide" : "View") + " cart");
	if (cart_for_taking() != noone) array_push(_hints, "Q: Take dish off cart");
	if (global.day_state == "tutorial")
	{
		array_push(_hints, "Space: Next step");
		array_push(_hints, "Esc: Skip tutorial");
	}
}
if (array_length(_hints) > 0)
{
	var _hs = 0.3;
	var _lh = string_height("A") * _hs + 1;
	var _hw = 0;
	for (var i = 0; i < array_length(_hints); i++) _hw = max(_hw, string_width(_hints[i]) * _hs);
	var _hx = 3;
	var _hy = _gh - 3 - array_length(_hints) * _lh - 4;
	draw_set_alpha(0.75);
	draw_set_colour(_brown);
	draw_roundrect(_hx, _hy, _hx + _hw + 8, _gh - 3, false);
	draw_set_alpha(1);
	for (var i = 0; i < array_length(_hints); i++)
	{
		var _line = _hints[i];
		var _split = string_pos(": ", _line);
		var _ly = _hy + 2 + i * _lh;
		if (_split > 0)
		{
			var _keypart = string_copy(_line, 1, _split + 1);
			draw_set_colour(_gold);
			draw_text_transformed(_hx + 4, _ly, _keypart, _hs, _hs, 0);
			draw_set_colour(c_white);
			draw_text_transformed(_hx + 4 + string_width(_keypart) * _hs, _ly, string_delete(_line, 1, _split + 1), _hs, _hs, 0);
		}
		else
		{
			draw_set_colour(c_white);
			draw_text_transformed(_hx + 4, _ly, _line, _hs, _hs, 0);
		}
	}
}

if (global.ui.cart_ui_open && pushing_cart != noone)
{
	var _px1 = 70, _py1 = 30, _px2 = 250, _py2 = 158;
	draw_set_alpha(0.94);
	draw_set_colour(_brown);
	draw_roundrect(_px1, _py1, _px2, _py2, false);
	draw_set_alpha(1);
	draw_set_colour(_gold);
	draw_roundrect(_px1, _py1, _px2, _py2, true);
	draw_set_halign(fa_center);
	draw_text_transformed((_px1 + _px2) / 2, _py1 + 4, "CART  " + string(array_length(pushing_cart.dishes)) + "/" + string(pushing_cart.max_dishes), 0.45, 0.45, 0);
	draw_set_colour(make_colour_rgb(255, 203, 93));
	draw_text_transformed((_px1 + _px2) / 2, _py2 + 3, "Click a dish to take it off", 0.3, 0.3, 0);
	draw_set_colour(_gold);
	draw_set_halign(fa_left);
	for (var i = 0; i < pushing_cart.max_dishes; i++)
	{
		var _sy = _py1 + 18 + i * 37;
		var _slot_hot = i < array_length(pushing_cart.dishes) && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _px1 + 6, _sy, _px2 - 6, _sy + 33);
		draw_set_colour(_slot_hot ? make_colour_rgb(110, 70, 34) : make_colour_rgb(50, 34, 22));
		draw_roundrect(_px1 + 6, _sy, _px2 - 6, _sy + 33, false);
		if (i < array_length(pushing_cart.dishes))
		{
			var _d = pushing_cart.dishes[i];
			global.draw_plate(_px1 + 22, _sy + 19, 12, false);
			global.draw_food(_d.food, _d.state, _px1 + 22, _sy + 16, 0.9);
			global.draw_toppings(_d.toppings, _px1 + 22, _sy + 16, 8);
			draw_set_colour(c_white);
			draw_text_transformed(_px1 + 40, _sy + 3, global.food_label(_d.food, _d.state) + "  (" + _d.state + ")", 0.34, 0.34, 0);
			var _lines = global.toppings_lines(_d.toppings);
			var _txt = (array_length(_lines) == 0) ? "No toppings" : "";
			for (var k = 0; k < array_length(_lines); k++) _txt += ((k > 0) ? ", " : "") + _lines[k];
			draw_set_colour(make_colour_rgb(200, 170, 120));
			draw_text_ext_transformed(_px1 + 40, _sy + 13, _txt, -1, (_px2 - _px1 - 52) / 0.28, 0.28, 0.28, 0);
		}
		else
		{
			draw_set_colour(make_colour_rgb(140, 110, 80));
			draw_text_transformed(_px1 + 40, _sy + 12, "Empty slot", 0.34, 0.34, 0);
		}
	}
	draw_set_colour(c_white);
}
