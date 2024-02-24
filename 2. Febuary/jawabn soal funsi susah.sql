CREATE FUNCTION dbo.ListYangBisadibeli (
    @uang AS MONEY
)
RETURNS @ResultTable TABLE (
    ProductID INT,
    Quantity INT,
	harga money,
	Sisa money
)
AS
BEGIN
    DECLARE @row INT = 1;
	declare  @id int
	DECLARE @pricePerProduct MONEY

    WHILE (@uang >= 0 AND 
	@row <= (SELECT count(ProductID) FROM Products where Discontinued = 0 AND UnitsInStock > 0))
    BEGIN
		set @id = (SELECT ProductID FROM 
									( SELECT ProductID,ROW_NUMBER() OVER (ORDER BY ProductID) AS RowNum FROM Products
										where Discontinued = 0 AND UnitsInStock > 0
									) AS NumberedProducts
									WHERE RowNum = @row)
        SET @pricePerProduct = (SELECT p.UnitPrice FROM Products p WHERE p.ProductID = @id );

        IF (@uang >= @pricePerProduct)
        BEGIN
			if (@uang>= @pricePerProduct * 2 )
			begin
				SET @uang = @uang - @pricePerProduct * 2;
				INSERT INTO @ResultTable VALUES (@id, 2,@pricePerProduct, @uang);
			end
			else
			begin
				SET @uang = @uang - @pricePerProduct;
				INSERT INTO @ResultTable VALUES (@id, 1,@pricePerProduct, @uang);
			end
        END
        SET @row += 1;
    END

    RETURN;
END;







select * from dbo.ListYangBisadibeli(100)
drop function dbo.ListYangBisadibeli
