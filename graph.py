import plotext as plt
import argparse as ar

argumento = ar.ArgumentParser()
argumento.add_argument("moneda", help="introduce el valor assignado a cada moneda", type = str)

arg_final=argumento.parse_args()


#Apertura de fitxero y ordenacion de valores separados por coma
def openFile(crypto):

	file = open("{}".format(crypto)+"_history.txt", 'rt')

	archivo=file.read()
	valores=archivo.split(',')
	lista_aux=[]
	#Adaptar formato de lista al formato de plotext
	lista=[ float(x) for x in valores ]
	for i in range(len(lista)):
		lista_aux.append(lista[len(lista)-i-1])
	return lista_aux

def graficGeneration(lista, cryptoCompleta, crypto):
	#Generacion de la grafica plotext
	plt.plot(lista)
	plt.legend(["lines", "point"])
	plt.plot(lista, line_marker=0, line_color="white")
	plt.canvas_color("none")
	plt.axes_color("none")
	plt.ticks_color("white")
	plt.title("GRAFICA PRECIO " + cryptoCompleta + " - ULTIMOS 100 DIAS - " + crypto +"/USD")
	plt.show()

def cryptoSelect(moneda):
	switch = {
		1: "BTC",
		2: "ETH",
		3: "XRP",
		4: "LTC",
		5: "ADA",
		6: "DOT",
		7: "DOGE"
	}	

	return switch.get(moneda)

def getNomComplet(moneda):
	switch = {
		"ETH": "ETHEREUM",
		"BTC": "BITCOIN",
		"LTC": "LITLECOIN",
		"XRP": "RIPPLE",
		"ADA": "CARDANO",
		"DOT": "POLKADOT",
		"DOGE": "DOGECOIN"
	}

	return switch.get(moneda)


crypto=cryptoSelect(int(arg_final.moneda))

datos=openFile(crypto)

cryptoCompleta=getNomComplet(crypto)
graficGeneration(datos, cryptoCompleta, crypto)
