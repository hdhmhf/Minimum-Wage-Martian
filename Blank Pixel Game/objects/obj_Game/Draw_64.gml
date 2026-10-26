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

if (global.tutorial_active)
{
	draw_set_alpha(0.78);
	draw_set_colour(c_black);
	draw_rectangle(0, 0, _gw, _gh, false);
	draw_set_alpha(1);
	draw_set_colour(make_colour_rgb(72, 43, 20));
	draw_roundrect(18, 12, _gw - 18, _gh - 12, false);
	draw_set_colour(make_colour_rgb(255, 203, 93));
	draw_roundrect(18, 12, _gw - 18, _gh - 12, true);
	draw_set_colour(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	var _tutorial_title = "Your first shift";
	var _tutorial_line1 = "";
	var _tutorial_line2 = "";
	var _tutorial_line3 = "";
	var _tutorial_line4 = "";
	switch (global.tutorial_page)
	{
		case 0:
			_tutorial_line1 = "Run the restaurant, cook what customers want, and earn money.";
			_tutorial_line2 = "This guide is optional; you can skip it any time.";
			break;
		case 1:
			_tutorial_title = "Move and interact";
			_tutorial_line1 = "Move with WASD or the arrow keys.";
			_tutorial_line2 = "Press E near objects to interact.";
			_tutorial_line3 = "Click the tablet icon on the left to open orders.";
			break;
		case 2:
			_tutorial_title = "Cook and serve";
			_tutorial_line1 = "At the fridge, press E; use left/right to choose food.";
			_tutorial_line2 = "At the stove, press E to cook, then again to collect it.";
			_tutorial_line3 = "If food burns, take it to the trash and press E to discard it.";
			_tutorial_line4 = "Match the customer's thought bubble and serve at their table.";
			break;
		default:
			_tutorial_title = "Neighborhood deliveries";
			_tutorial_line1 = "Buy the car for $100, then use the tablet to switch modes.";
			_tutorial_line2 = "Cook the listed food, drive to the named house, and press E.";
			_tutorial_line3 = "Deliver near its front door within 60 seconds.";
			break;
	}
	draw_text_transformed(30, 23, _tutorial_title, 0.58, 0.58, 0);
	draw_set_colour(make_colour_rgb(255, 203, 93));
	draw_line(30, 42, _gw - 30, 42);
	draw_set_colour(c_white);
	draw_text_transformed(30, 54, _tutorial_line1, 0.38, 0.38, 0);
	draw_text_transformed(30, 75, _tutorial_line2, 0.38, 0.38, 0);
	draw_text_transformed(30, 96, _tutorial_line3, 0.38, 0.38, 0);
	draw_text_transformed(30, 117, _tutorial_line4, 0.38, 0.38, 0);
	draw_set_colour(make_colour_rgb(50, 34, 22));
	draw_roundrect(21, _gh - 30, 77, _gh - 16, false);
	draw_roundrect(_gw - 88, _gh - 30, _gw - 21, _gh - 16, false);
	draw_set_colour(c_white);
	draw_set_halign(fa_center);
	draw_text_transformed(49, _gh - 27, "SKIP", 0.4, 0.4, 0);
	var _next_label = (global.tutorial_page >= 3) ? "START" : "NEXT >";
	draw_text_transformed(_gw - 54, _gh - 27, _next_label, 0.4, 0.4, 0);
	draw_text_transformed(_gw / 2, _gh - 27, string(global.tutorial_page + 1) + " / 4", 0.38, 0.38, 0);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
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
