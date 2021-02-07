import plotext as plt


#Apertura de fitxero y ordenacion de valores separados por coma
file=open("BTC_history.txt", 'rt')
archivo=file.read()
valores=archivo.split(',')

#Adaptar formato de lista al formato de plotext
lista=[ float(x) for x in valores ]

#Generacion de la grafica plotext
plt.plot(lista)
plt.legend(["lines", "point"])
plt.plot(lista, line_marker=0, line_color="white")
plt.canvas_color("none")
plt.axes_color("none")
plt.ticks_color("white")
plt.show()
