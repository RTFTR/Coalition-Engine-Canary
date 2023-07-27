//Draw main option texts
surface_set_target(MainOptionSurf);
draw_set_font(fnt_dt_sans);
draw_set_halign(fa_left);
var i = 0;
repeat array_length(MainOptions)
{
	draw_set_color(State == i + 1 ? c_yellow : c_white);
	var BaseY = 40 + MainOptionDisplaceY + i * 70,
		BottomY = BaseY + string_height(MainOptions[i]) + 5,
		BaseX = 30 + MainOptionDisplaceX,
		RightX = BaseX + 200;
	if point_in_rectangle(mouse_x, mouse_y, BaseX, BaseY - 5, RightX, BottomY)
	{
		if State == DEBUG_STATE.MAIN
		{
			draw_set_color(c_yellow);
		}
		if mouse_check_button_pressed(mb_left)
		{
			State = i + 1;
			MainOptionChoice = i;
			LoadSubOptions(i);
			audio_play(snd_menu_confirm);
		}
		if mouse_check_button_pressed(mb_right) && State == i + 1
		{
			State = DEBUG_STATE.MAIN;
			audio_play(snd_menu_confirm);
		}
	}
	draw_rectangle_width(BaseX, BaseY - 5, RightX, BottomY, 5, draw_get_color());
	draw_text(BaseX + 10, BaseY, MainOptions[i]);
	draw_set_color(c_white);
	++i;
}
surface_reset_target();
//Main options box
draw_rectangle_width(BaseX - 10, 20, RightX + 10, 460, 5);
draw_surface_part(MainOptionSurf, BaseX - 10, 20, 240, 440, BaseX - 10, 20);
surface_free(MainOptionSurf);

//Sub-options
if State != DEBUG_STATE.MAIN
{
	surface_set_target(SubOptionSurf);
	var i = 0;
	repeat array_length(SubOptions)
	{
		draw_set_color(c_white);
		var BaseY = 40 + SubOptionDisplaceY + i * 70,
			BottomY = BaseY + string_height(SubOptions[i]) + 5,
			BaseX = 270 + SubOptionDisplaceX,
			RightX = BaseX + 200;
		if point_in_rectangle(mouse_x, mouse_y, BaseX, BaseY - 5, RightX, BottomY)
		{
			draw_set_color(c_yellow);
			if mouse_check_button_pressed(mb_left) SubOptionAction(i);
		}
		draw_rectangle_width(BaseX, BaseY - 5, RightX, BottomY, 5, draw_get_color());
		draw_text(BaseX + 10, BaseY, string_limit(SubOptions[i], 180));
		draw_set_color(c_white);
		++i;
	}
	surface_reset_target();
	//Sub-options box
	draw_rectangle_width(BaseX - 10, 20, RightX + 10, 460, 5);
	draw_surface_part(SubOptionSurf, BaseX - 10, 20, 240, 440, BaseX - 10, 20);
	surface_free(SubOptionSurf);
	if State == DEBUG_STATE.SPRITES
	{
		if sprite_exists(SubOptionDrawSprite)
		{
			var offx = sprite_get_xoffset(SubOptionDrawSprite),
				offy = sprite_get_yoffset(SubOptionDrawSprite),
				sprwidth = sprite_get_width(SubOptionDrawSprite),
				sprheight = sprite_get_height(SubOptionDrawSprite),
				xscale = max(min(300 / sprwidth, 1), 100 / sprwidth),
				yscale = max(min(160 / sprheight, 1), 100 / sprheight),
				FinScale = min(xscale, yscale),
				nine = sprite_get_nineslice(SubOptionDrawSprite);
			draw_sprite_ext(SubOptionDrawSprite, 0, 430, 240, FinScale, FinScale, 0, c_white, 1);
			draw_set_font(fnt_mnc);
			draw_set_halign(fa_center);
			var text = "Scaled to: " + string(FinScale) + "x"
			if nine.enabled
				text += "\nNine slice is enabled,\nimage may be drawn incorrectly";
			draw_text(430, 410, text);
			draw_text(430, 20, "Origin: " + string(offx) + ", " + string(offy));
			draw_set_halign(fa_left);
		}
	}
}