
---Q3.1--------
Select * from Customer
where Segment='Consumer' and City = 'Arlington'
---Q3.2-------
Select * from SubCategory
where CategoryID=3
---Q4.1--------
Select Customer.* from Customer,Orders Where CustomerName like 'B%'
and
Customer.ID=Orders.CustomerID
and
MONTH(OrderDate)=12
and
YEAR(OrderDate)=2017
Order by Segment desc,CustomerName asc
---Q4.2-------
Select * from Orders,Customer
where
Customer.ID=Orders.CustomerID
and (OrderDate >= '2017-12-05' and OrderDate <='2017-12-10')
and DAY(ShipDate) - DAY(OrderDate) < 3
Order by State asc, City desc
--Q5.1-----------
Select SubCategory.ID as SubCategoryID,SubCategoryName,Count(SubCategoryName) as NumberOfProducts
 from SubCategory,Category,Product
Where SubCategory.CategoryID=Category.ID
and SubCategory.ID=Product.SubCategoryID
Group by SubCategory.ID,SubCategoryName
having Count(SubCategoryName) >100
Order by NumberOfProducts desc
--Q5.2-----------
Select OrderID,Orders.OrderDate,Sum(Quantity*SalePrice*(1-Discount)) as 'Total Amount' from OrderDetails,Orders
where Orders.ID=OrderDetails.OrderID
Group by OrderID,OrderDate
having Sum(Quantity*SalePrice*(1-Discount)) > 8000
Order by [Total Amount] desc

---Q6.1----------
Select Product.ID as ProductID,ProductName,Quantity from Product,OrderDetails
where
OrderDetails.ProductID=Product.ID and 
Quantity = (Select Orderdetail1.Quantity from OrderDetails Orderdetail1,OrderDetails
Where Orderdetail1.Quantity>OrderDetails.Quantity
except
Select OrderDetails.Quantity from Orderdetail1,OrderDetails
Where Orderdetail1.Quantity>OrderDetails.Quantity)
----Q6.2---------
Select * from Orders
Where OrderDate = (Select MAX(OrderDate) from Orders)
----Q7.1----------
Select OrderDetails.ProductID,ProductName,Count(ProductID) as NumberOfOrders from Product,OrderDetails
where Product.ID=OrderDetails.ProductID
Group by ProductID,ProductName
having Count(ProductID) = (
Select top 1 Count(ProductID) as NumberOfOrders from Product,OrderDetails
where Product.ID=OrderDetails.ProductID
Group by ProductID
Order by NumberOfOrders asc)
------Q7.2-------------------------------
Select CustomerID,Customer.CustomerName, COUNT(Orders.ID) as NumberOfOders from Customer,Orders
Where Customer.ID=Orders.CustomerID
Group by Orders.CustomerID,CustomerName
having COUNT(Orders.ID) = (
Select top 1 COUNT(Orders.ID) from Customer,Orders
Where Customer.ID=Orders.CustomerID
Group by Orders.CustomerID,CustomerName
Order by COUNT(Orders.ID) desc
)
-----Q8.1--------------
select * from(
select *
from (
    select top 5 * 
    from Product
    order by UnitPrice desc) first
union 
select *
from (
    select top 5 * 
    from Product
     order by UnitPrice asc) last
) t
order by UnitPrice desc
-----Q8.2---------------
Select * from(
select * from (

Select  top 5 SubCategory.ID as SubCategoryID,SubCategoryName,Count(SubCategoryName) as NumberOfProducts 
from SubCategory,Category,Product
Where SubCategory.CategoryID=Category.ID
and SubCategory.ID=Product.SubCategoryID
Group by SubCategory.ID,SubCategoryName
Order by NumberOfProducts desc
) first
union 
select * from (

Select top 5 SubCategory.ID as SubCategoryID,SubCategoryName,Count(SubCategoryName) as NumberOfProducts 
from SubCategory,Category,Product
Where SubCategory.CategoryID=Category.ID
and SubCategory.ID=Product.SubCategoryID
Group by SubCategory.ID,SubCategoryName
Order by NumberOfProducts asc) 
last
) t
Order by NumberOfProducts desc
-----Q9.1--------------
Create proc TotalAmount @OrderId varchar(50), @t float output
as
begin
  Set @t = (Select SalePrice*Quantity*(1-Discount) from Product,OrderDetails
  where
  Product.ID=OrderDetails.ProductID
  and
  OrderID = @OrderId)
end
-----Q9.2--------------
create proc CountProduct @OrderID nvarchar(255) , @NbProducts int output
as
begin
  
  Set @NbProducts = (Select COUNT(ProductID) from Orders,OrderDetails
  where Orders.ID = @OrderID
  and OrderDetails.OrderID=Orders.ID
  
  )
end
---Q10.1----------------
Create trigger InsertSubCategory
on SubCategory
for insert
as
begin
  Select inserted.SubCategoryName,Category.CategoryName from inserted,Category
  Where inserted.CategoryID = Category.ID
end
---Q10.2---------------
Create trigger InsertProduct
on Product
for insert
as
begin
  select inserted.ProductName,SubCategory.SubCategoryName from inserted,SubCategory
  where inserted.SubCategoryID=SubCategory.CategoryID
end
--------hien thi ProductId,Name,TotalQuantity trong 11/2017---------------
Select Product.ID,ProductName,Isnull(Sum(Quantity),0) as [Total Quantity] 
from  OrderDetails
inner join Orders
on OrderDetails.OrderID=Orders.ID
right join Product
on Product.ID=OrderDetails.ProductID
and Month(OrderDate) = 12
and YEAR(OrderDate) = 2017
group by ProductName,Product.ID



