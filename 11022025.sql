--однострочный комментарий

/* 
многострочный комментарий
*/

select * 
from track

select 
track_id
, name
, composer--имя автора
, album_id
from track;

select 9/3;

select 9/4.;

select
name
, round(milliseconds/60000.,2) as lenght_in_min
from track;

select*
from track
order by 
  name desc
  , track_id desc;

select*
from track
limit 10
offset 10;

select*
from track 
where album_id = 3;


select*
from track 
where 
   composer in('Queen','AC/DC','U2')
   
   select*
   from track 
   where 
   composer = 'Queen'
   and bytes > 9000000
   ;
   
   select*
   from track 
   where
   composer = 'Queen'
   or composer = 'AC/DC'
   order by 
   bytes
   ;
   
   select*
   from track where
   bytes > 9000000
   and (composer = 'Queen'
   or composer = 'AC/DC');
   
   select*
   from track 
   where 
   composer is null

  
