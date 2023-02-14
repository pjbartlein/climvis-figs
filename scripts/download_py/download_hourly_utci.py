import cdsapi

c = cdsapi.Client()

c.retrieve(
    'derived-utci-historical',
    {
        'version': '1_1',
        'format': 'zip',
        'variable': 'universal_thermal_climate_index',
        'product_type': 'consolidated_dataset',
        'year': '2021',
        'month': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
        ],
        'day': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
            '13', '14', '15',
            '16', '17', '18',
            '19', '20', '21',
            '22', '23', '24',
            '25', '26', '27',
            '28', '29', '30',
            '31',
        ],
    },
    'ERA5-TCI_utci_2021.zip')