if (!menu_open) exit;

if (menu_skip_frame)
{
	menu_skip_frame = false;
	exit;
}

var _n = array_length(global.fridge_foods);
if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) menu_index = (menu_index + 1) mod _n;
if (keyboard_check_pressed(vk_left)  || keyboard_check_pressed(ord("A"))) menu_index = (menu_index - 1 + _n) mod _n;

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
