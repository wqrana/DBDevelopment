USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Reporting_CustomerBySoldItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Abid H
-- Create date: 01/20/2017
--select * from Reporting_CustomerBySoldItems(44,default,default,'','','', '','','','')
-- =============================================
CREATE FUNCTION [dbo].[Reporting_CustomerBySoldItems] 
(	
	@ClientID bigint,
	@StartDate datetime  = '1/1/2000',
	@EndDate datetime  = '1/1/2020',
	@SCHLIST varchar(2048) = '',
	@GRLIST varchar(2048) = '',
	@HRLIST varchar(2048) = '',
	@QualificationTypes  varchar(2048) = '',
	--@sAccDate datetime = '1/1/2000',
	--@eAccDate datetime = '1/1/2020',
	--@categoryTypeList  varchar(2048) = '',
	--@categoryList  varchar(2048) = '',
	--@itemsList varchar(2048) = ''
	@ItemSelectionType int,
	@SelectedTypeList varchar(2048) = '',
	@SelectedQtyType varchar(100) = '',
	@minQty int = null,
	@maxQty int = null
)
RETURNS TABLE 
AS
RETURN 
(
	select 
	itemName, schoolName, grade, homeroom, 
	--FirstName, LastName, Middle, 
	FormattedName, qty, total   
	from 
			(select Menu.ItemName, schools.SchoolName schoolName, 
			ISNULL(Grades.Name, 'Adult') grade, ISNULL(Homeroom.Name, 'None') homeroom, 
			Customers.FirstName, 
			CASE  
				when (orderCustId = -3) 
					then (select 'Student Cash Sale') 
			   when (orderCustId = -2) 
					then (select 'Adult Cash Sale') 
				else 
					(select Customers.LastName + ', ' + Customers.FirstName) 
			END FormattedName, 
			Customers.LastName, 
			Customers.Middle, 
			itemCustomers.qty, itemCustomers.total 
			from 
				(select Items.Menu_Id menuId, orders.Customer_Id custId, SUM(items.Qty) qty, SUM(items.Qty * items.PaidPrice) total, 
				Orders.Customer_Id orderCustId 
				from items 
				inner join Orders on items.Order_Id = orders.Id 
				where Items.isVoid = 0 and Orders.isVoid = 0 
				and Orders.OrderDate between @StartDate and @EndDate
				-- Items Filter
				--AND ((Items.Menu_Id IN (SELECT Value FROM Reporting_fn_Split(@itemsList, ',')) AND @itemsList <> '') OR  (@itemsList = ''))
				-- Location Filter
				AND ((orders.School_Id IN (SELECT Value FROM Reporting_fn_Split(@SCHLIST, ',')) AND @SCHLIST <> '') OR  (@SCHLIST = ''))
				group by items.Menu_Id, orders.Customer_Id 
				) itemCustomers 
	left join Customers on itemCustomers.custId = Customers.Id 
	inner join Menu on itemCustomers.menuId = Menu.Id 
	inner join Category on Menu.Category_Id = Category.Id 
	left join Customer_School on Customers.Id = Customer_School.Customer_Id 
	left join Schools on Customer_School.School_Id = Schools.Id 
	left join Grades on Customers.Grade_Id = Grades.Id 
	left join HomeRoom on Customers.HomeRoom_Id = HomeRoom.Id 

	where (Customer_School.isPrimary = 1 or Customer_School.isPrimary is null) 
	
	-- Category Type Filter
	--AND ((Category.CategoryType_Id IN (SELECT Value FROM Reporting_fn_Split(@categoryTypeList, ',')) AND @categoryTypeList <> '') OR  (@categoryTypeList = ''))

	-- Category Filter
	--AND ((Menu.Category_Id IN (SELECT Value FROM Reporting_fn_Split(@categoryList, ',')) AND @categoryList <> '') OR  (@categoryList = ''))

	-- Customer Creation Date
	--and customers.CreationDate between @sAccDate  and @eAccDate

	AND ((ISNULL(Customers.LunchType, 4) IN (SELECT Value FROM Reporting_fn_Split(@QualificationTypes, ',')) AND @QualificationTypes <> '') OR  (@QualificationTypes = ''))

	-- Grades
	AND ((grades.Id IN (SELECT Value FROM Reporting_fn_Split(@GRLIST, ',')) AND @GRLIST <> '') OR  (@GRLIST = ''))

	-- Homeroom
	AND ((homeroom.Id IN (SELECT Value FROM Reporting_fn_Split(@HRLIST, ',')) AND @HRLIST <> '') OR  (@HRLIST = ''))
	
	-- Minimum Qty
	--if (RptOpts->useItemQty && RptOpts->minimumPurchasedQty != -1)

	--and qty >=   + IntToStr(RptOpts->minimumPurchasedQty) 

	-- Maximum Qty
	--if (RptOpts->useItemQty && RptOpts->maximumPurchasedQty != -1)
	--  and qty <=   + IntToStr(RptOpts->maximumPurchasedQty) +    ;

	AND ((@ItemSelectionType = 1 AND ((Category.CategoryType_Id IN (SELECT Value FROM Reporting_fn_Split(@SelectedTypeList, ',')) AND @SelectedTypeList IS NOT NULL)))

	OR (@ItemSelectionType = 2 AND ((Category.Id IN (SELECT Value FROM Reporting_fn_Split(@SelectedTypeList, ',')) AND @SelectedTypeList IS NOT NULL)))

	OR (@ItemSelectionType = 3 AND ((Menu.Id IN (SELECT Value FROM Reporting_fn_Split(@SelectedTypeList, ',')) AND @SelectedTypeList IS NOT NULL)))

	OR @SelectedTypeList IS NULL)

	AND ((@SelectedQtyType = 'Range' AND itemCustomers.qty >= IsNull(@minQty, 0) AND itemCustomers.qty <= IsNull(@maxQty, 0))
	OR (@SelectedQtyType = 'Greater Than' AND itemCustomers.qty > IsNull(@minQty, 0))
	OR (@SelectedQtyType = 'Less Than' AND itemCustomers.qty < IsNull(@maxQty, 0))
	OR (@SelectedQtyType = ''))
	
) sub

)
GO
