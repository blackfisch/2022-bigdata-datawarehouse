import DEF

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

df = pd.read_csv(DEF.FILE_HOSPITALISIERUNG)

df_cumulated = df[df['Altersgruppe'] == '00+']
# df.drop(["Bundesland_Id", "Altersgruppe",
#         "7T_Hospitalisierung_Inzidenz"], axis=1, inplace=True)

print(df_cumulated['7T_Hospitalisierung_Faelle'].max())


df_bund = df_cumulated[df_cumulated['Bundesland'] == 'Bundesgebiet']

dates = df_bund['Datum']
cases = df_bund['7T_Hospitalisierung_Faelle']

fix, ax = plt.subplots()
ax.plot(dates, cases)
ax.set_xlabel('Datum')
ax.set_ylabel('Hospitalisierungen (7 Tage)')
ax.set_title('Hospitalisierungen (7 Tage) in Deutschland')

# ax.xaxis.axis_date()
ax.tick_params(axis='x', rotation=45)

n = 50  # Keeps every 7th label
[l.set_visible(False) for (i, l) in enumerate(
    ax.xaxis.get_ticklabels()) if i % n != 0]

# cdf = mpl.dates.ConciseDateFormatter(ax.xaxis.get_major_locator())
# ax.xaxis.set_major_formatter(cdf)

plt.show()
