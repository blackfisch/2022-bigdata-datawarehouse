'''main function file for analysis of COVID-19 data from Germany'''

import definitions
import pandas as pd
import matplotlib.pyplot as plt


def max_hospitalized():
    '''min-max analysis and visualization of hospitalization data'''

    hosp_data = hosp_df[hosp_df['Altersgruppe'] == '00+']
    hosp_data['Datum'] = pd.to_datetime(hosp_data['Datum'])
    hosp_data.index = hosp_data['Datum']

    print("Min: ", hosp_data['7T_Hospitalisierung_Faelle'].min())
    print("Max: ", hosp_data['7T_Hospitalisierung_Faelle'].max())

    df_bund = hosp_data[hosp_data['Bundesland'] == 'Bundesgebiet']

    dates = df_bund['Datum']
    cases = df_bund['7T_Hospitalisierung_Faelle']

    _, axes = plt.subplots()
    axes.plot(dates, cases, label='Hospitalisierungen (7 Tage)')
    axes.set_xlabel('Datum')
    axes.set_ylabel('Hospitalisierungen (7 Tage)')
    axes.set_title('Hospitalisierungen (7 Tage) in Deutschland')
    axes.tick_params(axis='x', labelrotation=45)

    # Inzidenz
    _, axes = plt.subplots()
    inzidenz_data = inzidenz_df[inzidenz_df['Altersgruppe'] == '00+']
    inzidenz_data['Meldedatum'] = pd.to_datetime(inzidenz_data['Meldedatum'])
    inzidenz_data.index = inzidenz_data['Meldedatum']

    dates = inzidenz_data['Meldedatum']
    inzidenz = inzidenz_data['Inzidenz_7-Tage']
    axes.plot(dates, inzidenz, label='Inzidenz (7 Tage)')
    axes.set_ylabel('Inzidenz (7 Tage)')
    axes.set_title('Inzidenz (7 Tage) in Deutschland')
    axes.tick_params(axis='x', labelrotation=45)


def correlation_matrix():
    '''correlation matrix for all data'''
    impf_data = impf_df[['Impfdatum', 'Anzahl']]
    impf_data = impf_data.groupby('Impfdatum').sum()
    print('IMPF', impf_data.head())

    hosp_data = hosp_df[['Datum', 'Altersgruppe', '7T_Hospitalisierung_Faelle',
                         '7T_Hospitalisierung_Inzidenz', 'Bundesland_Id']]

    hosp_data = hosp_data[hosp_data['Altersgruppe'] == '00+']
    hosp_data = hosp_data[hosp_data['Bundesland_Id'] == 0]
    hosp_data = hosp_data.drop('Bundesland_Id', axis=1)
    print('HOSP', hosp_data.head())

    result = pd.concat([impf_data, hosp_data], axis=1).round(2)
    result = result[result.columns[::-1]]
    result = result.iloc[::-1]
    print(result.corr())

    _, axes = plt.subplots()
    im = axes.matshow(result.corr())
    axes.set_xticks(range(result.select_dtypes(['number']).shape[1]), result.select_dtypes(
        ['number']).columns, rotation=45)

    axes.set_yticks(range(result.select_dtypes(['number']).shape[1]), result.select_dtypes(
        ['number']).columns)

    cb = plt.colorbar(im, ax=axes)


if __name__ == "__main__":
    hosp_df = pd.read_csv(definitions.FILE_HOSPITALISIERUNG)
    impf_df = pd.read_csv(definitions.FILE_IMPFUNGEN_LAENDER)
    inzidenz_df = pd.read_csv(definitions.FILE_INZIDENZ_BUND)

    max_hospitalized()
    correlation_matrix()

    plt.show()
