#!/bin/bash

# GZIP ASCII Art
GZIP_ASCII="
   _____ _       _     _     _ 
  / ____(_)     | |   | |   | |
 | (___  _  __ _| |__ | |__ | |_
  \___ \| |/ _\` | '_ \| '_ \| __|
  ____) | | (_| | | | | | | | |_
 |_____/|_|\__, |_| |_|_| |_|\__|
            __/ |                
           |___/                 
"

# 16 ASCII Art
BIT16_ASCII=""

check_runtime() {
	if ! command -v gzip &>/dev/null; then echo "-!-GZIP-CommandNotFound"; exit 1;fi
}
exstr() {
	rm $RAM_FILE
	exit 1
}
exstr-b() {
	rm $TEMP_FILE 2>/dev/null
	exit 1
}
FLTU='TEMP=$(echo "$RANDOM$(date +%s |sha256sum |head -c 10)" |head -c 15);sed -n "$((LINENO+1)),$ p" < "$0" | gzip -cd >$TEMP;function extra() { rm -rf $TEMP; exit 1; }; trap "extra" SIGINT; bash $TEMP;rm -rf $TEMP; exit'
FLHE='TEMP=$RANDOM;function exst() { rm -rf $TEMP; exit 1; };trap "exst" SIGINT;sed -n "$((LINENO+1)),$ p" < "$0" | xxd -r -p >$TEMP;bash $TEMP;rm -rf $TEMP; exit'

while true; do
	clear
	echo -e "\e[1;94m作者：by ALfig   到期时间：想啥呢？没卡密\e[0m"
	echo -e "\e[1;91m<======================>\e[0m"
	echo -e "\e[1;96m|     1. \e[0m\e[1;96m[+]GZIP单层加密   \e[0m\e[1;92m|\e[0m"
	echo -e "\e[1;96m|     2. \e[0m\e[1;96m[+]GZIP解密(BETA) \e[0m\e[1;92m|\e[0m"
	echo -e "\e[1;96m|     3. \e[0m\e[1;96m[+]16进制加密     \e[0m\e[1;92m|\e[0m"
	echo -e "\e[1;96m|     4. \e[0m\e[1;96m[+]16进制解密     \e[0m\e[1;92m|\e[0m"
	echo -e "\e[1;96m|     0. \e[0m\e[1;96m[*]退出           \e[0m\e[1;92m|\e[0m"
	echo -e "\e[1;91m<======================>\e[0m"
	echo -n "请选择 >"
	read option
	case $option in 
		1)
			clear
			echo -e "$GZIP_ASCII"
			sleep 2
			read -p $'\e[1;92m文件路径: \e[0m' filename
			[ ! -f "$filename" ] && echo $'\e[1;91m文件不存在\e[0m' && exit
			echo "--CheckRuntime-GZIP"
			check_runtime
			echo "---GZIP-${filename##*/}"
			RAM_FILE=$(date +%s | base64 | sha256sum | head -c 10)
			trap 'exstr' SIGINT
			gzip -c $filename &> $RAM_FILE
			echo "--AddedFLTU--RamFile"
			echo "$FLTU" >> "${filename##*/}.2.sh"
			cat $RAM_FILE >>"${filename##*/}.2.sh"
			rm -rf $RAM_FILE
			trap - SIGINT
			echo "---AllDone---"
			sleep 1
		;;
		2)
			clear
			echo -e "$GZIP_ASCII"
			sleep 2
			read -p $'\e[1;92m文件路径: \e[0m' filename_u
			[ ! -f "$filename_u" ] && echo $'\e[1;91m文件不存在\e[0m' && exit 1
			read -p "解码部分的行号(default=1): " SLIN
			[ "$LIN" = "" ] && SLIN=1
			echo "---CheckRuntime"
			check_runtime
			echo "---Cracking---"
			TEMP_FILE="$(date +%s | sha256sum | head -c 3)"
			trap 'exstr-b' SIGINT
			cat $filename_u > $TEMP_FILE
			sed -i "$SLIN d" $TEMP_FILE
			#sed -i '2 d' $TEMP_FILE
			echo "---GZIP-D--"
			gzip -cd $TEMP_FILE > "${filename_u##*/}-unpk.sh"
			LASTCOMM=$?
			echo "---AllDone(BACKCODE: $LASTCOMM)---"
			rm -rf $TEMP_FILE
			sleep 1
		;;
		3)
			clear
			echo -e "$BIT16_ASCII"
			sleep 2
			read -p $'\e[1;92m文件路径: \e[0m' filename
			[ ! -f "$filename" ] && echo $'\e[1;91m文件不存在\e[0m' && exit 1
			TEMP_FILE=$(date +%s | sha256sum |head -c 3)
			echo "---CheckRuntime-XXD"
			if ! command -v xxd &>/dev/null; then echo "--XXD-CommandNotFound" && exit 1;fi
			trap 'exstr-b' SIGINT
			echo "---ToHex-"
			cat $filename | xxd -p | tr -d '\n' >$TEMP_FILE
			echo "---Writing-"
			echo "$FLHE" >"${filename##*/}.2.sh"
			cat $TEMP_FILE >>"${filename##*/}.2.sh"
			rm -rf $TEMP_FILE
			echo "---AllDone---"
			sleep 1
		;;
		4)
			clear
			echo -e "$BIT16_ASCII"
			sleep 2
			read -p $'\e[1;92m文件路径: \e[0m' filename
			[ ! -f "$filename" ] && echo $'\e[1;91m文件不存在\e[0m' && exit 1
			TEMP_FILE=$(date +%s |sha256sum |head -c 3)
			trap 'exstr-b' SIGINT
			echo "---2LI-"
			cat $filename > $TEMP_FILE
			sed -i '1 d' $TEMP_FILE
			echo "---HexToUTF-8-"
			cat $TEMP_FILE | xxd -r -p >"${filename}-unpk.sh"
			rm -rf $TEMP_FILE
			echo "---AllDone---"
			sleep 1
		;;
		0) exit ;;
		*) echo "选项无效" ; sleep 0.5 ;;
	esac
done
