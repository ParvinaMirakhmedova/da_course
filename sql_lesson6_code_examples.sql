drop table inv_subset;

create table inv_subset as 
select
	invoice_id
	, invoice_date
	, customer_id
	, total
from invoice
where
	customer_id <= 3
;

-- АГРЕГАТНЫЕ ОКОННЫЕ ФУНКЦИИ
select
	inv.*
	, sum(total) over() as total_sum
	, sum(total) over(
		partition by customer_id
	) as total_sum_by_customer
	, sum(total) over(
		partition by customer_id
		order by invoice_id
	) as running_total
	, avg(total) over(
		partition by customer_id
		order by invoice_date
		rows between 2 preceding and current row
	) as sliding_avg
from inv_subset inv;

-- РАНЖИРУЮЩИЕ ОКОННЫЕ ФУНКЦИИ
select 
	inv.*
	, rank() over(order by total desc) as total_rnk
	, dense_rank() over(order by total desc) as total_dnsrnk 
	, row_number() over(order by total desc) as row_n
	, ntile(4) over(order by total) as quantile
from inv_subset inv;

/* ЗАДАЧА
Из таблицы invoice вытащить поля:  invoice_id, customer_id, 
billing_country, total
* посчитать итог для каждой страны
* посчитать нарастающий итог для каждой страны
* посчитать скользящее среднее 2 предыдущих, 
  текущей и 2 будущих строк для каждой страны
*/
select
	invoice_id
	, customer_id
	, billing_country
	, total
	, sum(total) over(
		partition by billing_country
	) as total_by_cntry
	, sum(total) over(w) as running_total_by_cntry
	, round(avg(total) over(
		w rows between 2 preceding and 2 following
	), 2) as sliding_avg_total
from invoice
window
w as (
	partition by billing_country
	order by invoice_id
);
/*
from 
join
where
group by
having
window function
select
offset
limit
*/
-- АНАЛИТИЧЕСКИЕ ОКОННЫЕ ФУНКЦИИ
select 	
	inv.*
	, lag(total, 2, 0) over(win) as prev_inv
	, lead(total) over(win) as next_inv
	, round(total / first_value(total) over(win),2) as pct_of_first_inv
	, last_value(total) over(
		win 
		rows between unbounded preceding and unbounded following
	) as last_inv
	, nth_value(total, 3) over(win) as third_inv
from inv_subset inv
window
win as (
	partition by customer_id
	order by invoice_id
);

select 
	inv.*
	, sum(total) over(
		order by invoice_date
		range between unbounded preceding and current row
	) as run_total
	, sum(total) over(
		order by invoice_date
		rows between unbounded preceding and current row
	) as run_total2
from inv_subset inv;

