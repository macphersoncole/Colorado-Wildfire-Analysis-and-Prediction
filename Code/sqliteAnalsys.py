import datetime as dt
import sqlite3
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt 
#from matplotlib.color import ListedColormap

conn = sqlite3.connect('FPA_FOD_20170508.sqlite')

df = pd.read_sql(""" SELECT * from Fires""",con=conn)

df_CO = df[df.STATE.eq('CO')]

df_CO_fNg = df_CO[df_CO.FIRE_SIZE_CLASS.isin(['G','F','E','D','C'])]

df_CO_fNg_2000to2015 = df_CO_fNg[df_CO_fNg.FIRE_YEAR.isin(range(2000,2016))]

df_CO_fNg_2000to2015 = df_CO_fNg_2000to2015[['LATITUDE','LONGITUDE','DISCOVERY_DATE']]

df_CO_fNg_2000to2015['DISCOVERY_DATE'] = pd.to_datetime(df_CO_fNg_2000to2015['DISCOVERY_DATE'] - pd.Timestamp(0).to_julian_date(), unit='D')

print(df_CO_fNg_2000to2015)

df_CO_fNg_2000to2015.to_csv('cleaned_wildfires.csv')