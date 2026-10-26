display_set_gui_size(320, 180);

global.money = 0;
global.money_goal = 500;
global.mistakes = 0;
global.max_mistakes = 5;
global.game_over = "";
global.tickets = [];
global.car_owned = false;
global.car_feedback = "";
global.car_feedback_until = 0;
global.order_mode = "restaurant";
global.neighborhood_orders = [];
global.orders_open = true;
global.orders_scale = min((display_get_gui_height() - 12) / 400, (display_get_gui_width() - 20) / 400);
global.orders_x = (display_get_gui_width() - 400 * global.orders_scale) / 2;
global.orders_y = (display_get_gui_height() - 400 * global.orders_scale) / 2;
global.tablet_open = false;
global.tablet_button_alpha = 1;
global.orders_dragging = false;
global.orders_resizing = false;
global.orders_drag_moved = false;
global.orders_drag_offset_x = 0;
global.orders_drag_offset_y = 0;
global.orders_drag_start_x = 0;
global.orders_drag_start_y = 0;

next_spawn = current_time + 3000;
next_neighborhood_order = current_time + 5000;

global.in_story = true;
global.tutorial_active = false;
global.tutorial_page = 0;
story_frame = 0;
story_start_time = current_time;

audio_stop_sound(snd_music);
audio_play_sound(snd_intro, 1, true);
