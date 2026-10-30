if (day_serial != global.day_serial)
{
	if (instance_exists(table) && table.customer == id) table.customer = noone;
	instance_destroy();
	exit;
}

switch (state)
{
	case "walking":
		if (walk_to(spot_x, spot_y)) state = "waiting";
		break;

	case "waiting":
		if (ticket.angry || (!ticket.tutorial && current_time >= ticket.ends))
		{
			if (!ticket.done)
			{
				ticket.done = true;
				global.mistakes++;
			}
			audio_play_sound(snd_angry, 1, false);
			leave();
		}
		else if (table.plate_food != "" && table.plate_food != "dirty")
		{
			ticket.done = true;
			var _good = (table.plate_food == "good" || table.plate_food == "perfect");
			if (ticket.tutorial || (table.plate_kind == wants && _good))
			{
				var _score = global.score_toppings(wants_toppings, table.plate_toppings);
				var _pay = ((table.plate_food == "perfect") ? 15 : 10) + _score.tip;
				global.earn(_pay);
				pay_text = (_score.exact ? "Perfect! " : "") + "+$" + string(_pay);
				pay_until = current_time + 1500;
				state = "eating";
				eat_end = current_time + 3000;
				audio_play_sound(snd_happy, 1, false);
			}
			else
			{
				global.mistakes++;
				table.plate_food = "dirty";
				table.plate_kind = "";
				table.plate_toppings = {};
				audio_play_sound(snd_angry, 1, false);
				leave();
			}
		}
		break;

	case "eating":
		if (current_time >= eat_end)
		{
			table.plate_food = "dirty";
			table.plate_kind = "";
			table.plate_toppings = {};
			leave();
		}
		break;

	case "leaving":
		if (walk_to(exit_x, exit_y)) instance_destroy();
		break;
}

depth = -y;
