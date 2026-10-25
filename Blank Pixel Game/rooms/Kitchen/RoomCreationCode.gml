if (!instance_exists(obj_Game)) instance_create_depth(0, 0, 0, obj_Game);

instance_create_layer(152, 191, "Instances", obj_door, { target_room: Dining_Area, target_x: 160, target_y: 30 });

if (!instance_exists(obj_Player)) instance_create_layer(room_width / 2, 148, "Instances", obj_Player);
