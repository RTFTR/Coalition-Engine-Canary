function Encounter_Begin(exclaim = 1, move = 1)
{
	encounter_soul_x = 	(x - camera_get_view_x(view_camera[0])) * oGlobal.camera_scale_x;
	encounter_soul_y = 	(y - camera_get_view_y(view_camera[0]) - sprite_height / 2) * oGlobal.camera_scale_y;
	encounter_state = 3 - move - exclaim;
	if encounter_state == 1 audio_play(snd_warning);
}
function CollidingWithTile(Name)
{
	var input_horizontal = input_check("right") - input_check("left"),
		input_vertical =   input_check("down") - input_check("up"),
		input_cancel =     input_check("cancel"),
		spd = (global.spd + input_cancel) * speed_multiplier;
	// Check collision with tiles
	var lay_id = layer_get_id(Name),
		map_id, colliding = [true, true];
	//Collision checking
	map_id = layer_tilemap_get_id(lay_id);
	if input_horizontal != 0
	{
		var Left =  [true, true],
			Right = [true, true];
		if input_check("left")
			Left =  [tilemap_get_at_pixel(map_id, bbox_left - spd, bbox_top),
					tilemap_get_at_pixel(map_id, bbox_left - spd, bbox_bottom)];
		else if input_check("right")
			Right = [tilemap_get_at_pixel(map_id, bbox_right + spd, bbox_top),
						tilemap_get_at_pixel(map_id, bbox_right + spd, bbox_bottom)];
	
		Left =  !(Left[0] and Left[1]);
		Right = !(Right[0] and Right[1]);
		if Right or Left
		{
			colliding[0] = false;
		}	 
	}
	if input_vertical != 0
	{
		var Up =   [true, true],
			Down = [true, true];
		if input_check("up")
			Up =  [tilemap_get_at_pixel(map_id, bbox_left, bbox_top - spd),
					tilemap_get_at_pixel(map_id, bbox_right, bbox_top - spd)];
		else if input_check("down")
			Down = [tilemap_get_at_pixel(map_id, bbox_left, bbox_bottom + spd),
						tilemap_get_at_pixel(map_id, bbox_right, bbox_bottom + spd)];
	
		Up =   !(Up[0] and Up[1]);
		Down = !(Down[0] and Down[1]);
		if Down or Up
		{
			colliding[1] = false;
		}
	}
	return colliding;
}
#region Encounter
if encounter_state
{
	moveable = false;
	draw_menu = false
	encounter_time++;
	if encounter_state == 1
	{
		draw_sprite(sprEncounterExclaimation, 0, x, y - sprite_height);
		if encounter_time == 30
		{
			encounter_state++;
			encounter_time = 0;
		}
	}
	if encounter_state == 2
	{
		encounter_draw[0] = 1;
		if !(encounter_time % 5) and encounter_time < 20
		{
			audio_play(snd_noise);
			encounter_draw[2] = !encounter_draw[2];
		}
		if encounter_time == 20
		{
			encounter_draw[1] = 0;
			encounter_draw[2] = 1;
			audio_play(snd_encounter_soul_move);
			TweenFire(id, EaseLinear, TWEEN_MODE_ONCE, false, 0, 30, "encounter_soul_x", encounter_soul_x, 48);
			TweenFire(id, EaseLinear, TWEEN_MODE_ONCE, false, 0, 30, "encounter_soul_y", encounter_soul_y, 454);
		}
		if encounter_time == 50
		{
			encounter_state++;
			encounter_time = 0;
		}
	}
	if encounter_state == 3
	{
		if encounter_time == 1
		{
			Fader_Fade(1, 0 , 20, 0, c_black);
			room_goto(room_battle);
		}
	}
}
#endregion

// Input check as local variable for handy referencing
var input_horizontal = input_check("right") - input_check("left"),
	input_vertical =   input_check("down") - input_check("up"),
	//input_confirm =    input_check("confirm"),
	input_cancel =     input_check("cancel"),
	input_menu =	   input_check_pressed("menu"),
	spd = (global.spd + input_cancel) * speed_multiplier,
	scale_x = last_dir,
	assign_sprite = last_sprite;

// Menu opening
if global.interact_state == INTERACT_STATE.IDLE and !oOWController.menu_disable and !oOWController.dialog_exists
{
	if input_menu // Open Menu, UI works in oOWController
	{
		// This time source act as a buffer as the input check can also proceed
		// the menu closing input due to input check is global
		var delay = function()
					{
						global.interact_state = INTERACT_STATE.MENU;
						oOWController.menu = true;
						audio_play(snd_menu_switch);
						moveable = false;
					}
		var _handle = call_later(1, time_source_units_frames, delay);
	}
}

if keyboard_check_pressed(vk_space) or (x >= 830 and encounter_state == 0) Encounter_Begin();

if moveable // When the player can move around
{
	var colliding = CollidingWithTile("TileCollision");
	if !colliding[0]
	{
		assign_sprite = dir_sprite[2];
		scale_x = -sign(input_horizontal);
	
		x += sign(input_horizontal) ? spd : -spd;
	}
	if !colliding[1]
	{
		assign_sprite = dir_sprite[max(0, sign(input_vertical))];
		scale_x = 1
	
		y += sign(input_vertical) ? spd : -spd;
	}
	last_sprite = assign_sprite;
	last_dir = scale_x;
}
else
{
	assign_sprite = last_sprite;
	scale_x = last_dir;
}


image_xscale = scale_x;
if assign_sprite != -1 sprite_index = assign_sprite;
if (input_horizontal != 0 or input_vertical != 0) and moveable image_speed = spd / 12;
else 
{
	image_speed = 0;
	image_index = 0.5;
}

//Menu Idle spriting thing
if oOWController.menu
{
	switch oOWController.menu_state
	{
		case 0:		//Selection
			sprite_index = sprFriskThink;
			image_index = global.timer / 25;
		break
		case 1:		//Items
			sprite_index = sprFriskPocket;
			image_index = global.timer / 50;
		break
		case 3:		//Cell
			sprite_index = sprFriskCell;
		break
	}
}
else sprite_index = (assign_sprite == -1 ? dir_sprite[2] : assign_sprite)