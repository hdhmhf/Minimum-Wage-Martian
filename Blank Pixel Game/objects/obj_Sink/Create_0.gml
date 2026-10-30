depth = -y;
washing = false;
wash_start = 0;
wash_each = 1300;
chef = noone;
bubbles = [];
sparkle_until = 0;

use = function(_chef)
{
	if (_chef.holding == "dirty")
	{
		global.sink_dirty += _chef.dirty_count;
		_chef.holding = "";
		_chef.dirty_count = 0;
	}
	if (global.sink_dirty <= 0) return;
	washing = true;
	chef = _chef;
	wash_start = current_time;
	_chef.in_menu = true;
	_chef.scrubbing = true;
	_chef.facing = "up";
	_chef.sprite_index = spr_chef_walk_up;
	_chef.image_speed = 0.7;
}

stop_washing = function()
{
	washing = false;
	if (instance_exists(chef))
	{
		chef.in_menu = false;
		chef.scrubbing = false;
		chef.e_lock = 2;
	}
}
