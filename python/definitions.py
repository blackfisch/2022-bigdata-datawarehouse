'''static definitions for the python scripts'''


from os import path

_DATAPATH = path.join(path.dirname(__file__), '..', 'data')

FILE_HOSPITALISIERUNG = path.join(
    _DATAPATH,
    'Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv'
)

FILE_HOSPITALISIERUNG_ADJUSTIERT = path.join(
    _DATAPATH, 'Aktuell_Deutschland_adjustierte-COVID-19-Hospitalisierungen.csv'
)

FILE_IMPFQUOTEN = path.join(
    _DATAPATH,
    'Aktuell_Deutschland_Impfquoten_COVID-19.csv'
)

FILE_IMPFUNGEN_KREISE = path.join(
    _DATAPATH,
    'Aktuell_Deutschland_Landkreise_COVID-19-Impfungen.csv'
)

FILE_IMPFUNGEN_LAENDER = path.join(
    _DATAPATH,
    'Aktuell_Deutschland_Bundeslaender_COVID-19-Impfungen.csv'
)

FILE_INFEKTIONEN = path.join(
    _DATAPATH,
    'Aktuell_Deutschland_SarsCov2_Infektionen'
)
