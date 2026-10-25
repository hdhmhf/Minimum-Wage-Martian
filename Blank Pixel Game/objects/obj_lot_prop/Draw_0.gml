draw_set_alpha(1);

switch (kind)
{
	// ------------------------------------------------------------ CAR
	case "car":
	{
		var _x1 = dx;
		var _x2 = dx + w;
		var _dark  = merge_color(col, c_black, 0.38);
		var _roof  = merge_color(col, c_white, 0.14);
		var _light = merge_color(col, c_white, 0.35);
		var _glass = make_color_rgb(64, 90, 122);
		var _glint = make_color_rgb(158, 192, 220);

		// soft shadow on the asphalt
		draw_set_alpha(0.32);
		draw_set_color(c_black);
		rr(_x1 - 1, dy + 3, _x2 + 2, dy + h + 3, 8);
		draw_set_alpha(1);

		// tyres peeking out at the sides
		draw_set_color(make_color_rgb(18, 18, 22));
		rc(_x1 - 1, fy(6), _x1 + 2, fy(12));
		rc(_x2 - 2, fy(6), _x2 + 1, fy(12));
		rc(_x1 - 1, fy(h - 12), _x1 + 2, fy(h - 6));
		rc(_x2 - 2, fy(h - 12), _x2 + 1, fy(h - 6));

		// body: dark underside first, then the painted shell on top
		draw_set_color(_dark);
		rr(_x1, dy, _x2, dy + h, 8);
		draw_set_color(col);
		rr(_x1, dy, _x2, dy + h - 2, 8);

		// shiny bonnet
		draw_set_alpha(0.5);
		draw_set_color(_light);
		rc(_x1 + 3, fy(3), _x2 - 3, fy(8));
		draw_set_alpha(1);

		// windscreen, roof, rear window
		draw_set_color(_glass);
		rc(_x1 + 3, fy(10), _x2 - 3, fy(17));
		draw_set_color(_glint);
		rc(_x1 + 4, fy(11), _x1 + 8, fy(13));
		draw_set_color(_roof);
		rr(_x1 + 2, fy(16), _x2 - 2, fy(h - 10), 3);
		draw_set_color(_glass);
		rc(_x1 + 4, fy(h - 10), _x2 - 4, fy(h - 5));

		// head lights and tail lights
		draw_set_color(make_color_rgb(255, 244, 190));
		rc(_x1 + 2, fy(0), _x1 + 6, fy(2));
		rc(_x2 - 6, fy(0), _x2 - 2, fy(2));
		draw_set_color(make_color_rgb(214, 40, 40));
		rc(_x1 + 2, fy(h - 3), _x1 + 6, fy(h - 1));
		rc(_x2 - 6, fy(h - 3), _x2 - 2, fy(h - 1));

		// wing mirrors
		draw_set_color(col);
		rc(_x1 - 2, fy(13), _x1, fy(16));
		rc(_x2, fy(13), _x2 + 2, fy(16));
	}
	break;

	// ------------------------------------------------------------ STREET LAMP
	case "lamp":
	{
		var _lx = dx + w / 2;
		var _lb = dy + h;

		draw_set_alpha(0.3);
		draw_set_color(c_black);
		draw_ellipse(_lx - 6, _lb - 2, _lx + 9, _lb + 2, false);
		draw_set_alpha(1);

		draw_set_color(make_color_rgb(54, 58, 68));
		rc(_lx - 3, _lb - 5, _lx + 3, _lb);
		draw_set_color(make_color_rgb(74, 80, 92));
		rc(_lx - 1, dy + 8, _lx + 1, _lb - 5);
		draw_set_color(make_color_rgb(120, 128, 142));
		rc(_lx - 1, dy + 8, _lx, _lb - 5);
		draw_set_color(make_color_rgb(74, 80, 92));
		rc(_lx - 1, dy + 6, _lx + 6, dy + 8);
		draw_set_color(make_color_rgb(44, 48, 58));
		rr(_lx + 2, dy + 7, _lx + 9, dy + 11, 2);
		draw_set_color(lit ? make_color_rgb(255, 232, 150) : make_color_rgb(190, 198, 206));
		rc(_lx + 3, dy + 10, _lx + 8, dy + 12);
	}
	break;

	// ------------------------------------------------------------ TREE
	case "tree":
	{
		var _tx = dx + w / 2;
		var _tb = dy + h;

		draw_set_alpha(0.28);
		draw_set_color(c_black);
		draw_ellipse(_tx - 17, _tb - 5, _tx + 17, _tb + 4, false);
		draw_set_alpha(1);

		// trunk with little roots
		draw_set_color(make_color_rgb(92, 62, 40));
		rc(_tx - 3, _tb - 17, _tx + 3, _tb);
		draw_set_color(make_color_rgb(128, 90, 58));
		rc(_tx - 3, _tb - 17, _tx - 1, _tb);
		draw_set_color(make_color_rgb(70, 46, 30));
		rc(_tx - 5, _tb - 2, _tx - 3, _tb);
		rc(_tx + 3, _tb - 2, _tx + 5, _tb);

		// canopy in three layers: shade, body, sunlit leaves
		draw_set_color(make_color_rgb(38, 86, 50));
		draw_circle(_tx, _tb - 26, 16, false);
		draw_circle(_tx - 11, _tb - 21, 11, false);
		draw_circle(_tx + 11, _tb - 21, 11, false);
		draw_circle(_tx, _tb - 37, 12, false);
		draw_set_color(make_color_rgb(62, 124, 66));
		draw_circle(_tx - 1, _tb - 28, 13, false);
		draw_circle(_tx - 11, _tb - 23, 8, false);
		draw_circle(_tx + 10, _tb - 24, 8, false);
		draw_circle(_tx - 1, _tb - 38, 9, false);
		draw_set_color(make_color_rgb(108, 168, 84));
		draw_circle(_tx - 5, _tb - 34, 6, false);
		draw_circle(_tx + 6, _tb - 29, 5, false);
		draw_circle(_tx - 10, _tb - 24, 4, false);
		draw_set_color(make_color_rgb(150, 204, 110));
		draw_circle(_tx - 6, _tb - 38, 2, false);
		draw_circle(_tx + 7, _tb - 32, 2, false);
	}
	break;

	// ------------------------------------------------------------ BUSH
	case "bush":
	{
		var _bx = dx + w / 2;
		var _bb = dy + h;

		draw_set_alpha(0.25);
		draw_set_color(c_black);
		draw_ellipse(_bx - 10, _bb - 3, _bx + 10, _bb + 2, false);
		draw_set_alpha(1);

		draw_set_color(make_color_rgb(36, 84, 48));
		draw_circle(_bx - 4, _bb - 6, 6, false);
		draw_circle(_bx + 4, _bb - 6, 6, false);
		draw_circle(_bx, _bb - 9, 6, false);
		draw_set_color(make_color_rgb(60, 122, 64));
		draw_circle(_bx - 4, _bb - 7, 4, false);
		draw_circle(_bx + 4, _bb - 7, 4, false);
		draw_circle(_bx, _bb - 10, 4, false);
		draw_set_color(make_color_rgb(104, 164, 82));
		draw_circle(_bx - 2, _bb - 10, 2, false);
		draw_circle(_bx + 5, _bb - 8, 1, false);

		// a few blossoms
		draw_set_color(make_color_rgb(244, 140, 170));
		rc(_bx - 5, _bb - 8, _bx - 3, _bb - 6);
		rc(_bx + 3, _bb - 11, _bx + 5, _bb - 9);
		draw_set_color(make_color_rgb(250, 226, 110));
		rc(_bx + 1, _bb - 6, _bx + 3, _bb - 4);
	}
	break;

	// ------------------------------------------------------------ PLANTER BOX
	case "planter":
	{
		draw_set_alpha(0.25);
		draw_set_color(c_black);
		draw_ellipse(dx - 1, dy + h - 3, dx + w + 2, dy + h + 2, false);
		draw_set_alpha(1);

		// plants
		draw_set_color(make_color_rgb(52, 116, 62));
		draw_circle(dx + 4, dy + 4, 4, false);
		draw_circle(dx + w - 4, dy + 4, 4, false);
		draw_circle(dx + w / 2, dy + 3, 4, false);
		draw_set_color(make_color_rgb(244, 120, 150));
		rc(dx + 3, dy + 2, dx + 5, dy + 4);
		rc(dx + w - 5, dy + 1, dx + w - 3, dy + 3);
		draw_set_color(make_color_rgb(252, 214, 90));
		rc(dx + w / 2 - 1, dy, dx + w / 2 + 1, dy + 2);

		// box
		draw_set_color(make_color_rgb(148, 84, 60));
		rc(dx, dy + 7, dx + w, dy + h);
		draw_set_color(make_color_rgb(184, 112, 80));
		rc(dx - 1, dy + 6, dx + w + 1, dy + 8);
		draw_set_color(make_color_rgb(110, 60, 44));
		rc(dx, dy + h - 2, dx + w, dy + h);
	}
	break;

	// ------------------------------------------------------------ DUMPSTER
	case "dumpster":
	{
		draw_set_alpha(0.3);
		draw_set_color(c_black);
		draw_ellipse(dx - 1, dy + h - 3, dx + w + 3, dy + h + 3, false);
		draw_set_alpha(1);

		draw_set_color(make_color_rgb(38, 92, 64));
		rc(dx, dy + 8, dx + w, dy + h - 3);
		draw_set_color(make_color_rgb(50, 118, 82));
		rc(dx, dy + 12, dx + w, dy + h - 3);
		draw_set_color(make_color_rgb(34, 84, 58));
		for (var _dr = 4; _dr < w; _dr += 6) rc(dx + _dr, dy + 12, dx + _dr + 1, dy + h - 3);

		// grime and a scuff
		draw_set_alpha(0.35);
		draw_set_color(make_color_rgb(20, 40, 30));
		rc(dx, dy + h - 7, dx + w, dy + h - 3);
		draw_set_alpha(1);
		draw_set_color(make_color_rgb(210, 210, 190));
		rc(dx + 9, dy + 15, dx + 17, dy + 16);

		// hinged lid
		draw_set_color(make_color_rgb(28, 70, 50));
		rr(dx - 1, dy + 2, dx + w + 1, dy + 11, 2);
		draw_set_color(make_color_rgb(44, 100, 72));
		rc(dx + 1, dy + 3, dx + w - 1, dy + 5);

		// wheels and litter
		draw_set_color(make_color_rgb(20, 20, 24));
		rc(dx + 3, dy + h - 3, dx + 7, dy + h);
		rc(dx + w - 7, dy + h - 3, dx + w - 3, dy + h);
		draw_set_color(make_color_rgb(236, 232, 220));
		rc(dx + w + 2, dy + h - 2, dx + w + 5, dy + h - 1);
		rc(dx - 4, dy + h - 1, dx - 2, dy + h);
	}
	break;

	// ------------------------------------------------------------ BENCH
	case "bench":
	{
		draw_set_alpha(0.28);
		draw_set_color(c_black);
		draw_ellipse(dx - 1, dy + h - 3, dx + w + 2, dy + h + 2, false);
		draw_set_alpha(1);

		draw_set_color(make_color_rgb(50, 50, 56));
		rc(dx + 3, dy + 1, dx + 5, dy + h);
		rc(dx + w - 5, dy + 1, dx + w - 3, dy + h);

		// backrest
		draw_set_color(make_color_rgb(176, 128, 78));
		rc(dx, dy + 1, dx + w, dy + 4);
		rc(dx, dy + 5, dx + w, dy + 8);
		// seat
		draw_set_color(make_color_rgb(196, 148, 92));
		rc(dx, dy + 9, dx + w, dy + 12);
		draw_set_color(make_color_rgb(150, 104, 62));
		rc(dx, dy + 12, dx + w, dy + 14);
		draw_set_color(make_color_rgb(78, 52, 32));
		rc(dx, dy + 4, dx + w, dy + 5);
		rc(dx, dy + 8, dx + w, dy + 9);
	}
	break;

	// ------------------------------------------------------------ BOLLARD
	case "bollard":
	{
		draw_set_alpha(0.28);
		draw_set_color(c_black);
		draw_ellipse(dx - 2, dy + h - 2, dx + w + 3, dy + h + 2, false);
		draw_set_alpha(1);
		draw_set_color(make_color_rgb(240, 200, 50));
		rr(dx, dy + 1, dx + w, dy + h, 2);
		draw_set_color(make_color_rgb(40, 40, 44));
		rc(dx, dy + 5, dx + w, dy + 7);
		rc(dx, dy + 9, dx + w, dy + 11);
		draw_set_color(make_color_rgb(255, 232, 130));
		rc(dx + 1, dy + 2, dx + 2, dy + 5);
	}
	break;

	// ------------------------------------------------------------ TRAFFIC CONE
	case "cone":
	{
		draw_set_alpha(0.28);
		draw_set_color(c_black);
		draw_ellipse(dx - 2, dy + h - 2, dx + w + 3, dy + h + 2, false);
		draw_set_alpha(1);
		draw_set_color(make_color_rgb(222, 84, 28));
		rc(dx - 1, dy + h - 2, dx + w + 1, dy + h);
		draw_set_color(make_color_rgb(244, 118, 36));
		draw_triangle(dx + w / 2, dy, dx, dy + h - 2, dx + w, dy + h - 2, false);
		draw_set_color(make_color_rgb(244, 240, 230));
		rc(dx + 2, dy + 3, dx + w - 2, dy + 5);
	}
	break;

	// ------------------------------------------------------------ "P" SIGN
	case "sign":
	{
		draw_set_color(make_color_rgb(130, 134, 142));
		rc(dx + 6, dy + 12, dx + 8, dy + h);
		rc(dx + 4, dy + h - 2, dx + 10, dy + h);
		draw_set_color(make_color_rgb(28, 84, 170));
		rr(dx, dy, dx + w, dy + 14, 2);
		draw_set_color(c_white);
		rc(dx + 4, dy + 3, dx + 6, dy + 11);
		rc(dx + 4, dy + 3, dx + 9, dy + 5);
		rc(dx + 8, dy + 3, dx + 10, dy + 8);
		rc(dx + 4, dy + 7, dx + 9, dy + 9);
	}
	break;

	// ------------------------------------------------------------ MOOD OVERLAY (tint + lamp glow)
	case "overlay":
	{
		var _ow = room_width;
		var _oh = room_height;

		if (tint_a > 0)
		{
			draw_set_alpha(tint_a);
			draw_rectangle_color(0, 0, _ow, _oh, tint_top, tint_top, tint_bot, tint_bot, false);
			draw_set_alpha(1);
		}

		if (lamp_a > 0)
		{
			gpu_set_blendmode(bm_add);
			var _flick = 1 + 0.04 * sin(current_time / 230);

			for (var _ol = 0; _ol < array_length(lamps); _ol++)
			{
				var _lx2 = lamps[_ol][0];
				var _ly2 = lamps[_ol][1];

				// pool of light on the ground
				draw_set_color(make_color_rgb(255, 190, 100));
				for (var _r1 = 72; _r1 > 6; _r1 -= 6)
				{
					draw_set_alpha(0.016 * lamp_a * _flick);
					draw_ellipse(_lx2 + 4 - _r1, _ly2 + 2 - _r1 * 0.5, _lx2 + 4 + _r1, _ly2 + 2 + _r1 * 0.5, false);
				}

				// halo around the bulb
				draw_set_color(make_color_rgb(255, 226, 150));
				for (var _r2 = 11; _r2 > 1; _r2 -= 2)
				{
					draw_set_alpha(0.10 * lamp_a);
					draw_circle(_lx2 + 5, _ly2 - 37, _r2, false);
				}
			}

			// warm light in the restaurant windows
			draw_set_color(make_color_rgb(255, 176, 80));
			draw_set_alpha(0.30 * min(lamp_a, 1));
			for (var _ow2 = 0; _ow2 < array_length(windows); _ow2++)
			{
				rc(windows[_ow2][0], windows[_ow2][1], windows[_ow2][0] + 24, windows[_ow2][1] + 16);
			}

			// wall lamps beside the back door
			for (var _os = 0; _os < array_length(sconces); _os++)
			{
				var _sx = sconces[_os][0];
				var _sy = sconces[_os][1];
				draw_set_color(make_color_rgb(255, 214, 130));
				for (var _r3 = 12; _r3 > 1; _r3 -= 2)
				{
					draw_set_alpha(0.07 * lamp_a);
					draw_circle(_sx, _sy, _r3, false);
				}
				draw_set_color(make_color_rgb(255, 180, 90));
				for (var _r4 = 26; _r4 > 6; _r4 -= 5)
				{
					draw_set_alpha(0.014 * lamp_a);
					draw_ellipse(_sx - _r4, _sy + 20 - _r4 * 0.5, _sx + _r4, _sy + 20 + _r4 * 0.5, false);
				}
			}

			gpu_set_blendmode(bm_normal);
		}

		draw_set_alpha(1);
	}
	break;
}

draw_set_alpha(1);
draw_set_color(c_white);
