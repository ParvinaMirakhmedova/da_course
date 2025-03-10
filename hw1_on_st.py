import pandas as pd
import plotly.express as px
import streamlit as st

st.title("Chinook Sales report")

from connect import set_connection

query = """
    select billing_country, total,invoice_date
    from invoice
"""
with set_connection() as conn:
    df = pd.read_sql(query, conn)

df['year'] = df['invoice_date'].dt.year

min_bill, max_bill = df['total'].agg(['min', 'max'])

st.sidebar.header('Фильтрация данных')
countries = ['All'] + list(df['billing_country'].unique())
selected_country = st.sidebar.selectbox('Выберите страну', countries)

selected_range = st.sidebar.slider('Выберите диапазон суммы счета',
                                  min_value=min_bill,
                                  max_value=max_bill,
                                  value=(min_bill, max_bill))

if selected_country != 'All':
    filtered_df = df[(df['billing_country'] == selected_country) & 
                     (df['total'] >= selected_range[0]) & 
                     (df['total'] <= selected_range[1])]
else:
    filtered_df = df[(df['total'] >= selected_range[0]) & 
                     (df['total'] <= selected_range[1])]
    
available_years = sorted(filtered_df['year'].unique())

available_years = ['All'] + available_years
selected_year = st.sidebar.selectbox('Выберите год', available_years)

if selected_year != 'All':
    filtered_df_year = filtered_df[filtered_df['year'] == selected_year]
else:
    filtered_df_year = filtered_df

st.write(f"Отфильтрованные данные для страны: {selected_country} и года: {selected_year}")
st.dataframe(filtered_df_year)


col1, col2 = st.columns(2, gap='medium')
 
with col1:
     st.dataframe(filtered_df_year)

with col2:
     if st.checkbox('Show the chart'):
         fig_country = px.box(filtered_df, 
                     x='billing_country', 
                     y='total', 
                     title=f"Распределение доходов по странам ({selected_country})",
                     labels={'billing_country': 'Страна', 'total': 'Доход'})
st.plotly_chart(fig_country)

fig_year = px.line(filtered_df_year,
                   x='year', 
                   y='total', 
                   title="Доход по годам",
                   labels={'year': 'Год', 'total': 'Доход'}, 
                   markers=True)
st.plotly_chart(fig_year)
