import streamlit as st
import pandas as pd
import plotly.express as px

from connect import set_connection 

# Функция для загрузки данных инвойсов
@st.cache_data
def get_invoice_data(start_date, end_date):
    query = f"""
    SELECT i.invoice_date::date AS invoice_date, i.total
    FROM invoice i
    WHERE i.invoice_date::date BETWEEN '{start_date}' AND '{end_date}'
    ORDER BY i.invoice_date;
    """
    with set_connection() as conn:
        df = pd.read_sql(query, conn)
    return df

# Функция для загрузки данных по жанрам
@st.cache_data
def get_genre_sales_data(start_date, end_date):
    query = f"""
    SELECT g.name AS genre_name, SUM(il.quantity * il.unit_price) AS total_sales
    FROM invoice_line il
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    JOIN invoice i ON il.invoice_id = i.invoice_id
    WHERE i.invoice_date::date BETWEEN '{start_date}' AND '{end_date}'
    GROUP BY g.name
    ORDER BY total_sales DESC;
    """
    with set_connection() as conn:
        df = pd.read_sql(query, conn)
    return df
st.title("Продажи по инвойсам и жанрам")

start_date = st.date_input("Стартовая дата", datetime(2021, 1, 1))
end_date = st.date_input("Конечная дата", datetime.today())

# Получение данных для линейного графика
invoice_data = get_invoice_data(start_date, end_date)


# Линейный график по дате инвойса и сумме продаж
fig_line = px.line(invoice_data, x="invoice_date", y="total", title="Сумма продаж по датам инвойсов")
st.plotly_chart(fig_line)

# Получение данных для столбчатой диаграммы
genre_sales_data = get_genre_sales_data(start_date, end_date)

# Столбчатая диаграмма по жанрам
fig_bar = px.bar(genre_sales_data, x="genre_name", y="total_sales", title="Сумма продаж по жанрам")
st.plotly_chart(fig_bar)
