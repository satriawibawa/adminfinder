#!/bin/bash
clear

#color
merah='\e[31m'
ijo='\e[1;32m'
NC='\e[0m'
kuning='\e[1;33m'

#Intro
printf "${kuning} ====================================================="; printf "
|  / __|/ __|_   _| __| /_\ |  \/  | / _ \| _ \/ __|  |
|  \__ \ (__  | | | _| / _ \| |\/| || (_) |   / (_|   |
|  |___/\___| |_| |___/_/ \_\_|  |_(_)___/|_|_\\___|   |"
printf "\n =====================================================\n\n"
printf "${kuning}Coded by Mr.Sm4rt\n"
printf "${NC}Tools Name: Simple Admin finder\n\n"

#Input url
printf "${ijo}=> Insert URL:${NC} "; read Url
printf "${ijo}=> How many thread:${NC} "; read tread
	if [[ $tread = 0 ]]
		then
			printf "${merah}=> thread can't be 0${NC}\n"
			exit
	fi

#Scanning Url
slash=/
nyeken(){
	found=$(curl -s -o /dev/null -w '%{http_code}' ${Url}${slash}${dir} \
		-H "User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:53.0) Gecko/20100101 Firefox/53.0"
		)
	if [[ $found == 200 ]]
		then
			printf "${ijo}==> ${Url}${slash}${dir} ${kuning}=> Found${NC}\n"
			echo ${Url}${slash}${dir} >> Admin-$Url.txt
		else
			printf "${merah}==> ${Url}${slash}${dir} ${kuning}=> Not Found${NC}\n"
	fi
}

#Finding dirlist
getdir(){
	getgit=$(curl -s -o dirlist.txt -w '%{http_code}' https://raw.githubusercontent.com/agusgans/adminfinder/master/dirlist
)
	if [[ $getgit == 200 ]]
		then
			printf "${kuning}=> Dirlist downloaded${NC}\n"
		else
			printf "${merah}=> Failed to Download Dirlist${NC}\n"
			exit
	fi
}
if [[ ! -f dirlist.txt ]]
	then
		printf "${merah}\n=> Dirlist Not Found${NC}\n"
		printf "${ijo}=> Getting Dirlist from Github${NC}\n"
		getdir
	else
		printf "${ijo}\n=> Dirlist Found${NC}\n"
fi

#Make Output
if [[ -f Admin-$Url.txt ]]
	then
		rm Admin-$Url.txt
	fi
printf "${kuning}\n=> Creating Output${NC} \n"
touch Admin-$Url.txt
printf "${ijo}=> Output Created${NC} \n\n"

# FInal step
cekdirlis=$(wc -l dirlist.txt | cut -f1 -d' ')
printf "=> Total $cekdirlis Directory list Found${NC}\n"
sleeptime=5
con=1

for dir in $(cat dirlist.txt)
do
	setanu=$(expr $con % $tread)
	if [[ $setanu == 0 && $con > 0 ]]; then
		sleep $sleeptime
	fi
	nyeken & 
	con=$[$con+1]
done
wait
cekhasil=$(wc -l Admin-$Url.txt | cut -f1 -d' ')
printf "${kuning}\n=> Found $cekhasil directory on $Url${NC}\n"
printf "${ijo}=> Result On Admin-$Url.txt${NC}\n"
