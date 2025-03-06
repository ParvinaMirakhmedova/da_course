/*По каждому сотруднику компании предоставьте следующую информацию: id сотрудника, полное имя, позиция (title), 
 * id менеджера (reports_to), полное имя менеджера и через запятую его позиция*/


select
employee_id   
, reports_to 
, concat_ws(' , ',concat_ws(' ',first_name,last_name), title) as general_info
from employee;

/*Вытащите список чеков, сумма которых была больше среднего чека за 2023 год. 
 * Итоговая таблица должна содержать следующие поля: invoice_id, invoice_date, 
 * monthkey (цифровой код состоящий из года и месяца), customer_id, total*/


select 
	invoice_id 
	, customer_id 
	, total
	, to_char( invoice_date, 'YYYY-MM') as year_month
	from invoice
	where 
	 	total > ( 
	select avg(total) 
	from invoice);

/*Дополните предыдущую информацию email-ом клиента*/

select 
	invoice_id 
	, customer_id 
	, total
	, (
	select 
		email
	from customer	
		where customer_id = invoice.customer_id) as email
	, to_char( invoice_date, 'YYYY-MM') as year_month
	from invoice
	where 
	 	total > ( 
	select avg(total) 
	from invoice);

/*Отфильтруйте результирующий запрос, чтобы в нём не было клиентов имеющих почтовый ящик в домене gmail*/

select 
	invoice_id 
	, customer_id 
	, total
	,	(
	select 
		email
	from customer	
		where customer_id = invoice.customer_id) as email
	, to_char( invoice_date, 'YYYY-MM') as year_month
	from invoice
	where 
	 	total > ( 
	select avg(total) 
	from invoice)
	and (select 
		email
	from customer	
		where customer_id = invoice.customer_id) not like '%gmail%';

/*Посчитайте какой процент от общей выручки за 2024 год принёс каждый чек*/

select*
from invoice;

	
select 
	invoice_id 
	, invoice_date
	, customer_id 
	, total 
	, round(total/(select sum(total) from invoice),4) as pct_of_total_sum
	from invoice
	where 
		extract( year from invoice_date) = 2024;


/*Посчитайте какой процент от общей выручки за 2024 год принёс каждый клиент компании.*/

select 
	customer_id 
	, sum(total)/
	(select sum(total) 
	from invoice
	where
	 extract(year from invoice_date)=2024) as pct_of_total_sum
	from invoice
	group by customer_id 
	order by pct_of_total_sum desc;





