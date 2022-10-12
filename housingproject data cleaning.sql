select * 
from project.dbo.NH

--standardize date format

alter table project.dbo.NH
add SaleDateConverted date;

update project.dbo.NH
set SaleDateConverted=CONVERT(Date,SaleDate)

--populate property address data

select PropertyAddress
from project.dbo.NH
where PropertyAddress is null;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from project.dbo.NH a
join project.dbo.NH b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from project.dbo.NH a
join project.dbo.NH b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]


--split address into individual columns (address,city,state)

select Propertyaddress
from project.dbo.NH

        --split PropertyAddress

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress)) as city
from project.dbo.NH

        --update propAddress

alter table project.dbo.NH
add propAddress nvarchar(255);

update project.dbo.NH
set propAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',' ,PropertyAddress)-1) 

        --update Propcity

alter table project.dbo.NH
add Propcity nvarchar(255);

update project.dbo.NH
set Propcity =SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress)+1,LEN(PropertyAddress)) 


      --split owneraddress

select OwnerAddress
from project.dbo.NH

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from project.dbo.NH

      --update OwnerAdd

alter table project.dbo.NH
add OwnerAdd nvarchar(255)

update project.dbo.NH
set OwnerAdd=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

       
      --update OwnerCity

alter table project.dbo.NH
add OwnerCity nvarchar(255)

update project.dbo.NH
set OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

      --update OwnerCity

alter table project.dbo.NH
add OwnerState nvarchar(255)

update project.dbo.NH
set OwnerState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--change Y and N to Yes and No in SoldAsVacant field

select distinct(SoldAsVacant),count(SoldAsVacant)
from project.dbo.NH
group by SoldAsVacant

select SoldAsVacant,
 case when SoldAsVacant ='Y' then 'Ýes'
      when SoldAsVacant ='N' then 'No'
  else
  SoldAsVacant
  end
  from project.dbo.NH

    -- update SoldAsVacant

update project.dbo.NH
set SoldAsVacant= case when SoldAsVacant ='Y' then 'Ýes'
      when SoldAsVacant ='N' then 'No'
  else
  SoldAsVacant
  end
  

  --remove duplicate

WITH CTE as(
select *,
  ROW_NUMBER() over (
  partition by parcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
  order by uniqueID )as row_nm
from project.dbo.NH
)
DELETE
from CTE
where row_nm>1

--delete unused column

select * from project.dbo.NH

ALTER TABLE project.dbo.NH
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate