DROP SEQUENCE recipes_seq;
DROP SEQUENCE book_author_seq;
DROP SEQUENCE book_seq;
DROP SEQUENCE publication_seq;
DROP SEQUENCE author_work_seq;
DROP SEQUENCE recipe_text_seq;
drop sequence author_work_chapter_seq;
drop table RECIPE_TEXT;
drop table RECIPES;
drop table AUTHOR_WORK;
drop table BOOK_AUTHOR;
drop table PUBLICATION;
drop table BOOK;

create table recipes(
    id              int not null,
    recipe_number   varchar(10) not null,
    recipe_name     varchar(100) not null,
    description     varchar(500),
    text            clob,
    constraint recipes_pk primary key (id) enable
);

create sequence recipes_seq start with 1 increment by 1;
-- derby syntax
alter table recipes add constraint recipes_number_nn check (recipe_number is not null);

insert into recipes values(recipes_seq.nextVal,'13-1','Connecting to a Database','DriverManager and DataSource Implementations','Recipe Text');
insert into recipes values(recipes_seq.nextVal,'13-2','Querying a Database and Retrieving Results','Obtaining and using data from a DBMS','Recipe Text');
insert into recipes values(recipes_seq.nextVal,'13-3','Handling SQL Exceptions','Using SQLException','Recipe Text');

create table book_author(
id          int primary key,
lastname        varchar(30),
firstname       varchar(30));

create sequence book_author_seq
start with 1
increment by 1;

create table book(
id          int primary key,
title       varchar(150),
image       varchar(150),
description clob);

create sequence book_seq
start with 1
increment by 1;

insert into book values(book_seq.nextVal,'Java 8 Recipes','java8recipes.png','Learn about solving real-world problems with Java 8');
insert into book values(book_seq.nextVal,'Java EE 7 Recipes','javaee7recipes.png','Learn about solving real-world problems with Java EE 7');
insert into book values(book_seq.nextVal,'Introducing Java EE 7','introjavaee7recipes.png','Learn about all of the new features included in Java EE 7');
insert into book values(book_seq.nextVal,'Java 7 Recipes','java7recipes.png','Learn about solving real-world problems with Java 7');
insert into book values(book_seq.nextVal,'Java FX 2.0 - Introduction by Example','javafx2.png','Learn about solving real-world problems with JavaFX');

create table publication(
id              int primary key,
author_id       int not null,
book_title      varchar(500) not null,
publish_date    date,
publish_co      varchar(100));

create sequence publication_seq
start with 1
increment by 1;


create table author_work(
id              int primary key,
author_id       int not null,
chapter_number  int not null,
chapter_title   varchar(100) not null,
constraint author_work_fk
foreign key(author_id) references book_author(id));

create sequence author_work_seq
start with 1
increment by 1;

create sequence author_work_chapter_seq
start with 1
increment by 1;

insert into book_author values(book_author_seq.nextVal,'JUNEAU','JOSH');
insert into book_author values(book_author_seq.nextVal,'DEA','CARL');
insert into book_author values(book_author_seq.nextVal,'BEATY','MARK');
insert into book_author values(book_author_seq.nextVal,'GUIME','FREDDY');
insert into book_author values(book_author_seq.nextVal,'OCONNER','JOHN');

insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'JUNEAU'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java 8 Recipes'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'JUNEAU'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java 7 Recipes'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'JUNEAU'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java EE 7 Recipes'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'JUNEAU'),author_work_chapter_seq.nextVal,(select id from book where title = 'Introducing Java EE 7'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'GUIME'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java 7 Recipes'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'DEA'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java 7 Recipes'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'OCONNER'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java 7 Recipes'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'BEATY'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java 7 Recipes'));
insert into author_work values(author_work_seq.nextVal,(select id from book_author where lastname = 'DEA'),author_work_chapter_seq.nextVal,(select id from book where title = 'Java FX 2.0 - Introduction by Example'));

insert into publication values (publication_seq.nextVal,(select id from book_author where lastname = 'JUNEAU'),'Java EE 7 Recipes',to_date('2013-05-01','YYYY-MM-DD'),'APRESS');
insert into publication values (publication_seq.nextVal,(select id from book_author where lastname = 'JUNEAU'),'Introducing Java EE 7',to_date('2013-07-01','YYYY-MM-DD'),'APRESS');

create table recipe_text (
id              int primary key,
recipe_id       int not null,
text            clob,
constraint recipe_text_fk
foreign key (recipe_id)
references recipes(id));

create sequence recipe_text_seq
start with 10
increment by 1;

delimiter /
create or replace procedure dummy_proc (text IN VARCHAR2,text OUT VARCHAR2) as
begin
    msg :=text;
end;
/
delimiter ;
