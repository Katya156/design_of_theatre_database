-- 1. Отношение STATUS_PLAY(справочник Статусы спектаклей)
create table status_play(
		play_status char(3) primary key
);
-- 2. Отношение PLAYS(спектакли)
create table plays(
	play_id numeric(4) primary key,
	play_name varchar(40) not null,
	duration numeric(3) not null constraint positive_duration check(duration > 0),
	age numeric(2) not null constraint check_age check(age in (0,6,12,16,18)),
	descr varchar(500) not null,
	play_status char(3) not null references status_play,
coeff numeric(4, 2) not null constraint check_coeff_play check(coeff > 0)
);
-- 3. Отношение GENRES (Справочник Жанры)
create table genres(
		genre varchar(40) primary key
);
-- 4. Отношение GENRE_PLAYS (отношение к жанру)
create table genre_plays(
	play_id numeric(4) not null references plays,
	genre varchar(40) not null references genres
);
-- 5. Отношение AUTHORS (авторы)
create table authors(
	author_id numeric(3) primary key,
	surname varchar(20) not null,
	name_patr varchar(30) not null
);
-- 6. Отношение AUTHORSHIP (авторы)
create table authorship(
	author_id numeric(3) not null references authors,
	play_id numeric(4) not null references plays
);
-- 7. Отношение DIRECTORSHIP (режиссерство)
create table directorship(
	director_id numeric(4) not null references portfolio,
	play_id numeric(4) not null references plays
);
-- 8. Отношение SHOWS (представления)
create table shows(
	show_id numeric(4) primary key,
	play_id numeric(4) references plays,
	date_ date not null,
	time_ time not null,
	hall char(10) not null references halls,
	unique(date_, hall, time_)
);
-- 9. Отношение AREAS (Справочник Зоны)
create table areas(
	area char(10) primary key,
	coeff numeric(4, 2) not null constraint check_coeff check(coeff > 0)
);
-- 10. Отношение HALLS (Справочник Залы)
create table halls(
	hall char(10) primary key
);
-- 11. Отношение PLACES (места в залах)
create table places(
	place_id numeric(4) primary key,
	place_num numeric(2) not null constraint check_pos_place check(place_num > 0),
	row_num numeric(2) not null constraint check_pos_row check(row_num > 0),
	area char(10) not null references areas,
	hall char(10) not null references halls,
	unique(place_num, row_num, area, hall)
);

-- 12. Отношение STATUS_TICKET (Справочник Статусы билетов)
create table status_ticket(
	ticket_status char(3) primary key
);
-- 13. Отношение TICKETS (билеты)
create table tickets(
place_id numeric(4) references places,
	show_id numeric(4) references shows,
	price numeric(6) not null constraint check_price check(price > 0) default 100,
	status char(3) not null references status_ticket default 'on',
	primary key(place_id, show_id)
);
-- 14. Отношение PORTFOLIO (портфолио персонала)
create table portfolio(
	person_id numeric(4) primary key,
	surname varchar(20) not null,
	name_patr varchar(30) not null,
	birthdate date not null constraint check_birth check(extract(year from age(birthdate)) >= 14),
	passport_date date not null constraint check_passport_date check(extract(year from age(passport_date, birthdate)) in (14, 20, 45)),
	pasport_who varchar(50) not null,
	passport_num char(10) not null unique,
	inn char(12) not null unique,
	sex char(3) not null constraint check_sex check(sex in ('м', 'ж'))
);
-- 15. Отношение ROLES (роли)
create table roles(
	role_id numeric(5) primary key,
	play_id numeric(4) references plays,
	person_fio varchar(40),
	person_role varchar(30) not null
);
-- 16. Отношение CASTS (состав)
create table casts(
	actor_id numeric(4) not null references portfolio,
	role_id numeric(5) not null references roles,
	role_date date not null,
	primary key(actor_id, role_id)
);
-- 17. Отношение CAST_SHOW (Комбинация состава)
create table cast_show(
	actor_id numeric(4) not null,
	role_id numeric(5) not null,
	show_id numeric(4) not null references shows,
	foreign key(actor_id, role_id) references casts
);
-- 18 Отношение PHONE (телефон)
create table phone(
	person_id numeric(4) not null references portfolio,
	phone numeric(11) not null
);
-- 19. Отношение TYPE_REWARDS (Справочник Награды)
create table type_rewards(
reward varchar(50) primary key
);
-- 20. Отношение REWARDS (награды)
create table rewards(
	person_id numeric(4) not null references portfolio,
	reward varchar(50) not null references type_rewards,
year_ char(4) not null
);
-- 21. Отношение TYPE_AMPLUA (Справочник Амплуа)
create table type_amplua(
	amplua_type varchar(50) primary key
);
-- 22. Отношение AMPLUA (амплуа)
create table amplua(
	person_id numeric(4) not null references portfolio,
	amplua varchar(50) not null references type_amplua
);
-- 23. Отношение ADDRESS (адрес)
create table address(
	person_id numeric(4) not null references portfolio,
	address varchar(50) not null
);
-- 24. Отношение TYPE_JOBS (Справочник Должности)
create table type_jobs(
	job_type varchar(40) primary key,
price numeric(6) not null constraint check_price_job check(price > 0)
);
-- 25. Отношение JOBS (Должности)
create table jobs(
	person_id numeric(4) not null references portfolio,
	job varchar(40) not null references type_jobs,
date_first date not null constraint check_date_job check(date_first <= current_date),
date_last date 
);

-- Начальный состав для справочных таблиц: 
insert into genres values ('драма'), ('комедия'), ('мелодрама'), ('трагедия'), ('мистерия'), ('монодрама'), ('мюзикл');

insert into status_play values('on'), ('off'), ('pr');

insert into areas values ('балкон', 10), ('ложа', 30), ('бельэтаж', 40), ('амфитеатр', 60), ('партер', 80);

insert into halls values ('Зал 1'), ('Зал 2'), ('Зал 3');

insert into status_ticket values('on'), ('off');
		  
insert into type_jobs values ('актер первого плана', 50000),
('актер второго плана', 30000), 
('дублер', 11000);

insert into type_amplua values ('наперсница'),
('герой'),
('любовница');

insert into type_rewards values('Золотая маска'), ('Гвоздь сезона'), ('Признание'), ('Грани театра масс'), ('Тони');


-- Примеры готовых запросов - представлений:
-- 1. Список всех спектаклей, которые сейчас идут (удобное представление для пользователя):
create or replace view current_plays as
select * from plays where play_status = 'on'
order by 2;

-- 2. Сумма всех зарплат актеров первого плана (удобное представление для экономиста):
create or replace view salary_first_actors as
	select sum(price) from portfolio, jobs
	where portfolio.job = jobs.job and
jobs.job = 'актер первого плана';
select * from salary_first_actors;

-- 3. Данные актеров, играющих в текущих спектаклях (удобное представление для пользователя, худ. директора и экономиста):
create or replace view actors_curr_plays as
select portfolio.*, plays.play_name from portfolio, plays, casts, shows
where plays.play_status ='on'
and plays.play_id = shows.play_id
and shows.show_id = casts.show_id
and casts.actor_id = portfolio.person_id;
-- 4. Все сотрудники, работающие в театре на данный момент (удобное представление для пользователя, экономиста, худ. директора и директора):
      create or replace view curr_personnel as
      select portfolio.person_id, portfolio.surname, portfolio.name_patr, jobs.job, jobs.date_first from jobs, portfolio
      where portfolio.person_id = jobs.person_id and jobs.date_last is null;
-- 5. Актеры, также являющиеся и режиссерами (удобное представление для пользователя):
create or replace view actors_and_directors as
select portfolio.person_id, portfolio.surname, portfolio.name_patr, plays.play_name, plays.descr 
from portfolio, directorship, plays
where portfolio.person_id = directorship.director_id and directorship.play_id = plays.play_id;
