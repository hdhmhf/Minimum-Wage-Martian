cart_room = room;
facing = "down";
dishes = [];
max_dishes = 3;
draw_scale = 0.35;
depth = -(y + 10);

pick_dish = function(_table)
{
	if (instance_exists(_table.customer))
	{
		for (var i = 0; i < array_length(dishes); i++) if (dishes[i].food == _table.customer.wants) return i;
	}
	return 0;
}

serve_table = function(_table)
{
	var _i = pick_dish(_table);
	_table.plate_food = dishes[_i].state;
	_table.plate_kind = dishes[_i].food;
	_table.plate_toppings = dishes[_i].toppings;
	array_delete(dishes, _i, 1);
}
