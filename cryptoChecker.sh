#!/bin/bash

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

#Global variables (prices)
ETH_eur_price=$(curl -s "https://ethereumprice.org/eth-eur/" | html2text | grep "Current Price" -A 1 | head -2 | tail -1)
ETH_usd_price=$(curl -s "https://finance.yahoo.com/quote/ETH-USD/" | html2text | grep "As of" -B 1 | head -1 | awk -F'+' '{print $1}')
BTC_eur_price=$(curl -s "https://www.coingecko.com/es/monedas/bitcoin/eur" | html2text | grep "Bitcoin (BTC)" -A 1 | tail -1 | tr 'â¬' ' ' | awk -F' ' '{print $2}' | tr '.' ',')
BTC_usd_price=$(curl -s "https://www.coindesk.com/price/bitcoin" | html2text | grep "24 Hour % Change" -B 1 | head -1 | tr -d '$')
XRP_usd_price=$(curl -s "https://www.coindesk.com/price/xrp" | html2text | grep -w "Price" -A 1 | tail -1 | tr -d '$')
XRP_eur_price=$(curl -s "https://www.coingecko.com/es/monedas/xrp/eur" | html2text | grep "XRP (XRP)" -A 1 | tail -1 | tr '¬' ' ' | awk -F' ' '{print $3}' | tr ',' '.')
LTC_usd_price=$(curl -s "https://www.coindesk.com/price/litecoin" | html2text | grep -w "Price" -A 1 | tail -1 | tr -d '$')
LTC_eur_price=$(curl -s "https://www.coingecko.com/es/monedas/litecoin/eur" | html2text | grep "Litecoin (LTC)" -A 1 | tail -1 | tr '¬' ' ' | awk -F' ' '{print $3}' | tr ',' '.')

function showAll(){

echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} BTC ${end}${gray}es de ${end}${green}$BTC_eur_price€ / $BTC_usd_price$ ${end}"
echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} ETH ${end}${gray}es de ${end}${green}$ETH_eur_price€ / $ETH_usd_price$ ${end}"
echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} XRP ${end}${gray}es de ${end}${green}$XRP_eur_price€ / $XRP_usd_price$ ${end}"
echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} LTC ${end}${gray}es de ${end}${green}$LTC_eur_price€ / $LTC_usd_price$ ${end}"
}

function helpPanel(){
	echo -e "\n${red} Crypto checker v1.1 - DONE BY m4riio21${end}"
	echo -e "${red}-------------------------------------${end}"
	echo -e "\n\t${yellow}[-c]${end}${gray} Inspeccionar el precio de una criptomoneda en concreto${end}"
	echo -e "\n\t\t${blue}Ejemplo: ./cryptoChecker.sh -c BTC -c ETH${end}"
	echo -e "\n\t${yellow}[-a]${end}${gray} Visualizar el precio de todas las criptomonedas soportadas${end}${red} (BTC, ETH, LTC, XRP)${end}"
	echo -e "\n\t\t${blue}Especificar el parametro ALL --> ./cryptoChecker.sh -a ALL${end}"
}
#Main

declare -i parameter_counter=0;while getopts ":c:a:" opt; do
    case $opt in
        c) currs+=("$OPTARG"); parameter_counter=2;;
        a) parameter_counter=1;;
        h) helpPanel;;
    esac
done
shift $((OPTIND -1))

if [ $parameter_counter -eq 2 ]; then
	for cur in "${currs[@]}"; do
		echo -e "\n\t${yellow}[*] ${end}${gray}El precio del${end}${red} $cur ${end}${gray}es de ${end}${green}$(eval echo \$$cur'_eur_price')€ / $(eval echo \$$cur'_usd_price')$ ${end}"
	done
elif [ $parameter_counter -eq 1 ]; then
	showAll
else
	helpPanel
fi

