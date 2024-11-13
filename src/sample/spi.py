import initialize

import pandas as pd

def get_spi_data(year=2023):
    df = pd.read_excel('data/SPI2011-2023.xlsx', sheet_name='Data 2011-2023', skiprows=2)
    df = df[df['SPI \nyear'] == year]
    df = df.drop(columns=['SPI \nRank', 'SPI \nyear', 'Status', 'Expected years of tertiary schooling (years)'])
    df = df.dropna(axis='columns', how='all')
    return df

if __name__ == '__main__':
    print(get_spi_data(2023))