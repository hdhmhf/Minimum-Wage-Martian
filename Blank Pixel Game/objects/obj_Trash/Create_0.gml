depth = -y;

use = function(_chef)
{
	if (_chef.has_dish())
	{
		_chef.holding = "dirty";
		_chef.dirty_count = 1;
		_chef.holding_food = "";
		_chef.holding_toppings = {};
	}
	else if (_chef.holding == "raw")
	{
		_chef.holding = "";
		_chef.holding_food = "";
	}
}
