

/**Задача №1
Посчитайте количество клиентов, закреплённых за каждым сотрудником
 (подсказка: в таблице customer есть поле support_rep_id, которое хранит employee_id сотрудника, 
 за которым закреплён клиент). 
 Итоговая таблица должна содержать следующие поля: id сотрудника, полное имя, количество клиентов.
 Добавьте к получившейся таблице поле,
 показывающее какой процент от общей клиентской базы обслуживает каждый сотрудник.*/

	
select
e1.employee_id
, concat_ws(' ', e1.first_name,e1.last_name) as full_name
, count(c2.customer_id) as subordinates_cnt
, round(count(c2.customer_id) * 100.0 / 
        (select count(*) from customer), 2 )as pct_total_customers
from employee e1
	left join customer c2
		on e1.employee_id = c2.support_rep_id
group by 
	e1.employee_id
	, concat_ws(' ', e1.first_name,e1.last_name)
order by
	e1.employee_id;

/*Задача №2
Верните список альбомов, треки из которых вообще не продавались. 
Итоговая таблица должна содержать следующие поля: название альбома, имя исполнителя.*/

select
    a.title as album_name, 
    ar.name as artist_name
from album a
	left join artist ar 	
		on a.artist_id = ar.artist_id
	left join  track t 
		on a.album_id = t.album_id
	left  join invoice_line il 
		on t.track_id = il.track_id
where 	
	il.track_id is null 
order  by 
	album_name;




/*Задача №3
Выведите список сотрудников у которых нет подчинённых.*/


select
	e1.employee_id
	, e1.last_name
	, e2.employee_id as subordinates
from employee e1
	left join employee e2
		on e1.employee_id = e2.reports_to
where 
	e2.reports_to is null
order by
	e1.employee_id;


/*Задача №4
Верните список треков, которые продавались как в США так и в Канаде.
 Итоговая таблица должна содержать следующие поля: id трека, название трека.*/

select distinct
  t.track_id 
  , t.name as track_name
from track t
	left join invoice_line il 
		on t.track_id = il.track_id
	left join invoice i_usa 
		on il.invoice_id = i_usa.invoice_id 
		and i_usa.billing_country = 'USA'
	left join invoice i_canada 
		on il.invoice_id = i_canada.invoice_id 	
			and i_canada.billing_country = 'Canada'
order by
t.track_id;

/*
Верните список треков, которые продавались в Канаде, но не продавались в США.
 Итоговая таблица должна содержать следующие поля: id трека, название трека.*/

select  distinct  
t.track_id
,t.name as track_name
from  track t
	left join invoice_line il 
		on  t.track_id = il.track_id
	left join  invoice i 
		on il.invoice_id = i.invoice_id
where  
	i.billing_country = 'Canada'
and t.track_id not in (
    select  distinct 
    	il2.track_id
    from  invoice_line il2
    	left join  invoice i2 	
    		on  il2.invoice_id = i2.invoice_id
    where  
    	i2.billing_country = 'USA'
)
order by 
	t.track_id;

