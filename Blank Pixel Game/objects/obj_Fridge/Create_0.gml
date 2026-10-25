depth = -y;

display_set_gui_size(320, 180);

menu_open = false;
menu_index = 0;
menu_chef = noone;
menu_skip_frame = false;

use = function(_chef)
{
	if (_chef.holding == "" || _chef.holding == "raw")
	{
		menu_open = true;
		menu_chef = _chef;
		menu_index = max(0, array_get_index(global.fridge_foods, _chef.holding_food));
		menu_skip_frame = true;
		_chef.in_menu = true;
	}
}

close_menu = function()
{
	menu_open = false;
	menu_chef.in_menu = false;
	menu_chef.e_lock = 2;
}
