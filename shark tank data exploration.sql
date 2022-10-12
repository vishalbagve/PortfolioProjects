select * from project..data

--total episode

select count(distinct EpNo) from project..data

--total pitches 

select count(distinct Brand) from project..data

--pitches converted

select count( AmountInvestedlakhs) from project..data
where AmountInvestedlakhs>0;

--total male

select sum(Male) total_male from project..data total_male

--total female

select sum(Female)total_female from project..data

--Gender ratio

select sum(Female)/sum(Male) from project..data

--total invested amount

select sum(AmountInvestedlakhs) from project..data

--avg equity taken 

select avg(EquityTaken) from project..data 
where EquityTaken>0

--highest deal taken

select max(AmountInvestedlakhs) from project..data

--highest equity taken

select max(EquityTaken) from project..data

--at least one female in pitch

select count( Brand) from project..data
where Female>0

--avg team member

select avg(Teammembers) from project..data

--avg amount invested per deal
select avg(a.AmountInvestedlakhs) avg_amt_perdeal from
(select * from project..data where Deal!='No deal')a

--avgage group of contenstants

select avgage,count(avgage) cnt from project..data group by avgage order by cnt desc 

--location group of contenstants

select Location,count(Location) cnt from project..data group by Location order by cnt desc

--sector group of contenstants

select Sector,count(sector)cnt from project..data where sector!='null' group by sector order by cnt desc

--partners deals

select partners,count(partners)partners_deals from project..data where partners!='-' group by partners order by partners_deals desc

--aman investement details

select count(Amanamountinvested) from project..data where Amanamountinvested is not null

select count(Amanamountinvested) from project..data where Amanamountinvested is not null and Amanamountinvested>0

select sum(Amanamountinvested),avg(AmanEquitytaken) from project..data where  Amanamountinvested  is not null AND Amanamountinvested >0


--joining above two query

(select a.name,a.total_deal_aman_present,b.total_deal from 
(select 'aman' as name, count(Amanamountinvested) as total_deal_aman_present from project..data where Amanamountinvested is not null)a
inner join
(select 'aman' as name ,count(Amanamountinvested)as total_deal from project..data where Amanamountinvested is not null and Amanamountinvested>0)b
on a.name=b.name)

--joining above three query

select c.name,c.total_deal_aman_present,c.total_deal,d.total_amt_invested,d.avg_equity_taken from
(select a.name,a.total_deal_aman_present,b.total_deal from 
(select 'aman' as name, count(Amanamountinvested) as total_deal_aman_present from project..data where Amanamountinvested is not null)a
inner join
(select 'aman' as name ,count(Amanamountinvested)as total_deal from project..data where Amanamountinvested is not null and Amanamountinvested>0)b
on a.name=b.name)c

inner join

(select 'aman' as name,sum(Amanamountinvested) total_amt_invested,avg(AmanEquitytaken) avg_equity_taken from project..data where  Amanamountinvested  is not null AND Amanamountinvested >0)d

on c.name=d.name

--startup get  amount invested in each sector

select Brand,sector,AmountInvestedlakhs,rank() over(partition by sector order by AmountInvestedlakhs desc) rnk
from project..data 

--which startup get highest amount invested in each sector
select a.* from
(select Brand,sector,AmountInvestedlakhs,rank() over(partition by sector order by AmountInvestedlakhs desc) rnk
from project..data)a
where a.rnk=1