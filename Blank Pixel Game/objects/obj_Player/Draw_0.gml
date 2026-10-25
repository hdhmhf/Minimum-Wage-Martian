if (in_car) exit;

draw_sprite_ext(sprite_index, image_index, x, y, draw_scale, draw_scale, 0, c_white, image_alpha);

if (keyboard_check(ord("H")))
{
	draw_set_colour(hits_wall(x, y) ? c_lime : c_red);
	draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);
	draw_set_colour(c_white);
}

if (holding != "") global.draw_food(holding_food, holding, x, y - 26, 1);
