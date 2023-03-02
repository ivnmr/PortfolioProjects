/*

Portafolio de Proyecto "Limpieza de datos con SQL"

*/

SELECT *
FROM NashvilleHousing

-- Estandarizar el formato de fecha

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate) --Este método no funcionó, así que provemos otro

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date; --Agregamos una columna nueva

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate) --Rellenamos esa columna con el resultado de CONVERT

SELECT SaleDateConverted
FROM NashvilleHousing   --¡Funcionó! 

-- Rellenar la columna de PropertyAddress con los datos necesarios

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL  --Tenemos 29 filas con null en PropertyAddress

SELECT *
FROM NashvilleHousing
ORDER BY ParcelID  --Gracias a esto descubrimos que hay filas que repiten ParcelID y en esas filas se usa la misma dirección

SELECT
		nh1.ParcelID,
		nh1.PropertyAddress,
		nh2.ParcelID,
		nh2.PropertyAddress,
		ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
FROM NashvilleHousing nh1
JOIN NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.[UniqueID ] <> nh2.[UniqueID ]
WHERE nh1.PropertyAddress is null -- Unimos la tabla sobre si misma para poder obtener la dirección faltante 

UPDATE nh1
SET PropertyAddress = ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
FROM NashvilleHousing nh1
JOIN NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.[UniqueID ] <> nh2.[UniqueID ]
WHERE nh1.PropertyAddress is null --Ahora actualizamos la tabla con los datos de la consulta anterior

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress is null -- ¡Funciona! Ya no hay valores nulos en esa columna

-- Dividir la dirección en columnas individuales (Dirección, Ciudad, Estado)
SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address, -- Así separaramos la dirección
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City -- Así separamos la ciudad
FROM PortfolioProject..NashvilleHousing 

-----Crear nuevas columnas a la tabla original para poder agregar las nuevas direcciones de la propiedad

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing -- ¡Funcionó! Las columnas con sus respectivos datos se agregron correctamente

----Ahora intentemos lo mismo pero con otro método más fácil y la columna OwnerAddress ;D

SELECT OwnerAddress
FROM NashvilleHousing -- Esta columna tiene la dirección, ciudad y estado. Vamos a separarlos

SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,  --PARSENAME Separa el contenido por '.' y orden de segmento 
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,     --REPLACE reemplaza las ',' por '.' para que PARSENAME funcione
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM NashvilleHousing

----Ahora crearemos las columnas necesarias para agregar cada dato

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
FROM NashvilleHousing --¡Funcionó!

-- Cambiar las valores de Y y N a Yes y No en la columna 'SoldaAsVacant'

SELECT
	DISTINCT(SoldAsVacant),  --Hacemos esto para identificar qué variables hay esa columna
	COUNT(SoldAsVacant)  --Esto para contar el número de cada variable
FROM NashvilleHousing
GROUP BY (SoldAsVacant)   --Esto para agrupar por cada variable existente
ORDER BY 2

SELECT
	SoldAsVacant,
	CASE                                    --Utilizamos esta declaración de caso para cambiar los valores
		WHEN SoldAsVacant = 'Y' THEN 'Yes' 
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END
FROM NashvilleHousing

----Actualizaremos la columna con la consulta anterior

UPDATE NashvilleHousing
SET SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes' 
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END

----Veamos si funciona
SELECT
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY (SoldAsVacant) --¡Funciona!
ORDER BY 2 



-- Remover los duplicados

WITH RowNumCTE AS(
SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
					 ORDER BY
						UniqueID
							) AS row_num
FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE


--Remover columnas

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress

SELECT *
FROM NashvilleHousing