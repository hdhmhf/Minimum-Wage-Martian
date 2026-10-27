draw_self();

if (state == "cooking")
{
	var _state = "good";
	if (progress < perfect_min - 0.25) _state = "raw";
	else if (progress >= 0.95) _state = "burnt";
	global.draw_food(food, _state, x, y - 12, 1);

	draw_meter(round(x - 13), round(bbox_top - 7));
}
