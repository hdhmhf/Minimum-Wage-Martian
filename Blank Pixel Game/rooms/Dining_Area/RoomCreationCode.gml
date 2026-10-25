if (!instance_exists(obj_Game)) instance_create_depth(0, 0, 0, obj_Game);

instance_create_layer(160, 29, "Instances", obj_door, { target_room: Kitchen, target_x: 152, target_y: 148 });
instance_create_layer(160, 184, "Instances", obj_door, {
	target_room: Parking_Lot,
	target_x: 160,
	target_y: 166,
	sprite_index: spr_door_wood,
	image_xscale: 0.16,
	image_yscale: 0.16
});

with (obj_Table) instance_create_layer(x - 18, y, "Instances", obj_Chair);

if (!instance_exists(obj_Player)) instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_Player);
