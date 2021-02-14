#!/bin/bash
#prueba
# Crypto checker - DONE BY m4riio21 and polespinasa

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
	rm *.txt 2>/dev/null
	tput cnorm; exit 1
}

#Global variables (prices)

function updateValues(){

USD_price=$(curl -s "https://www.xe.com/currencyconverter/convert//?Amount/=1/&From/=EUR/&To/=USD%22%7C" | awk -F 'EUR / USD' '{printf substr($2,14,7);}')

ETH_usd_price=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=ETH-USDT" | tr ':' ' ' | awk -F' ' '{print $6}' | tr -d '"' | tr ',' ' ' | awk '{print $1}')
ETH_eur_price=$(echo "scale=2 ; $ETH_usd_price / $USD_price" | bc)

BTC_usd_price=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=BTC-USDT" | tr ':' ' ' | awk -F' ' '{print $6}' | tr -d '"' | tr ',' ' ' | awk '{print $1}')
BTC_eur_price=$(echo "scale=2 ; $BTC_usd_price / $USD_price" | bc)

XRP_usd_price=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=XRP-USDT" | tr ':' ' ' | awk -F' ' '{print $6}' | tr -d '"' | tr ',' ' ' | awk '{print $1}')
XRP_eur_price=$(echo "scale=5 ; $XRP_usd_price / $USD_price" | bc | awk '{printf "%.5f\n", $0}')

LTC_usd_price=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=LTC-USDT" | tr ':' ' ' | awk -F' ' '{print $6}' | tr -d '"' | tr ',' ' ' | awk '{print $1}')
LTC_eur_price=$(echo "scale=2 ; $LTC_usd_price / $USD_price" | bc)

ADA_usd_price=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=ADA-USDT" | tr ':' ' ' | awk -F' ' '{print $6}' | tr -d '"' | tr ',' ' ' | awk '{print $1}')
ADA_eur_price=$(echo "scale=5 ; $ADA_usd_price / $USD_price" | bc | awk '{printf "%.5f\n", $0}')

DOT_usd_price=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=DOT-USDT" | tr ':' ' ' | awk -F' ' '{print $6}' | tr -d '"' | tr ',' ' ' | awk '{print $1}')
DOT_eur_price=$(echo "scale=2 ; $DOT_usd_price / $USD_price" | bc)

DOGE_usd_price=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=DOGE-USDT" | tr ':' ' ' | awk -F' ' '{print $6}' | tr -d '"' | tr ',' ' ' | awk '{print $1}')
DOGE_eur_price=$(echo "scale=5 ; $DOGE_usd_price / $USD_price" | bc | awk '{printf "%.5f\n", $0}')

}

function historicVales(){

	curl -s "https://finance.yahoo.com/quote/BTC-USD/history/" | html2text | grep -w "Historical Prices" -A 205 | grep "^[A-Z]" | tail -100 | awk -F' ' '{print $6}' | tr -d ',' | xargs | tr ' ' ',' > BTC_history.txt
	curl -s "https://finance.yahoo.com/quote/ETH-USD/history/" | html2text | grep -w "Historical Prices" -A 105 | tail -100 | awk -F' ' '{print $8}' | tr -d ',' | xargs | tr ' ' ',' > ETH_history.txt
	curl -s "https://finance.yahoo.com/quote/LTC-USD/history/" | html2text | grep -w "Historical Prices" -A 105 | tail -100 | awk -F' ' '{print $8}' | tr -d ',' | xargs | tr ' ' ',' > LTC_history.txt
	curl -s "https://finance.yahoo.com/quote/XRP-USD/history/" | html2text | grep -w "Historical Prices" -A 105 | tail -100 | awk -F' ' '{print $8}' | tr -d ',' | xargs | tr ' ' ',' > XRP_history.txt
	curl -s "https://finance.yahoo.com/quote/ADA-USD/history/" | html2text | grep -w "Historical Prices" -A 105 | tail -100 | awk -F' ' '{print $8}' | tr -d ',' | xargs | tr ' ' ',' > ADA_history.txt
	curl -s "https://finance.yahoo.com/quote/DOT1-USD/history/" | html2text | grep -w "Historical Prices" -A 105 | tail -100 | awk -F' ' '{print $8}' | tr -d ',' | xargs | tr ' ' ',' | tr -d '-' | tr -s ',' > DOT_history.txt
	curl -s "https://finance.yahoo.com/quote/DOGE-USD/history/" | html2text | grep -w "Historical Prices" -A 200 | grep "Date" -A 100 | grep -v "Date" | awk -F' ' '{print $7}' | xargs | tr ' ' ',' > DOGE_history.txt
	
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

#chose up or down arrow
function arrow(){
	color="$1"
	if [ "$color" = "$green" ]; then
		echo "▲"
	elif [ "$color" = "$red" ]; then
		echo "▼"
	fi
}

function percentageVariety(){
	new="$1"
	actual="$2"
	positive="$3"
	if [ "$positive" = "$green" ]; then
		result="$(echo "scale=5; 100*$new/$actual-100" | bc)"
		if [ "$result < 1" ]; then
			result=$(echo "+0$result")
		fi
	elif [ "$positive" = "$red" ]; then
		result="$(echo "scale=5; 100-$new*100/$actual" | bc)"
		if [ "$result < 1" ]; then
			result=$(echo "-0$result")
		fi
	else result="0"
	fi
	echo $result
}

function showAll(){
	bucle=0
	
	#INICIALIZACION CRIPTOS PRIMERA VEZ
	BTC_actual=$BTC_usd_price; ETH_actual=$ETH_usd_price; XRP_actual=$XRP_usd_price; LTC_actual=$LTC_usd_price
	ADA_actual=$ADA_usd_price; DOT_actual=$DOT_usd_price
	while [ $bucle -eq 0 ]; do
		updateValues

		hora=$(date +"%x %T")
		clear
		echo -e "${red}----------------cryptoChecker (v1.3)---------------${end}"

		nuevo_aux=`echo "$BTC_usd_price"`
		color_aux=$(price_color $nuevo_aux $BTC_actual)
		arrowForm=$(arrow $color_aux)
		percent_aux=$(percentageVariety $nuevo_aux $BTC_actual $color_aux)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} BTC ${end}${gray}es de ${end}${color_aux}$BTC_eur_price€ / $BTC_usd_price$ $arrowForm ${percent_aux}%${end}"
		BTC_actual=$nuevo_aux

		nuevo_aux=`echo "$ETH_usd_price"`
		color_aux=$(price_color $nuevo_aux $ETH_actual)
		arrowForm=$(arrow $color_aux)
		percent_aux=$(percentageVariety $nuevo_aux $ETH_actual $color_aux)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} ETH ${end}${gray}es de ${end}${color_aux}$ETH_eur_price€ / $ETH_usd_price$ $arrowForm ${percent_aux}%${end}"
		ETH_actual=$nuevo_aux

		nuevo_aux=`echo "$XRP_usd_price"`
		color_aux=$(price_color $nuevo_aux $XRP_actual)
		arrowForm=$(arrow $color_aux)
		percent_aux=$(percentageVariety $nuevo_aux $XRP_actual $color_aux)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} XRP ${end}${gray}es de ${end}${color_aux}$XRP_eur_price€ / $XRP_usd_price$ $arrowForm ${percent_aux}%${end}"
		XRP_actual=$nuevo_aux

		nuevo_aux=`echo "$LTC_usd_price"`
		color_aux=$(price_color $nuevo_aux $LTC_actual)
		arrowForm=$(arrow $color_aux)
		percent_aux=$(percentageVariety $nuevo_aux $LTC_actual $color_aux)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} LTC ${end}${gray}es de ${end}${color_aux}$LTC_eur_price€ / $LTC_usd_price$ $arrowForm ${percent_aux}%${end}"
		LTC_actual=$nuevo_aux

		nuevo_aux=`echo "$ADA_usd_price"`
		color_aux=$(price_color $nuevo_aux $ADA_actual)
		arrowForm=$(arrow $color_aux)
		percent_aux=$(percentageVariety $nuevo_aux $ADA_actual $color_aux)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio de${end}${red} ADA ${end}${gray}es de ${end}${color_aux}$ADA_eur_price€ / $ADA_usd_price$ $arrowForm ${percent_aux}%${end}"
		ADA_actual=$nuevo_aux

		nuevo_aux=`echo "$DOT_usd_price"`
		color_aux=$(price_color $nuevo_aux $DOT_actual)
		arrowForm=$(arrow $color_aux)
		percent_aux=$(percentageVariety $nuevo_aux $DOT_actual $color_aux)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} DOT ${end}${gray}es de ${end}${color_aux}$DOT_eur_price€ / $DOT_usd_price$ $arrowForm ${percent_aux}%${end}"
		DOT_actual=$nuevo_aux

		nuevo_aux=`echo "$DOGE_usd_price"`
		color_aux=$(price_color $nuevo_aux $DOGE_actual)
		arrowForm=$(arrow $color_aux)
		percent_aux=$(percentageVariety $nuevo_aux $DOGE_actual $color_aux)
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} DOGE ${end}${gray}es de ${end}${color_aux}$DOGE_eur_price€ / $DOGE_usd_price$ $arrowForm ${percent_aux}%${end}"
		DOGE_actual=$nuevo_aux


		#CLOCK
		echo -e "\n\t\t${turquoise}._______________________.${end}"
		echo -ne "\t\t${turquoise}|\t\t\t|${end}"
		echo -ne "\n\t\t${turquoise}| Hora de actualizacion |${end}"
		echo -e "\n\t\t${turquoise}|${end}${gray}  $hora${end}${turquoise}\t|${end}"
		echo -e "\t\t${turquoise}|\t\t\t|${end}"
		echo -ne "\t\t${turquoise}·-----------------------·${end}"

		echo -e "\n\n\t${blue} Pulsa ENTER volver al menu..${end}"; 
		read -t 1 -p ""
		[[ $? -ne 0 ]] || mainMenu
    done
}


function showGraph(){
	clear
	echo -e "${red}----------------cryptoChecker (v1.3)---------------${end}"
	echo -e "\n\n\n\t\t ${red} SELECCIONA LA MONEDA PARA VISUALIZAR LA GRAFICA"
	echo -e "\n\t\t ${turquoise} 1.BTC   2.ETH   3.XRP   4.LTC   5. ADA   6. DOT   7.DOGE${end}"
	echo -ne "\n\n${red}Opcion: ${end}${blue}" && read crypto
	clear
	python3 graph.py $crypto
	sleep 4
	echo -e "\n${blue} Pulsa una tecla para continuar..${end}"
	read -s -n 1 key

	mainMenu

}

function printLogo(){
	clear
	tput civis
	echo -e "${red}----------------Bienvenido a cryptoChecker (v1.3)---------------${end}"
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
	updateValues
	clear
	echo -e "${red}----------------cryptoChecker (v1.3)----------------${end}"
	echo -e "\n${blue}Introduce las criptomonedas separadas por un espacio"
	echo -e "${red}----------------------------------------------------\n"
	echo -ne "\t" && read -p "" currs; echo -ne "${end}"
	clear
	echo -e "${red}----------------cryptoChecker (v1.3)----------------${end}"
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
    echo -e "${red}----------------cryptoChecker (v1.3)---------------${end}"
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
	echo -e "${red}----------------cryptoChecker (v1.3)---------------${end}"
	echo -e "\n${red} [!] ERROR! Opción no válida${end}"
	echo -ne "\n${blue} Volviendo al menu"; sleep 0.75; echo -ne "."; sleep 0.75; echo -ne "."; sleep 0.75; echo -ne ".";
	mainMenu
}

function menuRequisitos(){
	clear
	echo -e "${red}----------------cryptoChecker (v1.3)---------------${end}"
	echo -e "\n\n\t${red}ASEGÚRESE QUE ESTA EN MODO ROOT PARA EJECUTAR LA INSTLACION DE REQUISITOS${end}"
	echo -e "\n\t${turquoise} Si esta en modo ${red}ROOT${end}${turquoise} persione:${end}"
	echo -e "\n\t\t${red} 1 -> Continuar con la instalacion${end}"
	echo -e "\n\t\t${red} 2 -> Volver al menu${end}"
	echo -e "\n\t\t${red} 3 -> Salir del script${end}"
	echo -ne "\n\n${red}Opcion: ${end}${blue}" && read opcion
	case $opcion in
		1) instalacionRequisitos;;
		2) mainMenu;;
		3) ctrl_c;;
		*) error;;
	esac	
}

function instalacionRequisitos(){
	clear
	
	if ! [ $(id -u) = 0 ]; then
		echo -e "\n\t\t${red} NO ERES ROOT\n\n Porfavor reinicie el script en modo ROOT \n\nVolviendo al menu de requisitos${end}"; sleep 0.75; echo -ne "${red}.${end}"; sleep 0.75; echo -ne "${red}.${end}"; sleep 0.75; echo -ne "${red}.${end}";
		sleep 0.5
		menuRequisitos
	fi

	if dpkg -l python3 >/dev/null; then
		echo -e "\n\t\t${green}Python3 ya esta instalado en este sistema${end}"; sleep 2
	else
		echo -e "\n\t\t${red}Python3 no esta instalado, se procedera a instalar${end}";sleep 1
		apt-get install python3.6 2>/dev/null
		echo -ne "\t ${green}[V]${end}"
	fi
	if dpkg -l python3-pip > /dev/null; then
		echo -e "\n\t\t${green}Pip ya esta instalado en este sistema${end}"; sleep 1
	else
		echo -e "\n\t\t${red}Pip no esta instalado, se procedera a instalar${end}"; sleep 1
		apt install python3-pip 2>/dev/null
		echo -ne "\t ${green}[V]${end}"
	fi
	if python3 -m pip show plotext > /dev/null; then
		echo -e "\n\t\t${green}Plotext ya esta instalado en este sistema${end}"; sleep 1
	else
		echo -e "\n\t\t${red}Plotext no esta instalado, se procedera a instalar${end}";sleep 1
		python3 -m pip install plotext >/dev/null
		echo -ne "\t ${green}[V]${end}"
	fi
	sleep 3
	clear
	echo -e "\n${green}  Todos los requerimientos han sido instalados correctamente.\n\n ${end}${turquoise} Si hubiera algun error se deben instalar manualmente las siguientes herramientas: ${end}${red}\t\t\t PYHTON3\t PIP\t PLOTEXT${end}"
	echo -e "\n${blue}  Pulsa una tecla para continuar..${end}"
	read -s -n 1 key
	mainMenu

}

#Mains
function mainMenu(){
	clear
	echo -e "${red}----------------cryptoChecker (v1.3)---------------${end}"
	echo -e "\n${blue}Selecciona la opción deseada:${end}"
	echo -e "${red}----------${end}"
	echo -e "\n${blue} 1. Comprobar el precio de una/s criptomoneda/s en concreto${end}"
	echo -e "${blue} 2. Comprobar el precio de todas las criptomonedas soportadas actualmente ${end}"
	echo -e "${blue} 3. Visualizar la grafica de las criptomonedas soportadas actualmente ${end}"
	echo -e "${blue} 4. Instalacion de requisitos ${end}\n"
	echo -e "${red}----------${end}"
	echo -e "\n${blue} 0. Acerca de${end}"
	echo -e "${blue} S. Salir${end}"
	echo -ne "\n\n${red}Opcion: ${end}${blue}" && read opcion
	echo -e "${end}"
	case $opcion in
		0) info;;
		1) inspectCrypto;;
		2) showAll;;
		3) showGraph;;
		4) menuRequisitos;;
		S) ctrl_c;;
		s) ctrl_c;;
		*) error;;  
	esac
}

rm *.txt 2>/dev/null
historicVales
printLogo
