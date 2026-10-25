if (!instance_exists(obj_Game)) instance_create_depth(0, 0, 0, obj_Game);

// Solid house and neighborhood boundaries; the center street stays open.
var add_wall = function(_x, _y, _w, _h)
{
	instance_create_layer(_x, _y, "Instances", obj_lot_prop, {
		kind: "wall", w: _w, h: _h, box: [_x, _y, _w, _h]
	});
};

// Four house footprints, matching the red roof blocks in spr_neighborhood.
add_wall(24, 26, 104, 46);
add_wall(352, 26, 104, 46);
add_wall(24, 213, 104, 46);
add_wall(352, 213, 104, 46);

// Tree trunks in the yards also block the player.
var tree_sources = [[18, 70], [78, 68], [212, 70], [276, 68], [18, 126], [78, 128], [212, 126], [276, 128]];
for (var i = 0; i < array_length(tree_sources); i++)
{
	var tx = tree_sources[i][0];
	var ty = tree_sources[i][1];
	add_wall((tx + 4) * 1.6, (ty + 12) * 1.44, 10, 14);
}

// Road gates close the side streets and the south road; the north road stays open.
add_wall(0, 121, 32, 47);
add_wall(448, 121, 32, 47);
add_wall(194, 273, 92, 15);

// Room edges, with only the top-center road left open for the parking-lot link.
add_wall(0, 0, 200, 4); add_wall(280, 0, 200, 4);
add_wall(0, 0, 4, room_height); add_wall(room_width - 4, 0, 4, room_height);
add_wall(0, room_height - 4, room_width, 4);

if (!instance_exists(obj_Player))
{
	var sx = 240; var sy = 40;
	if (variable_global_exists("spawn_x")) { sx = global.spawn_x; sy = global.spawn_y; }
	instance_create_layer(sx, sy, "Instances", obj_Player);
}

instance_create_layer(240, 28, "Instances", obj_door, { target_room: Parking_Lot, target_x: 164, target_y: 205, visible: false, image_xscale: 5 });
