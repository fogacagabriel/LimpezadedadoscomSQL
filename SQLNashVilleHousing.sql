/*

Limpeza de dados em consultas SQL

*/


SELECT * FROM Portfolio.dbo.NashvilleHousing;


/*

Padronizar formato da data

*/

SELECT SALEDATECONVERTED, convert(DATE, SALEDATE) FROM Portfolio.dbo.NashvilleHousing;

UPDATE NASHVILLEHOUSING
SET SALEDATE = CONVERT (DATE, SALEDATE);

ALTER TABLE NASHVILLEHOUSING
ADD SALEDATECONVERTED DATE;

UPDATE NASHVILLEHOUSING
SET SALEDATECONVERTED = CONVERT(DATE,SALEDATE);


/*

Popular dados de endereço de propriedade

*/

SELECT * FROM Portfolio.dbo.NashvilleHousing
--WHERE PROPERTYADDRESS IS NULL
ORDER BY PARCELID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.propertyaddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
where a.propertyaddress is null;


UPDATE a
SET PropertyAddress = isnull(a.propertyaddress, b.propertyaddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]


/* 
Separar o endereço em colunas individuais (endereço, cidade, estado)
*/

SELECT PropertyAddress
FROM Portfolio.dbo.NashvilleHousing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
from Portfolio.dbo.NashvilleHousing; 


ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD PROPERTYSPLITADDRESS NVarchar(255);

UPDATE Portfolio.dbo.NashvilleHousing
SET PROPERTYSPLITADDRESS = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD PROPERTYSPLITCITY NVARCHAR(255);

UPDATE Portfolio.dbo.NashvilleHousing
SET PROPERTYSPLITCITY = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress));

--Verificar o resultado

SELECT * FROM
Portfolio.dbo.NashvilleHousing; 



SELECT OwnerAddress FROM
Portfolio.dbo.NashvilleHousing;


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
from portfolio.dbo.nashvillehousing;




ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OWNERSPLITADDRESS NVarchar(255);

UPDATE Portfolio.dbo.NashvilleHousing
SET OWNERSPLITADDRESS = PARSENAME(REPLACE(OwnerAddress, ',','.'),3);

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OWNERSPLITCITY NVARCHAR(255);

UPDATE Portfolio.dbo.NashvilleHousing
SET OWNERSPLITCITY = PARSENAME(REPLACE(OwnerAddress, ',','.'),2);

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OWNERSPLITSTATE NVARCHAR(255);

UPDATE Portfolio.dbo.NashvilleHousing
SET OWNERSPLITSTATE = PARSENAME(REPLACE(OwnerAddress, ',','.'),1);

--Verificar

SELECT * FROM
Portfolio.dbo.NashvilleHousing; 





-- Mudar Y e N para Yes e No no campo "Sold as Vacant"

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM Portfolio.dbo.NashvilleHousing
Group By SoldAsVacant
order by 2;


SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 end
from portfolio.dbo.NashvilleHousing


Update portfolio.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 end



--Remover valores duplicados
SELECT * 
FROM Portfolio.dbo.NashvilleHousing;

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num
from portfolio.dbo.nashvillehousing
--order by ParcelID
)
SELECT * 
from RowNumCTE
WHERE row_num>1
--order by PropertyAddress





--Deletar colunas não utilizadas

select * 
from Portfolio.dbo.NashvilleHousing;

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio.dbo.NashvilleHousing
DROP COLUMN SaleDate