#!/bin/bash

NC='\033[0m'
RED='\033[1;38;5;196m'
GREEN='\033[1;38;5;040m'
ORANGE='\033[1;38;5;202m'
BLUE='\033[1;38;5;012m'
BLUE2='\033[1;38;5;032m'
PINK='\033[1;38;5;013m'
GRAY='\033[1;38;5;004m'
NEW='\033[1;38;5;154m'
YELLOW='\033[1;38;5;214m'
CG='\033[1;38;5;087m'
CP='\033[1;38;5;221m'
CPO='\033[1;38;5;205m'
CN='\033[1;38;5;247m'
CNC='\033[1;38;5;051m'



echo ""
echo ""
echo ""
echo "██████╗     ██╗ █████╗  ██████╗██╗  ██╗"
echo "██╔════╝     ██║██╔══██╗██╔════╝██║ ██╔╝"
echo "██║          ██║███████║██║     █████╔╝ "
echo "██║     ██   ██║██╔══██║██║     ██╔═██╗ "
echo "╚██████╗╚█████╔╝██║  ██║╚██████╗██║  ██╗"
echo "╚═════╝ ╚════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
echo "                            Build with ♥"


if [[ -e tmp.txt || -e vuln.txt || -e safe.txt ]];
then 
    if [ -e tmp.txt ]
    then rm tmp.txt
    fi
    if [ -e vuln.txt ]
    then rm vuln.txt
    fi
    if [ -e safe.txt ]
    then rm safe.txt
    fi
fi 


echo "1. Single URL"
echo "2. Multiple URLs"
echo "3. POC Generator"
echo ""
read -p "Please select option: " option

function clickjacking(){
    check=$(curl -s -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --connect-timeout 5 --head -k $1)
    echo $check >> tmp.txt
    match=$(cat tmp.txt | egrep -w 'X-Frame-Options|Content-Security-Policy|x-frame-options|content-security-policy:')
    
    if [[ $match == '' ]];
    then  
        echo -e -n ${BLUE2}"\n[ ✔ ] ${CG}$1 ${RED}VULNERABLE \n"
        echo "$1" >> vuln.txt
    else
        echo -e -n ${BLUE2}"\n[ ✔ ] ${CG}$1 ${GREEN}NOT_VULNERABLE \n"
        echo "$1" >> safe.txt
    fi
}


function single_click(){
    check=$(curl -s -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --connect-timeout 5 --head -k $1)
    echo $check >> tmp.txt
    match=$(cat tmp.txt | egrep -w -i 'X-Frame-Options|Content-Security-Policy|x-frame-options|content-security-policy:')
    
    if [[ $match == '' ]];
    then  
        echo -e -n ${BLUE2}"\n[ ✔ ] ${CG}$1 ${RED}VULNERABLE \n"
    else
        echo -e -n ${BLUE2}"\n[ ✔ ] ${CG}$1 ${GREEN}NOT_VULNERABLE \n"
    fi
}

if [ $option == 1 ]; then 
	read -p "Please URL here: " url
	single_click $url
fi

if [ $option == 2 ]; then 
   read -p "Enter file name: " list
   if [ -e $list ];then
      domain_list="$list"
   else echo "file does not Exist: "
   exit
   fi 
   while IFS= read -r url; do
   clickjacking "$url"
   sleep 1
   done < "$domain_list"
   count=$(cat safe.txt | wc -l)
   scount=$(cat vuln.txt | wc -l)
   echo -e -n "\n$GREEN Safe URLs are saved in: safe.txt || count $count"
   echo -e -n "\n$RED Vulnerable URLs are saved in: vuln.txt || count $scount "
fi 


if [ -e tmp.txt ];
then rm tmp.txt
fi
