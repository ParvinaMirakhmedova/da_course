/*Задача 1
 * Для каждого клиента посчитайте сумму продаж по годам и месяцам. 
Итоговая таблица должна содержать следующие поля: customer_id, full_name, monthkey (в числовом формате), total.
Дополните получившуюся таблицу, посчитав для каждого клиента какой процент от общих продаж за каждый месяц он принёс.
 Т.е. если например в феврале 2023-го общая сумма продаж всем клиентам составила 100, а сумма продаж клиенту Х составила 15, тогда процент
  расчитывается как 15/100.
Дополните таблицу, посчитав для каждого клиента нарастающий итог за каждый год.
Дополните таблицу, добавив для каждого клиента скользящее среднее за 3 последних периода (2 предыдущих периода и текущий период).
Дополните таблицу, посчитав для каждого клиента разницу между суммой текущего периода и суммой предыдущего периода.*/

with  sales_data as  (
    select 
        i.customer_id,
        concat_ws(' ',c.first_name,c.last_name) as full_name,
        extract (year  from  i.invoice_date) * 100 + extract (month  from  i.invoice_date) as  monthkey,
        sum(i.total) as  total
    from  invoice i
    join  customer c on  i.customer_id = c.customer_id
    group  by  i.customer_id, full_name, monthkey
),
monthly_totals as  (
    select 
        monthkey,
        SUM(total) as  total_sales
    from  sales_data
    group  by  monthkey
)
select 
    s.customer_id,
    s.full_name,
    s.monthkey,
    s.total,
    (s.total / mt.total_sales) * 100 as  percentage_of_total,
    sum(s.total) over  (partition  by  s.customer_id, extract (year  from  TO_DATE(s.monthkey::TEXT, 'YYYYMM')) order by s.monthkey) as  cumulative_total,
    avg(s.total) over  (partition  by  s.customer_id order  by  s.monthkey rows  between  2 preceding  and  current  row ) as  moving_average,
    s.total - lag (s.total) over  (partition  by  s.customer_id order  by  s.monthkey) as  difference_from_prev
from  sales_data s
join  monthly_totals mt on  s.monthkey = mt.monthkey;

/*Верните топ 3 продаваемых альбома за каждый год.
 * Итоговая таблица должна содержать следующие поля: год, название альбома, имя исполнителя, количество проданных треков.*/

with album_sales as  (
    select 
        extract (year  from  i.invoice_date) as  year,
        a.title as  album_title,
        ar.name as  artist_name,
        sum(il.quantity) as  total_tracks_sold
    from  invoice_line il
    join  track t on  il.track_id = t.track_id
    join  album a on  t.album_id = a.album_id
    join  artist ar on  a.artist_id = ar.artist_id
    join  invoice i on  il.invoice_id = i.invoice_id
    group  by  year, album_title, artist_name
),
ranked_albums as  (
    select 
        year,
        album_title,
        artist_name,
        total_tracks_sold,
        row_number () over  (partition  by  year order  by  total_tracks_sold desc ) as  rank
    from  album_sales
)
select  
    year,
    album_title,
    artist_name,
    total_tracks_sold
from  ranked_albums
where  rank <= 3;

//*Посчитайте количество клиентов, закреплённых за каждым сотрудником. Итоговая таблица должна содержать следующие поля:
 id сотрудника, полное имя, количество клиентов
К предыдущему запросу добавьте поле, показывающее какой процент от общей клиентской базы обслуживает каждый сотрудник.*/

with  employee_customers as  (
    select 
        e.employee_id,
        concat_ws(' ',e.last_name,e.first_name) as  full_name,
        count(c.customer_id) as  customer_count
    from  employee e
    left  join  customer c on  e.employee_id = c.support_rep_id
    group  by  e.employee_id, full_name
),
total_customers as  (
    select 
    sum(customer_count) as  total_customer_count
    from  employee_customers
)
select  
    ec.employee_id,
    ec.full_name,
    ec.customer_count,
    (ec.customer_count::DECIMAL / tc.total_customer_count) * 100 as  customer_percentage
from  employee_customers ec
cross  join  total_customers tc
order  by  ec.customer_count desc ;

/*Для каждого клиента определите дату первой и последней покупки. Посчитайте разницу в годах между первой и последней покупкой.*/

 with  customer_purchases as  (
    select 
        customer_id,
        min(invoice_date) as  first_purchase_date,
        max(invoice_date) as  last_purchase_date
    from  invoice
    group  by  customer_id
)
select 
    customer_id,
    first_purchase_date,
    last_purchase_date,
    extract (year  from  last_purchase_date) - extract (year  from first_purchase_date) as  years_between
from  customer_purchases;




