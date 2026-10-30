if (global.in_story)
{
	if (keyboard_check_pressed(vk_escape)) end_story();
	else
	{
		story_frame = floor((current_time - story_start_time) / 3000);
		if (story_frame >= sprite_get_number(spr_story)) end_story();
	}
	exit;
}

if (global.game_over != "")
{
	if (keyboard_check_pressed(ord("R"))) game_restart();
	exit;
}

if (global.day_state == "summary")
{
	if (current_time > summary_lock && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)))
	{
		if (!global.day_passed)
		{
			global.lose_reason = "You missed the quota on day " + string(global.day) + ".";
			global.game_over = "lose";
		}
		else if (global.day >= global.max_days) global.game_over = "win";
		else start_day(global.day + 1);
		with (obj_Player) e_lock = 2;
	}
	exit;
}

if (global.day_state == "tutorial")
{
	var _menu_open = global.board_open;
	with (obj_Fridge) if (menu_open) _menu_open = true;
	if (keyboard_check_pressed(vk_escape) && !_menu_open)
	{
		reset_world();
		start_day(1);
	}
	else if (keyboard_check_pressed(vk_space) && !_menu_open) tut_next();
	else tutorial_update();
}

// Tablet launcher and touch controls. The launcher is available on the left
// in every room; the tablet can be moved and resized while open.
var _mouse_pressed = mouse_check_button_pressed(mb_left) || device_mouse_check_button_pressed(0, mb_left);
var _mouse_held = mouse_check_button(mb_left) || device_mouse_check_button(0, mb_left);
var _mouse_released = mouse_check_button_released(mb_left) || device_mouse_check_button_released(0, mb_left);
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _icon_y = (display_get_gui_height() - 38) * 0.5;
var _icon_x = 5 - 30 * (1 - global.tablet_button_alpha);
var _hide_tablet_button = false;
var _player = instance_find(obj_Player, 0);
if (_player != noone && view_enabled && view_camera[0] != -1)
{
	var _cam = view_camera[0];
	var _cam_x = camera_get_view_x(_cam);
	var _cam_y = camera_get_view_y(_cam);
	var _cam_w = max(1, camera_get_view_width(_cam));
	var _cam_h = max(1, camera_get_view_height(_cam));
	var _player_gui_x = (_player.x - _cam_x) * display_get_gui_width() / _cam_w;
	var _player_gui_y = (_player.y - _cam_y) * display_get_gui_height() / _cam_h;
	// Give the player clearance when they are directly beneath the launcher.
	_hide_tablet_button = (_player_gui_x >= -12 && _player_gui_x <= 54
		&& _player_gui_y >= _icon_y - 12 && _player_gui_y <= _icon_y + 68);
}
global.tablet_button_alpha = lerp(global.tablet_button_alpha, _hide_tablet_button ? 0 : 1, 0.16);
if (global.tablet_button_alpha < 0.01 && _hide_tablet_button) global.tablet_button_alpha = 0;
if (global.tablet_button_alpha > 0.99 && !_hide_tablet_button) global.tablet_button_alpha = 1;

if (_mouse_pressed && !global.board_open && global.tablet_button_alpha > 0.65 && _mx >= _icon_x && _mx <= _icon_x + 38 && _my >= _icon_y && _my <= _icon_y + 38)
{
	global.tablet_open = !global.tablet_open;
	if (global.tablet_open)
	{
		global.orders_scale = min((display_get_gui_height() - 12) / 400, (display_get_gui_width() - 20) / 400);
		global.orders_x = (display_get_gui_width() - 400 * global.orders_scale) / 2;
		global.orders_y = (display_get_gui_height() - 400 * global.orders_scale) / 2;
	}
}
else if (global.tablet_open)
{
	var _tablet_s = global.orders_scale;
	var _tablet_w = 400 * _tablet_s;
	var _tablet_h = 400 * _tablet_s;
	if (global.orders_resizing)
	{
		if (_mouse_held)
		{
			var _max_scale = min((display_get_gui_width() - global.orders_x - 2) / 400, (display_get_gui_height() - global.orders_y - 2) / 400);
			global.orders_scale = clamp(max((_mx - global.orders_x) / 400, (_my - global.orders_y) / 400), 0.18, max(0.18, _max_scale));
			global.orders_scale = min(global.orders_scale, _max_scale);
		}
		if (_mouse_released || !_mouse_held) global.orders_resizing = false;
	}
	else if (global.orders_dragging)
	{
		if (_mouse_held)
		{
			global.orders_x = clamp(_mx - global.orders_drag_offset_x, 2, display_get_gui_width() - _tablet_w - 2);
			global.orders_y = clamp(_my - global.orders_drag_offset_y, 2, display_get_gui_height() - _tablet_h - 2);
		}
		if (_mouse_released || !_mouse_held) global.orders_dragging = false;
	}
	else if (_mouse_pressed)
	{
		var _lx = _mx - global.orders_x;
		var _ly = _my - global.orders_y;
		if (_lx >= 382 * _tablet_s && _ly >= 382 * _tablet_s)
			global.orders_resizing = true;
		else if (_ly >= 80 * _tablet_s && _ly <= 115 * _tablet_s && _lx >= 40 * _tablet_s && _lx <= 370 * _tablet_s)
		{
			global.orders_dragging = true;
			global.orders_drag_offset_x = _lx;
			global.orders_drag_offset_y = _ly;
		}
		else if (_lx >= 25 * _tablet_s && _lx <= 375 * _tablet_s && _ly >= 114 * _tablet_s && _ly <= 139 * _tablet_s)
			global.orders_open = !global.orders_open;
		else if (_lx >= 32 * _tablet_s && _lx <= 370 * _tablet_s && _ly >= 337 * _tablet_s && _ly <= 374 * _tablet_s)
		{
			if (!global.car_owned)
			{
				global.car_feedback = "Buy the car to unlock neighborhood deliveries";
				global.car_feedback_until = current_time + 2500;
			}
			else if (global.order_mode == "restaurant")
			{
				global.order_mode = "neighborhood";
				global.orders_open = true;
			}
			else global.order_mode = "restaurant";
		}
	}
}


for (var i = array_length(global.tickets) - 1; i >= 0; i--)
{
	var _t = global.tickets[i];
	if (_t.done)
	{
		array_delete(global.tickets, i, 1);
	}
	else if (!_t.tutorial && current_time >= _t.ends)
	{
		_t.done = true;
		_t.angry = true;
		global.mistakes++;
		array_delete(global.tickets, i, 1);
	}
}

if (global.day_state == "running" && global.order_mode == "neighborhood" && global.car_owned && current_time >= next_neighborhood_order)
{
	if (array_length(global.neighborhood_orders) < 3)
	{
		var _houses = ["Red House", "Blue House", "Orange House", "Purple House"];
		var _food = global.fridge_foods[irandom(array_length(global.fridge_foods) - 1)];
		array_push(global.neighborhood_orders, {
			food: _food,
			house: _houses[irandom(array_length(_houses) - 1)],
			created: current_time,
			deadline: current_time + 60000
		});
		// Keep at least 30 seconds between incoming neighborhood orders.
		next_neighborhood_order = current_time + 30000;
	}
	else next_neighborhood_order = current_time + 1000;
}

// Expired delivery orders are removed and play the angry sound exactly once.
for (var oi = array_length(global.neighborhood_orders) - 1; oi >= 0; oi--)
{
	if (current_time >= global.neighborhood_orders[oi].deadline)
	{
		array_delete(global.neighborhood_orders, oi, 1);
		global.mistakes++;
		audio_play_sound(snd_angry, 1, false);
	}
}


if (global.day_state == "running" && global.order_mode == "restaurant" && current_time >= next_spawn && current_time < global.day_end - 25000)
{
	var _range = global.spawn_by_day[global.day - 1];
	next_spawn = current_time + irandom_range(_range[0], _range[1]);
	if (array_length(global.tickets) < 5)
	{
		var _ticket = global.new_ticket(global.patience_by_day[global.day - 1] + 5000);
		array_push(global.tickets, _ticket);
		array_push(global.arrivals, _ticket);
	}
}

if (room == Dining_Area)
{
	var _ai = 0;
	while (_ai < array_length(global.arrivals))
	{
		var _a = global.arrivals[_ai];
		if (_a.done)
		{
			array_delete(global.arrivals, _ai, 1);
			continue;
		}
		var _free = [];
		with (obj_Table) if (customer == noone) array_push(_free, id);
		if (array_length(_free) == 0) break;
		var _table = _free[irandom(array_length(_free) - 1)];
		_table.customer = instance_create_layer(160, 182, "Instances", obj_Customer, { table: _table, ticket: _a, seated: current_time - _a.arrive > 5000 });
		array_delete(global.arrivals, _ai, 1);
	}
}

if (global.day_state == "running")
{
	if (global.mistakes >= global.max_mistakes)
	{
		global.lose_reason = "Too many mistakes!";
		global.game_over = "lose";
	}
	else if (current_time >= global.day_end)
	{
		global.day_passed = global.day_earned >= global.quotas[global.day - 1];
		global.day_state = "summary";
		summary_lock = current_time + 700;
		reset_world();
	}
}
