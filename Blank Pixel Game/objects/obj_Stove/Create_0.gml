depth = -y;

state = "empty";   // "empty" or "cooking"
progress = 0;      // 0 = raw, 1 = burnt
cook_seconds = 6;  // how long from raw to burnt
perfect_min = 0.65;
perfect_max = 0.80;
food = "";
cook_start = 0;
burn_at = 0;
if (!variable_global_exists("burn_times")) global.burn_times = [];
day_serial = variable_global_exists("day_serial") ? global.day_serial : 0;

// called when u press E next to the stove
use = function(_chef)
{
	if (state == "empty")
	{
		if (_chef.holding == "raw")
		{
			food = _chef.holding_food;
			_chef.holding = "";
			_chef.holding_food = "";
			state = "cooking";
			progress = 0;
			cook_start = current_time;
			burn_at = cook_start + 0.95 * cook_seconds * 1000;
			array_push(global.burn_times, burn_at);
			audio_play_sound(snd_cook, 1, false);
		}
	}
	else if (_chef.holding == "")
	{
		var _st = "burnt";
		if (progress < perfect_min - 0.25)  _st = "raw";
		else if (progress < perfect_min)    _st = "good";
		else if (progress <= perfect_max)   _st = "perfect"; //good job
		else if (progress < 0.95)           _st = "good";
		if (_st != "raw")
		{
			if (global.clean_plates <= 0)
			{
				global.car_feedback = "No clean plates! Wash dishes at the sink.";
				global.car_feedback_until = current_time + 2500;
				return;
			}
			global.clean_plates--;
		}
		_chef.holding_food = food;
		_chef.holding = _st;
		_chef.holding_toppings = {};
		state = "empty";
		var _i = array_get_index(global.burn_times, burn_at);
		if (_i != -1) array_delete(global.burn_times, _i, 1);
	}
}


draw_meter = function(_x1, _y1)
{
	var _w = 26, _h = 4;
	var _x2 = _x1 + _w, _y2 = _y1 + _h;
	var _in_perfect = (progress >= perfect_min && progress <= perfect_max);

	draw_set_colour(_in_perfect ? make_colour_rgb(255, 203, 93) : c_black);
	draw_rectangle(_x1 - 1, _y1 - 1, _x2 + 1, _y2 + 1, false);
	draw_set_colour(make_colour_rgb(60, 60, 70));
	draw_rectangle(_x1, _y1, _x2, _y2, false);
	if (progress > 0)
	{
		draw_set_colour(make_colour_rgb(255, 203, 93));
		draw_rectangle(_x1, _y1, _x1 + _w * progress, _y2, false);
	}
	draw_set_colour(make_colour_rgb(80, 200, 90));
	draw_rectangle(_x1 + _w * perfect_min, _y1, _x1 + _w * perfect_max, _y2, false);
	draw_set_colour(make_colour_rgb(210, 50, 50));
	draw_rectangle(_x1 + _w * 0.95, _y1, _x2, _y2, false);
	draw_set_alpha(0.35);
	draw_set_colour(c_white);
	draw_line(_x1, _y1, _x2, _y1);
	draw_set_alpha(1);

	var _nx = round(_x1 + _w * progress);
	draw_set_colour(c_black);
	draw_rectangle(_nx - 1, _y1 - 3, _nx + 1, _y2 + 2, false);
	draw_set_colour(c_white);
	draw_rectangle(_nx, _y1 - 2, _nx, _y2 + 1, false);
}
