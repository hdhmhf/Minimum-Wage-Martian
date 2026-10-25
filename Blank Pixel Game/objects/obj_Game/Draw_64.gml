var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

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
	draw_set_halign(fa_right);
	draw_text_transformed(_gw - 4, _gh - 10, "R to play again", 0.4, 0.4, 0);
	draw_set_halign(fa_left);
	exit;
}

draw_sprite_ext(spr_money, 0, 12, 10, 0.25, 0.25, 0, c_white, 1);
draw_set_colour(c_white);
draw_text_transformed(21, 5, string(global.money) + " / " + string(global.money_goal), 0.5, 0.5, 0);

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

// Small tablet launcher stays at the left edge. Opening it shows the tablet
// large in the center while leaving the current room visible around it.
var _icon_x = 5 - 30 * (1 - global.tablet_button_alpha);
var _icon_y = (_gh - 38) * 0.5;
draw_set_alpha(global.tablet_button_alpha);
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

if (global.tablet_open)
{
	var _tablet_x = global.orders_x;
	var _tablet_y = global.orders_y;
	var _tablet_s = global.orders_scale;
	draw_sprite_ext(spr_delivery_tablet, 0,
		_tablet_x + sprite_get_xoffset(spr_delivery_tablet) * _tablet_s,
		_tablet_y + sprite_get_yoffset(spr_delivery_tablet) * _tablet_s,
		_tablet_s, _tablet_s, 0, c_white, 1);
	var _screen_x = _tablet_x + 34 * _tablet_s;
	var _screen_y = _tablet_y + 119 * _tablet_s;
	draw_set_colour(c_black);
	draw_text_transformed(_screen_x, _screen_y, "Orders", 0.38, 0.38, 0);
	if (!global.orders_open)
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
				draw_text_transformed(_screen_x, _row_y + 18 * _tablet_s, "To: " + _order.house, 0.34, 0.34, 0);
				draw_text_transformed(_screen_x, _row_y + 36 * _tablet_s, "Time: " + string(_seconds_left) + "s", 0.34, 0.34, 0);
			}
		}
	}
	else if (!global.car_owned)
	{
		draw_text_transformed(_screen_x, _screen_y + 20 * _tablet_s, "Buy the car to unlock deliveries", 0.32, 0.32, 0);
	}
	else
	{
		draw_text_transformed(_screen_x, _screen_y + 20 * _tablet_s, "Restaurant service is active", 0.34, 0.34, 0);
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
	draw_text_transformed(_gw / 2, _gh - 12, global.car_feedback, 0.5, 0.5, 0);
	draw_set_halign(fa_left);
}
