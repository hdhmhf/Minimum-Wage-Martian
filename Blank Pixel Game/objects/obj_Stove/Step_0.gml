if (state == "cooking")
{
	progress = min((current_time - cook_start) / (cook_seconds * 1000), 1);
}
