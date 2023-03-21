--This is an  EDA of a property dataset aiming to uncover patterns within the real estate market in these cities

-- Begin with data cleaning
-- converting datetime to date 
--( the update didnt work so altered the table to add new coln then updated w the same convert(date,saledate) and it worked)
select SaleDate, CONVERT(date, saledate)
from nashvillehousing

update nashvillehousing
set saledate = CONVERT(date, saledate)

alter table  nashvillehousing 
add saledateconverted date

update nashvillehousingS
set saledateconverted = CONVERT(date, saledate)

select * from nashvillehousing 

select ParcelID,PropertyAddress
from nashvillehousing as housing
where propertyaddress is null

select a.ParcelID,a.PropertyAddress, b.parcelid,b.PropertyAddress , ISNULL(a.propertyaddress,b.PropertyAddress)
from [Portfolio Project].[dbo].[NashvilleHousing]  a
join  [Portfolio Project].[dbo].[NashvilleHousing]  b 
on  a.ParcelID = b.ParcelID
and a.[UniqueID ] <>b.[UniqueID ] 


--having updated null rows in propaddress using selfjoin above query no longer finds nulls so its succesful
update a
set PropertyAddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from [Portfolio Project].[dbo].[NashvilleHousing]  a
join  [Portfolio Project].[dbo].[NashvilleHousing]  b 
on  a.ParcelID = b.ParcelID
and a.[UniqueID ] <>b.[UniqueID ] 
where a.PropertyAddress is null

--seperating address data to make it more suitable for analysis
select SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as  Address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as city
from [Portfolio Project].[dbo].[NashvilleHousing]

--having seperated address &city alter table to accomodate new values and update w our query to insert said values into table permanently
alter table nashvillehousing
add address nvarchar(255)

update NashvilleHousing
set address= SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) 


alter table nashvillehousing
add city nvarchar(255)

update NashvilleHousing
set city = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

select
Parsename(REPLACE(OwnerAddress,',','.'),1),
Parsename(REPLACE(OwnerAddress,',','.'),2),
 Parsename(REPLACE(OwnerAddress,',','.'),3)
from NashvilleHousing

alter table nashvillehousing
add ownerstate varchar (255)

alter table nashvillehousing
add owner_street varchar (255)

alter table nashvillehousing
add owner_address_split varchar (255)

update  nashvillehousing
set ownerstate = Parsename(REPLACE(OwnerAddress,',','.'),2)

update nashvillehousing
set owner_street = PARSENAME(replace(owneraddress,',','.'),3)

update nashvillehousing
set owner_address_split = PARSENAME(replace(owneraddress,',','.'),1)

-- confirm updates effected
select *
from NashvilleHousing

select COUNT(address) as Total_No_of_properties
from NashvilleHousing


--change Y and N to yes & no
select distinct(soldasvacant),COUNT(soldasvacant) as No_of_responses
from NashvilleHousing
group by SoldAsVacant
order by 2

select soldasvacant ,
case
when SoldAsVacant='y' then 'Yes'
when SoldAsVacant  = 'n' then 'no'
else SoldAsVacant
end as House_State 
from NashvilleHousing
group by soldasvacant

update NashvilleHousing 
set SoldAsVacant =
case
when SoldAsVacant='y' then 'Yes'
when SoldAsVacant  = 'n' then 'no'
else SoldAsVacant
end 

create view Home_Status 
as select SoldAsVacant, count(soldasvacant) as Count_Of_Home_Status
from NashvilleHousing
group by SoldAsVacant
select * from Home_Status

--Store no of homes bought as empty ina view Home_Status 
--over 90% of homes were bought while occupied

WITH DuplicateCount AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)


select *
From DuplicateCount
Where row_num > 1
order by PROpertyaddress

delete 
From DuplicateCount
Where row_num > 1

--selected DuplicateCount then deleted then select again to confirm its done 

--delete unwanted columns
select * from NashvilleHousing

alter table nashvillehousing
drop column owneraddress,propertyaddress


alter table nashvillehousing
drop column saledate


-- Carrying out exploratory data analysis 

select COUNT(uniqueid) as TotalNumberOfProperties
from NashvilleHousing

select city, count(city) as Properties_Spread
from NashvilleHousing
group by  (city)
order by count(city) desc

-- just seeing spread of properties across cities 
-- Nashville with 71.33911624% of all properties across 13 cities

select LandUse,AVG(saleprice) as Average_Price
from NashvilleHousing
group by LandUse
order by Average_Price desc
--Groupings Of what land is used for

select avg(saleprice) as Avg_Property_Price
from NashvilleHousing

select TaxDistrict,count(TaxDistrict) as TaxDistricts_Property_Count
from NashvilleHousing
group by TaxDistrict
order by TaxDistricts_Property_Count desc

select sum(saleprice) as Total_Value
from NashvilleHousing
-- Woah! Total PropertyValue coming in at over 18Billion

select a.[UniqueID ] ,b.[UniqueID ],a.address,b.address from NashvilleHousing a
join NashvilleHousing b
on a.[UniqueID ]=b.[UniqueID ]
where a.[UniqueID ]<>b.[UniqueID ]
and a.address=b.address
-- ok so properties are only sold once . none were sold multiple times 


select TaxDistrict,sum(SalePrice) as PropertyValue,COUNT(uniqueid) as NumberOfProperties
from NashvilleHousing
group by TaxDistrict
order by PropertyValue desc

select TaxDistrict,sum(SalePrice)/COUNT(uniqueid) as AveragePropertyValue
from NashvilleHousing
group by TaxDistrict
order by  AveragePropertyValue desc

drop table if exists #DuplicateWatch
create table #DuplicateWatch
(address varchar(255),uniqueid int,SalePrice int,SaleDateConverted date,LegalReference nvarchar(255),row_num int)

insert into #DuplicateWatch
Select address,[UniqueID ], saleprice,saledateconverted,legalreference,
	ROW_NUMBER() OVER (
	PARTITION BY Address,
				 SalePrice,
				 SaleDateconverted,
				 LegalReference,
				 ParcelID
				 ORDER BY
					UniqueID
					) row_num
From NashvilleHousing

select count(*) from #DuplicateWatch as duplicates
where row_num>1

delete  from #DuplicateWatch
where row_num>1

-- searched for duplicate buildings made sure theyre same as have same of diff colns
--56373 total 888 duplicates found &deleted


select *,
case 
when saledateconverted like '%2013%' then 2013
end as Yearly_Sales 
from NashvilleHousing
order by saledateconverted
-- no need thought of a better way

select saledateconverted,LEFT(saledateconverted,4)as saleyear
from NashvilleHousing
group by saledateconverted 
order by saleyear desc

alter table nashvillehousing
add SaleYear int

update NashvilleHousing
set saleyear = LEFT(saledateconverted,4)

select * from NashvilleHousing
-- ok change effected now we can group by year 


select distinct (YearBuilt),COUNT(yearbuilt) Buildings_Built
from NashvilleHousing
group by YearBuilt
order by Buildings_Built desc
-- most buildings built in 1930-1960 with 1950 the peak with 1153

with Timeperiods as (
select distinct (YearBuilt),COUNT(yearbuilt) Buildings_Built ,
CASE 
when YearBuilt between 1799 and 1899 then '19th_century' 
when YearBuilt between 1900 and 1999 then '20th_century'
else '21st_century'
end as Timeperiods
from NashvilleHousing
group by YearBuilt
--order by YearBuilt desc
)
select Timeperiods, sum(buildings_built) as Buildings_Built
from Timeperiods 
group by Timeperiods
order by Timeperiods
-- 20th century peak time for raising buildings by far

create view BuildingEra as
select distinct (YearBuilt),COUNT(yearbuilt) Buildings_Built ,
CASE 
when YearBuilt between 1799 and 1899 then '19th_century' 
when YearBuilt between 1900 and 1999 then '20th_century'
else '21st_century'
end as Timeperiods
from NashvilleHousing
group by YearBuilt
--order by YearBuilt desc
select * from BuildingEra

select BuildingEra ,COUNT(BuildingEra) as count
from BuildingEra
group by BuildingEra
-- having tested in temp table applying to main dataset
select * from nashvillehousing
  Buildingera


 update nashvillehousing
 set buildingera =
case 
when YearBuilt between 1799 and 1899 then '19th_century' 
when YearBuilt between 1900 and 1999 then '20th_century'
else '21st_century'
end

select BuildingAge,COUNT(buildingage) as Count
from nashvillehousing
group by BuildingAge

select *
from nashvillehousing

select  BuildingAge,sum(SalePrice) as Total,count(BuildingAge) as Count_Of_Buildings
from NashvilleHousing
group by buildingAge
-- old buildings cost the most but then theyre the most sha so distorted

select  BuildingAge, avg(SalePrice) as Average_Price,count(BuildingAge) as Count_Of_Buildings
from NashvilleHousing
group by buildingAge
order by Average_Price desc
-- old buildings way way more than new and so avg price distorted

select distinct(ownername),count(ownername) over (partition by ownername) NumberOfPropertiesOwned
from NashvilleHousing
where OwnerName is not null
order by  NumberOfPropertiesOwned desc
-- Owners with most properties

select address,bedrooms,SalePrice
from NashvilleHousing
order by SalePrice

select min(saleprice)
from nashvillehousing
-- error of some type prolly all these really low ones 

select distinct(LandUse),COUNT(landuse) over (partition by Landuse) as Count,avg(saleprice) over (partition by Landuse) as Avg_Price
from nashvillehousing
order by Avg_Price desc
-- different land types and their average prices 
-- bedrooms null value need to sort select distinct(LandUse),COUNT(landuse) over (partition by Landuse) as No_of_Buildings,avg(saleprice) over (partition by Landuse) as Avg_Price,Bedrooms from nashvillehousing order by Avg_Price  

select ownername,COUNT(ownername),sum(Acreage) as Properties_size
 from NashvilleHousing 
 group by  OwnerName 
order by Properties_size desc
--largest property owners 

select OwnerName,count(OwnerName) as Properties_owned,sum(Acreage) as Properties_size
from NashvilleHousing
group by  OwnerName 
order by Properties_owned desc

-- those who own most properties mostly corporations,some individuals also .

with Apartment_type as( 
Select distinct(Bedrooms),case
when Bedrooms=1 then '1 bedroom'
when Bedrooms=2 then '2 bedroom '
when Bedrooms=3 then '3 bedroom '
when Bedrooms=4 then '4 bedroom '
when Bedrooms=5 then '5 bedroom '
when Bedrooms=6 then '6 bedroom '
when Bedrooms=7 then '7	bedroom '
when Bedrooms=8 then '8 bedroom '
when Bedrooms=9 then '9 bedroom '
when Bedrooms=10 then '10 bedroom '
when Bedrooms=11 then '11 bedroom '
end as type,
count(Bedrooms) as spread from NashvilleHousing 
group by  Bedrooms )
select * from Apartment_type
order by Bedrooms asc
-- so 12 bedroom types  

create view Apartment_type as 
select CONCAT(bedrooms, ' bedroom') as Apartment_type from NashvilleHousing
-- after all those case statements  realised i could just do this
select * from [Apartment_type]

select city, CONCAT(bedrooms, ' bedroom') as Apartment_type, avg(SalePrice)as AvgPrices
from NashvilleHousing
group by city
order by avgPrices


create view PropertyValuations as
select count(*) as Property_Count ,
case when SalePrice > TotalValue then 'Overpaid'
when SalePrice < TotalValue then 'Bargain'
else 'Fair'
end as 'Valuations'
from NashvilleHousing
group by case when SalePrice > TotalValue then 'Overpaid'
when SalePrice < TotalValue then 'Bargain'
else 'Fair' end 
select * from PropertyValuations

select count(uniqueid)as Sales,SaleYear from NashvilleHousing
group by SaleYear
order by sales desc
--probably data captured at start of 2019 as theres just 2 sales