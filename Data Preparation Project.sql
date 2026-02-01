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

--transform column name to recognize values
EXEC sp_rename 'MUNICIPALITY_RAW.1988','Y1988', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1990','Y1990', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1989','Y1989', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1991','Y1991', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1992','Y1992', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1993','Y1993', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1994','Y1994', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1995','Y1995', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1996','Y1996', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1997','Y1997', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1998','Y1998', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.1999','Y1999', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2000','Y2000', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2001','Y2001', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2002','Y2002', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2003','Y2003', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2004','Y2004', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2005','Y2005', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2006','Y2006', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2007','Y2007', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2008','Y2008', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2009','Y2009', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2010','Y2010', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2011','Y2011', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2012','Y2012', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2013','Y2013', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2014','Y2014', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2015','Y2015', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2016','Y2016', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2017','Y2017', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2018','Y2018', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2019','Y2019', 'COLUMN';
EXEC sp_rename 'MUNICIPALITY_RAW.2020','Y2020', 'COLUMN';
