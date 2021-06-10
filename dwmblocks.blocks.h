//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/

// laptop
{"","bash ~/repos/personal/dwmblocks/status.sh status_battery",         1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_signalstrength",  1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_ssid",            1,0},

// misc
//{"","bash ~/repos/personal/dwmblocks/status.sh status_updates",         1800,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_git",             1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_containers",      1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_mounts",          1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_volume",          1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_caps",            1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_brightness",      1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_wallpaper",       60,0},

// performance
{"","bash ~/repos/personal/dwmblocks/status.sh status_memory",          1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_disk",            1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_cpu",             1,0},

// network
//{"","bash ~/repos/personal/dwmblocks/status.sh status_ip",              1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_vpn_blocked",     1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_vpn",             1,0},
//{"","bash ~/repos/personal/dwmblocks/status.sh status_internet",        1,0},

// minimum
{"","bash ~/repos/personal/dwmblocks/status.sh status_date",            1,0},

// end
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " ";
static unsigned int delimLen = 5;
