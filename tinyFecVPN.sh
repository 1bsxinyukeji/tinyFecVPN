#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
none='\e[0m'

[[ $(id -u) != 0 ]] && echo -e " \n哎呀……请使用 ${red}root ${none}用户运行 ${yellow}~(^_^) ${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

# 笨笨的检测方法
if [[ -f /usr/bin/apt-get ]] || [[ -f /usr/bin/yum ]]; then

	if [[ -f /usr/bin/yum ]]; then

		cmd="yum"

	fi

else

	echo -e " \n哈哈……这个 ${red}辣鸡脚本${none} 不支持你的系统。 ${yellow}(-_-) ${none}\n" && exit 1

fi

if [[ $sys_bit == "i386" || $sys_bit == "i686" ]]; then
	tinyvpn="tinyvpn_x86"
elif [[ $sys_bit == "x86_64" ]]; then
	tinyvpn="tinyvpn_amd64"
else
	echo -e " \n$red毛支持你的系统....$none\n" && exit 1
fi

install() {
	$cmd install wget -y
	ver=$(curl -s https://api.github.com/repos/wangyu-/tinyFecVPN/releases/latest | grep 'tag_name' | cut -d\" -f4)
	tinyFecVPN_download_link="https://github.com/wangyu-/tinyFecVPN/releases/download/$ver/tinyvpn_binaries.tar.gz"
	mkdir -p /tmp/tinyFecVPN
	if ! wget --no-check-certificate --no-cache -O "/tmp/tinyFecVPN.tar.gz" $tinyFecVPN_download_link; then
		echo -e "$red 下载 tinyFecVPN 失败！$none" && exit 1
	fi
	tar zxf /tmp/tinyFecVPN.tar.gz -C /tmp/tinyFecVPN
	cp -f /tmp/tinyFecVPN/$tinyvpn /usr/local/bin/tinyvpn
	chmod +x /usr/local/bin/tinyvpn
	if [[ -f /usr/local/bin/tinyvpn ]]; then
		clear
		echo -e " 
		$green tinyFecVPN 安装完成...$none

		输入$yellow tinyvpn $none即可使用....

		备注...这个脚本仅负责安装和卸载...
		
		如何配置...后台运行...开鸡启动这些东西嘛...

		大胸弟....你自己解决咯...

		脚本问题反馈: https://github.com/233boy/tinyFecVPN/issues
		
		tinyFecVPN 帮助或反馈: https://github.com/wangyu-/tinyFecVPN
		"
	else
		echo -e " \n$red安装失败...$none\n"
	fi
	rm -rf /tmp/tinyFecVPN
	rm -rf /tmp/tinyFecVPN.tar.gz
}
unistall() {
	if [[ -f /usr/local/bin/tinyvpn ]]; then
		tinyFecVPN_pid=$(pgrep "tinyvpn")
		[ $tinyFecVPN_pid ] && kill -9 $tinyFecVPN_pid >/dev/null 2>&1
		rm -rf /usr/local/bin/tinyvpn
		echo -e " \n$green卸载完成...$none\n" && exit 1
	else
		echo -e " \n$red大胸弟...你貌似毛有安装 tinyFecVPN ....卸载个鸡鸡哦...$none\n" && exit 1
	fi
}
error() {

	echo -e "\n$red 输入错误！$none\n"

}
while :; do
	echo
	echo "........... tinyFecVPN 快速一键安装 by 233blog.com .........."
	echo
	echo "帮助说明: 等有空再水一篇文章...."
	echo
	echo " 1. 安装"
	echo
	echo " 2. 卸载"
	echo
	read -p "请选择[1-2]:" choose
	case $choose in
	1)
		install
		break
		;;
	2)
		unistall
		break
		;;
	*)
		error
		;;
	esac
done
