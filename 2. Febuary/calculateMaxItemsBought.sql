DROP FUNCTION MaxNumberOfProducts

CREATE FUNCTION MaxNumberOfProducts (
	@Budget MONEY
) RETURNS @Return TABLE (ProductID INT, Quantity INT)
BEGIN
	DECLARE @Index INT = 1,
			@TotalSpent MONEY = 0,
			@toAlter INT = 0

	DECLARE @TempTable TABLE (
		ProductID INT, 
		Quantity INT,
		UnitPrice MONEY, 
		[Total Price] MONEY
	)
	
	INSERT @TempTable
	SELECT
		ProductID,
		IIF(UnitsInStock >= 2, 2, 1),
		UnitPrice,
		IIF(UnitsInStock >= 2, UnitPrice * 2, UnitPrice) [Total Price]
	FROM Products
	WHERE Discontinued = 0 AND UnitsInStock > 0

	DECLARE @CurrTotal MONEY = 0,
			@TempIsolated MONEY = 0

	WHILE @TotalSpent < @Budget 
	BEGIN
		IF @Index > (SELECT COUNT(ProductID) FROM @TempTable)
		BEGIN
			BREAK
		END

		SET @CurrTotal = (SELECT SUM([Total Price]) FROM (SELECT TOP (@Index) * FROM @TempTable ORDER BY [Total Price] ASC) Src)
		IF @CurrTotal <= @Budget
		BEGIN
			SET @TotalSpent = @CurrTotal
			SET @Index += 1
		END
		ELSE
		BEGIN
			SET @TempIsolated = (SELECT UnitPrice FROM @TempTable ORDER BY [Total Price] ASC OFFSET (@Index - 1) ROWS FETCH NEXT 1 ROWS ONLY)
			IF @TotalSpent + @TempIsolated <= @Budget
			BEGIN
				SET @toAlter = 1
			END
			ELSE
			BEGIN
				SET @Index -= 1
			END
			BREAK
		END
	END

	INSERT @Return
	SELECT TOP (@Index) ProductID, 2 FROM @TempTable ORDER BY [Total Price] ASC 
		
	IF @toAlter = 1
	BEGIN
		UPDATE @Return
		SET Quantity = 1
		WHERE ProductID = (SELECT ProductID FROM @TempTable ORDER BY [Total Price] ASC OFFSET (@Index - 1) ROWS FETCH NEXT 1 ROWS ONLY)
	END
	RETURN
END

WITH TEST AS (
SELECT 
	R.ProductID, 
	R.Quantity, 
	P.UnitPrice, 
	R.Quantity * P.UnitPrice [Price Bought]
FROM dbo.MaxNumberOfProducts(260) R 
JOIN Products P 
	ON R.ProductID = P.ProductID
)

SELECT
	CONVERT(VARCHAR, ProductID),
	Quantity,
	[Price Bought]
FROM TEST
UNION ALL
SELECT
	'Total',
	0,
	SUM([Price Bought])
FROM TEST
UNION ALL
SELECT
	'Remainder',
	0,
	260 - SUM([Price Bought])
FROM TEST