import json
import pandas as pd
from sqlalchemy import text

from connect import set_connection

SCHEMA = "demo_dash"

def create_tables():
    try:
        # читаем содержимое файла 'queries/tables.sql'
        with open('queries/tables.sql') as f:
            tables_query = f.read()
        
        # создаём схему и таблицы
        with set_connection() as psg:
            psg.execute(text(tables_query))
            psg.commit()
        
        print("Tables created successfully")
    except Exception as e:
        print(e)

create_tables()



def read_xl(sheet_name, columns_dict):
    temp_df = pd.read_excel(
        'source/adventure_works.xlsx',
        sheet_name=sheet_name,
        usecols=columns_dict.keys()
    ).rename(columns=columns_dict)
    return temp_df

with open('columns.json') as f:
    tables_dict = json.load(f) 

def insert_to_db(temp_df, tbl_name):
    with set_connection() as psg:
        temp_df.to_sql(
            schema=SCHEMA,
            name=tbl_name,
            con=psg,
            index=False,
            if_exists='append'
        )

def etl(sheet_name, columns_dict, tbl_name):
    print(f"inserting data to {tbl_name}...")
    temp_df = read_xl(sheet_name, columns_dict)
    insert_to_db(temp_df, tbl_name)
    
for k, v in tables_dict.items():
    etl(k, v["columns"], v["table_name"])



# etl("Customers", tables_dict["Customers"]["columns"], tables_dict["Customers"]["table_name"])