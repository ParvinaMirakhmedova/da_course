import pandas as pd
import plotly
import streamlit as st

tips =plotly.data.tips()

fig = px.scatter(
    data_frame = tips,
    x = 'total_bill',
    y= 'tip'
)

st.title('Streamlit intro')
st.plotly_chart(fig)