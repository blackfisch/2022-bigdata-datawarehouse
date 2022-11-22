import matplotlib.pyplot as plt
import numpy as np
import csv

x = []
y = []

with open('Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv', 'r') as file:
    column = csv.reader(file, delimiter=',')
    
    for column in file:
        x = column[3]
        y = column[4]

plt.plot(x,y, color = 'g', linestyle = 'dashed', marker = 'o')
plt.xticks(rotation = 25)
plt.xlabel('Altersgruppe')
plt.ylabel('7 Tage Hospitalisierungsfaelle')
plt.title('Hospitalisierungsfaelle pro Altersgruppe')
plt.grid()
plt.legend()
plt.show()


