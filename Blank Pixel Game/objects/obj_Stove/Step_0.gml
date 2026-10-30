if (day_serial != global.day_serial)
{
	day_serial = global.day_serial;
	state = "empty";
	food = "";
}

if (state == "cooking")
{
	progress = min((current_time - cook_start) / (cook_seconds * 1000), 1);
}
