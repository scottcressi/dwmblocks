//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/

// laptop
{" BAT: ","bash ~/repos/personal/dwmblocks/status.sh status_battery",1,0},
{" SIG: ","bash ~/repos/personal/dwmblocks/status.sh status_strength",1,0},
{" SSID: ","bash ~/repos/personal/dwmblocks/status.sh status_network",1,0},

// all
{" VOL: ","bash ~/repos/personal/dwmblocks/status.sh status_volume",1,0},
{" MEM: ","bash ~/repos/personal/dwmblocks/status.sh status_memory",1,0},
{" HDD: ","bash ~/repos/personal/dwmblocks/status.sh status_disk",1,0},
{" CPU: ","bash ~/repos/personal/dwmblocks/status.sh status_cpu",1,0},
{" CAP: ","bash ~/repos/personal/dwmblocks/status.sh status_caps",1,0},
{" IP: ","bash ~/repos/personal/dwmblocks/status.sh status_ip",1,0},
{" DATE: ","bash ~/repos/personal/dwmblocks/status.sh status_date",1,0},
{"","bash ~/repos/personal/dwmblocks/status.sh status_wallpaper",300,0},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
