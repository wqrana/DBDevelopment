USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[MemberIncomes]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[MemberIncomes]
AS

select * 
from
(
select App_Member_Id,
	col + cast(Income_Type_ID as varchar(max)) new_col,
	value
from app_member_incomes
cross apply
(
	VALUES
		(Income, 'Income_Type'),
		(Frequency_Id, 'F')
) x (value, col)
) src
pivot
(
	sum(value)
	for new_col in (Income_Type1,F1,Income_Type2,F2,Income_Type3,F3,Income_Type4,F4,Income_Type5,F5,Income_Type6,F6)
)piv
GO
