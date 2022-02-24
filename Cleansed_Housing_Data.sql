-- Data Cleaning

SELECT SaleDateConverted 
FROM NashvilleHousing.dbo.Housing;

UPDATE Housing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Housing 
ADD SaleDateConverted Date;

UPDATE Housing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Property Address Data 

SELECT *
FROM NashvilleHousing.dbo.Housing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.Housing a
JOIN NashvilleHousing.dbo.Housing b
ON a.ParcelId = b.ParcelId
AND a.[UniqueId] <> b.[UniqueId]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.Housing a
JOIN NashvilleHousing.dbo.Housing b
ON a.ParcelId = b.ParcelId
AND a.[UniqueId] <> b.[UniqueId]


-- Breaking up Address Column into Address, City, State Columns

SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address, 
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing.dbo.Housing

ALTER TABLE NashvilleHousing.dbo.Housing
ADD PropertyStreetAddress Nvarchar(255);

UPDATE NashvilleHousing.dbo.Housing
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing.dbo.Housing 
ADD PropertyCity Nvarchar(255)

UPDATE NashvilleHousing.dbo.Housing 
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



SELECT OwnerAddress 
FROM NashvilleHousing.dbo.Housing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM NashvilleHousing.dbo.Housing

ALTER TABLE NashvilleHousing.dbo.Housing
ADD OwnerStreetAddress Nvarchar(255)

UPDATE NashvilleHousing.dbo.Housing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing.dbo.Housing
ADD OwnerCity Varchar(255)

UPDATE NashvilleHousing.dbo.Housing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing.dbo.Housing
ADD StateOfOwner Varchar(255)

UPDATE NashvilleHousing.dbo.Housing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



-- Change Y and N to Yes and No in [Sold As Vacant] Field

SELECT SoldAsVacant, 
CASE 
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing.dbo.Housing

UPDATE NashvilleHousing.dbo.Housing
SET SoldAsVacant = 
CASE 
	WHEN SoldAsVacant = 'N' THEN 'No'
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	ELSE SoldAsVacant
	END
FROM NashvilleHousing.dbo.Housing

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing.dbo.Housing
GROUP BY SoldAsVacant


-- Deleting Unused Columns

SELECT * FROM NashvilleHousing.dbo.Housing

ALTER TABLE NashvilleHousing.dbo.Housing
DROP COLUMN  OwnerAddress, TaxDistrict, SaleDate



