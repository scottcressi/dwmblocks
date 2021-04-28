//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/

// laptop
{"","bash ~/repos/personal/dwmblocks/status.sh status_battery",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_strength",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_network",5,0},

// all
{"","bash ~/repos/personal/dwmblocks/status.sh status_containers",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_mounts",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_volume",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_memory",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_disk",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_cpu",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_caps",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_ip",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_router",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_vpn",5,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_date",1,0},

// end
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " ";
static unsigned int delimLen = 5;
