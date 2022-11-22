'''main function file for analysis of COVID-19 data from Germany'''

import definitions
import pandas as pd
# import numpy as np
import matplotlib.pyplot as plt
# import matplotlib as mpl


def main():
    '''main function calling the other functions'''

    max_hospitalized()


def max_hospitalized():
    '''min-max analysis and visualization of hospitalization data'''

    df_hospitalisierung = pd.read_csv(definitions.FILE_HOSPITALISIERUNG)

    df_cumulated = df_hospitalisierung[df_hospitalisierung['Altersgruppe'] == '00+']
    # df.drop(["Bundesland_Id", "Altersgruppe",
    #         "7T_Hospitalisierung_Inzidenz"], axis=1, inplace=True)

    print(df_cumulated['7T_Hospitalisierung_Faelle'].max())

    df_bund = df_cumulated[df_cumulated['Bundesland'] == 'Bundesgebiet']

    dates = df_bund['Datum']
    cases = df_bund['7T_Hospitalisierung_Faelle']

    _, axes = plt.subplots()
    axes.plot(dates, cases)
    axes.set_xlabel('Datum')
    axes.set_ylabel('Hospitalisierungen (7 Tage)')
    axes.set_title('Hospitalisierungen (7 Tage) in Deutschland')

    # ax.xaxis.axis_date()
    axes.tick_params(axis='x', rotation=45)

    nth = 50  # Keeps every n-th label
    _ = [l.set_visible(False) for (i, l) in enumerate(
        axes.xaxis.get_ticklabels()) if i % nth != 0]

    # cdf = mpl.dates.ConciseDateFormatter(ax.xaxis.get_major_locator())
    # ax.xaxis.set_major_formatter(cdf)

    plt.show()


if __name__ == "__main__":
    main()
