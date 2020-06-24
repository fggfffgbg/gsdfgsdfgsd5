#!/bin/bash
#MIT License
#
#Copyright (c) 2019-2020 JohnRosen

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

#Run me with:

#apt-get update && apt-get install sudo curl -y && sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/johnrosen1/vpstoolbox/master/vps.sh)"

#                 _              _ _               
#__   ___ __  ___| |_ ___   ___ | | |__   _____  __
#\ \ / / '_ \/ __| __/ _ \ / _ \| | '_ \ / _ \ \/ /
# \ V /| |_) \__ \ || (_) | (_) | | |_) | (_) >  < 
#  \_/ | .__/|___/\__\___/ \___/|_|_.__/ \___/_/\_\
#      |_|                                         
                                     

clear

set +e

if [[ $(id -u) != 0 ]]; then
	echo Please run this script as root.
	exit 1
fi

if [[ $(uname -m 2> /dev/null) != x86_64 ]]; then
	echo Please run this script on x86_64 machine.
	exit 1
fi

if [[ $(free -m  | grep Mem | awk '{print $2}' 2> /dev/null) -le "400" ]]; then
  echo Please run this script on machine with more than 400MB free ram.
  exit 1
fi

if [[ $(df $PWD | awk '/[0-9]%/{print $(NF-2)}' 2> /dev/null) -le "3000000" ]]; then
  echo Please run this script on machine with more than 3G free disk space.
  exit 1
fi

colorEcho(){
	set +e
	COLOR=$1
	echo -e "\033[${COLOR}${@:2}\033[0m"
}

if [[ -f /etc/init.d/aegis ]] || [[ -f /etc/systemd/system/aliyun.service ]]; then
colorEcho ${INFO} "Uninstall Aliyun aegis ing"
echo "" > /etc/motd
iptables -I INPUT -s 140.205.201.0/28 -j DROP
iptables -I INPUT -s 140.205.201.16/29 -j DROP
iptables -I INPUT -s 140.205.201.32/28 -j DROP
iptables -I INPUT -s 140.205.225.192/29 -j DROP
iptables -I INPUT -s 140.205.225.200/30 -j DROP
iptables -I INPUT -s 140.205.225.184/29 -j DROP
iptables -I INPUT -s 140.205.225.183/32 -j DROP
iptables -I INPUT -s 140.205.225.206/32 -j DROP
iptables -I INPUT -s 140.205.225.205/32 -j DROP
iptables -I INPUT -s 140.205.225.195/32 -j DROP
iptables -I INPUT -s 140.205.225.204/32 -j DROP
systemctl stop aegis
systemctl stop CmsGoAgent.service
systemctl stop aliyun
systemctl stop cloud-config
systemctl stop cloud-final
systemctl stop cloud-init-local.service
systemctl stop cloud-init
systemctl stop ecs_mq
systemctl stop exim4
systemctl stop apparmor
systemctl stop sysstat
systemctl disable aegis
systemctl disable CmsGoAgent.service
systemctl disable aliyun
systemctl disable cloud-config
systemctl disable cloud-final
systemctl disable cloud-init-local.service
systemctl disable cloud-init
systemctl disable ecs_mq
systemctl disable exim4
systemctl disable apparmor
systemctl disable sysstat
killall -9 aegis_cli >/dev/null 2>&1
killall -9 aegis_update >/dev/null 2>&1
killall -9 aegis_cli >/dev/null 2>&1
killall -9 AliYunDun >/dev/null 2>&1
killall -9 AliHids >/dev/null 2>&1
killall -9 AliHips >/dev/null 2>&1
killall -9 AliYunDunUpdate >/dev/null 2>&1
rm -rf /etc/init.d/aegis
rm -rf /etc/systemd/system/CmsGoAgent*
rm -rf /etc/systemd/system/aliyun*
rm -rf /lib/systemd/system/cloud*
rm -rf /lib/systemd/system/ecs_mq*
rm -rf /usr/local/aegis
rm -rf /usr/local/cloudmonitor
rm -rf /usr/sbin/aliyun*
rm -rf /sbin/ecs_mq_rps_rfs
for ((var=2; var<=5; var++)) do
	if [ -d "/etc/rc${var}.d/" ];then
		rm -rf "/etc/rc${var}.d/S80aegis"
	elif [ -d "/etc/rc.d/rc${var}.d" ];then
		rm -rf "/etc/rc.d/rc${var}.d/S80aegis"
	fi
done
apt-get purge sysstat exim4 chrony aliyun-assist telnet -y
systemctl daemon-reload
	if [[ $(lsb_release -cs) == stretch ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ oldstable main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable main contrib non-free

deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free

deb http://deb.debian.org/debian-security oldstable/updates main
deb-src http://deb.debian.org/debian-security oldstable/updates main

deb http://ftp.debian.org/debian stretch-backports main
deb-src http://ftp.debian.org/debian stretch-backports main
EOF
fi
	if [[ $(lsb_release -cs) == bionic ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#

###### Ubuntu Main Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
EOF
echo "nameserver 1.1.1.1" > '/etc/resolv.conf'
	fi
fi
#######color code############
ERROR="31m"      # Error message
SUCCESS="32m"    # Success message
WARNING="33m"   # Warning message
INFO="36m"     # Info message
LINK="92m"     # Share Link Message
#############################
cipher_server="ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
cipher_client="ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA"
#############################
systeminfo(){
	#neofetch
	#colorEcho ${INFO} "System Info"
	#olorEcho ${INFO} "1. CPU INFO"
	#colorEcho ${INFO} "model name: $( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )"
	#colorEcho ${INFO} "cpu cores: $( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo ) core(s)"
	#colorEcho ${INFO} "cpu freqency: $( awk -F'[ :]' '/cpu MHz/ {print $4;exit}' /proc/cpuinfo ) MHz"
	#colorEcho ${INFO} "2. RAM INFO"
	#colorEcho ${INFO} "Total ram: $( free -m | awk '/Mem/ {print $2}' ) MB"
	#colorEcho ${INFO} "3. DISK INFO"
	#colorEcho ${INFO} "Total disk space: $( df -hPl | grep -wvE '\-|none|tmpfs|devtmpfs|by-uuid|chroot|Filesystem|udev|docker' | awk '{print $2}' )"
	#colorEcho ${INFO} "4. OS INFO"
	#colorEcho ${INFO} "${dist}"
echo -e "-------------------------------System Information----------------------------"
echo -e "Hostname:\t\t"`hostname`
echo -e "uptime:\t\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`
echo -e "Product Name:\t\t"`cat /sys/class/dmi/id/product_name`
echo -e "Version:\t\t"`cat /sys/class/dmi/id/product_version`
echo -e "Serial Number:\t\t"`cat /sys/class/dmi/id/product_serial`
echo -e "Machine Type:\t\t"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`
echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
echo -e "Kernel:\t\t\t"`uname -r`
echo -e "Architecture:\t\t"`arch`
echo -e "Processor Name:\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
echo -e "Active User:\t\t"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`
echo -e "System Main IP:\t\t"`hostname -I`
echo -e "-----------------------------------------------------------------------------"
echo -e "-------------------------------IP Information----------------------------"
echo -e "ip:\t\t"`jq -r '.ip' "/root/.trojan/ip.json"`
echo -e "city:\t\t"`jq -r '.city' "/root/.trojan/ip.json"`
echo -e "region:\t\t"`jq -r '.region' "/root/.trojan/ip.json"`
echo -e "country:\t"`jq -r '.country' "/root/.trojan/ip.json"`
echo -e "loc:\t\t"`jq -r '.loc' "/root/.trojan/ip.json"`
echo -e "org:\t\t"`jq -r '.org' "/root/.trojan/ip.json"`
echo -e "postal:\t\t"`jq -r '.postal' "/root/.trojan/ip.json"`
echo -e "timezone:\t"`jq -r '.timezone' "/root/.trojan/ip.json"`
echo -e "-----------------------------------------------------------------------------"
if [[ -f /root/.trojan/ipv6.json ]]; then
echo -e "-------------------------------IPv6 Information----------------------------"
echo -e "ip:\t\t"$(jq -r '.ip' "/root/.trojan/ipv6.json")
echo -e "city:\t\t"$(jq -r '.city' "/root/.trojan/ipv6.json")
echo -e "region:\t\t"$(jq -r '.region' "/root/.trojan/ipv6.json")
echo -e "country:\t"$(jq -r '.country' "/root/.trojan/ipv6.json")
echo -e "loc:\t\t"$(jq -r '.loc' "/root/.trojan/ipv6.json")
echo -e "org:\t\t"$(jq -r '.org' "/root/.trojan/ipv6.json")
echo -e "postal:\t\t"$(jq -r '.postal' "/root/.trojan/ipv6.json")
echo -e "timezone:\t"$(jq -r '.timezone' "/root/.trojan/ipv6.json")
fi
}
#############################
setlanguage(){
	set +e
	if [[ ! -d /root/.trojan/ ]]; then
		mkdir /root/.trojan/
		mkdir /etc/certs/
	fi
	if [[ -f /root/.trojan/language.json ]]; then
		language="$( jq -r '.language' "/root/.trojan/language.json" )"
	fi
	while [[ -z $language ]]; do
	export LANGUAGE="C.UTF-8"
	export LANG="C.UTF-8"
	export LC_ALL="C.UTF-8"
	if (whiptail --title "System Language Setting" --yes-button "中文" --no-button "English" --yesno "使用中文或英文(Use Chinese or English)?" 8 78); then
	chattr -i /etc/locale.gen
	cat > '/etc/locale.gen' << EOF
zh_TW.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
language="cn"
locale-gen
update-locale
chattr -i /etc/default/locale
	cat > '/etc/default/locale' << EOF
LANGUAGE="zh_TW.UTF-8"
LANG="zh_TW.UTF-8"
LC_ALL="zh_TW.UTF-8"
EOF
#apt-get install manpages-zh -y
	cat > '/root/.trojan/language.json' << EOF
{
  "language": "$language"
}
EOF
	else
	chattr -i /etc/locale.gen
	cat > '/etc/locale.gen' << EOF
zh_TW.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
language="en"
locale-gen
update-locale
chattr -i /etc/default/locale
	cat > '/etc/default/locale' << EOF
LANGUAGE="en_US.UTF-8"
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
EOF
	cat > '/root/.trojan/language.json' << EOF
{
  "language": "$language"
}
EOF
fi
done
if [[ $language == "cn" ]]; then
export LANGUAGE="zh_TW.UTF-8"
export LANG="zh_TW.UTF-8"
export LC_ALL="zh_TW.UTF-8"
	else
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
fi
}
#############################
installacme(){
	set +e
	curl -s https://get.acme.sh | sh
	if [[ $? != 0 ]]; then
		colorEcho ${ERROR} "Install acme.sh fail,please check your internet availability!!!"
		exit 1
	fi
	~/.acme.sh/acme.sh --upgrade --auto-upgrade
}
#########Domain resolve verification###################
isresolved(){
	if [ $# = 2 ]
	then
		myip2=$2
	else
		myip2=`curl -s http://dynamicdns.park-your-domain.com/getip`
	fi
		ips=(`nslookup $1 1.1.1.1 | grep -v 1.1.1.1 | grep Address | cut -d " " -f 2`)
		for ip in "${ips[@]}"
		do
				if [ $ip == $myip ] || [ $ip == $myipv6 ] || [[ $ip == $localip ]]
				then
						return 0
				else
						continue
				fi
		done
		return 1
}
########################################################
issuecert(){
	set +e
	clear
	colorEcho ${INFO} "申请(issuing) let\'s encrypt certificate"
	if [[ -f /etc/certs/${domain}_ecc/fullchain.cer ]] && [[ -f /etc/certs/${domain}_ecc/${domain}.key ]] || [[ ${othercert} == 1 ]]; then
		TERM=ansi whiptail --title "证书已有，跳过申请" --infobox "证书已有，跳过申请。。。" 8 78
		else
	rm -rf /etc/nginx/sites-available/* &
	rm -rf /etc/nginx/sites-enabled/* &
	rm -rf /etc/nginx/conf.d/*
	touch /etc/nginx/conf.d/default.conf
		cat > '/etc/nginx/conf.d/default.conf' << EOF
server {
	listen       80;
	listen       [::]:80;
	server_name  $domain;
	root   /usr/share/nginx/html;
}
EOF
	nginx -t
	systemctl start nginx
	installacme
	clear
	colorEcho ${INFO} "测试证书申请ing(test issuing) let\'s encrypt certificate"
	~/.acme.sh/acme.sh --issue --nginx --cert-home /etc/certs -d $domain -k ec-256 --force --test --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
	if [[ $? != 0 ]]; then
	colorEcho ${ERROR} "证书申请测试失败，请检查VPS控制面板防火墙(80 443)是否打开!!!"
	colorEcho ${ERROR} "请访问https://letsencrypt.status.io/检测Let's encrypt服务是否正常!!!"
	colorEcho ${ERROR} "Domain verification fail,Pleae Open port 80 443 on VPS panel !!!"
	exit 1
	fi 
	clear
	colorEcho ${INFO} "正式证书申请ing(issuing) let\'s encrypt certificate"
	~/.acme.sh/acme.sh --issue --nginx --cert-home /etc/certs -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
	if [[ $? != 0 ]]; then
	colorEcho ${ERROR} "证书申请测试失败，请检查VPS控制面板防火墙(80 443)是否打开!!!"
	colorEcho ${ERROR} "请访问https://letsencrypt.status.io/检测Let's encrypt服务是否正常!!!"
	colorEcho ${ERROR} "Domain verification fail,Pleae Open port 80 443 on VPS panel !!!"
	exit 1
	fi
	chmod +r /etc/certs/${domain}_ecc/fullchain.cer
	chmod +r /etc/certs/${domain}_ecc/${domain}.key
	fi
}
###############User input################
prasejson(){
	set +e
	cat > '/root/.trojan/config.json' << EOF
{
  "installed": "1",
  "domain": "$domain",
  "password1": "$password1",
  "password2": "$password2",
  "qbtpath": "$qbtpath",
  "trackerpath": "$trackerpath",
  "trackerstatuspath": "$trackerstatuspath",
  "ariapath": "$ariapath",
  "ariapasswd": "$ariapasswd",
  "filepath": "$filepath",
  "netdatapath": "$netdatapath",
  "tor_name": "$tor_name"
}
EOF
}
################################################
readconfig(){
	domain="$( jq -r '.domain' "/root/.trojan/config.json" )"
    password1="$( jq -r '.password1' "/root/.trojan/config.json" )"
    password2="$( jq -r '.password2' "/root/.trojan/config.json" )"
    qbtpath="$( jq -r '.qbtpath' "/root/.trojan/config.json" )"
    trackerpath="$( jq -r '.trackerpath' "/root/.trojan/config.json" )"
    trackerstatuspath="$( jq -r '.username' "/root/.trojan/config.json" )"
    ariapath="$( jq -r '.ariapath' "/root/.trojan/config.json" )"
    ariapasswd="$( jq -r '.ariapasswd' "/root/.trojan/config.json" )"
    filepath="$( jq -r '.filepath' "/root/.trojan/config.json" )"
    netdatapath="$( jq -r '.netdatapath' "/root/.trojan/config.json" )"
    tor_name="$( jq -r '.tor_name' "/root/.trojan/config.json" )"  
}
####################################
userinput(){
	set +e
if [ ! -f /root/.trojan/config.json ]; then
	cat > '/root/.trojan/config.json' << EOF
{
  "installed": "0"
}
EOF
fi
install_status="$( jq -r '.installed' "/root/.trojan/config.json" )"

clear
if [[ ${install_status} == 1 ]]; then
	whiptail --title "Installed" --msgbox "Installed,reading configuration" 8 78
	readconfig
fi

whiptail --clear --ok-button "吾意已決 立即執行" --backtitle "Hi , Please choose carefully!" --title "Install checklist" --checklist --separate-output --nocancel "Please press space to choose !!!" 24 52 16 \
"Back" "返回上级菜单(Back to main menu)" off \
"系统" "System" on  \
"1" "Enable BBR(TCP-Turbo)" on \
"2" "Docker" on \
"3" "PHP" on \
"代理" "Proxy" on  \
"4" "Trojan-GFW" on \
"5" "Trojan-panel(require PHP MariaDB)" off \
"6" "Dnscrypt-proxy(Dns encryption)" on \
"7" "RSSHUB(Docker Version)" on \
"下载" "Download" on  \
"8" "Qbittorrent" off \
"9" "Bt-Tracker(Node.js Version)" off \
"10" "Aria2" on \
"11" "Filebrowser" on \
"状态" "Status" on  \
"12" "Netdata(Server status monitor)" on \
"测速" "Speedtest" on  \
"13" "Speedtest(Docker Version)" on \
"数据库" "Database" on  \
"14" "MariaDB" on \
"安全" "Security" on  \
"15" "Fail2ban" on \
"邮件" "Mail" on  \
"16" "Mail service" off \
"其他" "Others" off  \
"17" "OPENSSL" off \
"18" "Tor-Relay" off \
"19" "Enable TLS1.3 only" off 2>results

while read choice
do
	case $choice in
		Back) 
		advancedMenu
		break
		;;
		1) 
		install_bbr=1
		;;
		2)
		install_docker=1
		;;
		3)
		install_php=1
		;;
		4)
		install_trojan=1
		;;
		5) 
		install_tjp=1
		;;
		6) 
		dnsmasq_install=1
		;;
		7)
		install_rsshub=1
		;;
		8)
		install_qbt=1
		;;
		9)
		install_tracker=1
		;;
		10)
		install_aria=1
		;;
		11)
		install_file=1
		;;
		12)
		install_netdata=1
		;;
		13)
		install_speedtest=1
		;;
		14)
		install_mariadb=1
		;;
		15)
		install_fail2ban=1
		;;
		16)
		install_mail=1
		;;
		17)
		install_openssl=1
		;;
		18)
		install_tor=1
		;;
		19) 
		tls13only=1
		;;
		*)
		;;
	esac
done < results
####################################
system_upgrade=1
if [[ ${system_upgrade} == 1 ]]; then
	if [[ $(lsb_release -cs) == stretch ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Debian 10?" 8 78); then
			debian10_install=1
		fi
	fi
	if [[ $(lsb_release -cs) == jessie ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Debian 9?" 8 78); then
			debian9_install=1
		fi
	fi
	if [[ $(lsb_release -cs) == xenial ]]; then
		if (whiptail --title "System Upgrade" --yesno "Upgrade to Ubuntu 18.04?" 8 78); then
			ubuntu18_install=1
		fi
	fi
fi
####################################
if [[ ${install_mail} == 1 ]]; then
whiptail --title "Warning" --msgbox "Warning!!!:邮件服务仅推荐使用根域名(only recommend root domain),不推荐使用www等前缀(no www allowed),否则后果自负!!!" 8 78
whiptail --title "Warning" --msgbox "Warning!!!:邮件服务需要MX and PTR(reverse dns record) DNS Record,请自行添加,否则后果自负!!!" 8 78
fi
#####################################
while [[ -z ${domain} ]]; do
domain=$(whiptail --inputbox --nocancel "Please enter your domain(请輸入你的域名)(请先完成A/AAAA解析 https://dnschecker.org/)" 8 78 --title "Domain input" 3>&1 1>&2 2>&3)
done
hostnamectl set-hostname $domain
if [[ ${install_trojan} = 1 ]]; then
	while [[ -z ${password1} ]]; do
password1=$(whiptail --passwordbox --nocancel "Trojan-GFW Password One(若不確定，請直接回車，会随机生成)" 8 78 --title "password1 input" 3>&1 1>&2 2>&3)
if [[ -z ${password1} ]]; then
	password1=$(head /dev/urandom | tr -dc a-z0-9 | head -c 9 ; echo '' )
	fi
done
while [[ -z ${password2} ]]; do
password2=$(whiptail --passwordbox --nocancel "Trojan-GFW Password Two(若不確定，請直接回車，会随机生成)" 8 78 --title "password2 input" 3>&1 1>&2 2>&3)
if [[ -z ${password2} ]]; then
	password2=$(head /dev/urandom | tr -dc a-z0-9 | head -c 9 ; echo '' )
	fi
done
fi
if [[ ${password1} == ${password2} ]]; then
	password2=$(head /dev/urandom | tr -dc a-z0-9 | head -c 9 ; echo '' )
	fi
if [[ -z ${password1} ]]; then
	password1=$(head /dev/urandom | tr -dc a-z0-9 | head -c 9 ; echo '' )
	fi
if [[ -z ${password2} ]]; then
	password2=$(head /dev/urandom | tr -dc a-z0-9 | head -c 9 ; echo '' )
	fi
###################################
	if [[ ${install_mail} == 1 ]]; then
mailuser=$(whiptail --inputbox --nocancel "Please enter your desired mailusername" 8 78 --title "Mail user input" 3>&1 1>&2 2>&3)
if [[ -z ${mailuser} ]]; then
	mailuser=$(head /dev/urandom | tr -dc a-z | head -c 4 ; echo '' )
	fi
fi
###################################
	if [[ $install_qbt = 1 ]]; then
		while [[ -z $qbtpath ]]; do
		qbtpath=$(whiptail --inputbox --nocancel "Qbittorrent Path(路径)" 8 78 /${password1}_qbt/ --title "Qbittorrent path input" 3>&1 1>&2 2>&3)
		done
	fi
#####################################
	if [[ $install_tracker == 1 ]]; then
		while [[ -z ${trackerpath} ]]; do
		trackerpath=$(whiptail --inputbox --nocancel "Bittorrent-Tracker Path(路径)" 8 78 /announce --title "Bittorrent-Tracker path input" 3>&1 1>&2 2>&3)
		done
		while [[ -z ${trackerstatuspath} ]]; do
		trackerstatuspath=$(whiptail --inputbox --nocancel "Bittorrent-Tracker Status Path(状态路径)" 8 78 /${password1}_tracker --title "Bittorrent-Tracker status path input" 3>&1 1>&2 2>&3)
		done
	fi
####################################
	if [[ ${install_aria} == 1 ]]; then
		ariaport=$(shuf -i 10000-19000 -n 1)
		while [[ -z ${ariapath} ]]; do
		ariapath=$(whiptail --inputbox --nocancel "Aria2 RPC Path(路径)" 8 78 /${password1}_aria2/ --title "Aria2 path input" 3>&1 1>&2 2>&3)
		done
		while [[ -z $ariapasswd ]]; do
		ariapasswd=$(whiptail --passwordbox --nocancel "Aria2 rpc token(密码)" 8 78 --title "Aria2 rpc token input" 3>&1 1>&2 2>&3)
		if [[ -z ${ariapasswd} ]]; then
		ariapasswd=$(head /dev/urandom | tr -dc 0-9 | head -c 10 ; echo '' )
		fi
		done
	fi
####################################
	if [[ ${install_file} = 1 ]]; then
		while [[ -z ${filepath} ]]; do
		filepath=$(whiptail --inputbox --nocancel "Filebrowser路径" 8 78 /${password1}_file/ --title "Filebrowser path input" 3>&1 1>&2 2>&3)
		done
	fi
####################################
	if [[ ${install_netdata} = 1 ]]; then
		while [[ -z ${netdatapath} ]]; do
		netdatapath=$(whiptail --inputbox --nocancel "Netdata路径" 8 78 /${password1}_netdata/ --title "Netdata path input" 3>&1 1>&2 2>&3)
		done
	fi
####################################
	if [[ ${install_tor} = 1 ]]; then
		while [[ -z ${tor_name} ]]; do
		tor_name=$(whiptail --inputbox --nocancel "Tor nickname" 8 78 --title "tor nickname input" 3>&1 1>&2 2>&3)
		if [[ -z ${tor_name} ]]; then
		tor_name="myrelay"
	fi
	done
	fi
####################################
if [[ -f /etc/trojan/trojan.crt ]] && [[ -f /etc/trojan/trojan.key ]] && [[ -n /etc/trojan/trojan.crt ]] || [[ -f /etc/certs/${domain}_ecc/fullchain.cer ]]; then
		TERM=ansi whiptail --title "证书已有，跳过申请" --infobox "证书已有，跳过申请。。。" 8 78
		else
	if (whiptail --title "api" --yesno "使用 (use) api申请证书(to issue certificate)?" 8 78); then
		whiptail --title "Warning" --msgbox "若你的域名厂商(或者准确来说你的域名的NS)不在下列列表中,请在上一个yes/no选项中选否(需要保证域名A解析已成功)或者open an github issue/pr !" 8 78
    dns_api=1
    APIOPTION=$(whiptail --nocancel --clear --ok-button "吾意已決 立即執行" --title "API choose" --menu --separate-output "域名(domain)API：請按方向键來選擇(Use Arrow key to choose)" 15 78 6 \
"1" "Cloudflare" \
"2" "Namesilo" \
"3" "Aliyun" \
"4" "DNSPod.cn" \
"5" "CloudXNS.com" \
"6" "GoDaddy" \
"back" "返回"  3>&1 1>&2 2>&3)

    case $APIOPTION in
        1)
        while [[ -z ${CF_Key} ]] || [[ -z ${CF_Email} ]]; do
        CF_Key=$(whiptail --passwordbox --nocancel "https://dash.cloudflare.com/profile/api-tokens，快輸入你CF Global Key併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
        CF_Email=$(whiptail --inputbox --nocancel "https://dash.cloudflare.com/profile，快輸入你CF_Email併按回車" 8 78 --title "CF_Key input" 3>&1 1>&2 2>&3)
        done
        export CF_Key="$CF_Key"
        export CF_Email="$CF_Email"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_cf --cert-home /etc/certs -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
        ;;
        2)
        while [[ -z $Namesilo_Key ]]; do
        Namesilo_Key=$(whiptail --passwordbox --nocancel "https://www.namesilo.com/account_api.php，快輸入你的Namesilo_Key併按回車" 8 78 --title "Namesilo_Key input" 3>&1 1>&2 2>&3)
        done
        export Namesilo_Key="$Namesilo_Key"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_namesilo --cert-home /etc/certs --dnssleep 900 -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
        ;;
        3)
        while [[ -z $Ali_Key ]] || [[ -z $Ali_Secret ]]; do
        Ali_Key=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Key併按回車" 8 78 --title "Ali_Key input" 3>&1 1>&2 2>&3)
        Ali_Secret=$(whiptail --passwordbox --nocancel "https://ak-console.aliyun.com/#/accesskey，快輸入你的Ali_Secret併按回車" 8 78 --title "Ali_Secret input" 3>&1 1>&2 2>&3)
        done
        export Ali_Key="$Ali_Key"
        export Ali_Secret="$Ali_Secret"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_ali --cert-home /etc/certs -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
        ;;
        4)
        while [[ -z $DP_Id ]] || [[ -z $DP_Key ]]; do
        DP_Id=$(whiptail --passwordbox --nocancel "DNSPod.cn，快輸入你的DP_Id併按回車" 8 78 --title "DP_Id input" 3>&1 1>&2 2>&3)
        DP_Key=$(whiptail --passwordbox --nocancel "DNSPod.cn，快輸入你的DP_Key併按回車" 8 78 --title "DP_Key input" 3>&1 1>&2 2>&3)
        done
        export DP_Id="$DP_Id"
        export DP_Key="$DP_Key"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_dp --cert-home /etc/certs -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
        ;;
        5)
        while [[ -z $CX_Key ]] || [[ -z $CX_Secret ]]; do
        CX_Key=$(whiptail --passwordbox --nocancel "CloudXNS.com，快輸入你的CX_Key併按回車" 8 78 --title "CX_Key input" 3>&1 1>&2 2>&3)
        CX_Secret=$(whiptail --passwordbox --nocancel "CloudXNS.com，快輸入你的CX_Secret併按回車" 8 78 --title "CX_Secret input" 3>&1 1>&2 2>&3)
        done
        export CX_Key="$CX_Key"
        export CX_Secret="$CX_Secret"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_cx --cert-home /etc/certs -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
        ;;
        6)
        while [[ -z $CX_Key ]] || [[ -z $CX_Secret ]]; do
        CX_Key=$(whiptail --passwordbox --nocancel "https://developer.godaddy.com/keys/，快輸入你的GD_Key" 8 78 --title "GD_Key input" 3>&1 1>&2 2>&3)
        CX_Secret=$(whiptail --passwordbox --nocancel "https://developer.godaddy.com/keys/，快輸入你的GD_Secret" 8 78 --title "GD_Secret input" 3>&1 1>&2 2>&3)
        done
        export GD_Key="$CX_Key"
        export GD_Secret="$CX_Secret"
        installacme
        ~/.acme.sh/acme.sh --issue --dns dns_gd --cert-home /etc/certs -d $domain -k ec-256 --force --log --reloadcmd "systemctl reload trojan postfix dovecot nginx || true"
        ;;
        back) 
		userinput
		break
		;;
        *)
        ;;
    esac
    if [[ $? != 0 ]]; then
	colorEcho ${ERROR} "证书申请失败，请检查域名以及其他信息是否正确"
	colorEcho ${ERROR} "certificate issue fail,Pleae enter correct information and check your network"
	exit 1
	fi
    fi
fi
}
###############OS detect####################
osdist(){
set +e
colorEcho ${INFO} "初始化中(initializing)"
 if cat /etc/*release | grep ^NAME | grep -q Ubuntu; then
	dist=ubuntu
	apt-get update -q
	export DEBIAN_FRONTEND=noninteractive
	apt-get install whiptail curl locales lsb-release jq -y -q
 elif cat /etc/*release | grep ^NAME | grep -q Debian; then
	dist=debian
	apt-get update -q
	export DEBIAN_FRONTEND=noninteractive
	apt-get install whiptail curl locales lsb-release jq -y -q
 else
	TERM=ansi whiptail --title "OS not SUPPORTED" --infobox "OS NOT SUPPORTED!" 8 78
	exit 1;
 fi
}
##############Upgrade system optional########
upgradesystem(){
	set +e
 if [[ $dist == ubuntu ]]; then
	export UBUNTU_FRONTEND=noninteractive
	if [[ $ubuntu18_install == 1 ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#

###### Ubuntu Main Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-security main restricted universe multiverse 
deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted universe multiverse 
EOF
fi
	apt-get update --fix-missing
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt --fix-broken install -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get autoremove -qq -y'
	clear
 elif [[ $dist == debian ]]; then
	export DEBIAN_FRONTEND=noninteractive
	apt-get update --fix-missing
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y'
	if [[ ${debian10_install} == 1 ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ stable main contrib non-free
deb-src http://deb.debian.org/debian/ stable main contrib non-free

deb http://deb.debian.org/debian/ stable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ stable-updates main contrib non-free

deb http://deb.debian.org/debian-security stable/updates main
deb-src http://deb.debian.org/debian-security stable/updates main

deb http://ftp.debian.org/debian buster-backports main
deb-src http://ftp.debian.org/debian buster-backports main
EOF
fi
	if [[ ${debian9_install} == 1 ]]; then
		cat > '/etc/apt/sources.list' << EOF
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ oldstable main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable main contrib non-free

deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free

deb http://deb.debian.org/debian-security oldstable/updates main
deb-src http://deb.debian.org/debian-security oldstable/updates main

deb http://ftp.debian.org/debian stretch-backports main
deb-src http://ftp.debian.org/debian stretch-backports main
EOF
fi
	apt-get update --fix-missing
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -q -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt --fix-broken install -y'
	sh -c 'echo "y\n\ny\ny\ny\ny\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get autoremove -qq -y'
	clear
 else
	clear
	TERM=ansi whiptail --title "error can't upgrade system" --infobox "error can't upgrade system" 8 78
	exit 1;
 fi
}
#############Install NGINX################
installnginx(){
if [[ ! -f /etc/apt/sources.list.d/nginx.list ]]; then
	clear
	colorEcho ${INFO} "Install Nginx ing"
	curl -LO --progress-bar https://nginx.org/keys/nginx_signing.key
	apt-key add nginx_signing.key
	rm -rf nginx_signing.key
	touch /etc/apt/sources.list.d/nginx.list
	cat > '/etc/apt/sources.list.d/nginx.list' << EOF
deb https://nginx.org/packages/mainline/${dist}/ $(lsb_release -cs) nginx
deb-src https://nginx.org/packages/mainline/${dist}/ $(lsb_release -cs) nginx
EOF
	apt-get purge nginx -qq -y
	apt-get update -q
	apt-get install nginx -q -y
fi
	cat > '/lib/systemd/system/nginx.service' << EOF
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true
LimitNOFILE=51200
LimitNPROC=51200
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable nginx
	cat > '/etc/nginx/nginx.conf' << EOF
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log warn;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
	worker_connections 51200;
	use epoll;
	multi_accept on;
}

http {
	proxy_intercept_errors on;
	proxy_socket_keepalive off;
	proxy_http_version 1.1;
	http2_push_preload on;
	aio threads;
	charset UTF-8;
	tcp_nodelay on;
	tcp_nopush on;
	server_tokens off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	access_log /var/log/nginx/access.log;

	log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
		'\$status \$body_bytes_sent "\$http_referer" '
		'"\$http_user_agent" "\$http_x_forwarded_for"';

	sendfile on;
	gzip on;
	gzip_proxied any;
	gzip_types *;
	gzip_comp_level 9;

	include /etc/nginx/conf.d/*.conf;
}
EOF
clear
timedatectl set-timezone Asia/Hong_Kong
timedatectl set-ntp off
ntpdate -qu 1.hk.pool.ntp.org > /dev/null
}
#########Open ports########################
openfirewall(){
	set +e
	colorEcho ${INFO} "设置 firewall"
	#policy
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	ip6tables -P INPUT ACCEPT
	ip6tables -P FORWARD ACCEPT
	ip6tables -P OUTPUT ACCEPT
	#flash
	iptables -F
	ip6tables -F
	#block
	iptables -I INPUT -s 36.110.236.68/16 -j DROP
	iptables -I INPUT -s 114.114.112.0/21 -j DROP
	iptables -I INPUT -s 1.2.4.0/24 -j DROP
	iptables -I OUTPUT -d 36.110.236.68/16 -j DROP
	iptables -I OUTPUT -d 114.114.112.0/21 -j DROP
	iptables -I OUTPUT -d 1.2.4.0/24 -j DROP
	iptables -I OUTPUT -p tcp -m tcp --dport 5222 -j DROP
	iptables -I OUTPUT -p udp -m udp --dport 5222 -j DROP
	iptables -I OUTPUT -p tcp -m tcp --dport 1723 -j DROP
	iptables -I OUTPUT -p udp -m udp --dport 1723 -j DROP
	iptables -I OUTPUT -p tcp -m tcp --dport 1701 -j DROP
	iptables -I OUTPUT -p udp -m udp --dport 1701 -j DROP
	iptables -I OUTPUT -p tcp -m tcp --dport 500 -j DROP
	iptables -I OUTPUT -p udp -m udp --dport 500 -j DROP
	#keep connected
	iptables -A INPUT -p tcp -m tcp --tcp-flags ALL FIN,PSH,URG -j DROP
	iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
	iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -j DROP
	iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	#icmp
	iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
	iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
	ip6tables -A INPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
	ip6tables -A OUTPUT -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
	#iptables -m owner --uid-owner trojan -A OUTPUT -d 127.0.0.0/8 -j REJECT
	#iptables -m owner --uid-owner trojan -A OUTPUT -d 192.168.0.0/16 -j REJECT
	#iptables -m owner --uid-owner trojan -A OUTPUT -d 10.0.0.0/8 -j REJECT
	#iptables -m owner --uid-owner trojan -A OUTPUT --dport 53 -j ACCEPT
	#iptables -m owner --uid-owner trojan -A OUTPUT -d 127.0.0.0/8 --dport 80 -j ACCEPT
	#iptables -m owner --uid-owner trojan -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	#tcp
	iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT #HTTPS
	iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT #HTTP
	#udp
	iptables -A INPUT -p udp -m udp --dport 443 -j ACCEPT
	iptables -A INPUT -p udp -m udp --dport 80 -j ACCEPT
	iptables -A OUTPUT -j ACCEPT
	#iptables -I FORWARD -j DROP
	#tcp6
	ip6tables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT #HTTPSv6
	ip6tables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT #HTTPv6
	#udp6
	ip6tables -A INPUT -p udp -m udp --dport 443 -j ACCEPT
	ip6tables -A INPUT -p udp -m udp --dport 80 -j ACCEPT
	ip6tables -A OUTPUT -j ACCEPT
	#ip6tables -I FORWARD -j DROP
	if [[ $install_qbt == 1 ]]; then
		iptables -A INPUT -p tcp -m tcp --dport 8999 -j ACCEPT
		ip6tables -A INPUT -p tcp -m tcp --dport 8999 -j ACCEPT
		iptables -A INPUT -p udp -m udp --dport 8999 -j ACCEPT
		ip6tables -A INPUT -p udp -m udp --dport 8999 -j ACCEPT
	fi
	if [[ $install_tracker == 1 ]]; then
		iptables -A INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
		ip6tables -A INPUT -p tcp -m tcp --dport 8000 -j ACCEPT
		iptables -A INPUT -p udp -m udp --dport 8000 -j ACCEPT
		ip6tables -A INPUT -p udp -m udp --dport 8000 -j ACCEPT
	fi
	if [[ $install_aria == 1 ]]; then
		iptables -A INPUT -p tcp -m tcp --dport ${ariaport} -j ACCEPT
		ip6tables -A INPUT -p tcp -m tcp --dport ${ariaport} -j ACCEPT
		iptables -A INPUT -p udp -m udp --dport ${ariaport} -j ACCEPT
		ip6tables -A INPUT -p udp -m udp --dport ${ariaport} -j ACCEPT
	fi
	if [[ ${install_mail} == 1 ]]; then
		iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
		ip6tables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT
		iptables -A INPUT -p udp -m udp --dport 25 -j ACCEPT
		ip6tables -A INPUT -p udp -m udp --dport 25 -j ACCEPT
	fi
	if [[ ${dist} == debian ]]; then
	export DEBIAN_FRONTEND=noninteractive 
	apt-get install iptables-persistent -qq -y > /dev/null
	iptables-save > /etc/iptables/rules.v4
	ip6tables-save > /etc/iptables/rules.v6
 elif [[ ${dist} == ubuntu ]]; then
	export DEBIAN_FRONTEND=noninteractive
	ufw allow http
	ufw allow https
	ufw allow ${ariaport}
	apt-get install iptables-persistent -qq -y > /dev/null
	iptables-save > /etc/iptables/rules.v4
	ip6tables-save > /etc/iptables/rules.v6
 else
	clear
	TERM=ansi whiptail --title "error can't install iptables-persistent" --infobox "error can't install iptables-persistent" 8 78
	exit 1;
 fi
}
##########install dependencies#############
installdependency(){
	set +e
colorEcho ${INFO} "Updating system"
	apt-get update
	if [[ $install_status == 0 ]]; then
		if [ -f /etc/trojan/*.crt ]; then
		othercert=1
		mv /etc/trojan/*.crt /etc/trojan/trojan.crt
		fi
		if [ -f /etc/trojan/*.key ]; then
		mv /etc/trojan/*.key /etc/trojan/trojan.key
		fi
		if [[ $(systemctl is-active caddy) == active ]]; then
			systemctl stop caddy
			systemctl disable caddy
		fi
		if [[ $(systemctl is-active apache2) == active ]]; then
			systemctl stop apache2
			systemctl disable apache2
		fi
		if [[ $(systemctl is-active httpd) == active ]]; then
			systemctl stop httpd
			systemctl disable httpd
		fi
		#(echo >/dev/tcp/localhost/80) &>/dev/null && echo "TCP port 80 open" && kill $(lsof -t -i:80) || echo "Moving on"
		#(echo >/dev/tcp/localhost/80) &>/dev/null && echo "TCP port 443 open" && kill $(lsof -t -i:443) || echo "Moving on"
	fi
###########################################
if [[ $system_upgrade = 1 ]]; then
upgradesystem
fi
###########################################
	if [[ $install_bbr == 1 ]]; then
	colorEcho ${INFO} "Enabling TCP-BBR boost"
	#iii=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | cut -c2-999)
	cat > '/etc/sysctl.d/99-sysctl.conf' << EOF
#!!! Do not change these settings unless you know what you are doing !!!
#net.ipv4.ip_forward = 1
#net.ipv4.conf.all.forwarding = 1
#net.ipv4.conf.default.forwarding = 1
################################
#net.ipv6.conf.all.forwarding = 1
#net.ipv6.conf.default.forwarding = 1
#net.ipv6.conf.lo.forwarding = 1
################################
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
################################
net.ipv6.conf.all.accept_ra = 2
net.ipv6.conf.default.accept_ra = 2
################################
net.core.netdev_max_backlog = 100000
net.core.netdev_budget = 50000
net.core.netdev_budget_usecs = 5000
#fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.somaxconn = 10000
################################
net.ipv4.icmp_echo_ignore_all = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_mtu_probing = 0
##############################
net.ipv4.conf.all.arp_ignore = 2
net.ipv4.conf.default.arp_ignore = 2
net.ipv4.conf.all.arp_announce = 2
net.ipv4.conf.default.arp_announce = 2
##############################
net.ipv4.tcp_autocorking = 0
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_syn_backlog = 30000
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_ecn = 2
net.ipv4.tcp_ecn_fallback = 1
net.ipv4.tcp_frto = 0
net.ipv4.tcp_fack = 0
##############################
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
vm.swappiness = 1
net.ipv4.ip_unprivileged_port_start = 0
EOF
	sysctl --system
	cat > '/etc/systemd/system.conf' << EOF
[Manager]
#DefaultTimeoutStartSec=90s
DefaultTimeoutStopSec=30s
#DefaultRestartSec=100ms
DefaultLimitCORE=infinity
DefaultLimitNOFILE=51200
DefaultLimitNPROC=51200
EOF
		cat > '/etc/security/limits.conf' << EOF
* soft nofile 51200
* hard nofile 51200
* soft nproc 51200
* hard nproc 51200
EOF
if grep -q "ulimit" /etc/profile
then
	:
else
echo "ulimit -SHn 51200" >> /etc/profile
echo "ulimit -SHu 51200" >> /etc/profile
fi
if grep -q "pam_limits.so" /etc/pam.d/common-session
then
	:
else
echo "session required pam_limits.so" >> /etc/pam.d/common-session
fi
systemctl daemon-reload
	fi
###########################################
clear
colorEcho ${INFO} "Installing all necessary Software"
apt-get install sudo git curl xz-utils wget apt-transport-https gnupg dnsutils lsb-release python-pil unzip resolvconf ntpdate systemd dbus ca-certificates locales iptables software-properties-common cron e2fsprogs less haveged neofetch -q -y
apt-get install python3-qrcode python-dnspython -q -y
sh -c 'echo "y\n\ny\ny\n" | DEBIAN_FRONTEND=noninteractive apt-get install ntp -q -y'
clear
#############################################
if [[ -f /etc/certs/${domain}_ecc/fullchain.cer ]] && [[ -n /etc/certs/${domain}_ecc/fullchain.cer ]] || [[ $dns_api == 1 ]] || [[ ${othercert} == 1 ]] || [[ ${installstatus} == 1 ]]; then
	installnginx
	openfirewall
	else
	if isresolved $domain
	then
	installnginx
	openfirewall
	issuecert
	else
	whiptail --title "Domain verification fail" --msgbox --scrolltext "域名解析验证失败，请自行验证解析是否成功并且请关闭Cloudfalare CDN并检查VPS控制面板防火墙(80 443)是否打开!!!Domain verification fail,Pleae turn off Cloudflare CDN and Open port 80 443 on VPS panel !!!" 8 78
	clear
	colorEcho ${ERROR} "Please consider use api to issue certificate instead!"
	exit 1
	fi
fi
#########Install Docker###################
if [[ $install_docker == 1 ]]; then
  clear
  colorEcho ${INFO} "安装Docker(Install Docker ing)"
  if [[ ${dist} == debian ]]; then
  apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io -y
 elif [[ ${dist} == ubuntu ]]; then
  apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  apt-key fingerprint 0EBFCD88
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io -y
 else
  echo "fail"
  fi
  cat > '/etc/docker/daemon.json' << EOF
{
  "metrics-addr" : "127.0.0.1:9323",
  "experimental" : true
}
EOF
fi
##########Install Speedtest#################
if [[ ${install_speedtest} == 1 ]]; then
docker pull adolfintel/speedtest
docker run -d --restart unless-stopped --name speedtest -e MODE=standalone -p 127.0.0.1:8001:80 -it adolfintel/speedtest 
fi
##########Install RSSHUB#################
if [[ ${install_rsshub} == 1 ]]; then
docker pull diygod/rsshub
docker run -d --restart unless-stopped --name rsshub -p 127.0.0.1:1200:1200 diygod/rsshub
fi
##########Install Fail2ban#################
if [[ ${install_fail2ban} == 1 ]]; then
apt-get install fail2ban -y
fi
##########Enable TLS13 ONLY#################
if [[ $tls13only == 1 ]]; then
cipher_server="TLS_AES_128_GCM_SHA256"
fi
##########Install OPENSSL##############
if [[ ${install_openssl} == 1 ]]; then
	colorEcho ${INFO} "Install OPENSSL ing"
apt-get install git build-essential nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libssl-dev autoconf automake autotools-dev autopoint libtool libcppunit-dev -qq -y
wget https://www.openssl.org/source/openssl-1.1.1f.tar.gz && tar -xvf openssl-1.1.1f.tar.gz && rm -rf openssl-1.1.1f.tar.gz
cd openssl-1.1.1f && ./config no-ssl2 no-ssl3 && make -j $(nproc --all) && make test && make install
cd ..
rm -rf openssl*
apt-get purge build-essential -y
apt-get autoremove -y
fi
#############Install Qbittorrent################
if [[ $install_qbt == 1 ]]; then
	if [[ ! -f /usr/bin/qbittorrent-nox ]]; then
	clear
	colorEcho ${INFO} "安装Qbittorrent(Install Qbittorrent ing)"
	if [[ ${dist} == debian ]]; then
	export DEBIAN_FRONTEND=noninteractive 
	apt-get install qbittorrent-nox -q -y
 elif [[ ${dist} == ubuntu ]]; then
	export DEBIAN_FRONTEND=noninteractive
	add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
	apt-get install qbittorrent-nox -q -y
 else
	echo "fail"
 fi
 #useradd -r qbittorrent --shell=/usr/sbin/nologin
	cat > '/etc/systemd/system/qbittorrent.service' << EOF
[Unit]
Description=qBittorrent Daemon Service
Documentation=man:qbittorrent-nox(1)
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
Type=simple
User=root
RemainAfterExit=yes
ExecStart=/usr/bin/qbittorrent-nox --profile=/usr/share/nginx/
TimeoutStopSec=infinity
LimitNOFILE=51200
LimitNPROC=51200
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable qbittorrent.service
mkdir /usr/share/nginx/qBittorrent/
mkdir /usr/share/nginx/qBittorrent/downloads/
chmod 755 /usr/share/nginx/
fi
fi
clear
###########Install Bittorrent-tracker##############
if [[ $install_tracker = 1 ]]; then
	if [[ ! -f /usr/bin/bittorrent-tracker ]]; then
		clear
		colorEcho ${INFO} "Install Bittorrent-tracker ing"
	if [[ ${dist} = debian ]]; then
		export DEBIAN_FRONTEND=noninteractive 
		curl -sL https://deb.nodesource.com/setup_14.x | bash -
		apt-get install -q -y nodejs
 elif [[ ${dist} = ubuntu ]]; then
	export DEBIAN_FRONTEND=noninteractive
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	apt-get install -q -y nodejs
 else
	echo "fail"
 fi
 useradd -r bt_tracker --shell=/usr/sbin/nologin
 npm install -g bittorrent-tracker --quiet
	cat > '/etc/systemd/system/tracker.service' << EOF
[Unit]
Description=Bittorrent-Tracker Daemon Service
Wants=network-online.target
After=network-online.target nss-lookup.target

[Service]
Type=simple
User=bt_tracker
Group=bt_tracker
RemainAfterExit=yes
ExecStart=/usr/bin/bittorrent-tracker --trust-proxy
TimeoutStopSec=infinity
LimitNOFILE=51200
LimitNPROC=51200
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable tracker
systemctl start tracker
fi
fi
clear
##############Install FILEBROWSER###############
if [[ $install_file = 1 ]]; then
	if [[ ! -f /usr/local/bin/filebrowser ]]; then
	clear
	colorEcho ${INFO} "Install Filebrowser ing"
	export DEBIAN_FRONTEND=noninteractive
	curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
	cat > '/etc/systemd/system/filebrowser.service' << EOF
[Unit]
Description=filebrowser browser
After=network.target

[Service]
User=root
Group=root
RemainAfterExit=yes
ExecStart=/usr/local/bin/filebrowser -r /usr/share/nginx/ -d /etc/filebrowser/database.db -b ${filepath} -p 8081
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
LimitNOFILE=51200
LimitNPROC=51200
RestartSec=3s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable filebrowser
mkdir /etc/filebrowser/
touch /etc/filebrowser/database.db
chmod -R 755 /etc/filebrowser/
fi
fi
clear
##########Install Aria2c##########
if [[ $install_aria = 1 ]]; then
	#trackers_list=$(wget -qO- https://trackerslist.com/all.txt |awk NF|sed ":a;N;s/\n/,/g;ta")
	trackers_list=$(wget -qO- https://trackerslist.com/all_aria2.txt)
	cat > '/etc/systemd/system/aria2.service' << EOF
[Unit]
Description=Aria2c download manager
Requires=network.target
After=network.target

[Service]
Type=forking
User=root
RemainAfterExit=yes
ExecStart=/usr/local/bin/aria2c --conf-path=/etc/aria2.conf
ExecReload=/usr/bin/kill -HUP \$MAINPID
ExecStop=/usr/bin/kill -s STOP \$MAINPID
LimitNOFILE=51200
LimitNPROC=51200
RestartSec=3s
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
	cat > '/etc/aria2.conf' << EOF
#!!! Do not change these settings unless you know what you are doing !!!
#Global Settings###
daemon=true
async-dns=true
#enable-async-dns6=true
log-level=notice
console-log-level=info
human-readable=true
log=/var/log/aria2.log
rlimit-nofile=51200
event-poll=epoll
min-tls-version=TLSv1.2
dir=/usr/share/nginx/aria2/
file-allocation=falloc
check-integrity=true
conditional-get=false
disk-cache=64M #Larger is better,but should be smaller than available RAM !
enable-color=true
continue=true
always-resume=true
max-concurrent-downloads=50
content-disposition-default-utf8=true
#split=16
##Http(s) Settings#######
enable-http-keep-alive=true
http-accept-gzip=true
min-split-size=10M
max-connection-per-server=16
lowest-speed-limit=0
disable-ipv6=false
max-tries=0
#retry-wait=0
input-file=/usr/local/bin/aria2.session
save-session=/usr/local/bin/aria2.session
save-session-interval=60
force-save=true
metalink-preferred-protocol=https
##Rpc Settings############
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=false
rpc-secure=false
rpc-listen-port=6800
rpc-secret=$ariapasswd
#Bittorrent Settings######
follow-torrent=true
listen-port=$ariaport
enable-dht=true
enable-dht6=true
enable-peer-exchange=true
seed-ratio=0
bt-enable-lpd=true
bt-hash-check-seed=true
bt-seed-unverified=false
bt-save-metadata=true
bt-load-saved-metadata=true
bt-require-crypto=true
bt-force-encryption=true
bt-min-crypto-level=arc4
bt-max-peers=0
bt-tracker=$trackers_list
EOF
	if [[ ! -f /usr/local/bin/aria2c ]]; then
	clear
	colorEcho ${INFO} "安装aria2(Install aria2 ing)"
	#usermod -a -G aria2 nginx
	#useradd -r aria2 --shell=/usr/sbin/nologin
	apt-get install nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev libssl-dev libuv1-dev -q -y
	curl -LO --progress-bar https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/binary/aria2c.xz
	xz --decompress aria2c.xz
	cp -f aria2c /usr/local/bin/aria2c
	chmod +x /usr/local/bin/aria2c
	rm -rf aria2c
	apt-get autoremove -q -y
	touch /usr/local/bin/aria2.session
	mkdir /usr/share/nginx/aria2/
	chmod 755 /usr/share/nginx/aria2/
	fi
systemctl daemon-reload
systemctl enable aria2
systemctl start aria2
fi
###########Install Dnscrypt-proxy####################
if [[ ${dnsmasq_install} == 1 ]]; then
	if [[ ! -d /etc/dnscrypt-proxy/ ]]; then
		mkdir /etc/dnscrypt-proxy/
	fi
	cat > '/etc/dnscrypt-proxy/blacklist.txt' << EOF
#!!! Do not change these settings unless you know what you are doing !!!
###########################
#        Blacklist        #
###########################

## Rules for name-based query blocking, one per line
##
## Example of valid patterns:
##
## ads.*         | matches anything with an "ads." prefix
## *.example.com | matches example.com and all names within that zone such as www.example.com
## example.com   | identical to the above
## =example.com  | block example.com but not *.example.com
## *sex*         | matches any name containing that substring
## ads[0-9]*     | matches "ads" followed by one or more digits
## ads*.example* | *, ? and [] can be used anywhere, but prefixes/suffixes are faster

#ad.*
#ads.*

####Block 360####
#*.cn
360.com
360jie.com
360kan.com
360taojin.com
i360mall.com
qhimg.com
qhmsg.com
qhres.com
qihoo.com
nicaifu.com
so.com
####Block Xunlei###
xunlei.com
####Block Baidu###
91.com
aipage.com
apollo.auto
baidu.cn
baidu.com
baidubce.com
baiducontent.com
baidupcs.com
baidustatic.com
baifae.com
baifubao.com
bdimg.com
bdstatic.com
bdtjrcv.com
bdydns.cn
bdydns.net
chuanke.com
dlnel.com
dlnel.org
duapps.com
dwz.cn
hao123.com
hao123img.com
hao222.com
haokan.com
jomocdn.net
mipcdn.com
nuomi.com
quyaoya.com
smartapps.cn
tieba.com
tiebaimg.com
xianfae.com
xiaodutv.com
###
*baidu.cn
bdimg.com
bdstatic.com
duapps.com
quyaoya.com
tiebaimg.com
xiaodutv.com
sina.com
*huawei.*
hicloud.com
vmall.com
vmallres.com
wechat.com
###Other###
cyberghostvpn.com
vyprvpn.com
nordvpn.com
expressvpn.com
mifile.cn
xiaomi.cn
mi-img.com
miui.com
xiaomi.net
xiaomiyoupin.com
3304399.net
4399.com
4399dmw.com
4399er.com
4399youpai.com
5054399.com
img4399.com
58.com
58.com.cn
5858.com
58che.com
58xueche.com
anjuke.com
anjukestatic.com
chinahr.com
jxedt.com
zhuancorp.com
zhuanspirit.com
zhuanzhuan.com
acfun.cn
aixifan.com
10086.cn
139.com
chinamobile.com
chinamobileltd.com
dlercloud.com
dlercloud.org
dlercloud.me
dleris.best
bgplink.com
suda.cat
migucloud.com
migu.cn
cmvideo.cn
miguvideo.com
andfx.cn
andfx.net
cmicrwx.cn
cmpassport.com
fetion-portal.com
fetionpic.com
mmarket.com
mmarket6.com
chinapower.csis.org
189.cn
chinatelecom.com.cn
chntel.com
10010.com
10010.com.cn
chinaunicom.com
chinaunicom.com.cn
wo.com.cn
csdn.net
csdnimg.cn
hupu.com
hupucdn.com
71.am
iqiyi.com
iqiyipic.com
pps.tv
qiyi.com
qiyipic.com
qy.net
# CDN used by iqiyi
71edge.com
include:iqiyi-ads
3.cn
300hu.com
360buy.com
360buyimg.com
360top.com
7fresh.com
baitiao.com
blackdragon.com
caiyu.com
chinabank.com.cn
dao123.com
jcloud-cdn.com
jcloud-live.com
jcloud-oss.com
jcloud.com
jcloudcache.com
jcloudcs.com
jclouddn.com
jcloudec.com
jcloudlb.com
jcloudlive.com
jcloudlv.com
jcloudoss.com
jcloudss.com
jcloudstatic.com
jcloudvideo.com
jclps.com
jd-app.com
jd-ex.com
jd.cn
jd.co.th
jd.com
jd.hk
jd.id
jd.ru
jdcache.com
jdcloud.com
jdcloudcs.com
jdcloud-api.com
jddapeigou.com
jddebug.com
jddglobal.com
jdjinrong.com
jdpay.com
jdpaydns.com
jdx.com
jdwl.com
jingdongjinrong.com
jingxi.com
jkcsjd.com
joybuy.com
joybuy.es
linglonglife.com
mayshijia.com
minitiao.com
ocwms.com
paidaojia.cn
paipai.com
prestodb-china.com
qianxun.com
toplife.com
vg.com
wangyin.com
wdfok.com
yhd.com
yihaodianimg.com
yiyaojd.com
yizhitou.com
jinshuju.net
jinshujucdn.com
gifshow.com
kuaishou.com
static.yximgs.com
getlantern.org
openvpn.net
rixcloud.com
sina.com
sinaimg.cn
sina.com.cn
sinajs.cn
sina.cn
sinaapp.com
sinaedge.com
sinaimg.com
sinajs.com
weibo.com
weibo.com.cn
weibo.cn
weibocdn.com
go2map.com
sogo.com
sogou.com
sogoucdn.com
vilavpn.com
vilavpn.xyz
vilavpn1.xyz
vilavpn2.xyz
vilavpn3.xyz
vilavpn4.xyz
vilavpn5.xyz
vilavpn6.xyz
vilavpn7.xyz
kumiao.com
youku.com
ykimg.com
mmstat.com
soku.com
cibntv.net
yfcache.com
yfcloud.com
yfp2p.net
yunfancdn.com
zhihu.com
zhimg.com
v16a.tiktokcdn.com
p16-tiktokcdn-com.akamaized.net
log.tiktokv.com
ib.tiktokv.com
api-h2.tiktokv.com
v16m.tiktokcdn.com
api.tiktokv.com
v19.tiktokcdn.com
mon.musical.ly
api2-16-h2.musical.ly
api2.musical.ly
log2.musical.ly
api2-21-h2.musical.ly
##Others###
v2box.cloud
mielink.cc
blinkload.zone
xinjiecloud.co
justmysocks2.net
duangcloud.org
suying666.net
kaolay.com
afunvpn.com
maying.co
nexitallysafe.com
amysecure.com
cylink.pro
boslife.biz
surflite.net
clashcloud.net
hitun.io
renzhe.cloud
conair.me
stc-server.in
source-beat1.com
aaex.uk
obitibet.com
ssplive.pw
cloud-wing.net
yjc-i.xyz
net202.top
928.plus
paofu.cloud
cordcloud.org
ytoo.l
v2tun.com
muncloud.dog
mocloudplus.com
baicaonetwork.com
exflux.io
cttz.xyz
ssrpass.pw
pornsshub.com
catchflying.network
cloudn.me
boomsse.com
yiyo.mobi
sweetssr.com
taggood.xyz
80ss.xyz
kaolay.com
mray.club
guguex.com
blinkload.to
npss.cloud
bighead.group
bighead.plus
touhou.network
fnf.xyz
gfw.center
ixuexi.tech
kcjisu.casa
36dcup.bar
qcranev2.com
qcrane.vip
aloy.asia
pcr.cy
nsl-net.cc
eos9.vip
poicloud.blue
liuhua.in
mimemi.vip
yahaha.us
cylink0501.icu
nexitally.com
EOF
ipv6_true="false"
block_ipv6="true"
if [[ -n ${myipv6} ]]; then
	ping -6 ipv6.google.com -c 2 || ping -6 2620:fe::10 -c 2
	if [[ $? -eq 0 ]]; then
		ipv6_true="true"
		block_ipv6="false"
	fi
fi
    cat > '/etc/dnscrypt-proxy/dnscrypt-proxy.toml' << EOF
#!!! Do not change these settings unless you know what you are doing !!!
listen_addresses = ['127.0.0.1:53','[::1]:53']
user_name = 'nobody'
max_clients = 250
ipv4_servers = true
ipv6_servers = $ipv6_true
dnscrypt_servers = true
doh_servers = true
require_dnssec = false
require_nolog = true
require_nofilter = true
disabled_server_names = ['cisco', 'cisco-ipv6', 'cisco-familyshield']
force_tcp = false
timeout = 5000
keepalive = 30
lb_estimator = true
log_level = 2
use_syslog = true
#log_file = '/var/log/dnscrypt-proxy/dnscrypt-proxy.log'
cert_refresh_delay = 720
tls_disable_session_tickets = true
#tls_cipher_suite = [4865]
fallback_resolvers = ['1.1.1.1:53', '8.8.8.8:53']
ignore_system_dns = true
netprobe_timeout = 60
netprobe_address = '1.1.1.1:53'
# Maximum log files size in MB - Set to 0 for unlimited.
log_files_max_size = 0
# How long to keep backup files, in days
log_files_max_age = 7
# Maximum log files backups to keep (or 0 to keep all backups)
log_files_max_backups = 0
block_ipv6 = false
## Immediately respond to A and AAAA queries for host names without a domain name
block_unqualified = true
## Immediately respond to queries for local zones instead of leaking them to
## upstream resolvers (always causing errors or timeouts).
block_undelegated = true
## TTL for synthetic responses sent when a request has been blocked (due to
## IPv6 or blacklists).
reject_ttl = 600
cache = true
cache_size = 4096
cache_min_ttl = 2400
cache_max_ttl = 86400
cache_neg_min_ttl = 60
cache_neg_max_ttl = 600

#[local_doh]
#
#listen_addresses = ['127.0.0.1:3000']
#path = "/dns-query"
#cert_file = "/etc/certs/${domain}_ecc/fullchain.cer"
#cert_key_file = "/etc/certs/${domain}_ecc/${domain}.key"

[query_log]

  #file = '/var/log/dnscrypt-proxy/query.log'
  format = 'tsv'

[blacklist]

  blacklist_file = '/etc/dnscrypt-proxy/blacklist.txt'

[sources]

  ## An example of a remote source from https://github.com/DNSCrypt/dnscrypt-resolvers

  [sources.'public-resolvers']
  urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md']
  cache_file = 'public-resolvers.md'
  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
  prefix = ''

  [sources.'opennic']
  urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/opennic.md', 'https://download.dnscrypt.info/dnscrypt-resolvers/v3/opennic.md']
  cache_file = 'opennic.md'
  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
  prefix = ''

  ## Anonymized DNS relays

  [sources.'relays']
  urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md', 'https://download.dnscrypt.info/resolvers-list/v3/relays.md']
  cache_file = 'relays.md'
  minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
  refresh_delay = 72
  prefix = ''
EOF
	cat > '/etc/systemd/system/dnscrypt-proxy.service' << EOF
[Unit]
Description=DNSCrypt client proxy
Documentation=https://github.com/DNSCrypt/dnscrypt-proxy/wiki
After=network.target
Before=nss-lookup.target
Wants=nss-lookup.target

[Service]
#User=nobody
NonBlocking=true
ExecStart=/usr/sbin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
ProtectHome=yes
ProtectControlGroups=yes
ProtectKernelModules=yes
CacheDirectory=dnscrypt-proxy
LogsDirectory=dnscrypt-proxy
RuntimeDirectory=dnscrypt-proxy
LimitNOFILE=51200
LimitNPROC=51200
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable dnscrypt-proxy.service
	if [[ ! -f /usr/sbin/dnscrypt-proxy ]]; then
	clear
	colorEcho ${INFO} "Install dnscrypt-proxy ing"
		if [[ $(systemctl is-active dnsmasq) == active ]]; then
			systemctl disable dnsmasq
		fi
	dnsver=$(curl -s "https://api.github.com/repos/DNSCrypt/dnscrypt-proxy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
	curl -LO --progress-bar https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/${dnsver}/dnscrypt-proxy-linux_x86_64-${dnsver}.tar.gz
	tar -xvf dnscrypt-proxy-linux_x86_64-${dnsver}.tar.gz
	rm dnscrypt-proxy-linux_x86_64-${dnsver}.tar.gz
	cd linux-x86_64
	cp -f dnscrypt-proxy /usr/sbin/dnscrypt-proxy
	chmod +x /usr/sbin/dnscrypt-proxy
	cd ..
	rm -rf linux-x86_64
	setcap CAP_NET_BIND_SERVICE=+eip /usr/sbin/dnscrypt-proxy
	wget -P /etc/dnscrypt-proxy/ https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md -q --show-progress
	wget -P /etc/dnscrypt-proxy/ https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/opennic.md -q --show-progress
	wget -P /etc/dnscrypt-proxy/ https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md -q --show-progress
	fi
fi
chmod -R 755 /etc/dnscrypt-proxy/
clear
########Install Tor Relay##################
if [[ $install_tor = 1 ]]; then
	clear
	if [[ ! -f /usr/bin/tor ]]; then
	colorEcho ${INFO} "Install Tor Relay ing"
	export DEBIAN_FRONTEND=noninteractive
	touch /etc/apt/sources.list.d/tor.list
	cat > '/etc/apt/sources.list.d/tor.list' << EOF
deb https://deb.torproject.org/torproject.org $(lsb_release -cs) main
deb-src https://deb.torproject.org/torproject.org $(lsb_release -cs) main
EOF
	curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
	gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -
	apt-get update
	apt-get install deb.torproject.org-keyring tor tor-arm tor-geoipdb -q -y
	service tor stop
	cat > '/etc/tor/torrc' << EOF
SocksPort 0
ControlPort 9051
RunAsDaemon 1
ORPort 9001
#ORPort [$myipv6]:9001
Nickname $tor_name
ContactInfo $domain [tor-relay.co]
Log notice file /var/log/tor/notices.log
DirPort 9030
ExitPolicy reject6 *:*, reject *:*
EOF
service tor start
systemctl restart tor@default
	fi
fi
########Install PHP##################
if [[ $install_php = 1 ]]; then
	clear
	if [[ ! -f /usr/sbin/php-fpm7.4 ]]; then
	colorEcho ${INFO} "Install PHP ing"
	apt-get purge php* -y
	mkdir /usr/log/
	if [[ ${dist} == debian ]]; then
		wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
		echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
		apt-get update
 elif [[ ${dist} == ubuntu ]]; then
		add-apt-repository ppa:ondrej/php -y
		apt-get update
 else
	echo "fail"
 fi
	apt-get -y install php7.4
	systemctl disable --now apache2
	apt-get install php7.4-fpm -y
	apt-get install php7.4-common php7.4-mysql php7.4-ldap php7.4-xml php7.4-json php7.4-readline php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-opcache php7.4-soap php7.4-zip php7.4-intl php7.4-bcmath -y
	apt-get purge apache2* -y
	sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/fpm/php.ini
	cd /etc/php/7.4/
	curl -sS https://getcomposer.org/installer -o composer-setup.php
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer
	cd
	fi
cat > '/etc/php/7.4/fpm/pool.d/www.conf' << EOF
; Start a new pool named 'www'.
; the variable $pool can be used in any directive and will be replaced by the
; pool name ('www' here)
[www]

; Per pool prefix
; It only applies on the following directives:
; - 'access.log'
; - 'slowlog'
; - 'listen' (unixsocket)
; - 'chroot'
; - 'chdir'
; - 'php_values'
; - 'php_admin_values'
; When not set, the global prefix (or /usr) applies instead.
; Note: This directive can also be relative to the global prefix.
; Default Value: none
;prefix = /path/to/pools/$pool

; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
user = nginx
group = nginx

; The address on which to accept FastCGI requests.
; Valid syntaxes are:
;   'ip.add.re.ss:port'    - to listen on a TCP socket to a specific IPv4 address on
;                            a specific port;
;   '[ip:6:addr:ess]:port' - to listen on a TCP socket to a specific IPv6 address on
;                            a specific port;
;   'port'                 - to listen on a TCP socket to all addresses
;                            (IPv6 and IPv4-mapped) on a specific port;
;   '/path/to/unix/socket' - to listen on a unix socket.
; Note: This value is mandatory.
listen = /run/php/php7.4-fpm.sock
; listen = 127.0.0.1:9000
; Set listen(2) backlog.
; Default Value: 511 (-1 on FreeBSD and OpenBSD)
;listen.backlog = 511

; Set permissions for unix socket, if one is used. In Linux, read/write
; permissions must be set in order to allow connections from a web server. Many
; BSD-derived systems allow connections regardless of permissions. The owner
; and group can be specified either by name or by their numeric IDs.
; Default Values: user and group are set as the running user
;                 mode is set to 0660
listen.owner = nginx
listen.group = nginx
;listen.mode = 0660
; When POSIX Access Control Lists are supported you can set them using
; these options, value is a comma separated list of user/group names.
; When set, listen.owner and listen.group are ignored
;listen.acl_users =
;listen.acl_groups =

; List of addresses (IPv4/IPv6) of FastCGI clients which are allowed to connect.
; Equivalent to the FCGI_WEB_SERVER_ADDRS environment variable in the original
; PHP FCGI (5.2.2+). Makes sense only with a tcp listening socket. Each address
; must be separated by a comma. If this value is left blank, connections will be
; accepted from any ip address.
; Default Value: any
; listen.allowed_clients = 127.0.0.1

; Specify the nice(2) priority to apply to the pool processes (only if set)
; The value can vary from -19 (highest priority) to 20 (lower priority)
; Note: - It will only work if the FPM master process is launched as root
;       - The pool processes will inherit the master process priority
;         unless it specified otherwise
; Default Value: no set
; process.priority = -19

; Set the process dumpable flag (PR_SET_DUMPABLE prctl) even if the process user
; or group is differrent than the master process user. It allows to create process
; core dump and ptrace the process for the pool user.
; Default Value: no
; process.dumpable = yes

; Choose how the process manager will control the number of child processes.
; Possible Values:
;   static  - a fixed number (pm.max_children) of child processes;
;   dynamic - the number of child processes are set dynamically based on the
;             following directives. With this process management, there will be
;             always at least 1 children.
;             pm.max_children      - the maximum number of children that can
;                                    be alive at the same time.
;             pm.start_servers     - the number of children created on startup.
;             pm.min_spare_servers - the minimum number of children in 'idle'
;                                    state (waiting to process). If the number
;                                    of 'idle' processes is less than this
;                                    number then some children will be created.
;             pm.max_spare_servers - the maximum number of children in 'idle'
;                                    state (waiting to process). If the number
;                                    of 'idle' processes is greater than this
;                                    number then some children will be killed.
;  ondemand - no children are created at startup. Children will be forked when
;             new requests will connect. The following parameter are used:
;             pm.max_children           - the maximum number of children that
;                                         can be alive at the same time.
;             pm.process_idle_timeout   - The number of seconds after which
;                                         an idle process will be killed.
; Note: This value is mandatory.
pm = dynamic

; The number of child processes to be created when pm is set to 'static' and the
; maximum number of child processes when pm is set to 'dynamic' or 'ondemand'.
; This value sets the limit on the number of simultaneous requests that will be
; served. Equivalent to the ApacheMaxClients directive with mpm_prefork.
; Equivalent to the PHP_FCGI_CHILDREN environment variable in the original PHP
; CGI. The below defaults are based on a server without much resources. Don't
; forget to tweak pm.* to fit your needs.
; Note: Used when pm is set to 'static', 'dynamic' or 'ondemand'
; Note: This value is mandatory.
pm.max_children = $(($(nproc --all)*5))

; The number of child processes created on startup.
; Note: Used only when pm is set to 'dynamic'
; Default Value: (min_spare_servers + max_spare_servers) / 2
pm.start_servers = $(($(nproc --all)*4))

; The desired minimum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.min_spare_servers = $(($(nproc --all)*2))

; The desired maximum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.max_spare_servers = $(($(nproc --all)*4))

; The number of seconds after which an idle process will be killed.
; Note: Used only when pm is set to 'ondemand'
; Default Value: 10s
;pm.process_idle_timeout = 10s;

; The number of requests each child process should execute before respawning.
; This can be useful to work around memory leaks in 3rd party libraries. For
; endless request processing specify '0'. Equivalent to PHP_FCGI_MAX_REQUESTS.
; Default Value: 0
;pm.max_requests = 500

; The URI to view the FPM status page. If this value is not set, no URI will be
; recognized as a status page. It shows the following informations:
;   pool                 - the name of the pool;
;   process manager      - static, dynamic or ondemand;
;   start time           - the date and time FPM has started;
;   start since          - number of seconds since FPM has started;
;   accepted conn        - the number of request accepted by the pool;
;   listen queue         - the number of request in the queue of pending
;                          connections (see backlog in listen(2));
;   max listen queue     - the maximum number of requests in the queue
;                          of pending connections since FPM has started;
;   listen queue len     - the size of the socket queue of pending connections;
;   idle processes       - the number of idle processes;
;   active processes     - the number of active processes;
;   total processes      - the number of idle + active processes;
;   max active processes - the maximum number of active processes since FPM
;                          has started;
;   max children reached - number of times, the process limit has been reached,
;                          when pm tries to start more children (works only for
;                          pm 'dynamic' and 'ondemand');
; Value are updated in real time.
; Example output:
;   pool:                 www
;   process manager:      static
;   start time:           01/Jul/2011:17:53:49 +0200
;   start since:          62636
;   accepted conn:        190460
;   listen queue:         0
;   max listen queue:     1
;   listen queue len:     42
;   idle processes:       4
;   active processes:     11
;   total processes:      15
;   max active processes: 12
;   max children reached: 0
;
;
; Note: There is a real-time FPM status monitoring sample web page available
;       It's available in: /usr/share/php/7.4/fpm/status.html
;
; Note: The value must start with a leading slash (/). The value can be
;       anything, but it may not be a good idea to use the .php extension or it
;       may conflict with a real PHP file.
; Default Value: not set
pm.status_path = /status

ping.path = /ping

; This directive may be used to customize the response of a ping request. The
; response is formatted as text/plain with a 200 response code.
; Default Value: pong
;ping.response = pong

; The access log file
; Default: not set
;access.log = log/\$pool.access.log

; The access log format.
; The following syntax is allowed
;  %%: the '%' character
;  %C: %CPU used by the request
;      it can accept the following format:
;      - %{user}C for user CPU only
;      - %{system}C for system CPU only
;      - %{total}C  for user + system CPU (default)
;  %d: time taken to serve the request
;      it can accept the following format:
;      - %{seconds}d (default)
;      - %{miliseconds}d
;      - %{mili}d
;      - %{microseconds}d
;      - %{micro}d
;  %e: an environment variable (same as $_ENV or $_SERVER)
;      it must be associated with embraces to specify the name of the env
;      variable. Some exemples:
;      - server specifics like: %{REQUEST_METHOD}e or %{SERVER_PROTOCOL}e
;      - HTTP headers like: %{HTTP_HOST}e or %{HTTP_USER_AGENT}e
;  %f: script filename
;  %l: content-length of the request (for POST request only)
;  %m: request method
;  %M: peak of memory allocated by PHP
;      it can accept the following format:
;      - %{bytes}M (default)
;      - %{kilobytes}M
;      - %{kilo}M
;      - %{megabytes}M
;      - %{mega}M
;  %n: pool name
;  %o: output header
;      it must be associated with embraces to specify the name of the header:
;      - %{Content-Type}o
;      - %{X-Powered-By}o
;      - %{Transfert-Encoding}o
;      - ....
;  %p: PID of the child that serviced the request
;  %P: PID of the parent of the child that serviced the request
;  %q: the query string
;  %Q: the '?' character if query string exists
;  %r: the request URI (without the query string, see %q and %Q)
;  %R: remote IP address
;  %s: status (response code)
;  %t: server time the request was received
;      it can accept a strftime(3) format:
;      %d/%b/%Y:%H:%M:%S %z (default)
;      The strftime(3) format must be encapsuled in a %{<strftime_format>}t tag
;      e.g. for a ISO8601 formatted timestring, use: %{%Y-%m-%dT%H:%M:%S%z}t
;  %T: time the log has been written (the request has finished)
;      it can accept a strftime(3) format:
;      %d/%b/%Y:%H:%M:%S %z (default)
;      The strftime(3) format must be encapsuled in a %{<strftime_format>}t tag
;      e.g. for a ISO8601 formatted timestring, use: %{%Y-%m-%dT%H:%M:%S%z}t
;  %u: remote user
;
; Default: "%R - %u %t \"%m %r\" %s"
;access.format = "%R - %u %t \"%m %r%Q%q\" %s %f %{mili}d %{kilo}M %C%%"

; The log file for slow requests
; Default Value: not set
; Note: slowlog is mandatory if request_slowlog_timeout is set
;slowlog = log/$pool.log.slow

; The timeout for serving a single request after which a PHP backtrace will be
; dumped to the 'slowlog' file. A value of '0s' means 'off'.
; Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
; Default Value: 0
;request_slowlog_timeout = 0

; Depth of slow log stack trace.
; Default Value: 20
;request_slowlog_trace_depth = 20

; The timeout for serving a single request after which the worker process will
; be killed. This option should be used when the 'max_execution_time' ini option
; does not stop script execution for some reason. A value of '0' means 'off'.
; Available units: s(econds)(default), m(inutes), h(ours), or d(ays)
; Default Value: 0
;request_terminate_timeout = 0

; The timeout set by 'request_terminate_timeout' ini option is not engaged after
; application calls 'fastcgi_finish_request' or when application has finished and
; shutdown functions are being called (registered via register_shutdown_function).
; This option will enable timeout limit to be applied unconditionally
; even in such cases.
; Default Value: no
;request_terminate_timeout_track_finished = no

; Set open file descriptor rlimit.
; Default Value: system defined value
;rlimit_files = 1024

; Set max core size rlimit.
; Possible Values: 'unlimited' or an integer greater or equal to 0
; Default Value: system defined value
;rlimit_core = 0

; Chroot to this directory at the start. This value must be defined as an
; absolute path. When this value is not set, chroot is not used.
; Note: you can prefix with '$prefix' to chroot to the pool prefix or one
; of its subdirectories. If the pool prefix is not set, the global prefix
; will be used instead.
; Note: chrooting is a great security feature and should be used whenever
;       possible. However, all PHP paths will be relative to the chroot
;       (error_log, sessions.save_path, ...).
; Default Value: not set
;chroot =

; Chdir to this directory at the start.
; Note: relative path can be used.
; Default Value: current directory or / when chroot
;chdir = /var/www

; Redirect worker stdout and stderr into main error log. If not set, stdout and
; stderr will be redirected to /dev/null according to FastCGI specs.
; Note: on highloaded environement, this can cause some delay in the page
; process time (several ms).
; Default Value: no
catch_workers_output = yes

; Decorate worker output with prefix and suffix containing information about
; the child that writes to the log and if stdout or stderr is used as well as
; log level and time. This options is used only if catch_workers_output is yes.
; Settings to "no" will output data as written to the stdout or stderr.
; Default value: yes
;decorate_workers_output = no

; Clear environment in FPM workers
; Prevents arbitrary environment variables from reaching FPM worker processes
; by clearing the environment in workers before env vars specified in this
; pool configuration are added.
; Setting to "no" will make all environment variables available to PHP code
; via getenv(), $_ENV and $_SERVER.
; Default Value: yes
;clear_env = no

; Limits the extensions of the main script FPM will allow to parse. This can
; prevent configuration mistakes on the web server side. You should only limit
; FPM to .php extensions to prevent malicious users to use other extensions to
; execute php code.
; Note: set an empty value to allow all extensions.
; Default Value: .php
;security.limit_extensions = .php .php3 .php4 .php5 .php7

; Pass environment variables like LD_LIBRARY_PATH. All $VARIABLEs are taken from
; the current environment.
; Default Value: clean env
;env[HOSTNAME] = $HOSTNAME
;env[PATH] = /usr/local/bin:/usr/bin:/bin
;env[TMP] = /tmp
;env[TMPDIR] = /tmp
;env[TEMP] = /tmp

; Additional php.ini defines, specific to this pool of workers. These settings
; overwrite the values previously defined in the php.ini. The directives are the
; same as the PHP SAPI:
;   php_value/php_flag             - you can set classic ini defines which can
;                                    be overwritten from PHP call 'ini_set'.
;   php_admin_value/php_admin_flag - these directives won't be overwritten by
;                                     PHP call 'ini_set'
; For php_*flag, valid values are on, off, 1, 0, true, false, yes or no.

; Defining 'extension' will load the corresponding shared extension from
; extension_dir. Defining 'disable_functions' or 'disable_classes' will not
; overwrite previously defined php.ini values, but will append the new value
; instead.

; Note: path INI options can be relative and will be expanded with the prefix
; (pool, global or /usr)

; Default Value: nothing is defined by default except the values in php.ini and
;                specified at startup with the -d argument
;php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f www@my.domain.com
php_flag[display_errors] = on
php_admin_value[error_log] = /var/log/fpm-php.www.log
php_admin_flag[log_errors] = on
;php_admin_value[memory_limit] = 32M
EOF
systemctl restart php7.4-fpm
fi
########Install Netdata################
if [[ $install_netdata == 1 ]]; then
		clear
		colorEcho ${INFO} "Install netdata ing"
		bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --no-updates
		touch /opt/netdata/etc/netdata/python.d/dns_query_time.conf
		cat > '/opt/netdata/etc/netdata/python.d/nginx.conf' << EOF
localhost:

localipv4:
  name : 'local'
  url  : 'http://127.0.0.1:81/stub_status'
EOF
		cat > '/opt/netdata/etc/netdata/python.d/web_log.conf' << EOF
nginx_log:
  name  : 'nginx_log'
  path  : '/var/log/nginx/access.log'
EOF
		cat > '/opt/netdata/etc/netdata/go.d/docker_engine.conf' << EOF
jobs:
  - name: local
    url : http://127.0.0.1:9323/metrics
EOF
		cat > '/opt/netdata/etc/netdata/go.d/x509check.conf' << EOF
update_every : 60

jobs:
  - name   : ${domain}_${password1}
    source : https://${domain}:443
    check_revocation_status: yes

  - name   : ${domain}_${password1}_file_cert
    source : file:///etc/certs/${domain}_ecc/fullchain.cer
EOF
if [[ ${install_php} == 1 ]]; then
cat > '/opt/netdata/etc/netdata/python.d/phpfpm.conf' << EOF
local:
  url     : 'http://127.0.0.1:81/status?full&json'
EOF
fi
if [[ ${install_tor} == 1 ]]; then
apt-get install python-pip -y
pip install stem
cat > '/opt/netdata/etc/netdata/python.d/tor.conf' << EOF
update_every : 1
priority     : 60001

local_tcp:
 name: 'local'
 control_port: 9051
EOF
fi
systemctl restart netdata
fi
clear
##########Install Trojan-GFW#############
if [[ $install_trojan = 1 ]]; then
	if [[ ! -f /usr/local/bin/trojan ]]; then
	clear
	colorEcho ${INFO} "Install Trojan-GFW ing"
	#useradd -r trojan --shell=/usr/sbin/nologin
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
	systemctl daemon-reload
	clear
	colorEcho ${INFO} "configuring trojan-gfw"
	setcap CAP_NET_BIND_SERVICE=+eip /usr/local/bin/trojan
	fi
	ipv4_prefer="true"
	if [[ -n $myipv6 ]]; then
		ping -6 ipv6.google.com -c 2 || ping -6 2620:fe::10 -c 2
		if [[ $? -eq 0 ]]; then
			ipv4_prefer="false"
		fi
	fi
	cat > '/etc/systemd/system/trojan.service' << EOF
[Unit]
Description=trojan
Documentation=https://trojan-gfw.github.io/trojan/config https://trojan-gfw.github.io/trojan/
After=network.target network-online.target nss-lookup.target mysql.service mariadb.service mysqld.service

[Service]
Type=simple
StandardError=journal
#User=trojan
#Group=trojan
ExecStart=/usr/local/bin/trojan /usr/local/etc/trojan/config.json
ExecReload=/bin/kill -HUP \$MAINPID
LimitNOFILE=51200
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF
if [[ -f /usr/local/etc/trojan/dh.pem ]] && [[ -n /usr/local/etc/trojan/dh.pem ]]; then
    colorEcho ${INFO} "DH已有，跳过生成。。。"
    else
    colorEcho ${INFO} "Generating DH pem"
    openssl dhparam -out /usr/local/etc/trojan/dh.pem 2048
    fi
systemctl daemon-reload
systemctl enable trojan
if [[ ${install_mariadb} == 1 ]]; then
		cat > '/usr/local/etc/trojan/config.json' << EOF
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$password1",
        "$password2"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/certs/${domain}_ecc/fullchain.cer",
        "key": "/etc/certs/${domain}_ecc/${domain}.key",
        "key_password": "",
        "cipher": "$cipher_server",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
        	"h2",
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 82
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": "/usr/local/etc/trojan/dh.pem"
    },
    "tcp": {
        "prefer_ipv4": $ipv4_prefer,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": true,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "${password1}",
        "key": "",
        "cert": "",
        "ca": ""
    }
}
EOF
	else
		cat > '/usr/local/etc/trojan/config.json' << EOF
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$password1",
        "$password2"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/certs/${domain}_ecc/fullchain.cer",
        "key": "/etc/certs/${domain}_ecc/${domain}.key",
        "key_password": "",
        "cipher": "$cipher_server",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
        	"h2",
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 82
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": "/usr/local/etc/trojan/dh.pem"
    },
    "tcp": {
        "prefer_ipv4": $ipv4_prefer,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "${password1}",
        "key": "",
        "cert": "",
        "ca": ""
    }
}
EOF
fi

if [[ ${othercert} == 1 ]]; then
	if [[ ${install_mariadb} == 1 ]]; then
		cat > '/usr/local/etc/trojan/config.json' << EOF
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$password1",
        "$password2"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/trojan/trojan.crt",
        "key": "/etc/trojan/trojan.key",
        "key_password": "",
        "cipher": "$cipher_server",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
        	"h2",
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 82
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": "/usr/local/etc/trojan/dh.pem"
    },
    "tcp": {
        "prefer_ipv4": $ipv4_prefer,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": true,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "${password1}",
        "key": "",
        "cert": "",
        "ca": ""
    }
}
EOF
		else
		cat > '/usr/local/etc/trojan/config.json' << EOF
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": 443,
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$password1",
        "$password2"
    ],
    "log_level": 1,
    "ssl": {
        "cert": "/etc/trojan/trojan.crt",
        "key": "/etc/trojan/trojan.key",
        "key_password": "",
        "cipher": "$cipher_server",
        "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
        "prefer_server_cipher": true,
        "alpn": [
        	"h2",
            "http/1.1"
        ],
        "alpn_port_override": {
            "h2": 82
        },
        "reuse_session": true,
        "session_ticket": false,
        "session_timeout": 600,
        "plain_http_response": "",
        "curves": "",
        "dhparam": "/usr/local/etc/trojan/dh.pem"
    },
    "tcp": {
        "prefer_ipv4": $ipv4_prefer,
        "no_delay": true,
        "keep_alive": true,
        "reuse_port": false,
        "fast_open": false,
        "fast_open_qlen": 20
    },
    "mysql": {
        "enabled": false,
        "server_addr": "127.0.0.1",
        "server_port": 3306,
        "database": "trojan",
        "username": "trojan",
        "password": "${password1}",
        "key": "",
        "cert": "",
        "ca": ""
    }
}
EOF
	fi
fi
	chmod -R 755 /usr/local/etc/trojan/
	touch /usr/share/nginx/html/client1-$password1.json
	touch /usr/share/nginx/html/client2-$password2.json
	cat > "/usr/share/nginx/html/client1-$password1.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$myip",
	"remote_port": 443,
	"password": [
		"$password1"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "$domain",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
	cat > "/usr/share/nginx/html/client2-$password2.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$myip",
	"remote_port": 443,
	"password": [
		"$password2"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "$domain",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
if [[ -n $myipv6 ]]; then
	touch /usr/share/nginx/html/clientv6-$password1.json
	cat > "/usr/share/nginx/html/clientv6-$password1.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$myipv6",
	"remote_port": 443,
	"password": [
		"$password1"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "$domain",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
fi
fi
	clear
}
##########Install Mariadb#############
install_mariadb(){
  curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
  apt-get install mariadb-server -y
  apt-get install python-mysqldb -y
  apt-get -y install expect

  SECURE_MYSQL=$(expect -c "

set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"

expect \"Switch to unix_socket authentication\"
send \"n\r\"

expect \"Change the root password?\"
send \"n\r\"

expect \"Remove anonymous users?\"
send \"y\r\"

expect \"Disallow root login remotely?\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")

echo "$SECURE_MYSQL"

apt-get -y purge expect

    cat > '/etc/mysql/my.cnf' << EOF
# MariaDB-specific config file.
# Read by /etc/mysql/my.cnf

[client]

default-character-set = utf8mb4 

[mysqld]

character-set-server  = utf8mb4 
collation-server      = utf8mb4_unicode_ci
character_set_server   = utf8mb4 
collation_server       = utf8mb4_unicode_ci
# Import all .cnf files from configuration directory
!includedir /etc/mysql/mariadb.conf.d/
bind-address=127.0.0.1

[mariadb]

userstat = 1
EOF

mysql -u root -e "create user 'netdata'@'localhost';"
mysql -u root -e "grant usage on *.* to 'netdata'@'localhost';"
mysql -u root -e "flush privileges;"

mysql -u root -e "CREATE DATABASE trojan CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -e "create user 'trojan'@'localhost' IDENTIFIED BY '${password1}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON trojan.* to trojan@'localhost';"
mysql -u root -e "flush privileges;"

    cat > '/opt/netdata/etc/netdata/python.d/mysql.conf' << EOF
update_every : 10
priority     : 90100

local:
  user     : 'netdata'
  update_every : 1
EOF
##############Install Mail Service###############
if [[ $install_mail = 1 ]]; then
	if [[ ! -f /usr/sbin/postfix ]]; then
	clear
	colorEcho ${INFO} "Install Mail Service ing"
	export DEBIAN_FRONTEND=noninteractive
	apt-get install postfix -y
	apt-get install postfix-policyd-spf-python -y
	echo ${domain} > /etc/mailname
	postproto="ipv4"
	if [[ -n $myipv6 ]]; then
		ping -6 ipv6.google.com -c 2 || ping -6 2620:fe::10 -c 2
		if [[ $? -eq 0 ]]; then
			postproto="all"
		fi
	fi
	cat > '/etc/postfix/main.cf' << EOF
# See /usr/share/postfix/main.cf.dist for a commented, more complete version

# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

home_mailbox = Maildir/

smtpd_banner = \$myhostname ESMTP \$mail_name (Debian/GNU)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# See http://www.postfix.org/COMPATIBILITY_README.html -- default to 2 on
# fresh installs.
compatibility_level = 2

# TLS parameters
smtpd_tls_loglevel = 1
smtpd_tls_security_level = may
smtpd_tls_eccert_file = /etc/certs/${domain}_ecc/fullchain.cer
smtpd_tls_eckey_file = /etc/certs/${domain}_ecc/${domain}.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:\${data_directory}/smtpd_scache
smtpd_tls_mandatory_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1
smtpd_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1

smtp_tls_loglevel = 1
smtp_tls_security_level = may
smtp_tls_eccert_file = /etc/certs/${domain}_ecc/fullchain.cer
smtp_tls_eckey_file = /etc/certs/${domain}_ecc/${domain}.key
smtp_tls_session_cache_database = btree:\${data_directory}/smtp_scache
smtp_tls_mandatory_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1
smtp_tls_protocols = !SSLv2, !SSLv3, !TLSv1, !TLSv1.1

smtpd_sasl_type = dovecot

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = ${domain}
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = \$myhostname, ${domain}, localhost.${domain}, localhost
relayhost = 
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = ${postproto}

message_size_limit = 52428800

smtpd_helo_required = yes
smtpd_helo_restrictions = permit_mynetworks permit_sasl_authenticated reject_non_fqdn_helo_hostname reject_invalid_helo_hostname reject_unknown_helo_hostname
disable_vrfy_command = yes

smtpd_sender_restrictions = permit_mynetworks permit_sasl_authenticated reject_unknown_sender_domain reject_unknown_reverse_client_hostname reject_unknown_client_hostname
#smtpd_recipient_restrictions =
#   permit_mynetworks,
#   permit_sasl_authenticated,
#   reject_unauth_destination,
#   check_policy_service unix:private/policyd-spf

# Milter configuration
milter_default_action = accept
milter_protocol = 6
smtpd_milters = local:opendkim/opendkim.sock
non_smtpd_milters = \$smtpd_milters

smtpd_sasl_security_options = noanonymous
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes

smtp_header_checks = regexp:/etc/postfix/smtp_header_checks
EOF
	cat > '/etc/aliases' << EOF
# See man 5 aliases for format
postmaster:    root
root:   ${mailuser}
EOF
newaliases
echo "/^User-Agent.*Roundcube Webmail/            IGNORE" > /etc/postfix/smtp_header_checks
postmap /etc/postfix/smtp_header_checks
curl https://repo.dovecot.org/DOVECOT-REPO-GPG | gpg --import
gpg --export ED409DA1 > /etc/apt/trusted.gpg.d/dovecot.gpg
echo "deb https://repo.dovecot.org/ce-2.3-latest/${dist}/$(lsb_release -cs) $(lsb_release -cs) main" > /etc/apt/sources.list.d/dovecot.list
apt-get update
apt-get install dovecot-core dovecot-imapd -y
systemctl enable dovecot
adduser dovecot mail
cd /usr/share/nginx/
wget https://github.com/roundcube/roundcubemail/releases/download/1.4.6/roundcubemail-1.4.6-complete.tar.gz
tar -xvf roundcubemail-1.4.6-complete.tar.gz
rm -rf roundcubemail-1.4.6-complete.tar.gz
mv /usr/share/nginx/roundcubemail*/ /usr/share/nginx/roundcubemail/
chown -R nginx:nginx /usr/share/nginx/roundcubemail/
cd /usr/share/nginx/roundcubemail/
curl -s https://getcomposer.org/installer | php
cp -f composer.json-dist composer.json
cd
sed -i "s/587/25/;" /usr/share/nginx/roundcubemail/config/config.inc.php.sample
mysql -u root -e "CREATE DATABASE roundcubemail DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -e "CREATE USER roundcube@localhost IDENTIFIED BY '${password1}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost;"
mysql -u root -e "flush privileges;"
mysql -u roundcube -p"${password1}" -D roundcubemail < /usr/share/nginx/roundcubemail/SQL/mysql.initial.sql
deskey=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_#&!*%?' | fold -w 24 | head -n 1)
	cat > '/usr/share/nginx/roundcubemail/config/config.inc.php' << EOF
<?php

\$config['db_dsnw'] = 'mysql://roundcube:${password1}@localhost/roundcubemail';
\$config['default_host'] = 'localhost';
\$config['default_port'] = 143;
\$config['smtp_server'] = 'localhost';
\$config['smtp_port'] = 25;
\$config['support_url'] = 'https://github.com/johnrosen1/vpstoolbox';
\$config['des_key'] = '${deskey}';
\$config['enable_installer'] = false;

// ----------------------------------
// PLUGINS
// ----------------------------------
// List of active plugins (in plugins/ directory)
\$config['plugins'] = array();
EOF
useradd -m -s /sbin/nologin ${mailuser}
echo -e "${password1}\n${password1}" | passwd ${mailuser}
apt-get install opendkim opendkim-tools -y
gpasswd -a postfix opendkim
	cat > '/etc/opendkim.conf' << EOF
# Log to syslog
Syslog			yes
# Required to use local socket with MTAs that access the socket as a non-
# privileged user (e.g. Postfix)
UMask			007

# Sign for example.com with key in /etc/dkimkeys/dkim.key using
# selector '2007' (e.g. 2007._domainkey.example.com)
#Domain			example.com
#KeyFile		/etc/dkimkeys/dkim.key
#Selector		2007

# Commonly-used options; the commented-out versions show the defaults.
Canonicalization	relaxed/simple
Mode			sv
SubDomains		no

AutoRestart         yes
AutoRestartRate     10/1M
Background          yes
DNSTimeout          5
SignatureAlgorithm  rsa-sha256

Socket			local:/var/spool/postfix/opendkim/opendkim.sock

PidFile               /var/run/opendkim/opendkim.pid

OversignHeaders		From

# ResolverConfiguration     /etc/unbound/unbound.conf

TrustAnchorFile       /usr/share/dns/root.key

UserID                opendkim

# Map domains in From addresses to keys used to sign messages
KeyTable           refile:/etc/opendkim/key.table
SigningTable       refile:/etc/opendkim/signing.table

# Hosts to ignore when verifying signatures
ExternalIgnoreList  /etc/opendkim/trusted.hosts

# A set of internal hosts whose mail should be signed
InternalHosts       /etc/opendkim/trusted.hosts
EOF
	cat > '/etc/default/opendkim' << EOF
# Command-line options specified here will override the contents of
# /etc/opendkim.conf. See opendkim(8) for a complete list of options.
#DAEMON_OPTS=""
# Change to /var/spool/postfix/var/run/opendkim to use a Unix socket with
# postfix in a chroot:
#RUNDIR=/var/spool/postfix/var/run/opendkim
RUNDIR=/var/run/opendkim
#
# Uncomment to specify an alternate socket
# Note that setting this will override any Socket value in opendkim.conf
# default:
SOCKET="local:/var/spool/postfix/opendkim/opendkim.sock"
# listen on all interfaces on port 54321:
#SOCKET=inet:54321
# listen on loopback on port 12345:
#SOCKET=inet:12345@localhost
# listen on 192.0.2.1 on port 12345:
#SOCKET=inet:12345@192.0.2.1
USER=opendkim
GROUP=opendkim
PIDFILE=\$RUNDIR/\$NAME.pid
EXTRAAFTER=
EOF
mkdir /etc/opendkim/
mkdir /etc/opendkim/keys/
chown -R opendkim:opendkim /etc/opendkim
chmod go-rw /etc/opendkim/keys
echo "*@${domain}    default._domainkey.${domain}" > /etc/opendkim/signing.table
echo "default._domainkey.${domain}     ${domain}:default:/etc/opendkim/keys/${domain}/default.private" > /etc/opendkim/key.table
	cat > '/etc/opendkim/trusted.hosts' << EOF
127.0.0.1
localhost
10.0.0.0/8
172.16.0.0/12
192.168.0.0/16

*.${domain}
EOF
mkdir /etc/opendkim/keys/${domain}/
opendkim-genkey -b 2048 -d ${domain} -D /etc/opendkim/keys/${domain} -s default -v
chown opendkim:opendkim /etc/opendkim/keys/${domain}/default.private
mkdir /var/spool/postfix/opendkim/
chown opendkim:postfix /var/spool/postfix/opendkim

	cat > '/etc/dovecot/conf.d/10-auth.conf' << EOF
disable_plaintext_auth = no

#auth_cache_size = 0

#auth_cache_ttl = 1 hour

#auth_cache_negative_ttl = 1 hour

#auth_realms =

#auth_default_realm = 

#auth_username_chars = abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890.-_@

#auth_username_translation =

#auth_username_format = %Lu

#auth_master_user_separator =

#auth_anonymous_username = anonymous

#auth_worker_max_count = 30

#auth_gssapi_hostname =

#auth_krb5_keytab = 

#auth_use_winbind = no

#auth_winbind_helper_path = /usr/bin/ntlm_auth

#auth_failure_delay = 2 secs

#auth_ssl_require_client_cert = no

#auth_ssl_username_from_cert = no

# Space separated list of wanted authentication mechanisms:
#   plain login digest-md5 cram-md5 ntlm rpa apop anonymous gssapi otp skey
#   gss-spnego
# NOTE: See also disable_plaintext_auth setting.
auth_mechanisms = plain login

##
## Password and user databases
##

#
# Password database is used to verify user's password (and nothing more).
# You can have multiple passdbs and userdbs. This is useful if you want to
# allow both system users (/etc/passwd) and virtual users to login without
# duplicating the system users into virtual database.
#
# <doc/wiki/PasswordDatabase.txt>
#
# User database specifies where mails are located and what user/group IDs
# own them. For single-UID configuration use "static" userdb.
#
# <doc/wiki/UserDatabase.txt>

#!include auth-deny.conf.ext
#!include auth-master.conf.ext

!include auth-system.conf.ext
#!include auth-sql.conf.ext
#!include auth-ldap.conf.ext
#!include auth-passwdfile.conf.ext
#!include auth-checkpassword.conf.ext
#!include auth-vpopmail.conf.ext
#!include auth-static.conf.ext
EOF
	cat > '/etc/dovecot/conf.d/10-ssl.conf' << EOF

# SSL/TLS support: yes, no, required. <doc/wiki/SSL.txt>
ssl = yes

ssl_cert = </etc/certs/${domain}_ecc/fullchain.cer
ssl_key = </etc/certs/${domain}_ecc/${domain}.key

ssl_dh = </usr/local/etc/trojan/dh.pem

ssl_min_protocol = TLSv1.2

# SSL ciphers to use, the default is:
#ssl_cipher_list = ALL:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH
# To disable non-EC DH, use:
#ssl_cipher_list = ALL:!DH:!kRSA:!SRP:!kDHd:!DSS:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK:!RC4:!ADH:!LOW@STRENGTH

#ssl_curve_list =
ssl_prefer_server_ciphers = yes

ssl_options = no_ticket
EOF
	cat > '/etc/dovecot/conf.d/10-master.conf' << EOF
#default_process_limit = 100
#default_client_limit = 1000

# Default VSZ (virtual memory size) limit for service processes. This is mainly
# intended to catch and kill processes that leak memory before they eat up
# everything.
#default_vsz_limit = 256M

# Login user is internally used by login processes. This is the most untrusted
# user in Dovecot system. It shouldn't have access to anything at all.
#default_login_user = dovenull

# Internal user is used by unprivileged processes. It should be separate from
# login user, so that login processes can't disturb other processes.
#default_internal_user = dovecot

service imap-login {
  inet_listener imap {
    #port = 143
  }
  inet_listener imaps {
    #port = 993
    #ssl = yes
  }

  # Number of connections to handle before starting a new process. Typically
  # the only useful values are 0 (unlimited) or 1. 1 is more secure, but 0
  # is faster. <doc/wiki/LoginProcess.txt>
  #service_count = 1

  # Number of processes to always keep waiting for more connections.
  #process_min_avail = 0

  # If you set service_count=0, you probably need to grow this.
  #vsz_limit = $default_vsz_limit
}

service submission-login {
  inet_listener submission {
    #port = 587
  }
}

#service lmtp {
#  unix_listener lmtp {
    #mode = 0666
#  }

  # Create inet listener only if you can't use the above UNIX socket
  #inet_listener lmtp {
    # Avoid making LMTP visible for the entire internet
    #address =
    #port = 
  #}
#}

service imap {
  # Most of the memory goes to mmap()ing files. You may need to increase this
  # limit if you have huge mailboxes.
  #vsz_limit = $default_vsz_limit

  # Max. number of IMAP processes (connections)
  #process_limit = 1024
}

service submission {
  # Max. number of SMTP Submission processes (connections)
  #process_limit = 1024
}

service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }

}

service auth-worker {
  # Auth worker process is run as root by default, so that it can access
  # /etc/shadow. If this isn't necessary, the user should be changed to
  # $default_internal_user.
  #user = root
}

service dict {
  # If dict proxy is used, mail processes should have access to its socket.
  # For example: mode=0660, group=vmail and global mail_access_groups=vmail
  unix_listener dict {
    #mode = 0600
    #user = 
    #group = 
  }
}

service stats {
  unix_listener stats {
    user = netdata
    group = netdata
    #mode = 0666 # Use only if nothing else works. It's a bit insecure, since it allows any user in the system to mess up with the statistics.
  }
}

metric imap_select_no {
  event_name = imap_command_finished
  filter {
    cmd_name = SELECT
    tagged_reply_state = NO
  }
}

metric imap_select_no_notfound {
  event_name = imap_command_finished
  filter {
    cmd_name = SELECT
    tagged_reply = NO*Mailbox doesn't exist:*
  }
}

metric storage_http_gets {
  event_name = http_request_finished
  categories = storage
  filter {
    method = get
  }
}

# generate per-command metrics on successful commands
metric imap_command {
  event_name = imap_command_finished
  filter {
    tagged_reply_state = OK
  }
  group_by = cmd_name
}
EOF
	cat > '/etc/dovecot/conf.d/10-mail.conf' << EOF

mail_location = maildir:~/Maildir

# If you need to set multiple mailbox locations or want to change default
# namespace settings, you can do it by defining namespace sections.
#
# You can have private, shared and public namespaces. Private namespaces
# are for user's personal mails. Shared namespaces are for accessing other
# users' mailboxes that have been shared. Public namespaces are for shared
# mailboxes that are managed by sysadmin. If you create any shared or public
# namespaces you'll typically want to enable ACL plugin also, otherwise all
# users can access all the shared mailboxes, assuming they have permissions
# on filesystem level to do so.
namespace inbox {
  # Namespace type: private, shared or public
  #type = private

  # Hierarchy separator to use. You should use the same separator for all
  # namespaces or some clients get confused. '/' is usually a good one.
  # The default however depends on the underlying mail storage format.
  #separator = 

  # Prefix required to access this namespace. This needs to be different for
  # all namespaces. For example "Public/".
  #prefix = 

  # Physical location of the mailbox. This is in same format as
  # mail_location, which is also the default for it.
  #location =

  # There can be only one INBOX, and this setting defines which namespace
  # has it.
  inbox = yes

  # If namespace is hidden, it's not advertised to clients via NAMESPACE
  # extension. You'll most likely also want to set list=no. This is mostly
  # useful when converting from another server with different namespaces which
  # you want to deprecate but still keep working. For example you can create
  # hidden namespaces with prefixes "~/mail/", "~%u/mail/" and "mail/".
  #hidden = no

  # Show the mailboxes under this namespace with LIST command. This makes the
  # namespace visible for clients that don't support NAMESPACE extension.
  # "children" value lists child mailboxes, but hides the namespace prefix.
  #list = yes

  # Namespace handles its own subscriptions. If set to "no", the parent
  # namespace handles them (empty prefix should always have this as "yes")
  #subscriptions = yes

  # See 15-mailboxes.conf for definitions of special mailboxes.
}

# Example shared namespace configuration
#namespace {
  #type = shared
  #separator = /

  # Mailboxes are visible under "shared/user@domain/"
  # %%n, %%d and %%u are expanded to the destination user.
  #prefix = shared/%%u/

  # Mail location for other users' mailboxes. Note that %variables and ~/
  # expands to the logged in user's data. %%n, %%d, %%u and %%h expand to the
  # destination user's data.
  #location = maildir:%%h/Maildir:INDEX=~/Maildir/shared/%%u

  # Use the default namespace for saving subscriptions.
  #subscriptions = no

  # List the shared/ namespace only if there are visible shared mailboxes.
  #list = children
#}
# Should shared INBOX be visible as "shared/user" or "shared/user/INBOX"?
#mail_shared_explicit_inbox = no

# System user and group used to access mails. If you use multiple, userdb
# can override these by returning uid or gid fields. You can use either numbers
# or names. <doc/wiki/UserIds.txt>
#mail_uid =
#mail_gid =

# Group to enable temporarily for privileged operations. Currently this is
# used only with INBOX when either its initial creation or dotlocking fails.
# Typically this is set to "mail" to give access to /var/mail.
mail_privileged_group = mail

# Grant access to these supplementary groups for mail processes. Typically
# these are used to set up access to shared mailboxes. Note that it may be
# dangerous to set these if users can create symlinks (e.g. if "mail" group is
# set here, ln -s /var/mail ~/mail/var could allow a user to delete others'
# mailboxes, or ln -s /secret/shared/box ~/mail/mybox would allow reading it).
#mail_access_groups =

# Allow full filesystem access to clients. There's no access checks other than
# what the operating system does for the active UID/GID. It works with both
# maildir and mboxes, allowing you to prefix mailboxes names with eg. /path/
# or ~user/.
#mail_full_filesystem_access = no

# Dictionary for key=value mailbox attributes. This is used for example by
# URLAUTH and METADATA extensions.
#mail_attribute_dict =

# A comment or note that is associated with the server. This value is
# accessible for authenticated users through the IMAP METADATA server
# entry "/shared/comment". 
#mail_server_comment = ""

# Indicates a method for contacting the server administrator. According to
# RFC 5464, this value MUST be a URI (e.g., a mailto: or tel: URL), but that
# is currently not enforced. Use for example mailto:admin@example.com. This
# value is accessible for authenticated users through the IMAP METADATA server
# entry "/shared/admin".
#mail_server_admin = 

##
## Mail processes
##

# Don't use mmap() at all. This is required if you store indexes to shared
# filesystems (NFS or clustered filesystem).
#mmap_disable = no

# Rely on O_EXCL to work when creating dotlock files. NFS supports O_EXCL
# since version 3, so this should be safe to use nowadays by default.
#dotlock_use_excl = yes

# When to use fsync() or fdatasync() calls:
#   optimized (default): Whenever necessary to avoid losing important data
#   always: Useful with e.g. NFS when write()s are delayed
#   never: Never use it (best performance, but crashes can lose data)
#mail_fsync = optimized

# Locking method for index files. Alternatives are fcntl, flock and dotlock.
# Dotlocking uses some tricks which may create more disk I/O than other locking
# methods. NFS users: flock doesn't work, remember to change mmap_disable.
#lock_method = fcntl

# Directory where mails can be temporarily stored. Usually it's used only for
# mails larger than >= 128 kB. It's used by various parts of Dovecot, for
# example LDA/LMTP while delivering large mails or zlib plugin for keeping
# uncompressed mails.
#mail_temp_dir = /tmp

# Valid UID range for users, defaults to 500 and above. This is mostly
# to make sure that users can't log in as daemons or other system users.
# Note that denying root logins is hardcoded to dovecot binary and can't
# be done even if first_valid_uid is set to 0.
#first_valid_uid = 500
#last_valid_uid = 0

# Valid GID range for users, defaults to non-root/wheel. Users having
# non-valid GID as primary group ID aren't allowed to log in. If user
# belongs to supplementary groups with non-valid GIDs, those groups are
# not set.
#first_valid_gid = 1
#last_valid_gid = 0

# Maximum allowed length for mail keyword name. It's only forced when trying
# to create new keywords.
#mail_max_keyword_length = 50

# ':' separated list of directories under which chrooting is allowed for mail
# processes (ie. /var/mail will allow chrooting to /var/mail/foo/bar too).
# This setting doesn't affect login_chroot, mail_chroot or auth chroot
# settings. If this setting is empty, "/./" in home dirs are ignored.
# WARNING: Never add directories here which local users can modify, that
# may lead to root exploit. Usually this should be done only if you don't
# allow shell access for users. <doc/wiki/Chrooting.txt>
#valid_chroot_dirs = 

# Default chroot directory for mail processes. This can be overridden for
# specific users in user database by giving /./ in user's home directory
# (eg. /home/./user chroots into /home). Note that usually there is no real
# need to do chrooting, Dovecot doesn't allow users to access files outside
# their mail directory anyway. If your home directories are prefixed with
# the chroot directory, append "/." to mail_chroot. <doc/wiki/Chrooting.txt>
#mail_chroot = 

# UNIX socket path to master authentication server to find users.
# This is used by imap (for shared users) and lda.
#auth_socket_path = /var/run/dovecot/auth-userdb

# Directory where to look up mail plugins.
#mail_plugin_dir = /usr/lib/dovecot/modules

# Space separated list of plugins to load for all services. Plugins specific to
# IMAP, LDA, etc. are added to this list in their own .conf files.
#mail_plugins = 

##
## Mailbox handling optimizations
##

# Mailbox list indexes can be used to optimize IMAP STATUS commands. They are
# also required for IMAP NOTIFY extension to be enabled.
#mailbox_list_index = yes

# Trust mailbox list index to be up-to-date. This reduces disk I/O at the cost
# of potentially returning out-of-date results after e.g. server crashes.
# The results will be automatically fixed once the folders are opened.
#mailbox_list_index_very_dirty_syncs = yes

# Should INBOX be kept up-to-date in the mailbox list index? By default it's
# not, because most of the mailbox accesses will open INBOX anyway.
#mailbox_list_index_include_inbox = no

# The minimum number of mails in a mailbox before updates are done to cache
# file. This allows optimizing Dovecot's behavior to do less disk writes at
# the cost of more disk reads.
#mail_cache_min_mail_count = 0

# When IDLE command is running, mailbox is checked once in a while to see if
# there are any new mails or other changes. This setting defines the minimum
# time to wait between those checks. Dovecot can also use inotify and
# kqueue to find out immediately when changes occur.
#mailbox_idle_check_interval = 30 secs

# Save mails with CR+LF instead of plain LF. This makes sending those mails
# take less CPU, especially with sendfile() syscall with Linux and FreeBSD.
# But it also creates a bit more disk I/O which may just make it slower.
# Also note that if other software reads the mboxes/maildirs, they may handle
# the extra CRs wrong and cause problems.
#mail_save_crlf = no

# Max number of mails to keep open and prefetch to memory. This only works with
# some mailbox formats and/or operating systems.
#mail_prefetch_count = 0

# How often to scan for stale temporary files and delete them (0 = never).
# These should exist only after Dovecot dies in the middle of saving mails.
#mail_temp_scan_interval = 1w

# How many slow mail accesses sorting can perform before it returns failure.
# With IMAP the reply is: NO [LIMIT] Requested sort would have taken too long.
# The untagged SORT reply is still returned, but it's likely not correct.
#mail_sort_max_read_count = 0

protocol !indexer-worker {
  # If folder vsize calculation requires opening more than this many mails from
  # disk (i.e. mail sizes aren't in cache already), return failure and finish
  # the calculation via indexer process. Disabled by default. This setting must
  # be 0 for indexer-worker processes.
  #mail_vsize_bg_after_count = 0
}

##
## Maildir-specific settings
##

# By default LIST command returns all entries in maildir beginning with a dot.
# Enabling this option makes Dovecot return only entries which are directories.
# This is done by stat()ing each entry, so it causes more disk I/O.
# (For systems setting struct dirent->d_type, this check is free and it's
# done always regardless of this setting)
#maildir_stat_dirs = no

# When copying a message, do it with hard links whenever possible. This makes
# the performance much better, and it's unlikely to have any side effects.
#maildir_copy_with_hardlinks = yes

# Assume Dovecot is the only MUA accessing Maildir: Scan cur/ directory only
# when its mtime changes unexpectedly or when we can't find the mail otherwise.
#maildir_very_dirty_syncs = no

# If enabled, Dovecot doesn't use the S=<size> in the Maildir filenames for
# getting the mail's physical size, except when recalculating Maildir++ quota.
# This can be useful in systems where a lot of the Maildir filenames have a
# broken size. The performance hit for enabling this is very small.
#maildir_broken_filename_sizes = no

# Always move mails from new/ directory to cur/, even when the \Recent flags
# aren't being reset.
#maildir_empty_new = no

##
## mbox-specific settings
##

# Which locking methods to use for locking mbox. There are four available:
#  dotlock: Create <mailbox>.lock file. This is the oldest and most NFS-safe
#           solution. If you want to use /var/mail/ like directory, the users
#           will need write access to that directory.
#  dotlock_try: Same as dotlock, but if it fails because of permissions or
#               because there isn't enough disk space, just skip it.
#  fcntl  : Use this if possible. Works with NFS too if lockd is used.
#  flock  : May not exist in all systems. Doesn't work with NFS.
#  lockf  : May not exist in all systems. Doesn't work with NFS.
#
# You can use multiple locking methods; if you do the order they're declared
# in is important to avoid deadlocks if other MTAs/MUAs are using multiple
# locking methods as well. Some operating systems don't allow using some of
# them simultaneously.
#
# The Debian value for mbox_write_locks differs from upstream Dovecot. It is
# changed to be compliant with Debian Policy (section 11.6) for NFS safety.
#       Dovecot: mbox_write_locks = dotlock fcntl
#       Debian:  mbox_write_locks = fcntl dotlock
#
#mbox_read_locks = fcntl
#mbox_write_locks = fcntl dotlock

# Maximum time to wait for lock (all of them) before aborting.
#mbox_lock_timeout = 5 mins

# If dotlock exists but the mailbox isn't modified in any way, override the
# lock file after this much time.
#mbox_dotlock_change_timeout = 2 mins

# When mbox changes unexpectedly we have to fully read it to find out what
# changed. If the mbox is large this can take a long time. Since the change
# is usually just a newly appended mail, it'd be faster to simply read the
# new mails. If this setting is enabled, Dovecot does this but still safely
# fallbacks to re-reading the whole mbox file whenever something in mbox isn't
# how it's expected to be. The only real downside to this setting is that if
# some other MUA changes message flags, Dovecot doesn't notice it immediately.
# Note that a full sync is done with SELECT, EXAMINE, EXPUNGE and CHECK 
# commands.
#mbox_dirty_syncs = yes

# Like mbox_dirty_syncs, but don't do full syncs even with SELECT, EXAMINE,
# EXPUNGE or CHECK commands. If this is set, mbox_dirty_syncs is ignored.
#mbox_very_dirty_syncs = no

# Delay writing mbox headers until doing a full write sync (EXPUNGE and CHECK
# commands and when closing the mailbox). This is especially useful for POP3
# where clients often delete all mails. The downside is that our changes
# aren't immediately visible to other MUAs.
#mbox_lazy_writes = yes

# If mbox size is smaller than this (e.g. 100k), don't write index files.
# If an index file already exists it's still read, just not updated.
#mbox_min_index_size = 0

# Mail header selection algorithm to use for MD5 POP3 UIDLs when
# pop3_uidl_format=%m. For backwards compatibility we use apop3d inspired
# algorithm, but it fails if the first Received: header isn't unique in all
# mails. An alternative algorithm is "all" that selects all headers.
#mbox_md5 = apop3d

##
## mdbox-specific settings
##

# Maximum dbox file size until it's rotated.
#mdbox_rotate_size = 10M

# Maximum dbox file age until it's rotated. Typically in days. Day begins
# from midnight, so 1d = today, 2d = yesterday, etc. 0 = check disabled.
#mdbox_rotate_interval = 0

# When creating new mdbox files, immediately preallocate their size to
# mdbox_rotate_size. This setting currently works only in Linux with some
# filesystems (ext4, xfs).
#mdbox_preallocate_space = no

##
## Mail attachments
##

# sdbox and mdbox support saving mail attachments to external files, which
# also allows single instance storage for them. Other backends don't support
# this for now.

# Directory root where to store mail attachments. Disabled, if empty.
#mail_attachment_dir =

# Attachments smaller than this aren't saved externally. It's also possible to
# write a plugin to disable saving specific attachments externally.
#mail_attachment_min_size = 128k

# Filesystem backend to use for saving attachments:
#  posix : No SiS done by Dovecot (but this might help FS's own deduplication)
#  sis posix : SiS with immediate byte-by-byte comparison during saving
#  sis-queue posix : SiS with delayed comparison and deduplication
#mail_attachment_fs = sis posix

# Hash format to use in attachment filenames. You can add any text and
# variables: %{md4}, %{md5}, %{sha1}, %{sha256}, %{sha512}, %{size}.
# Variables can be truncated, e.g. %{sha256:80} returns only first 80 bits
#mail_attachment_hash = %{sha1}

# Settings to control adding $HasAttachment or $HasNoAttachment keywords.
# By default, all MIME parts with Content-Disposition=attachment, or inlines
# with filename parameter are consired attachments.
#   add-flags-on-save - Add the keywords when saving new mails.
#   content-type=type or !type - Include/exclude content type. Excluding will
#     never consider the matched MIME part as attachment. Including will only
#     negate an exclusion (e.g. content-type=!foo/* content-type=foo/bar).
#   exclude-inlined - Exclude any Content-Disposition=inline MIME part.
#mail_attachment_detection_options =
EOF
	cat > '/etc/dovecot/conf.d/15-mailboxes.conf' << EOF
##
## Mailbox definitions
##

# Each mailbox is specified in a separate mailbox section. The section name
# specifies the mailbox name. If it has spaces, you can put the name
# "in quotes". These sections can contain the following mailbox settings:
#
#  
# special_use:
#   A space-separated list of SPECIAL-USE flags (RFC 6154) to use for the
#   mailbox. There are no validity checks, so you could specify anything
#   you want in here, but it's not a good idea to use flags other than the
#   standard ones specified in the RFC:
#
#     \All       - This (virtual) mailbox presents all messages in the
#                  user's message store.
#     \Archive   - This mailbox is used to archive messages.
#     \Drafts    - This mailbox is used to hold draft messages.
#     \Flagged   - This (virtual) mailbox presents all messages in the
#                  user's message store marked with the IMAP \Flagged flag.
#     \Important - This (virtual) mailbox presents all messages in the
#                  user's message store deemed important to user.
#     \Junk      - This mailbox is where messages deemed to be junk mail
#                  are held.
#     \Sent      - This mailbox is used to hold copies of messages that
#                  have been sent.
#     \Trash     - This mailbox is used to hold messages that have been
#                  deleted.
#
# comment:
#   Defines a default comment or note associated with the mailbox. This
#   value is accessible through the IMAP METADATA mailbox entries
#   "/shared/comment" and "/private/comment". Users with sufficient
#   privileges can override the default value for entries with a custom
#   value.

# NOTE: Assumes "namespace inbox" has been defined in 10-mail.conf.
namespace inbox {
  # These mailboxes are widely used and could perhaps be created automatically:
  mailbox Drafts {
    auto = subscribe
    special_use = \Drafts
  }
  mailbox Junk {
    auto = subscribe
    special_use = \Junk
  }
  mailbox Trash {
    auto = subscribe
    special_use = \Trash
  }

  # For \Sent mailboxes there are two widely used names. We'll mark both of
  # them as \Sent. User typically deletes one of them if duplicates are created.
  mailbox Sent {
    auto = subscribe
    special_use = \Sent
  }
  mailbox "Sent Messages" {
    special_use = \Sent
  }

  # If you have a virtual "All messages" mailbox:
  #mailbox virtual/All {
  #  special_use = \All
  #  comment = All my messages
  #}

  # If you have a virtual "Flagged" mailbox:
  #mailbox virtual/Flagged {
  #  special_use = \Flagged
  #  comment = All my flagged messages
  #}

  # If you have a virtual "Important" mailbox:
  #mailbox virtual/Important {
  #  special_use = \Important
  #  comment = All my important messages
  #}
}
EOF
fi
systemctl restart postfix dovecot
fi
clear
}
########Nginx config##############
nginxtrojan(){
	set +e
	clear
	colorEcho ${INFO} "配置(configing) nginx"
rm -rf /etc/nginx/sites-available/*
rm -rf /etc/nginx/sites-enabled/*
rm -rf /etc/nginx/conf.d/*
touch /etc/nginx/conf.d/default.conf
if [[ $install_trojan == 1 ]]; then
	cat > '/etc/nginx/conf.d/default.conf' << EOF
#!!! Do not change these settings unless you know what you are doing !!!
server {
	listen 127.0.0.1:80;
	listen 127.0.0.1:82 http2;
	server_name $domain;
	
	resolver 127.0.0.1;
	resolver_timeout 10s;
	#if (\$http_user_agent ~* (wget|curl) ) { return 403; }
	#if (\$http_user_agent = "") { return 403; }
	if (\$host != "$domain") { return 404; }
	add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
	#add_header X-Frame-Options SAMEORIGIN always;
	#add_header X-Content-Type-Options "nosniff" always;
	#add_header Referrer-Policy "no-referrer";
	#add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://ssl.google-analytics.com https://assets.zendesk.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com https://assets.zendesk.com; style-src 'self' https://fonts.googleapis.com https://assets.zendesk.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://assets.zendesk.com https://www.facebook.com https://s-static.ak.facebook.com https://tautt.zendesk.com; object-src 'none'";
	#add_header Feature-Policy "geolocation none;midi none;notifications none;push none;sync-xhr none;microphone none;camera none;magnetometer none;gyroscope none;speaker self;vibrate none;fullscreen self;payment none;";
	location / {
			root /usr/share/nginx/html/;
			index index.html;
		}
    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_param SCRIPT_FILENAME \$request_filename;
        #fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_pass   unix:/run/php/php7.4-fpm.sock;
        }

EOF
	else
	cat > '/etc/nginx/conf.d/default.conf' << EOF
#!!! Do not change these settings unless you know what you are doing !!!
server {
	listen 443 ssl http2;
	listen [::]:443 ssl http2;

	ssl_certificate       /etc/certs/${domain}_ecc/fullchain.cer;
	ssl_certificate_key   /etc/certs/${domain}_ecc/${domain}.key;
	ssl_protocols         TLSv1.3 TLSv1.2;
	ssl_ciphers $cipher_server;
	ssl_prefer_server_ciphers on;
	ssl_early_data on;
	ssl_session_cache   shared:SSL:40m;
	ssl_session_timeout 1d;
	ssl_session_tickets off;
	ssl_stapling on;
	ssl_stapling_verify on;
	#ssl_dhparam /etc/nginx/nginx.pem;

	root /usr/share/nginx/html;

	resolver 127.0.0.1;
	resolver_timeout 10s;
	server_name           $domain;
	#add_header alt-svc 'quic=":443"; ma=2592000; v="46"';
	#add_header X-Frame-Options SAMEORIGIN always;
	#add_header X-Content-Type-Options "nosniff" always;
	#add_header X-XSS-Protection "1; mode=block" always;
	#add_header Referrer-Policy "no-referrer";
	add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
	#add_header Content-Security-Policy "default-src 'self'; script-src 'self' https://ssl.google-analytics.com https://assets.zendesk.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com https://assets.zendesk.com; style-src 'self' https://fonts.googleapis.com https://assets.zendesk.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://assets.zendesk.com https://www.facebook.com https://s-static.ak.facebook.com https://tautt.zendesk.com; object-src 'none'";
	#add_header Feature-Policy "geolocation none;midi none;notifications none;push none;sync-xhr none;microphone none;camera none;magnetometer none;gyroscope none;speaker self;vibrate none;fullscreen self;payment none;";
	#if (\$http_user_agent ~* (wget|curl) ) { return 403; }
	#if (\$http_user_agent = "") { return 403; }
	if (\$host != "$domain") { return 404; }
	location / {
		index index.html;
	}
    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_param SCRIPT_FILENAME \$request_filename;
        #fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_pass   unix:/run/php/php7.4-fpm.sock;
        }
EOF
fi
if [[ $install_tjp == 1 ]]; then
echo "    location /${password1}_config/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        client_max_body_size 0;" >> /etc/nginx/conf.d/default.conf
echo "        index index.php;" >> /etc/nginx/conf.d/default.conf
echo "        alias /usr/share/nginx/trojan-panel/public/;" >> /etc/nginx/conf.d/default.conf
echo "        try_files \$uri \$uri/ @config;" >> /etc/nginx/conf.d/default.conf
echo "        location ~ \.php\$ {" >> /etc/nginx/conf.d/default.conf
echo "        include fastcgi_params;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_pass unix:/run/php/php7.4-fpm.sock;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_index index.php;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_param SCRIPT_FILENAME \$request_filename;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
echo "        location @config {" >> /etc/nginx/conf.d/default.conf
echo "        rewrite /${password1}_config/(.*)\$ /${password1}_config/index.php?/\$1 last;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_mail == 1 ]]; then
echo "    location /${password1}_webmail/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        client_max_body_size 0;" >> /etc/nginx/conf.d/default.conf
echo "        index index.php;" >> /etc/nginx/conf.d/default.conf
echo "        alias /usr/share/nginx/roundcubemail/;" >> /etc/nginx/conf.d/default.conf
echo "        location ~ \.php\$ {" >> /etc/nginx/conf.d/default.conf
echo "        include fastcgi_params;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_pass unix:/run/php/php7.4-fpm.sock;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_index index.php;" >> /etc/nginx/conf.d/default.conf
echo "        fastcgi_param SCRIPT_FILENAME \$request_filename;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $dnsmasq_install == 1 ]]; then
echo "    #location /dns-query {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        #proxy_redirect off;" >> /etc/nginx/conf.d/default.conf
echo "        #proxy_pass https://127.0.0.1:3000/dns-query;" >> /etc/nginx/conf.d/default.conf
echo "        #proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/default.conf
echo "        #proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/default.conf
echo "        #proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        #proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        #proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        #error_page 502 = @errpage;" >> /etc/nginx/conf.d/default.conf
echo "        #}" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_speedtest == 1 ]]; then
echo "    location /${password1}_speedtest/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        client_max_body_size 0;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:8001/;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_rsshub == 1 ]]; then
echo "    location /${password1}_rsshub/ {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        client_max_body_size 0;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:1200/;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_aria == 1 ]]; then
echo "    location $ariapath {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:6800/jsonrpc;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_qbt == 1 ]]; then
echo "    location $qbtpath {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass              http://127.0.0.1:8080/;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header        X-Forwarded-Host        \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_file == 1 ]]; then
echo "    location $filepath {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:8081/;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        client_max_body_size 0;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_tracker == 1 ]]; then
echo "    location $trackerpath {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:8000/announce;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Upgrade \$http_upgrade;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Connection "upgrade";" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
echo "    location $trackerstatuspath {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://127.0.0.1:8000/stats;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$http_host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Real-IP \$remote_addr;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
if [[ $install_netdata == 1 ]]; then
echo "    location ~ $netdatapath(?<ndpath>.*) {" >> /etc/nginx/conf.d/default.conf
echo "        #access_log off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_redirect off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header Host \$host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-Host \$host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-Server \$host;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass_request_headers on;" >> /etc/nginx/conf.d/default.conf
echo '        proxy_set_header Connection "keep-alive";' >> /etc/nginx/conf.d/default.conf
echo "        proxy_store off;" >> /etc/nginx/conf.d/default.conf
echo "        proxy_pass http://netdata/\$ndpath\$is_args\$args;" >> /etc/nginx/conf.d/default.conf
echo "        gzip on;" >> /etc/nginx/conf.d/default.conf
echo "        gzip_proxied any;" >> /etc/nginx/conf.d/default.conf
echo "        gzip_types *;" >> /etc/nginx/conf.d/default.conf
echo "        }" >> /etc/nginx/conf.d/default.conf
fi
echo "}" >> /etc/nginx/conf.d/default.conf
echo "" >> /etc/nginx/conf.d/default.conf
echo "server {" >> /etc/nginx/conf.d/default.conf
echo "    listen 80;" >> /etc/nginx/conf.d/default.conf
echo "    listen [::]:80;" >> /etc/nginx/conf.d/default.conf
echo "    server_name $domain;" >> /etc/nginx/conf.d/default.conf
echo "    return 301 https://$domain\$request_uri;" >> /etc/nginx/conf.d/default.conf
echo "}" >> /etc/nginx/conf.d/default.conf
echo "" >> /etc/nginx/conf.d/default.conf
echo "server {" >> /etc/nginx/conf.d/default.conf
echo "    listen 80 default_server;" >> /etc/nginx/conf.d/default.conf
echo "    listen [::]:80 default_server;" >> /etc/nginx/conf.d/default.conf
echo "    server_name _;" >> /etc/nginx/conf.d/default.conf
echo "    return 404;" >> /etc/nginx/conf.d/default.conf
echo "}" >> /etc/nginx/conf.d/default.conf
if [[ $install_netdata == 1 ]]; then
echo "server { #For Netdata only !" >> /etc/nginx/conf.d/default.conf
echo "    listen 127.0.0.1:81;" >> /etc/nginx/conf.d/default.conf
echo "    location /stub_status {" >> /etc/nginx/conf.d/default.conf
echo "    access_log off;" >> /etc/nginx/conf.d/default.conf
echo "    stub_status;" >> /etc/nginx/conf.d/default.conf
echo "    }" >> /etc/nginx/conf.d/default.conf
echo "    location ~ ^/(status|ping)\$ {" >> /etc/nginx/conf.d/default.conf
echo "    access_log off;" >> /etc/nginx/conf.d/default.conf
echo "    allow 127.0.0.1;" >> /etc/nginx/conf.d/default.conf
echo "    fastcgi_param SCRIPT_FILENAME \$request_filename;" >> /etc/nginx/conf.d/default.conf
echo "    fastcgi_index index.php;" >> /etc/nginx/conf.d/default.conf
echo "    include fastcgi_params;" >> /etc/nginx/conf.d/default.conf
echo "    fastcgi_pass   unix:/run/php/php7.4-fpm.sock;" >> /etc/nginx/conf.d/default.conf
echo "    }" >> /etc/nginx/conf.d/default.conf
echo "}" >> /etc/nginx/conf.d/default.conf
echo "upstream netdata {" >> /etc/nginx/conf.d/default.conf
echo "    server 127.0.0.1:19999;" >> /etc/nginx/conf.d/default.conf
echo "    keepalive 64;" >> /etc/nginx/conf.d/default.conf
echo "}" >> /etc/nginx/conf.d/default.conf
fi
nginx -t
htmlcode=$(shuf -i 1-3 -n 1)
curl -LO --progress-bar https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/$htmlcode.zip
unzip -o $htmlcode.zip -d /usr/share/nginx/html/
rm -rf $htmlcode.zip
rm -rf /usr/share/nginx/html/readme.txt
chown -R nginx:nginx /usr/share/nginx/
systemctl restart nginx
}
##########Auto boot start###############
start(){
	set +e
	colorEcho ${INFO} "启动(starting) trojan-gfw and nginx ing..."
	systemctl daemon-reload
	if [[ $install_qbt = 1 ]]; then
		systemctl start qbittorrent.service
	fi
	if [[ $install_file = 1 ]]; then
		systemctl start filebrowser
	fi
	if [[ $install_trojan = 1 ]]; then
		systemctl start trojan
	fi
}
##########Check for update############
checkupdate(){
	set +e
	cd
	apt-get update
	apt-get upgrade -y
	if [[ -f /usr/local/bin/trojan ]]; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/trojan-gfw/trojan-quickstart/master/trojan-quickstart.sh)"
	fi
	if [[ -f /opt/netdata/usr/sbin/netdata ]]; then
		bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait --no-updates
		wget -O /opt/netdata/etc/netdata/netdata.conf http://127.0.0.1:19999/netdata.conf
		sed -i 's/# bind to = \*/bind to = 127.0.0.1/g' /opt/netdata/etc/netdata/netdata.conf
		systemctl restart netdata
  	fi
  	echo "Done !"
}
###########Trojan share link########
sharelink(){
	set +e
	cd
	clear
	if [[ $install_trojan = 1 ]]; then
		curl -LO --progress-bar https://github.com/trojan-gfw/trojan-url/raw/master/trojan-url.py
		chmod +x trojan-url.py
	cat > "/usr/share/nginx/client1.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$domain",
	"remote_port": 443,
	"password": [
		"$password1"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
	cat > "/usr/share/nginx/client2.json" << EOF
{
	"run_type": "client",
	"local_addr": "127.0.0.1",
	"local_port": 1080,
	"remote_addr": "$domain",
	"remote_port": 443,
	"password": [
		"$password2"
	],
	"log_level": 1,
	"ssl": {
		"verify": true,
		"verify_hostname": true,
		"cert": "",
		"cipher": "$cipher_client",
		"cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
		"sni": "",
		"alpn": [
			"h2",
			"http/1.1"
		],
		"reuse_session": true,
		"session_ticket": false,
		"curves": ""
	},
	"tcp": {
		"no_delay": true,
		"keep_alive": true,
		"reuse_port": false,
		"fast_open": false,
		"fast_open_qlen": 20
	}
}
EOF
	./trojan-url.py -q -i /usr/share/nginx/client1.json -o /usr/share/nginx/html/$password1.png
	./trojan-url.py -q -i /usr/share/nginx/client2.json -o /usr/share/nginx/html/$password2.png
	rm /usr/share/nginx/client1.json
	rm /usr/share/nginx/client2.json
	rm -rf trojan-url.py
	fi
	cat > "/usr/share/nginx/html/result.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="description" content="Vpstoolbox Result">
    <meta name="keywords" content="Vpstoolbox">
    <meta name="author" content="John Rosen">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="icon" type="image/x-icon" href="https://raw.githubusercontent.com/johnrosen1/trojan-gfw-script/master/binary/trojan.ico">
    <title>Vps Toolbox Result</title>
</head>
<style>
body {
  background-color: #cccccc;
  font-size: 1.2em;
}

ul.ttlist{
    list-style: cjk-ideographic;
}

.menu{
    position: relative;
    background-color: #B2BEB5;  
    font-family: sans-serif;
    font-size: 2em;
    margin-top: -10px;
    padding-top: 0px;
    text-align: center;
    width: 100%;
    height: 8%;
}

.menu ul{
    list-style-type: none;
    overflow: hidden;
    margin: 0;
    padding: 0;
}

.menu li{
    float: left;
}
.menu a{
    display: inline;
    color: white;
    text-align: center;
    padding-left: 100px;
    padding-right: 100px;
    text-decoration: none;
}

.menu li:hover {
    background-color: #CC99FF;
}

.tt{
    /* position: absolute; */
    border:1px #00f none;
    border-radius: 5px;
    width: 75%;
    width: calc(100% - 120px);
    box-sizing: border-box;
    margin: 20px auto 70px;
    padding: 0 50px 10px 50px;
    /* margin-left: 150px; */
    /* margin-top: 20px; */
    /* font-size: 1.2em; */
    font-family: PingFangSC, 'Noto Sans CJK SC', sans-serif;
    /* font-weight: bold; */
    /* padding-left: 50px;
    padding-right: 50px;
    padding-bottom: 10px; */
    /* margin-bottom: 60px; */
    background-color: #E6FFFB;
    overflow: visible;
}
.tt a {
    text-decoration: none;
    color: #8095ff;
    /* font-size: 1.3em; */
}

.tt img{
    width: 550px;
    height: 40%;
}

.tt li {
    padding-top: 10px;
}

.subtt{
    text-align: center;
    margin: auto;
    font-size: 2em;
    padding-top: 30px;
}
.desc {
    font-size: 0.8em;
    text-align: right;
}

.t1{
    font-size: 1.2em;
}

footer{
    padding-top: 0;
    position: fixed;
    margin: 0;
    background-color: #B2BEB5;
    width: 100%;
    height: 50px;
    bottom: 0;
}

footer p{
    color: #fff;
    text-align: center;
    font-size: 1em;
    font-family: sans-serif;
}

footer a{
    color: #fff;
}

footer a:link {
    text-decoration: none;
}

@media (max-width: 560px){
    .menu{
        font-size: 1.2em;
    }
    .sidebar {
        display: none;
    }

    .cate {
        display: none;
    }
    .tt{
        position: absolute;
        width: 80%;
        margin-left: 0;
    }
    .menu{
        padding-top: 0px;
    }
}

@media (max-width: 750px){
    .sidebar {
        display: none;
    }
    .cate{
        display: none;
    }
}
::-webkit-scrollbar {
    width: 11px;
}

::-webkit-scrollbar-track {
    background: #CCFFEE;
    border-radius: 10px;
}

::-webkit-scrollbar-thumb {
    background: #B3E5FF;
    border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
    background: #156; 
}
</style>
<body>
    <div>
        <div>
            <article>
                <div class="tt">
                    <h1 class="subtt">Vps Toolbox Result</h1>
                    <p class="desc">If you did not choose any of the softwares during the installation below, just ignore them.</p>
                    <p class="desc">！如果你安装的时候没有选择相应的软件，请自动忽略相关内容！</p>
                    <p class="desc">！以下所有链接以及信息都是有用的，请在提任何问题或者issue前仔细阅读相关内容！</p>
                    <p class="desc"><a href="https://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way/blob/master/README-zh_CN.md" target="_blank">提问的智慧</a></p>
                    <br>
                    
                    <h2>Trojan-GFW</h2>
                    <h4> 默认安装: ✅</h4>
                    <p>Introduction: An unidentifiable mechanism that helps you bypass GFW.</p>
                    <ul class="ttlist">
                        <li>
                            <h3>Trojan-GFW client config profiles</h3>
                            <ol>
                                <li><a href="client1-$password1.json" target="_blank">Profile 1</a></li>
                                <li><a href="client2-$password2.json" target="_blank">Profile 2</a></li>
                                <li><a href="clientv6-$password1.json" target="_blank">IPV6 Profile</a>(only vaild when your server has a ipv6 address,or will 404 !)</li>
                            </ol>
                        </li>
                        <li>
                            <h3>Trojan-GFW Share Links</h3>
                            <ol>
                                <li><code>trojan://$password1@$domain:443</code></li>
                                <li><code>trojan://$password2@$domain:443</code></li>
                            </ol>
                        </li>
                        <li>
                            <h3>Trojan-GFW QR codes (不支援python3-prcode的系统会404!)</h3>
                            <ol>
                                <li><a href="$password1.png" target="_blank">QR code 1</a></li>
                                <li><a href="$password2.png" target="_blank">QR code 2</a></li>
                            </ol>
                        </li>
                        <li>
                            <h3>Related Links</h3>
                            <ol>
                                <li><a href="https://github.com/trojan-gfw/igniter/releases" target="_blank">Android client</a></li>
                                <li><a href="https://apps.apple.com/us/app/shadowrocket/id932747118" target="_blank">ios client</a></li>
                                <li><a href="https://github.com/trojan-gfw/trojan/releases/latest" target="_blank">windows client</a></li>
                                <li><a href="https://github.com/trojan-gfw/trojan/wiki/Mobile-Platforms" target="_blank">https://github.com/trojan-gfw/trojan/wiki/Mobile-Platforms</a></li>
                                <li><a href="https://github.com/trojan-gfw/trojan/releases/latest" target="_blank">https://github.com/trojan-gfw/trojan/releases/latest</a></li>
                            </ol>
                        </li>
                    </ul>
                    <br>

                    <h2>Trojan-panel</h2>
                    <h4>默认安装: ❎</h4>
                    <p>Introduction: Trojan multi-user control panel</p>
                    <p><a href="https://$domain/${password1}_config/" target="_blank">https://$domain/${password1}_config/</a></p>
                    <p>Related Links</p>
                    <ol>
                        <li><a href="https://trojan-tutor.github.io/2019/06/08/p43.html#more" target="_blank">Trojan-Panel配置(仅供参考！)</a></li>
                        <li><a href="https://github.com/trojan-gfw/trojan-panel" target="_blank">https://github.com/trojan-gfw/trojan-panel</a></li>
                        <li><a href="" target="_blank">test</a></li>
                        <li><a href="" target="_blank">tset</a></li>
                    </ol>
                    <br>

                    <h2>Rsshub</h2>
                    <h4>默认安装: ✅</h4>
                    <p>Introduction: Please read the rsshub docs</p>
                    <p><a href="https://$domain/${password1}_rsshub/" target="_blank">https://$domain/${password1}_rsshub/</a></p>
                    <p>Related Links</p>
                    <ol>
                        <li><a href="https://docs.rsshub.app/" target="_blank">RSSHUB docs</a></li>
                        <li><a href="https://github.com/DIYgod/RSSHub-Radar" target="_blank">RSSHub Radar</a></li>
                        <li><a href="" target="_blank">test</a></li>
                        <li><a href="" target="_blank">tset</a></li>
                    </ol>
                    <br>
                    
                    <h2>Qbittorrent</h2>
                    <h4>默认安装: ❎</h4>
                    <p>Introduction: download resources you want to your vps(support bt only but extremely fast)</p>
                    <!-- <p><a href="https://$domain$qbtpath" target="_blank">https://$domain$qbtpath</a> 用户名(username): admin 密碼(password): adminadmin</p> -->
                    <ul>
                        <li><a href="https://$domain$qbtpath" target="_blank">https://$domain$qbtpath</a></li>
                        <li>用户名(username): admin</li>
                        <li>密碼(password): adminadmin</li>
                    </ul>
                    <p>Tips:</p>
                    <ol>
                        <li>请将Qbittorrent中的Bittorrent加密選項改为 強制加密(Require encryption) ,否则會被迅雷吸血！！！</li>
                        <li>请在Qbittorrent中添加Trackers <a href="https://trackerslist.com/all.txt" target="_blank">https://trackerslist.com/all.txt</a> ,否则速度不會快的！！！</li>
                        <li>请在Web选项中将监听地址修改为127.0.0.1并关闭 UPnP／NAT-PMP (端口请勿修改)来防止未授权访问！！！</li>
                    </ol>
                    
                    <p>附：优秀的BT站点推荐(Related Links)</p>
                    <ol>
                        <li><a href="https://thepiratebay.org/" target="_blank">https://thepiratebay.org/</a></li>
                        <li><a href="https://sukebei.nyaa.si/" target="_blank">https://sukebei.nyaa.si/</a></li>
                        <li><a href="https://rarbgprx.org/torrents.php" target="_blank">https://rarbgprx.org/torrents.php</a></li>
                    </ol>
                    <p>Related Links</p>
                    <ol>
                        <li><a href="https://www.qbittorrent.org/download.php" target="_blank">win等平台下载页面</a></li>
                        <li><a href="https://github.com/qbittorrent/qBittorrent" target="_blank">Github页面</a></li>
                        <li><a href="https://play.google.com/store/apps/details?id=com.lgallardo.qbittorrentclientpro" target="_blank">Android远程操控客户端</a></li>
                        <li><a href="https://www.qbittorrent.org/" target="_blank">https://www.qbittorrent.org/</a></li>
                        <li><a href="https://www.johnrosen1.com/qbt/" target="_blank">https://www.johnrosen1.com/qbt/</a></li>
                    </ol>
                    <br>
                    
                    <h2>Bittorrent-trackers</h2>
                    <h4>默认安装: ❎</h4>
                    <p>Introduction: use it as a private or public(not recommended) bittorrent tracker</p>
                    <p><code>https://$domain:443$trackerpath</code></p>
                    <p><code>http://$domain:8000/announce</code></p>
                    <p>你的Bittorrent-Tracker信息（查看状态用）(Your Bittorrent-Tracker Status Information)</p>
                    <p><a href="https://$domain:443$trackerstatuspath" target="_blank">https://$domain:443$trackerstatuspath</a></p>
                    <p>Tips:</p>
                    <ol>
                        <li>请手动将此Tracker添加于你的BT客户端中，发布种子时记得填上即可。</li>
                        <li>请记得将此Tracker分享给你的朋友们。</li>
                    </ol>
                    <p>Related Links</p>
                    <ol>
                        <li><a href="https://github.com/webtorrent/bittorrent-tracker" target="_blank">https://github.com/webtorrent/bittorrent-tracker</a></li>
                        <li><a href="https://lifehacker.com/whats-a-private-bittorrent-tracker-and-why-should-i-us-5897095" target="_blank">What's a Private BitTorrent Tracker, and Why Should I Use One?</a></li>
                        <li><a href="https://www.howtogeek.com/141257/htg-explains-how-does-bittorrent-work/" target="_blank">How Does BitTorrent Work?</a></li>
                    </ol>
                    <br>
                    
                    <h2>Aria2</h2>
                    <h4>默认安装: ✅</h4>
                    <p>Your Aria2 Information</p>
                    <p>Introduction: download resources you want to your vps(support ftp/http/https/bt)</p>
                    <p><code>$ariapasswd@https://$domain:443$ariapath</code></p>
                    <p>Related Links:</p>
                    <p>Ariang is recommended to connect to your server</p>
                    <ol>
                        <li><a href="https://github.com/mayswind/AriaNg/releases" target="_blank">Aria客户端(远程操控)</a></li>
                        <li><a href="https://github.com/aria2/aria2" target="_blank">https://github.com/aria2/aria2</a></li>
                        <li><a href="https://aria2.github.io/manual/en/html/index.html" target="_blank">https://aria2.github.io/manual/en/html/index.html</a> 官方文档</li>
                        <li><a href="https://play.google.com/store/apps/details?id=com.gianlu.aria2app" target="_blank">https://play.google.com/store/apps/details?id=com.gianlu.aria2app</a></li>
                    </ol>
                    <br>
                    
                    <h2>Filebrowser</h2>
                    <h4>默认安装: ✅</h4>
                    <p>Your Filebrowser Information</p>
                    <p>Introduction: download any resources(formaly downloaded by qbt or aria2) from your vps to your local network</p>
                    <!-- <p><a href="https://$domain:443$filepath" target="_blank">https://$domain:443$filepath</a> 用户名(username): admin 密碼(password): admin</p> -->
                    <ul>
                        <li><a href="https://$domain:443$filepath" target="_blank">https://$domain:443$filepath</a></li>
                        <li>用户名(username): admin</li>
                        <li>密碼(password): admin</li>
                    </ul>
                    <p>Tips:</p>
                    <p>！请修改默认用户名和密码！。</p>
                    <p>Related Links</p>
                    <ul>
                        <li><a href="https://github.com/filebrowser/filebrowser" target="_blank">https://github.com/filebrowser/filebrowser</a></li>
                        <li><a href="https://filebrowser.xyz/" target="_blank">https://filebrowser.xyz/</a></li>
                    </ul>
                    <br>

                    <h2>Netdata</h2>
                    <h4>默认安装: ✅</h4>
                    <p>Your Netdata Information</p>
                    <p><a href="https://$domain:443$netdatapath" target="_blank">https://$domain:443$netdatapath</a></p>
                    <p>Related Links</p>
                    <ol>
                        <li><a href="https://play.google.com/store/apps/details?id=com.kpots.netdata" target="_blank">https://play.google.com/store/apps/details?id=com.kpots.netdata</a></li>
                        <li><a href="https://github.com/netdata/netdata" target="_blank">https://github.com/netdata/netdata</a></li>
                    </ol>
                    <br>

                    <h2>Speedtest</h2>
                    <h4>默认安装: ✅</h4>
                    <p>Introduction: test download and upload speed from vps to your local network</p>
                    <p><a href="https://$domain:443/${password1}_speedtest/" target="_blank">https://$domain:443/${password1}_speedtest/</a></p>
                    <p>Related Links</p>
                    <ol>
                        <li><a href="https://github.com/librespeed/speedtest" target="_blank">https://github.com/librespeed/speedtest</a></li>
                        <li><a href="https://github.com/librespeed/speedtest/blob/docker/doc.md" target="_blank">https://github.com/librespeed/speedtest/blob/docker/doc.md</a></li>
                    </ol>
                    <br>

                    <h2>MariaDB</h2>
                    <h4>默认安装: ✅</h4>
                    <p>Your MariaDb Information</p>
                    <p>No default root password, remote access has been disabled for security!</p>
                    <p>无默认root密码,为了安全起见,外网访问已禁用,请直接使用以下命令访问数据库！</p>
                    <p>mysql -u root</p>
                    <p>如果需要外网访问,请自行注释掉/etc/mysql/my.cnf中的bind-address选项并重启mariadb！</p>
                    <p>Please edit /etc/mysql/my.cnf and restart mariadb if you need remote access !</p>
                    <br>
                    
                    <h2>Mail Service</h2>
                    <h4>默认安装: ❎</h4>
                    <p>Your Mail service Information</p>
                    <!-- <p><a href="https://$domain$qbtpath" target="_blank">https://$domain$qbtpath</a> 用户名(username): admin 密碼(password): adminadmin</p> -->
                    <ul>
                        <li><a href="https://${domain}/${password1}_webmail/" target="_blank">Roundcube Webmail</a></li>
                        <li>用户名(username): ${mailuser}</li>
                        <li>密碼(password): ${password1}</li>
                        <li>收件地址: ${mailuser}@${domain}</li>
                    </ul>
                    <p>Tips:</p>
                    <ol>
                        <li>阿里云，gcp等厂商默认不开放25端口，不能发邮件，请注意.</li>
                        <li>请自行修改发件人身份为${mailuser}@${domain}</li>
                        <li>请自行添加SPF(TXT) RECORD: v=spf1 mx ip4:${myip} a ~all</li>
                        <li>请自行运行sudo cat /etc/opendkim/keys/${domain}/default.txt 来获取生成的DKIM(TXT) RECORD</li>
                    </ol>
                    
                    <p>附：</p>
                    <ol>
                        <li><a href="https://www.mail-tester.com/" target="_blank">https://www.mail-tester.com/</a></li>
                        <li><a href="https://lala.im/6838.html" target="_blank">Debian10使用Postfix+Dovecot+Roundcube搭建邮件服务器</a></li>
                        <li><a href="" target="_blank">test</a></li>
                    </ol>
                    <p>Related Links</p>
                    <ol>
                        <li><a href="" target="_blank">test</a></li>
                        <li><a href="" target="_blank">test</a></li>
                        <li><a href="" target="_blank">test</a></li>
                        <li><a href="" target="_blank">test</a></li>
                        <li><a href="" target="_blank">test</a></li>
                    </ol>
                    <br>


                    <h2>How to change the default config </h2>
                    <p>Nginx</p>
                    <ul>
                        <li><code>sudo nano /etc/nginx/conf.d/default.conf</code></li>
                        <li><code>sudo systemctl start/restart/status nginx</code></li>
                    </ul>
                    <p>Trojan-GFW</p>
                    <ul>
                        <li><code>sudo nano /usr/local/etc/trojan/config.json</code></li>
                        <li><code>sudo systemctl start/restart/status trojan</code></li>
                    </ul>
                    <p>Dnscrypt-proxy</p>
                    <ul>
                        <li><code>sudo nano /etc/dnscrypt-proxy/dnscrypt-proxy.toml</code></li>
                        <li><code>sudo systemctl start/restart/status dnscrypt-proxy</code></li>
                    </ul>
                    <p>Aria2</p>
                    <ul>
                        <li><code>sudo nano /etc/aria2.conf</code></li>
                        <li><code>sudo systemctl start/restart/status aria2</code></li>
                    </ul>
                    <p>Netdata</p>
                    <ul>
                        <li><code>sudo nano /opt/netdata/etc/netdata/netdata.conf</code></li>
                        <li><code>sudo systemctl start/restart/status netdata</code></li>
                    </ul>
                    <p>Speedtest</p>
                    <ul>
                        <li><code>docker ps/stop/start</code></li>
                        <li><code>docker run -d --restart unless-stopped -e MODE=standalone -p 127.0.0.1:8001:80 -it adolfintel/speedtest </code></li>
                    </ul>
                    <p>Tor</p>
                    <ul>
                        <li><code>sudo nano /etc/tor/torrc</code></li>
                        <li><code>sudo systemctl start/restart/status tor@default</code></li>
                    </ul>
                    <br>

                </div>
            </article>
            <footer>
                <p><a href="https://github.com/johnrosen1/vpstoolbox">VPS Toolbox</a> Copyright &copy; MIT License 2020 Johnrosen</p>
            </footer>
        </div>
    </div>
</body>
</html>
EOF
}
##########Uninstall##########
uninstall(){
	set +e
	cd
	if [[ -f /usr/local/bin/trojan ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) trojan?" 8 78); then
		systemctl stop trojan
		systemctl disable trojan
		rm -rf /etc/systemd/system/trojan*
		rm -rf /usr/local/etc/trojan/*
		rm -rf /root/.trojan/autoupdate.sh
		fi
	fi
	if [[ -f /usr/sbin/nginx ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) nginx?" 8 78); then
		systemctl stop nginx
		systemctl disable nginx
		apt-get -y remove nginx
		rm -rf /etc/apt/sources.list.d/nginx.list
		rm -rf /usr/share/nginx/html/
		fi
	fi
	if [[ -f /usr/sbin/dnscrypt-proxy ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) dnscrypt-proxy?" 8 78); then
			systemctl stop dnscrypt-proxy
			systemctl disable dnscrypt-proxy
			rm -rf /usr/sbin/dnscrypt-proxy
			rm /etc/systemd/system/dnscrypt-proxy.service
		fi
	fi
	if [[ -f /usr/bin/qbittorrent-nox ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) qbittorrent?" 8 78); then
		systemctl stop qbittorrent
		systemctl disable qbittorrent
		apt-get -y remove qbittorrent-nox
		rm /etc/systemd/system/qbittorrent.service
		fi
	fi
	if [[ -f /usr/bin/bittorrent-tracker ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) bittorrent-tracker?" 8 78); then
		systemctl stop tracker
		systemctl disable tracker
		rm -rf /usr/bin/bittorrent-tracker
		rm /etc/systemd/system/tracker.service
		fi
	fi
	if [[ -f /usr/local/bin/aria2c ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) aria2?" 8 78); then
		systemctl stop aria
		systemctl disable aria
		rm -rf /etc/aria.conf
		rm -rf /usr/local/bin/aria2c
		rm /etc/systemd/system/aria2.service
		fi
	fi
	if [[ -f /usr/local/bin/filebrowser ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) filebrowser?" 8 78); then
		systemctl stop filebrowser
		systemctl disable filebrowser
		rm /usr/local/bin/filebrowser
		rm /etc/systemd/system/filebrowser.service
		fi
	fi
	if [[ -f /usr/bin/tor ]]; then
		if (whiptail --title "api" --yesno "卸载 (uninstall) tor?" 8 78); then
		systemctl stop tor
		systemctl disable tor
		systemctl stop tor@default
		apt-get -y remove tor
		rm -rf /etc/apt/sources.list.d/tor.list
		fi
	fi
	if (whiptail --title "api" --yesno "卸载 (uninstall) acme.sh?" 8 78); then
		~/.acme.sh/acme.sh --uninstall
	fi
	cat > '/root/.trojan/config.json' << EOF
{
  "installed": "0"
}
EOF
	cat > '/root/.trojan/license.json' << EOF
{
  "license": "0"
}
EOF
	apt-get update
	systemctl daemon-reload
	colorEcho ${INFO} "卸载完成"
}
#######Auto Update##############
autoupdate(){
	set +e
	if [[ $install_trojan == 1 ]]; then
cat > '/root/.trojan/autoupdate.sh' << EOF
#!/bin/bash
apt-get update
apt-get upgrade -y
trojanversion=\$(curl -fsSL https://api.github.com/repos/trojan-gfw/trojan/releases/latest | grep tag_name | sed -E 's/.*"v(.*)".*/\1/')
/usr/local/bin/trojan -v &> /root/.trojan/trojan_version.txt
if cat /root/.trojan/trojan_version.txt | grep \$trojanversion > /dev/null; then
   	echo "no update required" >> /root/.trojan/update.log
    else
    echo "update required" >> /root/.trojan/update.log
    wget -q https://github.com/trojan-gfw/trojan/releases/download/v\$trojanversion/trojan-\$trojanversion-linux-amd64.tar.xz
    tar -xf trojan-\$trojanversion-linux-amd64.tar.xz
    rm -rf trojan-\$trojanversion-linux-amd64.tar.xz
    cd trojan
    chmod +x trojan
    cp -f trojan /usr/local/bin/trojan
    systemctl restart trojan
    cd
    rm -rf trojan
    echo "Update complete" >> /root/.trojan/update.log
fi
EOF
touch /root/.trojan/update.log
crontab -l | grep -q '0 0 1 * * bash /root/.trojan/autoupdate.sh'  && echo 'cron exists' || echo "0 0 1 * * bash /root/.trojan/autoupdate.sh" | crontab
	fi
}
#########Log Check#########
logcheck(){
	set +e
	readconfig
	clear
	if [[ -f /usr/local/bin/trojan ]]; then
		colorEcho ${INFO} "Trojan Log"
		journalctl -a -u trojan.service
		less /root/.trojan/update.log
	fi
	if [[ -f /usr/sbin/dnscrypt-proxy ]]; then
		colorEcho ${INFO} "dnscrypt-proxy Log"
		journalctl -a -u dnscrypt-proxy.service
	fi
	if [[ -f /usr/local/bin/aria2c ]]; then
		colorEcho ${INFO} "Aria2 Log"
		less /var/log/aria2.log
	fi
	colorEcho ${INFO} "Nginx Log"
	less /var/log/nginx/error.log
	less /var/log/nginx/access.log
}
#####Main menu##########
advancedMenu() {
	Mainmenu=$(whiptail --clear --ok-button "吾意已決 立即安排" --backtitle "Hi!" --title "VPS ToolBox Menu" --menu --nocancel "Welcome to VPS Toolbox main menu,Please Choose an option!" 13 78 5 \
	"Install" "安裝" \
	"Benchmark" "效能"\
	"Log" "日志" \
	"Update" "更新" \
	"Uninstall" "卸載" \
	"Exit" "退出" 3>&1 1>&2 2>&3)
	case $Mainmenu in
		Install)
		clear
		userinput
		systeminfo
		installdependency
		if [[ $install_mariadb == 1 ]]; then
			install_mariadb
		fi
##########Install Trojan-panel#################
if [[ ${install_tjp} == 1 ]]; then
colorEcho ${INFO} "Install Trojan-panel ing"
curl -sL https://deb.nodesource.com/setup_14.x | bash -
apt-get install -q -y nodejs
cd /usr/share/nginx/
git clone https://github.com/trojan-gfw/trojan-panel.git
chown -R nginx:nginx /usr/share/nginx/trojan-panel
cd trojan-panel
composer install
npm install
npm audit fix
cp .env.example .env
php artisan key:generate
sed -i "s/example.com/${domain}/;" /usr/share/nginx/trojan-panel/.env
sed -i "s/DB_PASSWORD=/DB_PASSWORD=${password1}/;" /usr/share/nginx/trojan-panel/.env
clear
colorEcho ${INFO} "Please type yes !"
php artisan migrate --force
chown -R nginx:nginx /usr/share/nginx/trojan-panel
cd
fi
################################################
		nginxtrojan
		start
		sharelink
		rm results
		prasejson
		autoupdate
		apt-get purge dnsutils python-pil python3-qrcode -q -y
		apt-get autoremove -y
		if [[ $install_netdata = 1 ]]; then
		wget -O /opt/netdata/etc/netdata/netdata.conf http://127.0.0.1:19999/netdata.conf
		sed -i 's/# bind to = \*/bind to = 127.0.0.1/g' /opt/netdata/etc/netdata/netdata.conf
		cd /opt/netdata/bin
		bash netdata-claim.sh -token=llFcKa-42N035f4WxUYZ5VhSnKLBYQR9Se6HIrtXysmjkMBHiLCuiHfb9aEJmXk0hy6V_pZyKMEz_QN30o2s7_OsS7sKEhhUTQGfjW0KAG5ahWhbnCvX8b_PW_U-256otbL5CkM -rooms=38e38830-7b2c-4c34-a4c7-54cacbe6dbb9 -url=https://app.netdata.cloud
		cd
		fi
		if [[ $dnsmasq_install -eq 1 ]]; then
			if [[ ${dist} = ubuntu ]]; then
	 			systemctl stop systemd-resolved
	 			systemctl disable systemd-resolved
 			fi
			if [[ $(systemctl is-active dnsmasq) == active ]]; then
				systemctl stop dnsmasq
			fi
		rm /etc/resolv.conf
		touch /etc/resolv.conf
		echo "nameserver 127.0.0.1" > '/etc/resolv.conf'
		systemctl start dnscrypt-proxy
		iptables -t nat -I OUTPUT ! -d 127.0.0.1/32 -p udp -m udp --dport 53 -j DNAT --to 127.0.0.1:53
		ip6tables -t nat -I OUTPUT ! -d ::1 -p udp -m udp --dport 53 -j DNAT --to [::1]:53
		iptables-save > /etc/iptables/rules.v4
		fi
		mv /usr/share/nginx/html/result.html /usr/share/nginx/html/$password1.html
		clear
		cat > '/etc/profile.d/mymotd.sh' << EOF
#!/bin/bash
#!!! Do not change these settings unless you know what you are doing !!!
domain="$( jq -r '.domain' "/root/.trojan/config.json" )"
password1="$( jq -r '.password1' "/root/.trojan/config.json" )"
password2="$( jq -r '.password2' "/root/.trojan/config.json" )"
neofetch
echo -e "-------------------------------IP Information----------------------------"
echo -e "ip:\t\t"\$(jq -r '.ip' "/root/.trojan/ip.json")
echo -e "city:\t\t"\$(jq -r '.city' "/root/.trojan/ip.json")
echo -e "region:\t\t"\$(jq -r '.region' "/root/.trojan/ip.json")
echo -e "country:\t"\$(jq -r '.country' "/root/.trojan/ip.json")
echo -e "loc:\t\t"\$(jq -r '.loc' "/root/.trojan/ip.json")
echo -e "org:\t\t"\$(jq -r '.org' "/root/.trojan/ip.json")
echo -e "postal:\t\t"\$(jq -r '.postal' "/root/.trojan/ip.json")
echo -e "timezone:\t"\$(jq -r '.timezone' "/root/.trojan/ip.json")
if [[ -f /root/.trojan/ipv6.json ]]; then
echo -e "-------------------------------IPv6 Information----------------------------"
echo -e "ip:\t\t"\$(jq -r '.ip' "/root/.trojan/ipv6.json")
echo -e "city:\t\t"\$(jq -r '.city' "/root/.trojan/ipv6.json")
echo -e "region:\t\t"\$(jq -r '.region' "/root/.trojan/ipv6.json")
echo -e "country:\t"\$(jq -r '.country' "/root/.trojan/ipv6.json")
echo -e "loc:\t\t"\$(jq -r '.loc' "/root/.trojan/ipv6.json")
echo -e "org:\t\t"\$(jq -r '.org' "/root/.trojan/ipv6.json")
echo -e "postal:\t\t"\$(jq -r '.postal' "/root/.trojan/ipv6.json")
echo -e "timezone:\t"\$(jq -r '.timezone' "/root/.trojan/ipv6.json")
fi
echo -e "-------------------------------Service Status----------------------------"
  if [[ -f /usr/local/bin/trojan ]]; then
echo -e "Trojan-GFW:\t\t"\$(systemctl is-active trojan)
  fi
  if [[ -f /usr/sbin/nginx ]]; then
echo -e "Nginx:\t\t\t"\$(systemctl is-active nginx)
  fi
  if [[ -f /usr/sbin/dnscrypt-proxy ]]; then
echo -e "Dnscrypt-proxy:\t\t"\$(systemctl is-active dnscrypt-proxy)
  fi
  if [[ -f /usr/bin/qbittorrent-nox ]]; then
echo -e "Qbittorrent:\t\t"\$(systemctl is-active qbittorrent)
  fi
  if [[ -f /usr/bin/bittorrent-tracker ]]; then
echo -e "Bittorrent-tracker:\t"\$(systemctl is-active tracker)
  fi
  if [[ -f /usr/local/bin/aria2c ]]; then
echo -e "Aria2c:\t\t\t"\$(systemctl is-active aria2)
  fi
  if [[ -f /usr/local/bin/filebrowser ]]; then
echo -e "Filebrowser:\t\t"\$(systemctl is-active filebrowser)
  fi
  if [[ -f /opt/netdata/usr/sbin/netdata ]]; then
echo -e "Netdata:\t\t"\$(systemctl is-active netdata)
  fi
  if [[ -f /usr/bin/dockerd ]]; then
echo -e "Docker:\t\t\t"\$(systemctl is-active docker)
  fi
  if [[ -f /usr/sbin/mysqld ]]; then
echo -e "MariaDB:\t\t"\$(systemctl is-active mariadb)
  fi
  if [[ -f /usr/sbin/php-fpm7.4 ]]; then
echo -e "PHP:\t\t\t"\$(systemctl is-active php7.4-fpm)
  fi
  if [[ -f /usr/sbin/dovecot ]]; then
echo -e "Dovecot:\t\t"\$(systemctl is-active dovecot)
  fi
  if [[ -f /usr/sbin/postfix ]]; then
echo -e "Postfix:\t\t"\$(systemctl is-active postfix)
  fi
  if [[ -f /usr/sbin/sshd ]]; then
echo -e "sshd:\t\t\t"\$(systemctl is-active sshd)
  fi
  if [[ -f /usr/bin/fail2ban-server ]]; then
echo -e "Fail2ban:\t\t"\$(systemctl is-active fail2ban)
  fi
  if [[ -f /usr/sbin/ntpd ]]; then
echo -e "ntpd:\t\t\t"\$(systemctl is-active ntp)
  fi
  if [[ -f /usr/bin/tor ]]; then
echo -e "Tor:\t\t"\$(systemctl is-active tor)
  fi
echo -e "-------------------------------Bandwith Usage----------------------------"
echo -e "         Receive    Transmit"
tail -n +3 /proc/net/dev | awk '{print \$1 " " \$2 " " \$10}' | numfmt --to=iec --field=2,3
echo -e "-------------------------------Certificate Status----------------------------"
ssl_date=\$(echo |openssl s_client -connect ${domain}:443 2>&1 |sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'|openssl x509 -text)
tmp_last_date=\$(echo "\${ssl_date}" | grep 'Not After :' | awk -F' : ' '{print \$NF}')
last_date=\$(date -ud "\${tmp_last_date}" +%Y-%m-%d" "%H:%M:%S)
day_count=\$(( (\$(date -d "\${last_date}" +%s) - \$(date +%s))/(24*60*60) ))
echo -e "\e[40;33;1m The [${domain}] expiration date is : \${last_date} && [\${day_count} days] \e[0m"
echo -e "-------------------------------------------------------------------------"
echo "****************************************************************************************************"
echo "*                                   Vps Toolbox Result                                             *"
echo "*                     Please visit the following link to get the result                            *"
echo "*                       https://$domain/$password1.html                                     *"
echo "*                 For more info ,please run the following command                                  *"
echo 'curl -sO https://raw.githubusercontent.com/johnrosen1/vpstoolbox/master/vps.sh && sudo bash vps.sh*'
echo "****************************************************************************************************"
EOF
		chmod +x /etc/profile.d/mymotd.sh
		clear
		if (whiptail --title "Reboot" --yesno "安装成功(success)！ 重启 (reboot) 使配置生效,重新SSH连接后将自动出现结果 (to make the configuration effective)?" 8 78); then
		clear
		reboot
		fi
		;;
		Benchmark)
		clear
		systeminfo
		colorEcho ${INFO} "Hardware Benchmark"
		curl -LO --progress-bar http://cdn.geekbench.com/Geekbench-5.1.0-Linux.tar.gz && tar -xvf Geekbench-5.1.0-Linux.tar.gz && rm -rf Geekbench-5.1.0-Linux.tar.gz && cd Geekbench-5.1.0-Linux
		./geekbench5
		#./geekbench_x86_64
		cd ..
		rm -rf Geekbench-5.1.0-Linux
		colorEcho ${INFO} "Please read the result then hit enter to proceed"
		read var
		colorEcho ${INFO} "Network Benchmark"
		apt-get install gnupg apt-transport-https dirmngr -y -qq
		INSTALL_KEY="379CE192D401AB61"
		DEB_DISTRO=$(lsb_release -sc)
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $INSTALL_KEY
		echo "deb https://ookla.bintray.com/debian ${DEB_DISTRO} main" | sudo tee  /etc/apt/sources.list.d/speedtest.list
		apt-get update -q
		apt-get purge speedtest-cli -y -qq
		apt-get install speedtest -y -qq
		#speedtest
		sh -c 'echo "YES\n" | speedtest'
		colorEcho ${INFO} "Benchmark complete"
		;;
		Log)
		clear
		logcheck
		advancedMenu
		;;
		Update)
		clear
		checkupdate
		colorEcho ${SUCCESS} "Update Success"
		;;
		Uninstall)
		clear
		uninstall
		colorEcho ${SUCCESS} "Remove complete"
		;;
		Exit)
		whiptail --title "Bash Exited" --msgbox "Goodbye!" 8 78
		exit
		;;
		esac
}
clear
cd
osdist
if grep -q "DebianBanner" /etc/ssh/sshd_config
then
:
else
ssh-keygen -A
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/' /etc/ssh/sshd_config
sed -i 's/^HostKey \/etc\/ssh\/ssh_host_\(dsa\|ecdsa\)_key$/\#HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config
#sed -i 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config
sed -i 's/#TCPKeepAlive yes/TCPKeepAlive yes/' /etc/ssh/sshd_config
sed -i 's/#PermitTunnel no/PermitTunnel no/' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/#GatewayPorts no/GatewayPorts no/' /etc/ssh/sshd_config
sed -i 's/#StrictModes yes/StrictModes yes/' /etc/ssh/sshd_config
sed -i 's/#AllowAgentForwarding yes/AllowAgentForwarding no/' /etc/ssh/sshd_config
sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding no/' /etc/ssh/sshd_config
echo "" >> /etc/ssh/sshd_config
echo "Protocol 2" >> /etc/ssh/sshd_config
echo "DebianBanner no" >> /etc/ssh/sshd_config
echo "AllowStreamLocalForwarding no" >> /etc/ssh/sshd_config
systemctl reload sshd
fi
setlanguage
if [[ -f /root/.trojan/license.json ]]; then
	license="$( jq -r '.license' "/root/.trojan/license.json" )"
fi

if [[ $license != 1 ]]; then
	if (whiptail --title "Accept LICENSE?" --yesno "Please read and accept the MIT License！ https://github.com/johnrosen1/vpstoolbox/blob/master/LICENSE" 8 78); then
	cat > '/root/.trojan/license.json' << EOF
{
  "license": "1"
}
EOF
	else
		whiptail --title "Accept LICENSE required" --msgbox "You must read and accept the MIT License to continue !!!" 8 78
		exit 1
	fi
fi
clear
curl -s https://ipinfo.io?token=56c375418c62c9 --connect-timeout 300 > /root/.trojan/ip.json
myip="$( jq -r '.ip' "/root/.trojan/ip.json" )"
localip=$(ip a | grep inet | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
myipv6=$(ip -6 a | grep inet6 | grep "scope global" | awk '{print $2}' | cut -d'/' -f1)
if [[ -n ${myipv6} ]]; then
	curl -s https://ipinfo.io/${myipv6}?token=56c375418c62c9 --connect-timeout 300 > /root/.trojan/ipv6.json
fi
advancedMenu
