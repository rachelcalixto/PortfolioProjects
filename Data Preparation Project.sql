/* Dataset source

https://data.gov.ph/index/public/resource/commission-of-filipino-overseas:-statistical-profile-of-registered-filipino-emigrants-%5B1981-2020%5D-/number-of-registered-filipino-emigrants-by-place-of-origin-in-the-philippines:-1988-2020/w3fgcanp-4ci6-36uv-ny9r-pvq0dwlyxl9x

*/
-- This is the base data. Removed null rows thru Excel before importing to SQL Server
Select * from FilipinoEmigrants..MUNICIPALITY_RAW;
--
-------------------------------------------------
--Create a reference table for Province
CREATE TABLE [dbo].[PROVINCE](
	[province_code] [nvarchar](50) NULL,
	[province_name] [nvarchar](50) NULL
);


--Create a reference table for Municipality
create table MUNICIPALITY
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	municipality_name varchar(100) not null,
	province_code varchar(50) not null
);


-- Populate Province Reference Table
insert into FilipinoEmigrants..PROVINCE
select distinct id, municipality from FilipinoEmigrants..MUNICIPALITY_RAW where total is null;


-- Populate Municipality Reference Table
insert into FilipinoEmigrants..MUNICIPALITY (municipality_name,province_code)
select distinct municipality, id  from FilipinoEmigrants..MUNICIPALITY_RAW where 
total is not null;


-- Data Clean-up to group Municipality per Province
-- Note that province_code is used as the unique code in Province Table
update FilipinoEmigrants..MUNICIPALITY
set province_code = '037100' where municipality_name = 'SUBIC, (ZAMBALES)';

update FilipinoEmigrants..MUNICIPALITY
set province_code = '973600' 
where municipality_name = 'MARANTAO, (LANAO DEL SUR)' or municipality_name ='MARAWI CITY';

update FilipinoEmigrants..PROVINCE set province_name = 'NCR, FIRST DISTRICT'
WHERE province_code = '993900';

update FilipinoEmigrants..MUNICIPALITY
set province_code = '993900'
WHERE municipality_name like '%NCR, FIRST DISTRICT%';

update FilipinoEmigrants..MUNICIPALITY
set province_code = '997400'
where municipality_name like '%SECOND DISTRICT%';

insert into FilipinoEmigrants..PROVINCE (province_code, province_name) 
values ('997400','NCR, SECOND DISTRICT');

update FilipinoEmigrants..MUNICIPALITY
set province_code = '997500'
where municipality_name like '%THIRD DISTRICT%';

insert into FilipinoEmigrants..PROVINCE (province_code, province_name) 
values ('997500','NCR, THIRD DISTRICT');

update FilipinoEmigrants..MUNICIPALITY
set province_code = '997600'
where municipality_name like '%FOURTH DISTRICT%';

insert into FilipinoEmigrants..PROVINCE (province_code, province_name) 
values ('997600','NCR, FOURTH DISTRICT');

insert into FilipinoEmigrants..PROVINCE (province_code, province_name) 
values ('0','OTHERS');

--Data validation

-- assign new code for duplicate province_code
SELECT PROVINCE_CODE, COUNT(*)  from FilipinoEmigrants..PROVINCE
GROUP BY PROVINCE_CODE HAVING COUNT(*) > 1;
/* 101300	BUKIDNON
101300	ZAMBOANGA SIBUGAY */
update FilipinoEmigrants..PROVINCE
set province_code = '101301' where province_name = 'ZAMBOANGA SIBUGAY';

update FilipinoEmigrants..MUNICIPALITY
set province_code = '101301' 
where municipality_name like '%ZAMBOANGA SIBUGAY%';

select count (distinct province_code) from FilipinoEmigrants..MUNICIPALITY; --83
select count (*) from FilipinoEmigrants..PROVINCE; --83

----Data values of Emigrant

create table EMIGRANT
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	municipality_id INT not null,
	emigrant_year VARCHAR(50) not null,
	emigrant_count INT not null
);
