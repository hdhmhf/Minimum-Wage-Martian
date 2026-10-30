if (in_car) exit;

draw_sprite_ext(sprite_index, image_index, x, y, draw_scale, draw_scale, 0, c_white, image_alpha);

if (keyboard_check(ord("H")))
{
	draw_set_colour(hits_wall(x, y) ? c_lime : c_red);
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
	draw_set_colour(c_white);
}

if (holding == "dirty")
{
	for (var i = 0; i < dirty_count; i++) global.draw_plate(x, y - 24 - i * 2, 6, true);
}
else if (holding != "")
{
	if (holding != "raw") global.draw_plate(x, y - 23, 7, false);
	global.draw_food(holding_food, holding, x, y - 26, 1);
	if (holding != "raw") global.draw_toppings(holding_toppings, x, y - 26, 5);
}
