if (washing && current_time - wash_start >= wash_each)
{
	global.sink_dirty--;
	global.clean_plates++;
	global.plates_washed++;
	sparkle_until = current_time + 400;
	wash_start = current_time;
	if (global.sink_dirty <= 0) stop_washing();
}

if (washing && random(1) < 0.5) array_push(bubbles, { x: x + random_range(-9, 9), y: y - 12, r: random_range(1, 2.5), life: irandom_range(25, 45) });
for (var i = array_length(bubbles) - 1; i >= 0; i--)
{
	var _b = bubbles[i];
	_b.y -= 0.35;
	_b.x += random_range(-0.25, 0.25);
	_b.life--;
	if (_b.life <= 0) array_delete(bubbles, i, 1);
}
