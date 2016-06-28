/* drop part */
/*drop index usrs_lck;
drop index usrs_author;
drop index game_enab;
drop table logons;
drop table rating;
drop table score;
drop table comments;
drop table game;
drop table usrs;
drop sequence usrid_seq;
drop sequence gameid_seq;
drop sequence comid_seq;
drop sequence logid_seq;

drop view u01;
drop view u02;
drop view u03;
drop view u04;
drop view u05;
drop view u06;
drop view u07;
drop view u08;
drop view u09;
drop view u10;
drop view u10_absolute;
drop view u11;
drop view u12;
drop view u13;
drop view u14;
drop view u15;
drop view u16_bannedusers;
drop view u17_bestauthorgame;


/** create of database structure */
create sequence usrid_seq start with 1 increment by 1;
create sequence gameid_seq start with 1 increment by 1;
create sequence comid_seq start with 1 increment by 1;
create sequence logid_seq start with 1 increment by 1;

/* as a base, we dont need to create indexes primary, foreign and unique (already indexed) */

create table usrs (
  usrid integer default null,
  uname varchar2(20) unique not null, 
  pwd varchar2(32) not null, /* an digest can be used to save safest password*/ 
  email varchar2(256) unique not null,
  dat date default current_timestamp, 
  isauthor varchar2(1) default 'N' check (isauthor in ('Y', 'N')), /* this flag told, the autor can add games into a studio */ 
  lck varchar2(1) default 'N' check (lck in ('Y', 'N')), /* this flag told, an account is locked by administrator of studio */
  primary key (usrid)
);

create index usrs_lck ON usrs (lck);
create index usrs_author ON usrs (isauthor);

create table logons (
  logid integer,
  usrid integer,
  ipv4 varchar(15) not null,
  ontime timestamp default current_timestamp,
  action varchar(1) default 'B' check (action in ('B', 'L', 'S')), /* Bad passw, Locked, Succes */
  primary key (logid),
  foreign key (usrid) references usrs(usrid) on delete set null
);

create table game (
  gameid INTEGER,
  gname varchar2(20) unique not null, /** Game name */
  author integer default NULL, /*it can be an id from another table (eg user with flag author)*/
  dat date default current_timestamp, /* can be an date + time */
  surl varchar(255) not null, /** an shorted url without hostname (FQDN)*/
  enab varchar2(1) default 'Y' check (enab in ('Y', 'N')), /* game enabled */
  primary key(gameid),
  foreign key (author) references usrs(usrid) on delete set null
);

create index game_enab ON game (enab);

create table score (
  usrid integer,
  gameid integer,
  dat date default current_timestamp,
  score integer not null check (score >0),
  foreign key (usrid) references usrs(usrid) on delete set null,
  foreign key (gameid) references game(gameid) on delete set null
);

create table rating (
  usrid integer, 
  gameid integer, 
  dat date default current_timestamp,
  rating integer not null check (rating >0 and rating<6),
  primary key (usrid, gameid),
  foreign key (usrid) references usrs(usrid) on delete set null,
  foreign key (gameid) references game(gameid) on delete set null
);

create table comments (
  comid integer, 
  usrid integer,
  gameid integer,
  dat date default current_timestamp,
  msg varchar2(255) not null check (length(msg)>0),
  primary key (comid), 
  foreign key (usrid) references usrs(usrid) on delete set null,
  foreign key (gameid) references game(gameid) on delete set null
);

/**
  INSERTS per user
  we use sequences for primary keys, but, it can be dangeous (in import)
*/
insert into usrs (usrid, uname, pwd, email, isauthor, dat) 
  values (usrid_seq.nextval, 'dalik', '1234', 'dalik@gamecenter.localhost','Y', '1.1.2015');
  
    insert into logons (LOGID, USRID, ipv4, action)
      values(logid_seq.nextval, usrid_seq.currval, '192.168.0.7', 'B');

    insert into logons (LOGID, USRID, ipv4, action)
      values(logid_seq.nextval, usrid_seq.currval, '192.168.0.7', 'B');
      
    insert into logons (LOGID, USRID, ipv4, action)
      values(logid_seq.nextval, usrid_seq.currval, '192.168.0.87', 'S');
  

insert into usrs (usrid, uname, pwd, email) 
  values (usrid_seq.nextval, 'jozi', '1234', 'jozi@gamecenter.localhost');
  
    insert into logons (LOGID, USRID, ipv4, action)
      values(logid_seq.nextval, usrid_seq.currval, '192.16.5.4', 'L');
    insert into logons (LOGID, USRID, ipv4, action)
      values(logid_seq.nextval, usrid_seq.currval, '192.7.8.9', 'S');
  
insert into usrs (usrid, uname, pwd, email) 
  values (usrid_seq.nextval, 'velaznako', '1234', 'znako@gamecenter.localhost');
  
insert into usrs (usrid, uname, pwd, email, isauthor, lck) 
  values (usrid_seq.nextval, 'billy', '1234', 'billy@gamecenter.localhost', 'Y', 'Y');

    insert into logons (LOGID, USRID, ipv4, action)
      values(logid_seq.nextval, usrid_seq.currval, '192.168.4.2', 'B');

/* 
  inserts games
*/
insert into game (gameid, author, gname, surl, dat) 
  values (gameid_seq.nextval, 1, 'Y2K', '/games/Y2K/', '1.1.2000');

insert into game (gameid, author, gname, surl, dat) 
  values (gameid_seq.nextval, 1, 'Mines', '/games/mines/', '1.1.1995');

insert into game (gameid, gname, author, surl, dat) 
  values (gameid_seq.nextval, 'WonXP2', 4, '/games/XP_SP2/', '30.6.2002');

insert into game (gameid, gname, author, surl, dat) 
  values (gameid_seq.nextval, 'Commander Ken', 4, '/games/KENNY/', '12.4.1992');

insert into game (gameid, gname, author, surl) 
  values (gameid_seq.nextval, 'Mario fall', 1, '/games/mariofall/');
  
/* insert comments */
insert into comments (comid, gameid, usrid, msg, DAT) 
  VALUES (comid_seq.nextval, 1,1, 'Super hra ;)', '1.1.1994');

insert into comments (comid, gameid, usrid, msg) 
  VALUES (comid_seq.nextval, 2,2, 'neviem ako sa to hra :-(');

insert into comments (comid, gameid, usrid, msg) 
  VALUES (comid_seq.nextval, 2,2, 'aach :-/');
  
insert into comments (comid, gameid, usrid, msg) 
  VALUES (comid_seq.nextval, 3,3, 'keèup');
  
insert into comments (comid, gameid, usrid, msg) 
  VALUES (comid_seq.nextval, 4,3, 'horèica');

insert into comments (comid, gameid, usrid, msg) 
  VALUES (comid_seq.nextval, 1,3, 'mak');

insert into comments (comid, gameid, usrid, msg) 
  VALUES (comid_seq.nextval, 2,3, 'rub¾a');

insert into rating  (usrid, gameid, rating)
  values (1,1,5);

insert into rating  (usrid, gameid, rating)
  values (1,2,3);

insert into rating  (usrid, gameid, rating)
  values (2,2,1);

insert into rating  (usrid, gameid, rating)
  values (2,3,2);

insert into rating  (usrid, gameid, rating)
  values (1,3,3);
  
insert into score (usrid, gameid, score) 
    values(1,1,100);

insert into score (usrid, gameid, score) 
    values(1,1,200);
    
insert into score (usrid, gameid, score) 
    values(3,1,50);

insert into score (usrid, gameid, score) 
    values(3,1,20);

/** views */
create or replace view U01 as 
  select * from usrs order by DAT ASC;

create or replace view U02 as 
  select game.*, usrs.uname as authorname from game join USRS on USRS.USRID = game.AUTHOR;

create or replace view U03 as 
  select c.comid, c.dat, c.msg, u.USRID, u.UNAME, g.GAMEID, g.GNAME from comments c join usrs u on u.USRID = c.USRID join game g on g.GAMEID = c.GAMEID;

create or replace view U04 as 
  select * from usrs where length(usrs.uname) = (select MAX(length(usrs.uname)) from usrs);
  
create or replace view U05 as 
  select game.*, 'Y' as nonplayed from game where not exists (select 1 from score where score.GAMEID = game.gameid);
  
create or replace view U06 as
  SELECT usrs.* FROM usrs left join rating on rating.USRID = usrs.USRID where rating.RATING is null;
  
create or replace view U07 as  
  select usrs.* from usrs where not exists (Select 1 from rating where rating.gameid = 1 and usrs.usrid = rating.gameid);

create or replace view U08 as
  select 
    (select count(*) from game) as gamecount, 
    (select count(*) from usrs) as usercount, 
    (select count(*) from comments) as commentcount, 
    (select count(*) from rating) as ratingcount
  from dual;
  
create or replace view U09 as 
  select game.*, usrs.uname as authorname from game 
  join usrs on game.AUTHOR = usrs.USRID
  where game.dat = (select min(dat) from game);
    
create or replace view U10 as 
select rating.gameid, count(rating.gameid) as numratings, avg(rating.rating) as avgrating, u02.gname, u02.AUTHORNAME, u02.AUTHOR
  from rating
  join u02 on rating.GAMEID = u02.GAMEID
  group by rating.gameid, u02.gname, u02.AUTHORNAME, u02.AUTHOR;
  
create or replace view U10_absolute as  /* used to compare overal ratings by games */
select rating.gameid, count(rating.gameid) as numratings, (sum(rating.rating) / (Select count(*) from rating)) as absrating, u02.gname, u02.AUTHORNAME, u02.AUTHOR
  from rating
  join u02 on rating.GAMEID = u02.GAMEID
  group by rating.gameid, u02.gname, u02.AUTHORNAME, u02.AUTHOR;

create or replace view U11 as
  select comments.gameid, count(comments.gameid) as commentcount, game.gname
  from comments
  join game on game.gameid = comments.gameid
  group by comments.gameid, game.gname;
  
create or replace view U12 as
  select score.usrid, count(score.usrid) as plays, sum(score.score) as totscore, usrs.uname
  from score
  join usrs on score.USRID = usrs.USRID
  group by score.usrid, usrs.uname;

  
create or replace view U13 as
  select usrs.* 
  from usrs
  where usrs.USRID in (select score.usrid from score where score.dat = (select max(score.dat) from score));

create or replace view U14 as
  select game.gname, comments.gameid, count(*) as numcomments 
  from comments
  join game on game.GAMEID = comments.GAMEID
  where comments.gameid in (select gameid from u10 where u10.AVGRATING = (select max(u10.avgrating) from u10))
  group by comments.GAMEID, game.gname;
  
create or replace view U15 as 
  select comments.usrid, comments.gameid, count(comments.msg) as numcomments, 
    usrs.uname, game.gname
  from  comments
  join usrs on usrs.usrid = comments.usrid
  join game on game.gameid = comments.gameid
  group by comments.usrid, comments.gameid, usrs.uname, game.gname
  order by uname, gname, numcomments;
  
create or replace view U16_bannedusers as /* select users with denied login */
  select * from usrs where lck = 'Y';
  
create or replace view U17_bestauthorgame as /* select best author by abolute score */
  select AUTHORNAME from u10_absolute where absrating = (select max(absrating) from u10_absolute);
  
create or replace view U18_badlogonsperuser as 
  select logons.usrid, count(*) as badcount, usrs.uname 
  from logons 
  join usrs on usrs.usrid = logons.usrid
  where action = 'B'
  group by logons.usrid, usrs.uname;
  
  
  /** and mooore and moooore */