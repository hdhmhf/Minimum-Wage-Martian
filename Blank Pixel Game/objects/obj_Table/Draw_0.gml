draw_self();

if (plate_food != "")
{
	draw_set_colour(c_white);
	draw_ellipse(x - 7, y - 18, x + 7, y - 10, false);
	draw_set_colour(c_ltgray);
	draw_ellipse(x - 7, y - 18, x + 7, y - 10, true);
	draw_set_colour(c_white);

	global.draw_food(plate_kind, plate_food, x, y - 14, 0.8);
}
