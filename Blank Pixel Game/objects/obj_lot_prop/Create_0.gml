
if (!variable_instance_exists(id, "kind"))  kind = "car";
if (!variable_instance_exists(id, "w"))     w = 16;
if (!variable_instance_exists(id, "h"))     h = 16;
if (!variable_instance_exists(id, "col"))   col = c_white;
if (!variable_instance_exists(id, "flip"))  flip = false;
if (!variable_instance_exists(id, "lit"))   lit = false;

dx = x;
dy = y;

// sort with the player, who uses depth = -y
depth = -(dy + h - 8);
if (kind == "overlay") depth = -30000;
if (kind == "wall") visible = false;

if (kind == "lamp" && !variable_instance_exists(id, "box"))
{
	box = [dx + w / 2 - 3, dy + 8, 6, max(4, h - 13)];
}

// scales the 8x4 foot mask to fit box
if (variable_instance_exists(id, "box"))
{
	mask_index = spr_mask_feet;
	image_xscale = box[2] / 8;
	image_yscale = box[3] / 4;
	x = box[0] + 4 * image_xscale;
	y = box[1] - 6 * image_yscale;
}

rc = function(_x1, _y1, _x2, _y2)
{
	var _a = draw_get_alpha();
	var _c = draw_get_color();
	var _l = min(_x1, _x2);
	var _r = max(_x1, _x2);
	var _t = min(_y1, _y2);
	var _b = max(_y1, _y2);
	draw_primitive_begin(pr_trianglelist);
	draw_vertex_color(_l, _t, _c, _a);
	draw_vertex_color(_r, _t, _c, _a);
	draw_vertex_color(_l, _b, _c, _a);
	draw_vertex_color(_r, _t, _c, _a);
	draw_vertex_color(_r, _b, _c, _a);
	draw_vertex_color(_l, _b, _c, _a);
	draw_primitive_end();
};

rr = function(_x1, _y1, _x2, _y2, _rad)
{
	draw_roundrect_ext(min(_x1, _x2), min(_y1, _y2), max(_x1, _x2), max(_y1, _y2), _rad, _rad, false);
};

fy = function(_o)
{
	return flip ? (dy + h - _o) : (dy + _o);
};
