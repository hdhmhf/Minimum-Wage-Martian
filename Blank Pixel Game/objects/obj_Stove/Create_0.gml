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
		_chef.holding_food = food;
		if (progress < perfect_min - 0.25)  _chef.holding = "raw";
		else if (progress < perfect_min)    _chef.holding = "good";
		else if (progress <= perfect_max)   _chef.holding = "perfect"; //good job
		else if (progress < 0.95)           _chef.holding = "good";
		else                                _chef.holding = "burnt";
		state = "empty";
		var _i = array_get_index(global.burn_times, burn_at);
		if (_i != -1) array_delete(global.burn_times, _i, 1);
	}
}