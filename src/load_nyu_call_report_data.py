"""
Download, unzip, and format the NYU Call Report data found here:
https://pages.stern.nyu.edu/~pschnabl/data/data_callreport.html

The data dictionary is provided in ../data/manual/
"""
import pandas as pd
import zipfile
from pathlib import Path
import urllib.request

import config
DATA_DIR = Path(config.DATA_DIR)

def download_unzip_and_save_as_parquet(data_dir = DATA_DIR):
    
    # Download the file
    url = "https://pages.stern.nyu.edu/~pschnabl/research/callreports_1976_2020_WRDS.dta.zip"
    zip_path = data_dir / "pulled" / "callreports_1976_2020_WRDS.dta.zip"
    urllib.request.urlretrieve(url, zip_path)

    # Unzip the file
    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        zip_ref.extractall(data_dir / "pulled")

    # Load the file into a pandas dataframe
    data_path = data_dir / "pulled" / "callreports_1976_2020_WRDS.dta"
    df = pd.read_stata(data_path)

    columns_to_convert_to_int = [
        'rssdid',
        'chartertype',
        'cert',
        'bhcid',
        'date',
        'year',
        'month',
        'quarter',
        'day',
    ]
    df[columns_to_convert_to_int] = df[columns_to_convert_to_int].fillna(99999).astype('int')
    df[columns_to_convert_to_int] = df[columns_to_convert_to_int].astype('str')
    df[columns_to_convert_to_int] = df[columns_to_convert_to_int].replace('99999', pd.NA)
    
    # df[columns_to_convert_to_int].info()
    # df[columns_to_convert_to_int].head()
    # df[columns_to_convert_to_int].isna().sum()

    # Save the dataframe as a parquet file
    parquet_path = data_dir / "pulled" / "nyu_call_report.parquet"
    df.to_parquet(parquet_path)

def load_nyu_call_report(data_dir = DATA_DIR):
    parquet_path = data_dir / "pulled" / "nyu_call_report.parquet"
    df = pd.read_parquet(parquet_path)
    return df


def _demo():
    df = load_nyu_call_report()
    df.head()
    df.info(verbose=True)

if __name__ == "__main__":
    download_unzip_and_save_as_parquet(data_dir=DATA_DIR)
    