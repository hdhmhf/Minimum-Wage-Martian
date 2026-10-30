if (!instance_exists(obj_Game)) instance_create_depth(0, 0, 0, obj_Game);

instance_create_layer(152, 191, "Instances", obj_door, { target_room: Dining_Area, target_x: 160, target_y: 30 });

if (!instance_exists(obj_Sink)) instance_create_layer(160, 48, "Instances", obj_Sink);
if (!instance_exists(obj_CuttingBoard)) instance_create_layer(160, 106, "Instances", obj_CuttingBoard);

if (!instance_exists(obj_Cart)) instance_create_layer(200, 120, "Instances", obj_Cart);

if (!instance_exists(obj_Player)) instance_create_layer(room_width / 2, 148, "Instances", obj_Player);
