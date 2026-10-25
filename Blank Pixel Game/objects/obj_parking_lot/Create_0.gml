// Collision-only setup for the original Sprite31 parking-lot map.
// The room background supplies all visible artwork; this controller adds
// invisible blockers for the building and room edges.
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

// Block the building facade but leave its doorway open.
wall(0, 0, 148, 46);
wall(176, 0, 192, 46);

// Block the large sewer cap on the right sidewalk. Its room-space bounds are
// mapped from the cap in Sprite31 (the background is stretched to 480x288).
wall(344, 98, 96, 92);

// Keep the player inside the map bounds.
wall(0, 0, 4, room_height);
wall(room_width - 4, 0, 4, room_height);
// Leave the road opening clear so the player can walk into Neighborhood.
wall(0, room_height - 4, 160, 4);
wall(240, room_height - 4, room_width - 240, 4);
