if (!instance_exists(obj_Game)) instance_create_depth(0, 0, 0, obj_Game);

if (!instance_exists(obj_parking_lot))
	instance_create_layer(0, 0, "Instances", obj_parking_lot);

if (!instance_exists(obj_Car))
	instance_create_layer(110, 118, "Instances", obj_Car);

	instance_create_layer(160, 35, "Instances", obj_door, {
	target_room: Dining_Area,
	target_x: 160,
	target_y: 120,
	sprite_index: spr_door_wood,
	image_xscale: 0.08,
	image_yscale: 0.08
});

// start in the middle unless we came through a door
if (!instance_exists(obj_Player))
{
	var _spawn_x = 160;
	var _spawn_y = 166;
	if (variable_global_exists("spawn_x"))
	{
		_spawn_x = global.spawn_x;
		_spawn_y = global.spawn_y;
	}
	instance_create_layer(_spawn_x, _spawn_y, "Instances", obj_Player);
}

instance_create_layer(164, 288, "Instances", obj_door, { target_room: Neighborhood, target_x: 240, target_y: 68, sprite_index: spr_gate, image_xscale: 0.25, image_yscale: 0.25, depth: -288 });
