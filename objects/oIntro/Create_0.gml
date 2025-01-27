audio_play(snd_logo);
hint = 0;
TweenFire(self, "", 0, 0, 119, 1, "hint>", 1);
y = 0;

enum INTRO_MENU_STATE
{
	LOGO,
	SETTINGS,
	FIRST_TIME, // First time ever open the game
	NAMING,
	NAME_CHECKING,
	NAME_CONFIRM,
	NAME_CHOSEN, // Name changing locked after first time naming ever
	MENU,
}

menu_state = INTRO_MENU_STATE.LOGO;
menu_choice = [0, 0];
input_buffer = 0;

#region Introduction
instruction_label = "--- Instruction ---";
instruction_text =
@"[[Z or ENTER] - Confirm
[[X or SHIFT] - Cancel
[[C or CTRL] - Menu (In-game)
[[F4] - Fullscreen
[[Hold ESC] - Quit
When HP is 0, you lose.";
#endregion

#region // Naming function
Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var i = 0;
naming_letter = ds_grid_create(27, 2);
repeat 27
{
	naming_letter[# i, 0] = string_char_at(Letters, i + 1);
	naming_letter[# i, 1] = string_lower_buffer(naming_letter[# i, 0]);
	++i;
}
naming_choice = 0;
naming_alpha = [1, 0];
name = "";
name_desc = "Is this name correct?";
name_x = 320;
name_y = 110;
name_scale = 1;
name_max_length = 6; // In letter ofc
name_confirm = 0;
name_usable = true
name_check = false;
#endregion

#region // Settings
function CheckName(checkname){
	switch string_lower_buffer(checkname)
	{
		default:
			name_desc = "Is this name correct?";
			name_usable = true;
			break;
		case "chara":
			name_desc = "The true name.";
			name_usable = true;
			break;
		case "frisk":
			name_desc = "WARNING : This name will\rmake your life hell\ranyways, proceed?";
			name_usable = true;
			break;
		case "aaaaaa":
			name_desc = "Not very creative...?";
			name_usable = true;
			break;
		case "toriel":
			name_desc = "I think you should\rthink of your own\rname, my child.";
			name_usable = false;
			name_confirm = false;
			break;
		case "alphy":
			name_desc = "Uh.... Ok?";
			name_usable = true;
			break;
		case "alphys":
			name_desc = "D-Don't do that.";
			name_usable = false;
			name_confirm = false;
			break;
		case "asgore":
			name_desc = "You cannot.";
			name_usable = false;
			name_confirm = false;
			break;
		case "asriel":
			name_desc = "...";
			name_usable = false;
			name_confirm = false;
			break;
		case "flowey":
			name_desc = "I already CHOSE\rthat name.";
			name_confirm = false;
			name_usable = false;
			break;
		case "sans":
			name_desc = "nope.";
			name_confirm = false;
			name_usable = false;
			break;
		case "papyru":
			name_desc = "I'LL ALLOW IT!!!!";
			name_usable = true;
			break;
		case "undyne":
			name_desc = "Get your OWN name!";
			name_usable = false;
			name_confirm = false;
			break;
		case "mtt":
		case "mettat":
		case "metta":
			name_desc = "OOOOH!!! ARE YOU\rPROMOTING MY BRAND?";
			name_usable = true;
			break;
		case "temmie":
			name_desc = "hOI!";
			name_usable = true;
			break;
		case "murder":
		case "mercy":
			name_desc = "That's a little on-\rthe-nose, isn't it...?";
			name_usable = true;
			break;
		case "gerson":
			name_desc = "Wah ha ha! Why not?";
			name_usable = true;
			break;
		case "bratty":
			name_desc = "Like, OK I guess.";
			name_usable = true;
			break;
		case "catty":
			name_desc = "Bratty! Bratty!\rThat's MY name!";
			name_usable = true;
			break;
		case "bpants":
			name_desc = "You are really scraping the\rbottom of the barrel.";
			name_usable = true;
			break;
		case "jerry":
			name_desc = "Jerry.";
			name_usable = true;
			break;
		case "woshua":
			name_desc = "Clean name.";
			name_usable = true;
			break;
		case "blooky":
			name_desc = "..........\r(They're powerless to\rstop you.)";
			name_usable = true;
			break;
		case "shyren":
			name_desc = "...?";
			name_usable = true;
			break;
		case "aaron":
			name_desc = "Is this name correct? ;)";
			name_usable = true;
			break;
		case "gaster":
			game_restart();
			break;
	}
}
LogoText = "UNDERTALE";
fading = false;
#endregion