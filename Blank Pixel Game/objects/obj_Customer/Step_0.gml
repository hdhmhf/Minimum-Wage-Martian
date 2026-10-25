switch (state)
{
	case "walking":
		if (walk_to(spot_x, spot_y))
		{
			state = "waiting";
			ticket.ends = current_time + patience_ms;
			array_push(global.tickets, ticket);
		}
		break;

	case "waiting":
		if (ticket.angry || current_time >= ticket.ends)
		{
			if (!ticket.done)
			{
				ticket.done = true;
				global.mistakes++;
			}
			audio_play_sound(snd_angry, 1, false);
			leave();
		}
		else if (table.plate_food != "")
		{
			ticket.done = true;
			if (table.plate_kind == wants && (table.plate_food == "good" || table.plate_food == "perfect"))
			{
				global.money += (table.plate_food == "perfect") ? 15 : 10;
				state = "eating";
				eat_end = current_time + 3000;
				audio_play_sound(snd_happy, 1, false);
			}
			else
			{
				global.mistakes++;
				table.plate_food = "";
				table.plate_kind = "";
				audio_play_sound(snd_angry, 1, false);
				leave();
			}
		}
		break;

	case "eating":
		if (current_time >= eat_end)
		{
			table.plate_food = "";
			table.plate_kind = "";
			leave();
		}
		break;

	case "leaving":
		if (walk_to(exit_x, exit_y)) instance_destroy();
		break;
}

depth = -y;
