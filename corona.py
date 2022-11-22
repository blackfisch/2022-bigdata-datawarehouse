import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv("Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv")
df.drop(["Bundesland_Id","Altersgruppe", "7T_Hospitalisierung_Inzidenz"], axis=1, inplace=True)

print(max(df["7T_Hospitalisierung_Faelle"]))


