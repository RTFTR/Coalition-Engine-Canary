audio_play(snd_logo);
hint = 0;
TweenFire(self, EaseLinear, TWEEN_MODE_ONCE, false, 119, 1, "hint", 0, 1);
y = 0;

//instance_create_depth(0,0,1,RainbowFuture);
//if choose(0,1)
//	instance_create_depth(0,0,1,Bloomer);
//var shd = choose(
////shdSepia,
////shdInvert,
//shdNoise
//)
//Effect_Shader(shd);

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

#region // Naming function
var Letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
naming_letter = [Letters, string_lower(Letters)];
naming_choice = 1;
naming_alpha = [1, 0];
name = "";
name_desc = "Is this name correct?";
name_x = 320;
name_y = 110;
name_scale = 1;
name_max_length = 6; // In letter ofc
name_confirm = 0;
name_check = false;
#endregion

#region // Settings
global.easy = true;
is_setting = false;
settings_x = -480;
Setting = 0;
SettingY = 85;
SettingYTarget = 85;
SettingSoundIsPlayed = false;
BGShdVal = 0;
SettingVar =
[
	global.Volume,
	global.CompatibilityMode,
	global.ShowFPS,
	global.easy,
	global.InputKeys,
	undefined
];
SettingVarChange = [5, 0, 0, 0, 0];
SettingName =
[
	"Master Volume",
	"Show FPS",
	"Compatibility Mode",
	"Easy Mode",
	"Input Keys",
	"Battle Select",
];
MouseInSetting = false;
SettingDescX = 1000;
SettingDesc =
[
	"Volume of game\n(Left Right to Toggle)\n(Shift for precise)",
	"Shows FPS on the top\nright corner",
	"Reduces special effects",
	"Enables Easy Mode",
	"Change your inputs",
	"",
];
SettingSurface = -1;
SelectingKey = false;
function SettingPush(name, vary, desc)
{
	array_push(SettingName, name);
	array_push(SettingVar, vary);
	array_push(SettingDesc, desc);
}

KeyIsSetting = false;
KeySelX = 1000;
KeyTextY = 30;
KeyTextYTarget = 30;
KeySet = -1;
KeySetVerb = "";
KeyScale = array_create(14, 0.6);
KeySurface = -1;

ValSetX = 1000;
CubePos = [320, 100];
LerpSpeed = 0.12;
TitleScale = 1;
Titlepos = [320, 200];
DescX = 320;
LogoText = "Coalition\nEngine";
LogoText = "UNDERTALE";
Musics = audio_create_stream_array("MusSans", "MusOST1");
MusicList = [];
fading = false;
#endregion

window_set_cursor(cr_none);
instance_create_depth(mouse_x, mouse_y, -1, oOrbit);