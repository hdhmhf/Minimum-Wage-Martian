if (day_serial != global.day_serial)
{
	day_serial = global.day_serial;
	plate_food = "";
	plate_kind = "";
	plate_toppings = {};
	customer = noone;
}

draw_self();

if (plate_food == "dirty") global.draw_plate(x, y - 14, 7, true);
else if (plate_food != "")
{
	global.draw_plate(x, y - 14, 7, false);
	global.draw_food(plate_kind, plate_food, x, y - 14, 0.8);
	global.draw_toppings(plate_toppings, x, y - 14, 6);
}
