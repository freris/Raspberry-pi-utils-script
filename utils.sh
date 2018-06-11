#!/bin/sh
#Monday 11/06/2018 - 14:41:59 v 1.3
command=$1
RED='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
#No empty strings
if [ -z "$command" ];
then
echo "Please type a question e.g. temp or cpu etc. Or type help to list commands"
exit
fi

#temperature full temp=56.6'C
if [ $command == "tempf" ]
then
temp=$(/opt/vc/bin/vcgencmd measure_temp)
echo $temp
exit
fi

#temperature 56.6'C
if [ $command == "tempc" ]
then
temp=$(/opt/vc/bin/vcgencmd measure_temp)
temp=${temp:5:6}
echo $temp
exit
fi

#temperature only decimal 56.6
if [ $command == "tempd" ]
then
temp=$(/opt/vc/bin/vcgencmd measure_temp)
temp=${temp:5:4} #isolate temp=56.6'C  = 56.6
echo $temp
exit
fi

#cpu with %
if [ $command == "cpuf" ]
then
cpo=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
printf -v cpu "%.1f" "$cpo"
echo $cpu"%"
exit
fi

#cpu without %
if [ $command == "cpu" ]
then
cpo=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
printf -v cpu "%.1f" "$cpo"
echo $cpu
exit
fi

#volt
if [ $command == "volt" ]
then
volts=$(/opt/vc/bin/vcgencmd measure_volts)
volts=${volts:5:4}
echo $volts
exit
fi

#main disk size GB
if [ $command == "disk-s" ]
then
dsk=$(lsblk | grep disk | awk '{print $4;}')
echo $dsk
exit
fi

#root disk size GB
if [ $command == "disk-rs" ]
then
dsk=$(mount | grep ' / '| cut -d ' ' -f 1 | grep -oP "^/dev/\K.*")
usage=$((df -h | grep $dsk) | awk '{print $2;}')
echo $usage
exit
fi

#root disk space used GB
if [ $command == "disk-ru" ]
then
dsk=$(mount | grep ' / '| cut -d ' ' -f 1 | grep -oP "^/dev/\K.*")
usage=$((df -h | grep $dsk) | awk '{print $3;}')
echo $usage
exit
fi

#root disk space free GB
if [ $command == "disk-rf" ]
then
dsk=$(mount | grep ' / '| cut -d ' ' -f 1 | grep -oP "^/dev/\K.*")
usage=$((df -h | grep $dsk) | awk '{print $4;}')
echo $usage
exit
fi

#memory total GB
if [ $command == "mem-t" ]
then
mem=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024}' /proc/meminfo)
echo $mem"GB"
exit
fi

#memory available GB
if [ $command == "mem-a" ]
then
mem=$(awk '/MemAvailable/ { printf "%.3f \n", $2/1024/1024}' /proc/meminfo)
echo $mem"GB"
exit
fi

#memory free GB
if [ $command == "mem-f" ]
then
mem=$(awk '/MemFree/ { printf "%.3f \n", $2/1024/1024}' /proc/meminfo)
echo $mem"GB"
exit
fi

#memory card muted or unmuted ? 
if [ $command == "ismuted" ]
then
card=$2
numi=2
#No empty strings
if [ -z "$card" ];
then
echo "Please type sound card number > ./utils.sh ismuted 1"
exit
fi
if [ $card -gt 0 ]
then
numi=5
else
numi=2
fi
ismu=$(amixer -c $card cget numid=$numi | grep ": values")
ismu=$(echo $ismu | sed 's/^.*=//')
if [ $ismu == "on" ]
then
echo "Unmuted"
fi
if [ $ismu == "off" ]
then
echo "Muted"
fi
exit
fi

#Get volume level
if [ $command == "vol" ]
then
cardno=$2
#No empty strings
if [ -z "$cardno" ];
then
echo "Please type sound card number > ./utils.sh vol 1"
exit
fi
vol=$(amixer -c $cardno scontrols | sed -n "1p"| grep -Po "'.*?'" | sed "s/'//g")
volev=$(amixer -c $cardno get $vol  | grep % | cut -d ' ' -f 6 | sed 's/[^a-zA-Z0-9]//g' | head -1)
echo $volev
exit
fi

#Uptime device
if [ $command == "uptime" ]
then
utim=$(uptime -p)
echo $utim
exit
fi

#Processor name
if [ $command == "procnam" ]
then
pnam=$(cat /proc/cpuinfo | grep "model name" | head -1)
echo $pnam
exit
fi

#Processor chip
if [ $command == "hdchnam" ]
then
pnam=$(cat /proc/cpuinfo | grep "Hardware" | head -1)
echo $pnam
exit
fi

#Find system errors
if [ $command == "gerror" ]
then
er=$(dmesg | grep Error)
echo $er
exit
fi

#Get Internal IP
if [ $command == "devip" ]
then
dip=$(ip addr show eth0 | awk '/inet / {print $2}' | cut -d/ -f 1)
echo $dip
exit
fi

#Get Mac Address
if [ $command == "devmac" ]
then
dmc=$(ip link show eth0 | awk '/ether/ {print $2}')
echo $dmc
exit
fi

#Get Default gateway
if [ $command == "degw" ]
then
dgw=$(ip r | awk '/^def/{print $3}')
echo $dgw
exit
fi

#Is device on line?
if [ $command == "donline" ]
then
#check if fping installed
x=`pacman -Qs fping`
if [ -n "$x" ]
 then 
 :
 else 
 echo ""
 echo -e "${RED} Fping Not Installed. Please wait to install it..."
 echo -e "${NC}"
 pacman --needed --noconfirm -Sy fping
 sleep 2
 echo -e "${NC}"
 echo -e "${YELLOW} Fping Installed. Please wait to run command > If device is online..."
 echo -e "${NC}"
fi
#if installed continue
itest=$(fping -t100 google.com | grep alive)
if [ "$itest" == "" ] 
then 
echo "Off Line"
else
echo "On Line"
fi
exit
fi

#Clean uninstalled packages
if [ $command == "clun" ]
then
clu=$(pacman -Sc --noconfirm)
echo "All uninstalled packages cleaned from cache"
exit
fi

#Clean uninstalled packages
if [ $command == "clall" ]
then
cla=$(pacman -Scc --noconfirm)
echo "All packages cleaned from cache"
exit
fi

#Get serial number
if [ $command == "sno" ]
then
sn=$(grep -Po '^Serial\s*:\s*\K[[:xdigit:]]{16}' /proc/cpuinfo)
echo $sn
exit
fi

#Get host name
if [ $command == "hna" ]
then
hn=$(cat /etc/hostname)
echo $hn
exit
fi

#Get machine id
if [ $command == "mid" ]
then
md=$(cat /etc/machine-id)
echo $md
exit
fi

#List all users
if [ $command == "lus" ]
then
lu=$(cat /etc/passwd | cut -d ":" -f1)
printf  "$lu\n"
exit
fi

#List all groups
if [ $command == "lgp" ]
then
lg=$(cat /etc/group)
printf "$lg\n"
exit
fi

#Check user / group membership
if [ $command == "umb" ]
then
use=$2
#No empty strings
if [ -z "$use" ];
then
echo "Please type user name [ ./utils.sh umb username ]"
exit
fi
um=$(groups $use)
printf "$um\n"
exit
fi

#Check Open Ports
if [ $command == "lop" ]
then
op=$(netstat -tunlp)
printf "$op\n"
exit
fi

#Active Internet connections (only servers)
if [ $command == "lac" ]
then
ap=$(netstat -lntup)
printf "$ap\n"
exit
fi

#Get files/folders infos
if [ $command == "finfo" ]
then
fld=$2
#No empty strings
if [ -z "$fld" ];
then
echo "Please type a folder [ ./utils.sh finfo folder ]"
exit
fi
ap=$(du -shc /$fld/*)
printf "$ap\n"
exit
fi

#Get files/folders infos
if [ $command == "finft" ]
then
fld=$2
#No empty strings
if [ -z "$fld" ];
then
echo "Please type a folder [ ./utils.sh finft folder ]"
exit
fi
ap=$(du -shc /$fld/* | grep total)
printf "$ap\n"
exit
fi

#Get files/folders permissions list
if [ $command == "fperm" ]
then
flp=$2
#No empty strings
if [ -z "$flp" ];
then
echo "Please type a folder [ ./utils.sh fperm folder ]"
exit
fi
ape=$(stat -c "%a %n" /$flp/*)
printf "$ape\n"
exit
fi

#List all clients connected to port 22 (ssh)
if [ $command == "lssh" ]
then
lsh=$(netstat -tn 2>/dev/null | grep :22 | awk '{print $5}' | cut -d: -f1 | uniq -c | awk '{print $2}')
if [ -z $lsh ]
then
echo "No activity detected on all ssh ports"
else
printf "$lsh\n"
fi
exit
fi

#List all clients connected to port 80 (http)
if [ $command == "lhtp" ]
then
lht=$(netstat -tn 2>/dev/null | grep :80 | awk '{print $5}' | cut -d: -f1 | uniq -c | awk '{print $2}')
if [ -z $lht ]
then
echo "No activity detected on all http/https ports"
else
printf "$lht\n"
fi
exit
fi

#List all clients connected on udp ports
if [ $command == "ludp" ]
then
lud=$(netstat -t | grep 'udp' | awk '{print $5}' | cut -d: -f1 | sort | uniq)
if [ -z $lud ]
then
echo "No activity detected on all udp ports"
else
printf "$lud\n"
fi
exit
fi

#List all clients connected on tcp ports
if [ $command == "ltcp" ]
then
ltp=$(netstat -t | grep 'tcp' | awk '{print $5}' | cut -d: -f1 | sort | uniq)
if [ -z $ltp ]
then
echo "No activity detected on all tcp ports"
else
printf "$ltp\n"
fi
exit
fi

#Get a gpio ( BCM_GPIO pins ) value
if [ $command == "lwgp" ]
then
#check if wiringpi installed
x=`pacman -Qs wiringpi`
if [ -n "$x" ]
 then 
 :
 else 
 echo ""
 echo -e "${RED} wiringpi Not Installed. Please install it first."
 echo -e "${NC}"
 exit
fi
gpo=$2
#No empty strings
if [ -z "$gpo" ];
then
echo "Please type a gpio number [./utils.sh lwgp 12]"
exit
fi
gp=$(gpio -g read $gpo)
printf "$gp\n"
exit
fi

#Get a gpio ( Broadcom SOC channel pins ) value
if [ $command == "lwbp" ]
then
#check if wiringpi installed
x=`pacman -Qs wiringpi`
if [ -n "$x" ]
 then 
 :
 else 
 echo ""
 echo -e "${RED} wiringpi Not Installed. Please install it first."
 echo -e "${NC}"
 exit
fi
gpo=$2
#No empty strings
if [ -z "$gpo" ];
then
echo "Please type a gpio number [./utils.sh lwbp 12]"
exit
fi
gp=$(gpio read $gpo)
printf "$gp\n"
exit
fi


#===========================================
#help
if [ $command == "help" ]
then
cat << EOF
***********************************************
*usage: ./utils.sh [command] [extra parameter]*
***********************************************
--------------Available commands:--------------
***********************************************

help ---------> These help instructions...

clall --------> Clean all packages from cache to get more disk space
clun ---------> Clean all uninstalled packages from cache to get more disk space
cpu ----------> Get cpu usage in format > 0.2
cpuf ---------> Get cpu usage in format > 0.2%
degw ---------> Get default gateway
devip --------> Get device internal IP address
devmac -------> Get device Mac address
disk-rf ------> Get root parition free space in format > 5.3G
disk-rs ------> Get root parition size in format > 7.2G
disk-ru ------> Get root parition used space in format > 1.6G
disk-s -------> Get sd card size in format > 7.4G
donline ------> Is device connected to internet?
finfo --------> Get files/folders sizes [ ./utils.sh finfo home ]
finft --------> Get files/folders total size [ ./utils.sh finft home ]
fperm --------> Get files/folders permissions list [./utils.sh fperm home ]
                or get permissions for specific file type e.g .sh [./utils.sh fperm home | grep .sh]
                or for subdirectory [./utils.sh fperm home/alarm] or [./utils.sh fperm home/alarm | grep .sh]
gerror -------> Find all system errors
hdchnam ------> Get processor chip type > Hardware : BCM2835
hna ----------> Get device name
ismuted[card]-> Find if main sound card (PCM) is muted or not [./utils.sh ismuted 1 ]
lac ----------> List all Active Internet connections (only servers)
lgp ----------> List all groups
lop ----------> List all open ports
lus ----------> List all users
lssh ---------> List all clients connected to port 22 (ssh)
lhtp ---------> List all clients connected to port 80 (http)
ltcp ---------> List all clients connected on tcp ports
ludp ---------> List all clients connected on udp ports
lwgp ---------> Get a gpio ( BCM_GPIO pins ) value [./utils.sh lgp 12]
lwbp ---------> Get a gpio ( Broadcom SOC channel ) value [./utils.sh lbp 12]
mem-a --------> Get available ram memory in format > 0.843 GB
mem-f --------> Get free ram memory in format > 0.029 GB
mem-t --------> Get total ram memory in format > 0.914 GB
mid ----------> Get machine id
procnam ------> Get processor name > model name : ARMv7 Processor rev 4 (v7l)
sno ----------> Get device serial number
tempc --------> Get temperature in format > 56.6'C
tempd --------> Get temperature in format > 56.6
tempf --------> Get temperature in format > temp=56.6'C
umb[username]-> List all groups and user membership > [ ./utils.sh umb username ]
uptime -------> Get device uptime in format > up 1 hour, 29 minutes
vol[card no] -> Get volume level of selected card in format > 77
volt ---------> Get cpu voltage in format > 1.26
EOF
exit
fi

#if not match any parameter
echo -e "Error! - Command ${RED}[ $1 ]${NC}  not found!. Type help to get available commands"
