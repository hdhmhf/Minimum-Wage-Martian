var _lift = 0;
if (state == "waiting" || state == "eating")
{
	var _cut = 290;
	var _seat_y = y - 9;
	var _part_x = x - sprite_get_xoffset(sprite_index) * image_xscale;
	var _sw = sprite_get_width(sprite_index);
	draw_sprite_part_ext(sprite_index, 0, 0, 0, _sw, _cut, _part_x, _seat_y - _cut * image_yscale, image_xscale, image_yscale, c_white, 1);
	draw_sprite_part_ext(sprite_index, 0, 0, _cut, _sw, sprite_get_height(sprite_index) - _cut, _part_x, _seat_y, image_xscale, image_yscale * 0.5, c_white, 1);
	_lift = 9 - (sprite_get_yoffset(sprite_index) - _cut) * image_yscale;
}
else draw_self();

var _top = bbox_top - 4 - _lift;
if (state == "waiting")
{
	draw_set_colour(c_white);
	draw_roundrect(x - 8, _top - 14, x + 8, _top, false);
	global.draw_food(wants, "good", x, _top - 8, 0.5);
	var _keys = global.topping_keys(wants_toppings);
	for (var k = 0; k < array_length(_keys); k++)
	{
		draw_set_colour(global.condiment_by_id(_keys[k]).colour);
		draw_circle(x - 4 + k * 4, _top - 2, 1, false);
	}
	var _left = ticket.tutorial ? 1 : clamp((ticket.ends - current_time) / ticket.patience, 0, 1);
	draw_set_colour(merge_colour(c_red, c_lime, _left));
	draw_rectangle(x - 8, _top + 2, x - 8 + 16 * _left, _top + 3, false);
	draw_set_colour(c_white);
}
if (current_time < pay_until)
{
	draw_set_halign(fa_center);
	draw_set_colour(make_colour_rgb(255, 203, 93));
	draw_text_transformed(x, _top - 24 - (1500 - (pay_until - current_time)) / 150, pay_text, 0.3, 0.3, 0);
	draw_set_halign(fa_left);
	draw_set_colour(c_white);
}
