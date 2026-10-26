if (global.in_story)
{
	if (keyboard_check_pressed(vk_escape))
	{
		global.in_story = false;
		global.tutorial_active = true;
		next_spawn = current_time + 3000;
		with (obj_Player) e_lock = 2;
		audio_stop_sound(snd_intro);
		audio_play_sound(snd_music, 1, true);
	}
	else
	{
		// Derive the slide from elapsed time so slow frames cannot stall the sequence.
		story_frame = floor((current_time - story_start_time) / 3000);
		if (story_frame >= sprite_get_number(spr_story))
		{
			global.in_story = false;
			global.tutorial_active = true;
			next_spawn = current_time + 3000;
			with (obj_Player) e_lock = 2;
			audio_stop_sound(snd_intro);
			audio_play_sound(snd_music, 1, true);
		}
	}
	exit;
}

// The tutorial pauses play and can be advanced with the keyboard or buttons.
if (global.tutorial_active)
{
	var _tutorial_next = keyboard_check_pressed(vk_enter)
		|| keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_right);
	var _tutorial_skip = keyboard_check_pressed(vk_escape);
	if (mouse_check_button_pressed(mb_left) || device_mouse_check_button_pressed(0, mb_left))
	{
		var _tx = device_mouse_x_to_gui(0);
		var _ty = device_mouse_y_to_gui(0);
		if (_tx >= 224 && _tx <= 300 && _ty >= 145 && _ty <= 170) _tutorial_next = true;
		else if (_tx >= 18 && _tx <= 88 && _ty >= 145 && _ty <= 170) _tutorial_skip = true;
	}
	if (_tutorial_skip) global.tutorial_active = false;
	else if (_tutorial_next)
	{
		if (global.tutorial_page >= 3) global.tutorial_active = false;
		else global.tutorial_page++;
	}
	exit;
}

if (global.game_over != "")
{
	if (keyboard_check_pressed(ord("R"))) game_restart();
	exit;
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

if (_mouse_pressed && global.tablet_button_alpha > 0.65 && _mx >= _icon_x && _mx <= _icon_x + 38 && _my >= _icon_y && _my <= _icon_y + 38)
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
	else if (current_time >= _t.ends)
	{
		_t.done = true;
		_t.angry = true;
		global.mistakes++;
		array_delete(global.tickets, i, 1);
	}
}

if (global.order_mode == "neighborhood" && global.car_owned && current_time >= next_neighborhood_order)
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

if (global.order_mode == "restaurant" && room == Dining_Area && current_time >= next_spawn)
{
	next_spawn = current_time + irandom_range(8000, 14000);
	var _free = [];
	with (obj_Table) if (customer == noone) array_push(_free, id);
	if (array_length(_free) > 0)
	{
		var _table = _free[irandom(array_length(_free) - 1)];
		_table.customer = instance_create_layer(160, 182, "Instances", obj_Customer, { table: _table });
	}
}

if (global.mistakes >= global.max_mistakes) global.game_over = "lose";
else if (global.money >= global.money_goal) global.game_over = "win";
