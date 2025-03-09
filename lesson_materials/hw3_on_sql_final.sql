create schema if not exists store_final;

set search_path to store_final; 

create table if not exists customers_final( 
customer_id_final serial
, customer_name_final varchar(50) not null
, email_final varchar(260)
, address_final text
, primary key(customer_id_final)
);

insert into customers_final(customer_name_final, address_final)
select 
	concat_ws(' ',first_name, last_name) as customer_name
	, concat_ws(' ', country, state, city, address) as address
from public.customer;

create table if not exists products_final( 
 product_id_final serial
 , product_name_final varchar(100)
 , price_final integer not null
 , primary key(product_id_final)
 );

insert into products_final(product_id_final,product_name_final, price_final)
values
  ('1','Ноутбук Lenovo Thinkpad','12000')
  	, ('2', 'Мышь для компьютера, беспроводная','90') 
	, ('3', 'Подставка для ноутбука','300') 
	, ('4', 'Шнур электрический для ПК', '160')
;

create table if not exists sales_final(  
sale_id_final serial
, sale_stampline_final timestamp not null default localtimestamp
, quantity_final integer not null default 1
, customer_id_final integer
, product_id_final integer
, primary key (sale_id_final )
, foreign key (customer_id_final) references customers_final(customer_id_final) on delete cascade 
, foreign key (product_id_final) references products_final(product_id_final) on delete cascade
);

select* 
from sales_final;

insert into sales_final(sale_id_final,customer_id_final,product_id_final,quantity_final)
values 
	('1','3','4','1')
	,('2','56','2','3')
	,('3','11','2','1')
	,('4','31','2','1')
	,('5','24','2','3') 
	,('6','27','2','1')
	,('7','37','3','2')
	,('8','35','1','2')
	,('9','21','1','2')
	,('10','31','2','2')
	,('11','15','1','1')
	,('12','29','2','1')
	,('13','12','2','1')
;
select* 
from sales_final;

alter table sales_final
add column discount numeric
;

alter table sales_final 
alter column discount type numeric;


update sales_final
set discount = 0.2
where product_id_final = 1
;


create view v_usa_customers as
select
	customer_id_final
	, customer_name_final
	, email_final
	, address_final
from customers_final
where 	
address_final like '%USA%'
;
select*
from v_usa_customers;