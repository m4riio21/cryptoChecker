#!/bin/bash
#prueba
# Crypto checker - DONE BY m4riio21

#Colours
green="\e[0;32m\033[1m"
end="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
	clear
	echo -e "\n${red}[!] Saliendo...\n${end}"
	tput cnorm; exit 1
}

#Global variables (prices)

function updateValues(){

ETH_eur_price=$(curl -s "https://ethereumprice.org/eth-eur/" | html2text | grep "Current Price" -A 1 | head -2 | tail -1 | tr -d '€')
ETH_usd_price=$(curl -s "https://finance.yahoo.com/quote/ETH-USD/" | html2text | grep "As of" -B 1 | head -1 | awk -F'+' '{print $1}')
ETH_new=$(curl -s "https://ethereumprice.org/eth-eur/" | html2text | grep "Current Price" -A 1 | head -2 | tail -1 | tr -d '€' | tr -d ',')

BTC_eur_price=$(curl -s "https://www.coingecko.com/es/monedas/bitcoin/eur" | html2text | grep "Bitcoin (BTC)" -A 1 | tail -1 | tr 'â¬' ' ' | awk -F' ' '{print $2}' | tr '.' ',')
BTC_usd_price=$(curl -s "https://www.coindesk.com/price/bitcoin" | html2text | grep "24 Hour % Change" -B 1 | head -1 | tr -d '$')
BTC_new=$(curl -s "https://www.coingecko.com/es/monedas/bitcoin/eur" | html2text | grep "Bitcoin (BTC)" -A 1 | tail -1 | tr 'â¬' ' ' | awk -F' ' '{print $2}' | tr '.' ',' | tr -d ',')

XRP_usd_price=$(curl -s "https://www.coindesk.com/price/xrp" | html2text | grep -w "Price" -A 1 | tail -1 | tr -d '$')
XRP_eur_price=$(curl -s "https://www.coingecko.com/es/monedas/xrp/eur" | html2text | grep "XRP (XRP)" -A 1 | tail -1 | tr '¬' ' ' | awk -F' ' '{print $3}' | tr ',' '.')
XRP_new=$(curl -s "https://www.coingecko.com/es/monedas/xrp/eur" | html2text | grep "XRP (XRP)" -A 1 | tail -1 | tr '¬' ' ' | awk -F' ' '{print $3}' | tr ',' '.')


LTC_usd_price=$(curl -s "https://www.coindesk.com/price/litecoin" | html2text | grep -w "Price" -A 1 | tail -1 | tr -d '$')
LTC_eur_price=$(curl -s "https://www.coingecko.com/es/monedas/litecoin/eur" | html2text | grep "Litecoin (LTC)" -A 1 | tail -1 | tr '¬' ' ' | awk -F' ' '{print $3}' | tr ',' '.')
LTC_new=$(curl -s "https://www.coingecko.com/es/monedas/litecoin/eur" | html2text | grep "Litecoin (LTC)" -A 1 | tail -1 | tr '¬' ' ' | awk -F' ' '{print $3}' | tr ',' '.')
}

#check values to select price color
function price_color(){
	new="$1"
	actual="$2"
	if [ -z $new ] || [ -z $actual ]; then echo "$gray"
	else
		if [ `echo "$new < $actual" | bc` -eq "1" ]; then
				echo "$red"
		elif [ `echo "$new > $actual" | bc` -eq "1" ]; then
			echo "$green"
		else echo "$gray"
		fi
	fi
}

function showAll(){
	bucle=0
	
	#INICIALIZACION CRIPTOS PRIMERA VEZ
	BTC_actual=$BTC_new; ETH_actual=$ETH_new; XRP_actual=$XRP_new; LTC_actual=$LTC_new

	while [ $bucle -eq 0 ]; do
		updateValues

		hora=$(date +"%x %T")
		clear
		echo -e "${red}----------------cryptoChecker (v1.2)---------------${end}"

		nuevo_aux=`echo "$BTC_new"`
		color_aux=$(price_color $nuevo_aux $BTC_actual)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} BTC ${end}${gray}es de ${end}${color_aux}$BTC_eur_price€ / $BTC_usd_price$ ${end}"
		BTC_actual=$nuevo_aux

		nuevo_aux=`echo "$ETH_new"`
		color_aux=$(price_color $nuevo_aux $ETH_actual)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} ETH ${end}${gray}es de ${end}${color_aux}$nuevo_aux€ / $ETH_usd_price$ ${end}"
		ETH_actual=$nuevo_aux

		nuevo_aux=`echo "$XRP_new"`
		color_aux=$(price_color $nuevo_aux $XRP_actual)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} XRP ${end}${gray}es de ${end}${color_aux}$XRP_eur_price€ / $XRP_usd_price$ ${end}"
		XRP_actual=$new

		nuevo_axu=`echo "$LTC_new"`
		color_aux=$(price_color $nuevo_axu $LTC_actual)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} LTC ${end}${gray}es de ${end}${color_aux}$LTC_eur_price€ / $LTC_usd_price$ ${end}"
		LTC_actual=$new


		#CLOCK
		echo -e "\n\t\t${turquoise}._______________________.${end}"
		echo -ne "\t\t${turquoise}|\t\t\t|${end}"
		echo -ne "\n\t\t${turquoise}| Hora de actualizacion |${end}"
		echo -e "\n\t\t${turquoise}|${end}${gray}  $hora${end}${turquoise}\t|${end}"
		echo -e "\t\t${turquoise}|\t\t\t|${end}"
		echo -ne "\t\t${turquoise}·-----------------------·${end}"
		
		

    done
}

function printLogo(){
	clear
	tput civis
	echo -e "${red}----------------Bienvenido a cryptoChecker (v1.2)---------------${end}"
	echo -e "${red}                       _         _____ _               _             ${end}"
	sleep 0.18
	echo -e "${red}                      | |       / ____| |             | |            ${end}"
	sleep 0.18
	echo -e "${red}  ___ _ __ _   _ _ __ | |_ ___ | |    | |__   ___  ___| | _____ _ __ ${end}"
	sleep 0.18
	echo -e "${red} / __| '__| | | | '_ \| __/ _ \| |    | '_ \ / _ \/ __| |/ / _ \ '__|${end}"
	sleep 0.18
	echo -e "${red}| (__| |  | |_| | |_) | || (_) | |____| | | |  __/ (__|   <  __/ |   ${end}"
	sleep 0.18
	echo -e "${red} \___|_|   \__, | .__/ \__\___/ \_____|_| |_|\___|\___|_|\_\___|_|   ${end}"
	sleep 0.18
	echo -e "${red}            __/ | |                                                  ${end}"
	sleep 0.18
	echo -e "${red}           |___/|_|                                                  ${end}"
	sleep 0.25
	echo -e "\n\t\t${blue}Programado por m4riio21 y polespinasa${end}"
	sleep 0.5
	echo -e "\n${blue} Pulsa una tecla para continuar..${end}"
	read -s -n 1 key
	mainMenu
}

function inspectCrypto(){
	clear
	echo -e "${red}----------------cryptoChecker (v1.2)----------------${end}"
	echo -e "\n${blue}Introduce las criptomonedas separadas por un espacio"
	echo -e "${red}----------------------------------------------------\n"
	echo -ne "\t" && read -p "" currs; echo -ne "${end}"
	clear
	echo -e "${red}----------------cryptoChecker (v1.2)----------------${end}"
	for cur in $currs; do
    	echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} $cur ${end}${gray}es de ${end}${green}$(eval echo \$$cur'_eur_price')€ / $(eval echo \$$cur'_usd_price')$ ${end}"
	done

	sleep 0.5
    echo -e "\n${blue} Pulsa una tecla para continuar..${end}"
    tput civis
    read -s -n 1 key
    mainMenu
}

function info(){
	clear
    echo -e "${red}----------------cryptoChecker (v1.2)---------------${end}"
	echo -e "\n https://github.com/m4riio21/cryptoChecker"
	echo -e "\n${red} [*] Hecho por${end} m4riio21${red} & ${end}polespinasa"
	sleep 0.5
    echo -e "\n${blue} Pulsa una tecla para continuar..${end}"
    tput civis
    read -s -n 1 key
    mainMenu
}

function clock(){
	echo -e "\n\t${yellow}Hora de actualizacion${end}"
	while sleep 1;do
		tput cup 15 $(($(tput cols)-179))
		date +"%x %T"
	done &
}

function error(){
	clear
	tput civis
	echo -e "${red}----------------cryptoChecker (v1.2)---------------${end}"
	echo -e "\n${red} [!] ERROR! Opción no válida${end}"
	echo -ne "\n${blue} Volviendo al menu"; sleep 0.75; echo -ne "."; sleep 0.75; echo -ne "."; sleep 0.75; echo -ne ".";
	mainMenu
}

function mainMenu(){
	clear
	echo -e "${red}----------------cryptoChecker (v1.2)---------------${end}"
	echo -e "\n${blue}Selecciona la opción deseada:${end}"
	echo -e "${red}----------${end}"
	echo -e "\n${blue} 1. Comprobar el precio de una/s criptomoneda/s en concreto${end}"
	echo -e "${blue} 2. Comprobar el precio de todas las criptomonedas soportadas actualmente ${end}\n"
	echo -e "${red}----------${end}"
	echo -e "\n${blue} 0. Acerca de${end}"
	echo -e "${blue} S. Salir${end}"
	echo -ne "\n\n${red}Opcion: ${end}${blue}" && read opcion
	echo -e "${end}"
	case $opcion in
		0) info;;
		1) inspectCrypto;;
		2) showAll;;
		S) ctrl_c;;
		s) ctrl_c;;
		*) error;;
	esac
}

printLogo
