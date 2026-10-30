depth = -y;

plate_food = "";
plate_kind = "";
plate_toppings = {};
customer = noone;
day_serial = variable_global_exists("day_serial") ? global.day_serial : 0;

serve = function(_chef)
{
	if (plate_food == "" && _chef.has_dish())
	{
		plate_food = _chef.holding;
		plate_kind = _chef.holding_food;
		plate_toppings = _chef.holding_toppings;
		_chef.holding = "";
		_chef.holding_food = "";
		_chef.holding_toppings = {};
	}
	else if (plate_food == "dirty" && (_chef.holding == "" || (_chef.holding == "dirty" && _chef.dirty_count < 3)))
	{
		if (_chef.holding == "") _chef.dirty_count = 0;
		_chef.holding = "dirty";
		_chef.dirty_count++;
		plate_food = "";
		plate_kind = "";
		plate_toppings = {};
	}
}
