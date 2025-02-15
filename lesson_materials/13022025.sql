select*
from track 
where
	name like 'K%;'
	
	-- буква К в начале
	
select*
from track 
where
	name like '%K%'	
	;
	-- буква К в середине

select*
from track
 where
 name ilike '%k%'
 ;
-- регистр не важен (оказывает независиом от того заглавная буква или нет)

select*
from customer
where
last_name like 'K_hler'
;

select
customer_id 
,state
, country
, country || ' ' || state || ' ' || city as address
, concat (country, ' ', state,  ' ',  city) as address2
, concat_ws(' ,', country, state, city) as address3;
-- 3 метода склеивания

select 
	name
	, length(name) as title_len
from track;

select 
	name
, upper(name) as all_caps
, lower(name) as all_lower
,initcap(name) as each_word_cap
from track


select 
	name
	, left(name,3) as first3_symbols
	--первые символы
	,right(name,2) as last3_symbols
	--последние символы
	, substring(name,2,4) as middle_symbols
	--указываем сначала индекс буквы с которой вести отчет ,а потом количество
from track;


select 
name
,position('n' in name) as n_ix
from track;

select
name
, replace (name,'Shark', 'Baby_Shark')
from track
;

select*
from employee;

select 
employee_id
, email
, split_part(email,'@',2)
-- делим текст на части по разделителю ,например, одна собачка делит текст на 2 части, поэтому указываем цифру  2 как указатель
,(string_to_array(email,'@'))[1] as email_arr
from employee;

select 
	name
	,regexp_substr(name,'\d{4}') as year_in_track_name
	from track
	where
		regexp_like(name,'\d');
---регулярные выражения для парсинга

select *
from track
where 
regexp_like(name,'^S')
-- выбираем все треки, начинающиеся с буквы S
;
select *
from track
where 
regexp_like(name,'m$')

select *
from track
where 
regexp_like(name,'m$','i')
--нечувствителен к регистру за счет 'i'

select *
from track
where 
regexp_like(name,'m$');

select *
from track
where 
regexp_like(name,'^[^K].*') 

		--сортировка по цифрам