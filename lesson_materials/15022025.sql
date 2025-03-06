create schema if not exists spotify;

create table if not exists users(
user_id serial
, username varchar(20)
, created_at timestamp
, deleted_at timestamp
);

drop table users;
--удаляем таблицу

set search_path to spotify;
-- меняем путь

select current_schema;
--проверяем текущее местоположение


create table if not exists users(
user_id serial
, username varchar(20)
, created_at timestamp
, deleted_at timestamp
, primary key (user_id)
);


create table if not exists tracks(
track_id serial
, track_name text not null
, composer text
, added_at timestamp default localtimestamp
, duration integer 
, size_in_bytes integer
, primary key (track_id)
);

create table playlist (
user_id integer not null
, track_id integer not null
, foreign key(user_id) references users (user_id) on delete cascade
, foreign key (track_id) references tracks(track_id) on delete cascade
);
--связываем таблицы через ключи

insert into users(username, created_at)
values
	('user1','2025-01-01')
;

select*
from users;

insert into users(username, created_at)
values
	('user2','2025-01-01'
	);

select*
from users;

insert into users(username,created_at)
select
	first_name as username
	, hire_date as created_at
	from public.employee;

select*
from users
;

create table invoice_subset as 
select *
from public.invoice
limit 10;


select *
from public.employee;
--сли хотим проверить сет из другой схемы, то нужно обязательно её указывать, в нашем случае имя схемы - public

alter table invoice_subset
rename to inv_subset;

select*
from inv_subset;

alter table inv_subset
add column inv_year integer;
--добавление нового стоблца

update inv_subset
set inv_year = extract(year from invoice_date);
--внесли данные в этот столбец


select*
from inv_subset;

update inv_subset
set total = 20
where 
invoice_id = 1;


select*
from inv_subset
order by invoice_id;


select*
from inv_subset;

update inv_subset
set total = total*10
where 
	billing_country = 'USA' or billing_country = 'Canada';
-- billing_country in ('USA' or 'Canada')

select*
from inv_subset

--как удалить строки из таблицы

delete from inv_subset
where 
	billing_country = 'France';

select*
from inv_subset;

--очистить содержимое таблицы

truncate table inv_subset;

select* 
from inv_subset;

-- для колонки можно сртировать по индексу, для этого создаем бинарный индекс (редко пользуются аналитики, т.к. это влияет на скорость insert, что плохо)

create index username_ix on users(username);

select * 
from users 
where 
	username like '%cy';

set search_path to public;

select current_schema; 

select*
from track;

--чтобы не изменять основную таблицу, мы можем создать представление (образ) и можно в таком виде отправить другой команде,чтобы она не видела все столбцы, имеющиеся в таблице

create view v_track as 
select 
track_id 
, name as track_name 
, round(milliseconds / 60000.,2) as duration_in_min 
, round(bytes / (1024.*1024),2) as size_in_Mb
from track;

select*
from v_track;
--запрос на представление

drop view v_track; --удаление образа












