create database if not exists netflix_data;
use	netflix_data;

create table genre_details(
genre_id varchar(10) primary key,
genre_name varchar(100)
);

create table netflix_originals(
title varchar(255),
genre_id varchar(10),
runtime int,
imdb_score float,
languages varchar(100),
premiere_date date,
foreign key (genre_id) references genre_details(genre_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Genre_Details.csv'
into table genre_details
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Netflix_Originals.csv'
into table netflix_originals
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select gd.genre_name,
round(AVG(no.IMDB_Score),2) AS Avg_IMDB_Score
from netflix_originals no
join genre_details gd on no.genre_id = gd.genre_id
group by gd.genre_name
order by Avg_IMDB_Score desc;

select gd.genre_name,
round(AVG(no.IMDB_Score),2) AS Avg_IMDB_Score
from netflix_originals no
join genre_details gd on no.genre_id = gd.genre_id
group by gd.genre_name
having avg_imdb_score > 7.5
order by Avg_IMDB_Score desc;

select title, imdb_score
from netflix_originals
order by imdb_score desc;

select title, runtime
from netflix_originals
order by runtime desc
limit 10;

select gd.genre_name, no.title
from netflix_originals no
join genre_details gd on no.genre_id = gd.genre_id;

select gd.genre_name, no.title
from genre_details gd
join netflix_originals no on no.genre_id = gd.genre_id;

select
gd.genre_name,
no.title,
no.imdb_score,
rank() over (partition by gd.genre_name order by no.imdb_score desc) as rank_within_genre
from netflix_originals no
join genre_details gd on gd.genre_id = no.genre_id;

select title, imdb_score
from netflix_originals
where imdb_score > (
select avg(imdb_score) from netflix_originals
)
order by imdb_score desc;

select gd.genre_name, count(*) as total_titles
from genre_details gd
join netflix_originals no on no.genre_id = gd.genre_id
group by gd.genre_name
order by total_titles desc;

select gd.genre_name, count(*) as high_rated_titles
from netflix_originals no
join genre_details gd on no.genre_id = gd.genre_id
where no.imdb_score > 8
group by gd.genre_name
having count(*) > 5
order by high_rated_titles desc;

