select*
from invoice;

/*
Напишите код, который из таблицы invoice вернёт дату самой первой и самой последней покупки
*/

select 
max (invoice_date) as last_purchase_date 
min (invoice_date) as first_purchase_date
from invoice;

/*
 Напишите код, который вернёт размер среднего чека для покупок из США.
 */
select 
round(avg (total),2) as average_bill
from invoice
where 
	billing_country = 'USA'
;
 
/*
 * Напишите код, который вернёт список городов в которых 
 * имеется более одного клиента.
 */

select
	billing_city
	,count(customer_id) as customer_count
	from invoice
 group by 
 	billing_city
 	having count(customer_id)>1;

/*Из таблицы customer вытащите список телефонных номеров, не содержащих скобок;
 */

select *
from customer;
 
select 
	phone 
	from customer
	where 
		phone not like '%(%' and phone not like '%)%';

/*
Измените текст 'lorem ipsum' так чтобы только первая буква первого слова была в верхнем регистре,а остальные в нижнем
*/


select 
	concat(upper(substring('lorem ipsum'),1,1)), lower(substring('lorem ipsum'),2))) as text
;

/*Из таблицы track вытащите список названий песен, которые содежат слово 'run'
 */

select
	name
from track
where name ilike '%run%';

/*Вытащите список клиентов с почтовым ящиком в 'gmail';
 */

select*
from customer
	where 
email like '%gmail%';

/*Из таблицы track найдите произведение с самым длинным названием
 */


select
name
, length(name) as length
from track
order by 
length(name) desc
limit 1;


/*Посчитайте общую сумму продаж за 2021 год, в разбивке по месяцам.
 *  Итоговая таблица должна содержать следующие поля: month_id, sales_sum
 */

select 
	extract (month from invoice_date) as month_id
     ,sum (total) as sales_sum
from invoice
	where
		extract(year from invoice_date) = 2021
	group by 
		month_id
	order by 
		month_id;
     
/*К предыдущему запросу (вопрос №9) добавьте также поле с названием месяца 
 * (для этого функции to_char в качестве второго аргумента нужно передать слово 'month'). 
 * Итоговая таблица должна содержать следующие поля: month_id, month_name, sales_sum. * 
 Результат должен быть отсортирован по номеру месяца. 
 */

select 
	extract (month from invoice_date) as month_id
	,to_char (invoice_date, 'month') as month_name
	,sum (total) as sales_sum
from invoice
where extract(year from invoice_date) = 2021
group by month_id, to_char(invoice_date,'month')
order by month_id;

/*Вытащите список 3 самых возрастных сотрудников компании. Итоговая таблица должна содержать следующие поля:
 full_name (имя и фамилия), birth_date, age_now (возраст в годах в числовом формате)
 */
select*
from employee;


select
    concat(first_name, ' ', last_name) as full_name,
    birth_date,
    extract(year from age(birth_date)) as age_now
from employee
order by age_now desc
limit 3;

/*Посчитайте каков будет средний возраст сотрудников через 3 года и 4 месяца.
*/

select 
    round(avg(extract(year from age(birth_date)) + 
        extract(month from age(birth_date)) / 12 + 3 + 4 / 12),2) AS avg_age_in_3_4_years
from employee;

/*Посчитайте сумму продаж в разбивке по годам и странам. Оставьте только те строки где сумма продажи больше 20. 
 Результат отсортируйте по году продажи (по возрастанию) и сумме продажи (по убыванию).
*/

select*
from invoice
;

select 
    extract(year from invoice_date) as year,
    billing_country,
    sum(total) as total_sales
from invoice
group by extract(year from invoice_date), billing_country
having sum(total) > 20
order by year, total_sales desc;