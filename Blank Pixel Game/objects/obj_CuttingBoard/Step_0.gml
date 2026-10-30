if (!open) exit;

if (skip_frame)
{
	skip_frame = false;
	exit;
}

if (phase == "in" && current_time - phase_t >= 400) phase = "on";
if (phase == "out")
{
	if (current_time - phase_t >= 400) finish_close();
	exit;
}

var _n = array_length(global.condiments);

if (pour_frame >= 0)
{
	var _pc = global.condiments[pour_id];
	var _frames = sprite_get_number(_pc.anim) - 1;
	pour_frame = (current_time - pour_start) * _frames / 900;
	if (pour_frame >= _frames)
	{
		pour_frame = -1;
		add_topping(_pc.id);
	}
}
for (var i = array_length(drops) - 1; i >= 0; i--)
{
	var _d = drops[i];
	_d.vy += 0.2;
	_d.y += _d.vy;
	_d.a += 6;
	if (_d.y >= plate_y - 8)
	{
		add_topping(_d.id);
		array_delete(drops, i, 1);
	}
}

if (phase != "on") exit;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
if (_mx != last_mx || _my != last_my) mouse_used = true;
last_mx = _mx;
last_my = _my;

if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D")))
{
	kb_index = min(kb_index + 1, _n - 1);
	mouse_used = false;
}
if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A")))
{
	kb_index = max(kb_index - 1, 0);
	mouse_used = false;
}
if (mouse_wheel_down()) scroll_target += spacing;
if (mouse_wheel_up()) scroll_target -= spacing;
if (mouse_used && _my > 126)
{
	if (_mx < shelf_l) scroll_target -= 4;
	if (_mx > shelf_r) scroll_target += 4;
}
if (!mouse_used)
{
	var _kx = shelf_l + 16 + kb_index * spacing - scroll_target;
	if (_kx < shelf_l + 16) scroll_target -= shelf_l + 16 - _kx;
	if (_kx > shelf_r - 16) scroll_target += _kx - (shelf_r - 16);
}
var _max_scroll = max(0, (_n - 1) * spacing + 32 - (shelf_r - shelf_l));
scroll_target = clamp(scroll_target, 0, _max_scroll);
scroll = lerp(scroll, scroll_target, 0.3);

hover = -1;
if (mouse_used)
{
	if (_my >= 126 && _mx > shelf_l && _mx < shelf_r)
	{
		for (var i = 0; i < _n; i++) if (i != selected && abs(_mx - bottle_x(i)) < spacing / 2) hover = i;
	}
}
else if (kb_index != selected) hover = kb_index;
for (var i = 0; i < _n; i++) lift[i] = lerp(lift[i], (i == hover) ? 10 : 0, 0.3);

var _click = mouse_check_button_pressed(mb_left);
if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_escape) || (_click && point_in_rectangle(_mx, _my, 4, 74, 60, 88)))
{
	if (pour_frame < 0 && array_length(drops) == 0) close();
	exit;
}
if (mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
{
	if (pour_frame < 0) selected = -1;
}
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_enter)) pick(kb_index);
if (_click)
{
	if (hover >= 0) pick(hover);
	else pour();
}
if (keyboard_check_pressed(vk_space)) pour();
