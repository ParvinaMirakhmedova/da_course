import streamlit as st
import pandas as pd
import plotly.express as px

from connect import set_connection 

@st.cache_data
def get_min_max_dates():
    query = """
    select 
    min(invoice_date::date) as min_date 
    , max(invoice_date::date) as max_date
    from invoice;
    """
    with set_connection() as conn:
         df = pd.read_sql(query, conn)
    min_date = df['min_date'][0]
    max_date = df['max_date'][0]
    return min_date, max_date


min_date, max_date = get_min_max_dates()

start_date = st.date_input('Начальная дата', min_date)
end_date = st.date_input('Конечная дата', max_date)

@st.cache_data
def load_invoice_data(start_date, end_date):
    query = f"""
    select invoice_date, total
    from invoice
    where invoice_date::date between '{start_date}' and '{end_date}'
    """
    with set_connection() as conn:
        df = pd.read_sql(query, conn)
    return df

@st.cache_data
def load_genre_sales_data(start_date, end_date):
    query = f"""
    select
      g.name as genre_name
      , sum(il.quantity * il.unit_price) as total_sales
    from invoice_line il
    join 
        track t on il.track_id = t.track_id
    join 
        genre g on t.genre_id = g.genre_id
    join 
        invoice i on il.invoice_id = i.invoice_id
    where 
        i.invoice_date::date between '{start_date}' and '{end_date}'
    group by
        g.name
    """
    with set_connection() as conn:
        df = pd.read_sql(query, conn)
    return df


def plot_sales_by_date(df):
    fig = px.line(df, 
                  x='invoice_date', 
                  y='total', 
                  title='Продажи по датам инвойсов', 
                  labels={'invoice_date': 'Дата инвойса', 'total': 'Сумма продаж'})
    st.plotly_chart(fig)

def plot_sales_by_genre(df):
    fig = px.bar(df, 
                 x='genre_name', 
                 y='total_sales', 
                 title='Разбивка суммы инвойсов по жанрам', 
                 labels={'genre_name': 'Жанр', 'total_sales': 'Сумма продаж'})
    st.plotly_chart(fig)

st.title('Дашборд продаж по инвойсам')


invoice_data = load_invoice_data(start_date, end_date)
if not invoice_data.empty:
    st.subheader('Продажи по датам инвойсов')
    plot_sales_by_date(invoice_data)
else:
    st.write("Нет данных для отображения на основе выбранных дат.")

genre_data = load_genre_sales_data(start_date, end_date)
if not genre_data.empty:
    st.subheader('Разбивка суммы инвойсов по жанрам')
    plot_sales_by_genre(genre_data)
else:
    st.write("Нет данных для отображения по жанрам.")
