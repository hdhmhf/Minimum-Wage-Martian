if (!menu_open) exit;

if (menu_skip_frame)
{
	menu_skip_frame = false;
	exit;
}

var _n = array_length(global.fridge_foods);
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) menu_index = (menu_index + 1) mod _n;
if (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"))) menu_index = (menu_index - 1 + _n) mod _n;
var _cols = min(_n, menu_cols);
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")))
{
	if (menu_index + _cols < _n) menu_index += _cols;
	else if (menu_index div _cols < (_n - 1) div _cols) menu_index = _n - 1;
}
if ((keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) && menu_index - _cols >= 0) menu_index -= _cols;

if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))
{
	menu_chef.holding_food = global.fridge_foods[menu_index];
	menu_chef.holding = "raw";
	close_menu();
}
else if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("Q")))
{
	close_menu();
}
