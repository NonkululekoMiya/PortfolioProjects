
--CLEANING DATA IN SQL QUERIES

SELECT *
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

--Standardize Date Format (SaleDate)

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing


--Populate Property Address data

SELECT *
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.ParcelID
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing a
Join [PortfolioProject  HousingData].dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.ParcelID,
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing a
Join [PortfolioProject  HousingData].dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing a
Join [PortfolioProject  HousingData].dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID]

--Breaking out Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

----The -1 is to get rid of the comma after the address

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address
,SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

----The +1 is to start after the address comma without seeing the comma


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing


--Splitting the address using PARSENAME

SELECT OwnerAddress
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing


ALTER TABLE [PortfolioProject  HousingData].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE [PortfolioProject  HousingData].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE [PortfolioProject  HousingData].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE [PortfolioProject  HousingData].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE [PortfolioProject  HousingData].dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE [PortfolioProject  HousingData].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing


--Chaning the Y and N to Yes and No respectively in "Sold as Vacant" column

SELECT DISTINCT(SoldAsVacant)
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing


SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

UPDATE [PortfolioProject  HousingData].dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2


--Deleting Unused Columns

SELECT *
FROM [PortfolioProject  HousingData].dbo.NashvilleHousing

ALTER TABLE [PortfolioProject  HousingData].dbo.NashvilleHousing
DROP COLUMN TaxDistrict, SaleDate

