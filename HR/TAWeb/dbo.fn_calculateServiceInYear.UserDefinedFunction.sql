USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calculateServiceInYear]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Waqar>
-- Create date: <2020-11-09>
-- Description:	<Calculate Service in Year for report>
-- =============================================
CREATE FUNCTION [dbo].[fn_calculateServiceInYear]
(
	-- Add the parameters for the function here
	@UseHireDateforYearsInService bit, 
	@hireDate datetime,
	@rehireDate datetime,
	@serviceEndDate datetime =null
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	Declare @serviceInYear int;
	Set @serviceEndDate = IsNull(@serviceEndDate,GETDATE());
	IF IsNull(@UseHireDateforYearsInService,0)=0
	Begin
	Set @hireDate = @rehireDate;
	End
	Set @serviceInYear = DATEDIFF(day, IsNull(@hireDate, @serviceEndDate), @serviceEndDate)/365;

	Return @serviceInYear;

END


GO
