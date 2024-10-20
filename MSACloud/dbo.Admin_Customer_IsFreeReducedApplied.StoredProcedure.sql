USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Customer_IsFreeReducedApplied]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Abid H
-- Create date: 5/11/2016
-- Description : This stored procedure checks whether Free and Reduced Meal Application 
-- has been submitted by this Customer. This would be used in POS ADMIN portal
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Customer_IsFreeReducedApplied]
	
	@ClientID bigint,
	@CustomerID bigint
AS
BEGIN
	SET NOCOUNT ON;
	 select isNULL(count(*),0) as AppCount from [dbo].[App_Members] 
	 where 
	 Customer_id = @CustomerID and 
	 ClientID = @ClientID

END
GO
