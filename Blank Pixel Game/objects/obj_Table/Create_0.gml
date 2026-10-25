depth = -y;

plate_food = "";
plate_kind = "";
customer = noone;

serve = function(_chef)
{
	if (plate_food == "" && _chef.holding != "")
	{
		plate_food = _chef.holding;
		plate_kind = _chef.holding_food;
		_chef.holding = "";
		_chef.holding_food = "";
	}
}
