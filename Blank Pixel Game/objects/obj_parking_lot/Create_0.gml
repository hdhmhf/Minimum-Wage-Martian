ground_surface = -1;

spawn = function(_x, _y, _vars)
{
	return instance_create_layer(_x, _y, "Instances", obj_lot_prop, _vars);
};

wall = function(_left, _top, _width, _height)
{
	spawn(_left, _top, {
		kind: "wall",
		w: _width,
		h: _height,
		box: [_left, _top, _width, _height]
	});
};

wall(0, 0, 148, 46);
wall(176, 0, 192, 46);

wall(344, 98, 96, 92);

wall(0, 0, 4, room_height);
wall(room_width - 4, 0, 4, room_height);
wall(0, room_height - 4, 160, 4);
wall(240, room_height - 4, room_width - 240, 4);
