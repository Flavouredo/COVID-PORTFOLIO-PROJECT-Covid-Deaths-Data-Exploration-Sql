

--1.
--Clearing Data in SQL Queries

Select *
From PortfolioProjectTwo.dbo.NashvilleHousing



--2.
--Standardize Date format

select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProjectTwo.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


--3.
--Populate Property Address Data

select *
From PortfolioProjectTwo.dbo.NashvilleHousing
Where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectTwo.dbo.NashvilleHousing a
JOIN PortfolioProjectTwo.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND  A.[UniqueID ] <> B.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectTwo.dbo.NashvilleHousing a
JOIN PortolioProjectTwo.dbo.NashivilleHousing b
	ON a.ParcelID = b.ParcelID
	AND  A.[UniqueID ] <> B.[UniqueID ]
Where a.PropertyAddress is null
Where a.PropertyAddress is null


--4.
--Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
From PortfolioProjectTwo.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress)) as Address

From PortfolioProjectTwo.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,  LEN(PropertyAddress))

Select *
From PortfolioProjectTwo.dbo.NashvilleHousing


Select OwnerAddress
From PortfolioProjectTwo.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProjectTwo.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Select OwnerAddress
From PortfolioProjectTwo.dbo.NashvilleHousing

--5.
--Change Y and N to Yes and No inm "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjectTwo.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SOldAsVacant
		END
From PortfolioProjectTwo.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SOldAsVacant
		END
From PortfolioProjectTwo.dbo.NashvilleHousing


--6.
--Remove Duplicates 

WITH RowNumCTE AS (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueId
					) row_num

From PortfolioProjectTwo.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


--7.
--Delete Unused Columns

Select *
From PortfolioProjectTwo.dbo.NashvilleHousing

ALTER TABLE PortfolioProjectTwo.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProjectTwo.dbo.NashvilleHousing
DROP COLUMN SaleDate