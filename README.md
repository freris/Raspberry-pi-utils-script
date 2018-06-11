# Raspberry-pi-utils-script
**A Raspberry-pi script in bash (For ArchLinux Only) to get some useful system informations**

***Usage : ./utils.sh [command] [parameter]***

Available commands ( or run ./utils.sh help )

**help** > help instructions

**clall**   > Clean all packages from cache to get more disk space

**clun**    > Clean all uninstalled packages from cache to get more disk space

**cpu**     > Get cpu usage in format > 0.2

**cpuf**    > Get cpu usage in format > 0.2%

**degw**    > Get default gateway

**devip**   > Get device internal IP address

**devmac**  > Get device Mac address

**disk-rf** > Get root parition free space in format > 5.3G

**disk-rs** > Get root parition size in format > 7.2G

**disk-ru** > Get root parition used space in format > 1.6G

**disk-s**  > Get sd card size in format > 7.4G

**donline** > Is device connected to internet?

**finfo**   > Get files/folders sizes [ ./utils.sh finfo home ]

**finft**   > Get files/folders total size [ ./utils.sh finft home ]

**fperm**   > Get files/folders permissions list [./utils.sh fperm home ]
                or get permissions for specific file type e.g .sh [./utils.sh fperm home | grep .sh]
                or for subdirectory [./utils.sh fperm home/alarm] or [./utils.sh fperm home/alarm | grep .sh]

**gerro**r  > Find all system errors

**hdchnam** > Get processor chip type > Hardware : BCM2835

**hna**     > Get device name

**ismuted**[card] > Find if main sound card (PCM) is muted or not [./utils.sh ismuted 1 ]

**lac**     > List all Active Internet connections (only servers)

**lgp**     > List all groups

**lop**     > List all open ports

**lus**     > List all users

**lssh**    > List all clients connected to port 22 (ssh)

**lhtp**    > List all clients connected to port 80 (http)

**ltcp**    > List all clients connected on tcp ports

**ludp**    > List all clients connected on udp ports

**lwgp**    > Get a gpio ( BCM_GPIO pins ) value [./utils.sh lgp 12]

**lwbp**    > Get a gpio ( Broadcom SOC channel ) value [./utils.sh lbp 12]

**mem-a**   > Get available ram memory in format > 0.843 GB

**mem-f**   > Get free ram memory in format > 0.029 GB

**mem-t**   > Get total ram memory in format > 0.914 GB

**mid**     > Get machine id

**procnam** > Get processor name > model name : ARMv7 Processor rev 4 (v7l)

**sno**     > Get device serial number

**tempc**   > Get temperature in format > 56.6'C

**tempd**   > Get temperature in format > 56.6

**tempf**   > Get temperature in format > temp=56.6'C

**umb**[username] > List all groups and user membership > [ ./utils.sh umb username ]

**uptime**  > Get device uptime in format > up 1 hour, 29 minutes

**vol**[card no] > Get volume level of selected card in format > 77

**volt**    > Get cpu voltage in format > 1.26a
