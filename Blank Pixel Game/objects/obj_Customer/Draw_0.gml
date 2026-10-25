draw_self();

if (state == "waiting")
{
	var _top = bbox_top - 4;
	draw_set_colour(c_white);
	draw_roundrect(x - 8, _top - 14, x + 8, _top, false);
	global.draw_food(wants, "good", x, _top - 7, 0.5);
	var _left = clamp((ticket.ends - current_time) / patience_ms, 0, 1);
	draw_set_colour(merge_colour(c_red, c_lime, _left));
	draw_rectangle(x - 8, _top + 2, x - 8 + 16 * _left, _top + 3, false);
	draw_set_colour(c_white);
}
