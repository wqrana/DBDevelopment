USE [DevFstPOS_LiveDB]
GO
/****** Object:  UserDefinedFunction [dbo].[Generate_NewSaleInvoiceNo]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[Generate_NewSaleInvoiceNo]
(
	
	
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result as varchar(50)
	
	set @Result = 'N/A'
	
	
		Select @Result = 'SINV-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'SINV-','') as int)+1) as varchar(10)) ,'1') from SAL_InvoiceMaster where InvoiceNo like 'SINV-%' 
	
		
	RETURN @Result

END


----select dbo.GenerateInvoiceNo ('igp')
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateAccount]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GenerateAccount](@ParentAcno varchar(50),@PLevel int,@CCode int)

RETURNS varchar(30)

AS
BEGIN

	declare @Result varchar(50)
	--set @ParentAcno = '1002'
if @PLevel=2 or @PLevel=3 
	Select @Result = replace(str(isnull(max(cast(RIGHT(Acno,2) as int)),0) +1,2),' ','0') from chartofaccount where isnull(parentAcno,'') = @ParentAcno and CCode = @CCode
else if @PLevel=5 
	Select @Result = replace(str(isnull(max(cast(RIGHT(Acno,4) as int)),0) +1,4),' ','0') from chartofaccount where isnull(parentAcno,'') = @ParentAcno and CCode = @CCode
else
	Select @Result = replace(str(isnull(max(cast(RIGHT(Acno,3) as int)),0) +1,3),' ','0') from chartofaccount where isnull(parentAcno,'') = @ParentAcno and CCode = @CCode


	-- Return the result of the function
	RETURN @ParentAcno + @Result

END


--Select replace(str(isnull(max(cast(RIGHT(Acno,3) as int)),0) +1,3),' ','0') from chartofaccount where isnull(parentAcno,'') = @ParentAcno 
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateId]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GenerateId]
(
	@TransactionType varchar(50),
	@CCode int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result as varchar(50)
	
	set @Result = 'N/A'
--		Select @Result = isnull(cast(max(cast(REPLACE(CityId , '','') as int)+1) as varchar(10)) ,'1') from City
	
	if @TransactionType = 'cityid' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(CityId,3) as int)),0) +1,3 ),' ','0') from City WHERE CCode = @CCode
	--if @TransactionType = 'countryid' 
	--	--Select @Result = isnull(cast(max(cast(REPLACE(CountryId , '','') as int)+1) as varchar(10)) ,'1') from Country
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(CountryId,3) as int)),0) +1,3 ),' ','0') from Country WHERE CCode = @CCode
	--if @TransactionType = 'depttid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(DepartmentID,3) as int)),0) +1,3 ),' ','0') from HR_Department WHERE CCode = @CCode
	--if @TransactionType = 'desigid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(DesignationID,3) as int)),0) +1,3 ),' ','0') from HR_Designation WHERE CCode = @CCode
	--if @TransactionType = 'qualifid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(QualificationID,3) as int)),0) +1,3 ),' ','0') from HR_Qualification WHERE CCode = @CCode
	--if @TransactionType = 'facilityid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(FacilityID,3) as int)),0) +1,3 ),' ','0') from HR_Facility WHERE CCode = @CCode
	--if @TransactionType = 'religionid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(ReligionID,3) as int)),0) +1,3 ),' ','0') from HR_Religion WHERE CCode = @CCode
	--if @TransactionType = 'dealerpolicyid' 
	--	--Select @Result = isnull(cast(max(cast(REPLACE(CountryId , '','') as int)+1) as varchar(10)) ,'1') from Country
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(PolicyID,3) as int)),0) +1,3 ),' ','0') from SAL_DiscountPolicy WHERE CCode = @CCode
	if @TransactionType = 'ratelistid' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(RateListID,3) as int)),0) +1,3 ),' ','0') from SAL_RateList WHERE CCode = @CCode
	----if @TransactionType = 'productionratelistid' 
	--	Select @Result = isnull(cast(max(cast(RateListID as int)+1) as varchar(10)) ,'1') from PRD_ProductionRateList WHERE CCode = @CCode

	--if @TransactionType = 'addaid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(AddaID,3) as int)),0) +1,3 ),' ','0') from Adda WHERE CCode = @CCode
	if @TransactionType = 'uomid' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(ID,3) as int)),0) +1,3 ),' ','0') from STK_UOM --WHERE CCode = @CCode
	if @TransactionType = 'newcustomer'
		Select @Result = replace(str(isnull(max(cast(CustomerCode as int)),0) +1,5 ),' ','0') from SAL_Customer WHERE CCode = @CCode
	if @TransactionType = 'newsupplier'
		Select @Result = replace(str(isnull(max(cast(SupplierCode as int)),0) +1,5 ),' ','0') from PUR_Supplier WHERE CCode = @CCode

		--Select @Result = replace(str(isnull(max(cast(RIGHT(CustomerCode,3) as int)),0) +1,3 ),' ','0') from SAL_Customer WHERE CCode = @CCode
	--if @TransactionType = 'iteminstruction'
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(ID,3) as int)),0) +1,3 ),' ','0') from STK_ItemInstruction WHERE CCode = @CCode
		
	if @TransactionType = 'packingid' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(ID,3) as int)),0) +1,3 ),' ','0') from STK_StdPacking WHERE CCode = @CCode
	if @TransactionType = 'productgrpid' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(GroupID,3) as int)),0) +1,3 ),' ','0') from STK_ProductGroups WHERE CCode = @CCode
	if @TransactionType = 'productsubgrpid'
		Select @Result = replace(str(isnull(max(cast(RIGHT(SubGroupID,3) as int)),0) +1,3 ),' ','0') from STK_ProductSubGroup WHERE CCode = @CCode
	if @TransactionType = 'terrid' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(TerrID,3) as int)),0) +1,3 ),' ','0') from SAL_Territory WHERE CCode = @CCode
	if @TransactionType = 'gdid' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(GodownID,3) as int)),0) +1,3 ),' ','0') from STK_Godown WHERE CCode = @CCode
	--if @TransactionType = 'bankid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(ID,3) as int)),0) +1,3 ),' ','0') from BankNames WHERE CCode = @CCode
	--if @TransactionType = 'machineid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(ID,3) as int)),0) +1,3 ),' ','0') from PRD_Machines WHERE CCode = @CCode
	--if @TransactionType = 'mouldid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(ID,3) as int)),0) +1,3 ),' ','0') from PRD_Moulds
	--if @TransactionType = 'prodinctratelistid' 
	--	Select @Result = replace(str(isnull(max(cast(RIGHT(RateListID,3) as int)),0) +1,3 ),' ','0') from PRD_ProductionIncentiveRateListMaster
	if @TransactionType = 'matcate' 
		Select @Result = replace(str(isnull(max(cast(RIGHT(MatCateId,3) as int)),0) +1,3 ),' ','0') from STK_MaterialCategory WHERE CCode = @CCode

	--if @TransactionType = 'dealerpolicyid'
	--	Select @Result = isnull(cast(max(cast(DealerPolicyId as int)+1) as varchar(10)) ,'1') from SAL_DealerPolicy
	RETURN @Result
END

GO
/****** Object:  UserDefinedFunction [dbo].[GenerateInvoiceNo]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GenerateInvoiceNo]
(
	@TransactionType varchar(50),
	@CCode int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result as varchar(50)
	
	set @Result = 'N/A'
	
	if @TransactionType = 'purchase' 
		Select @Result = 'PINV-' + isnull(cast(max(cast(REPLACE(invoiceno , 'PINV-','') as int)+1) as varchar(10)) ,'1') from PUR_PurchaseMaster where invoiceno like 'PINV-%' and CCode = @CCode
	if @TransactionType = 'purchasereturn' 
		Select @Result = 'PRINV-' + isnull(cast(max(cast(REPLACE(invoiceno , 'PRINV-','') as int)+1) as varchar(10)) ,'1') from PUR_PRMaster where invoiceno like 'PRINV-%' and CCode = @CCode
	--if @TransactionType = 'odppurchase' 
	--	Select @Result = 'ODPPINV-' + isnull(cast(max(cast(REPLACE(invoiceno , 'ODPPINV-','') as int)+1) as varchar(10)) ,'1') from ODP_PurchaseMaster where invoiceno like 'ODPPINV-%'
	if @TransactionType = 'quotation' 
		Select @Result = 'QUOT-' + isnull(cast(max(cast(REPLACE(quotationno , 'QUOT-','') as int)+1) as varchar(10)) ,'1') from SAL_QuotationMaster where quotationno like 'QUOT-%' and CCode = @CCode
	--if @TransactionType = 'quotationpur'
	--	Select @Result = 'PURQT-' + isnull(cast(max(cast(REPLACE(QuotationNo, 'PURQT-','') as int)+1) as varchar(10)) ,'1') from PUR_QuotationMaster where QuotationNo like 'PURQT-%'
	
	--if @TransactionType = 'MaterialIssueRequest'
	--	Select @Result = 'MIR-' + isnull(cast(max(cast(REPLACE(MIRNo , 'MIR-','') as int)+1) as varchar(10)) ,'1') from STK_MaterialIssueRequestMain where MIRNo like 'MIR-%'

	--if @TransactionType = 'MaterialIssued'
	--	Select @Result = 'MID-' + isnull(cast(max(cast(REPLACE(MIDNo , 'MID-','') as int)+1) as varchar(10)) ,'1') from STK_MaterialIssuedMain where MIDNo like 'MID-%'

	--if @TransactionType = 'materialreceiveback'
	--	Select @Result = 'MRB-' + isnull(cast(max(cast(REPLACE(MRBNo , 'MRB-','') as int)+1) as varchar(10)) ,'1') from STK_MaterialreceivebackMain where MRBNo like 'MRB-%'


	--if @TransactionType = 'purchaserequest'
	--	Select @Result = 'PR-' + isnull(cast(max(cast(REPLACE(PRNo , 'PR-','') as int)+1) as varchar(10)) ,'1') from PUR_purchaserequestMain where PRNo like 'PR-%'

	if @TransactionType = 'purchaseorder'
		Select @Result = 'PO-' + isnull(cast(max(cast(REPLACE(PONo , 'PO-','') as int)+1) as varchar(10)) ,'1') from PUR_purchaseOrderMain where PONo like 'PO-%' and CCode = @CCode


	--if @TransactionType = 'dealerpolicyid'
	--	Select @Result = isnull(cast(max(cast(DealerPolicyId as int)+1) as varchar(10)) ,'1') from SAL_DealerPolicy

	--if @TransactionType = 'dealertargetitem'
	--	Select @Result = isnull(cast(max(cast(TargetId as int)+1) as varchar(10)) ,'1') from SAL_DealerTargetItem
	--if @TransactionType = 'dealeritemdiscount'
	--	Select @Result = isnull(cast(max(cast(PolicyId as int)+1) as varchar(10)) ,'1') from SAL_DealerItemDiscount

	--if @TransactionType = 'dealerrecoverytargetid'
	--	Select @Result = isnull(cast(max(cast(TargetId as int)+1) as varchar(10)) ,'1') from SAL_DealerRecoveryTargetMaster

	--if @TransactionType = 'dealerincentiveid'
	--	Select @Result = isnull(cast(max(cast(Id as int)+1) as varchar(10)) ,'1') from Sal_DealerIncentive

	--if @TransactionType = 'compcitysale'
	--	Select @Result = isnull(cast(max(cast(CompSaleId as int)+1) as varchar(10)) ,'1') from COMANLY_CompetitorsSalesCity

	--if @TransactionType = 'visitplan'
	--	Select @Result = isnull(cast(max(cast(VisitId as int)+1) as varchar(10)) ,'1') from SAL_VisitPlanMaster

	if @TransactionType = 'saleorder'
		--Select @Result = isnull(cast(max(cast(OrderNo as int)+1) as varchar(10)) ,'1') from SAL_SalesOrderMaster
		Select @Result = 'SORD-' + isnull(cast(max(cast(REPLACE(OrderNo, 'SORD-','') as int)+1) as varchar(10)) ,'1') from SAL_SalesOrderMaster where OrderNo like 'SORD-%' and CCode = @CCode
	--if @TransactionType = 'taskorder'
	--	Select @Result = 'TO-' + isnull(cast(max(cast(REPLACE(OrderNo, 'TO-','') as int)+1) as varchar(10)) ,'1') from PPC_TaskOrderMaster where OrderNo like 'TO-%'
	--if @TransactionType = 'contractorprodcapacity'
	--	Select @Result = isnull(cast(max(cast(InvoiceNo as int)+1) as varchar(10)) ,'1') from PPC_ContractorProductionCapacity
	--if @TransactionType = 'workorder'
	--	Select @Result = 'WO-' + isnull(cast(max(cast(REPLACE(OrderNo, 'WO-','') as int)+1) as varchar(10)) ,'1') from PPC_WorkOrder where OrderNo like 'WO-%'
		
	if @TransactionType = 'dcno'
		--Select @Result = isnull(cast(max(cast(DCNo as int)+1) as varchar(10)) ,'1') from STK_DeliveryChallanMaster
		Select @Result = 'DC-' + isnull(cast(max(cast(REPLACE(DcNo, 'DC-','') as int)+1) as varchar(10)) ,'1') from STK_DeliveryChallanMaster where DCNo like 'DC-%' and CCode = @CCode
	if @TransactionType='saleinvno' 
		Select @Result = 'SINV-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'SINV-','') as int)+1) as varchar(10)) ,'1') from SAL_InvoiceMaster where InvoiceNo like 'SINV-%' and CCode = @CCode
	if @TransactionType='salereturninvno' 
		Select @Result = 'SRI-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'SRI-','') as int)+1) as varchar(10)) ,'1') from SAL_SRInvoiceMaster where InvoiceNo like 'SRI-%' and CCode = @CCode
	--if @TransactionType='trfinvno' 
	--	Select @Result = 'TRF-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'TRF-','') as int)+1) as varchar(10)) ,'1') from SAL_TransferInvoiceMaster where InvoiceNo like 'TRF-%'

	if @TransactionType='crv' 
		Select @Result = 'CRV-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'CRV-','') as int)+1) as varchar(10)) ,'1') from GL_Cash where InvoiceNo like 'CRV-%'	and CCode = @CCode	
	if @TransactionType='cpv' 
		Select @Result = 'CPV-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'CPV-','') as int)+1) as varchar(10)) ,'1') from GL_Cash where InvoiceNo like 'CPV-%'	and CCode = @CCode	
	--if @TransactionType='invadj' 
	--	Select @Result = 'INVAD-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'INVAD-','') as int)+1) as varchar(10)) ,'1') from SAL_InvoicePaymentsAdjustments where InvoiceNo like 'INVAD-%'		
	if @TransactionType='brv' 
		Select @Result = 'BRV-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'BRV-','') as int)+1) as varchar(10)) ,'1') from GL_Bank where InvoiceNo like 'BRV-%'	and CCode = @CCode	
	if @TransactionType='bpv' 
		Select @Result = 'BPV-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'BPV-','') as int)+1) as varchar(10)) ,'1') from GL_Bank where InvoiceNo like 'BPV-%'	and CCode = @CCode	
	if @TransactionType='igp' 
		Select @Result = 'IGP-' + isnull(cast(max(cast(REPLACE(IGPNo, 'IGP-','') as int)+1) as varchar(10)) ,'1') from STK_IGP where IGPNo like 'IGP-%'	and CCode = @CCode	
	--if @TransactionType = 'chqrec' 
	--	Select @Result = 'CHQR-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'CHQR-','') as int)+1) as varchar(10)) ,'1') from GL_CHQReceive where InvoiceNo like 'CHQR-%'		
	--if @TransactionType = 'chqiss' 
	--	Select @Result = 'CHQIS-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'CHQIS-','') as int)+1) as varchar(10)) ,'1') from GL_CHQIssue where InvoiceNo like 'CHQIS-%'		
	--if @TransactionType = 'chqret' 
	--	Select @Result = 'CHQRT-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'CHQRT-','') as int)+1) as varchar(10)) ,'1') from GL_CHQReturn where InvoiceNo like 'CHQRT-%'		

	--if @TransactionType = 'chqclear' 
	--	Select @Result = 'CHQCL-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'CHQCL-','') as int)+1) as varchar(10)) ,'1') from GL_CHQClear where InvoiceNo like 'CHQCL-%'		
	if @TransactionType='grn' 
		Select @Result = 'GRN-' + isnull(cast(max(cast(REPLACE(GRNNo, 'GRN-','') as int)+1) as varchar(10)) ,'1') from STK_GRN where GRNNo like 'GRN-%'	and CCode = @CCode	
	if @TransactionType='jv' 
		Select @Result = 'JV-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'JV-','') as int)+1) as varchar(10)) ,'1') from GL_Ledger where InvoiceNo like 'JV-%'	and CCode = @CCode	
	--if @TransactionType = 'slstarget'
	--	Select @Result = isnull(cast(max(cast(TargetNo as int)+1) as varchar(10)) ,'1') from SAL_SlsMonthlyTarget

	--if @TransactionType = 'slstargetitem' 
	--	Select @Result = isnull(cast(max(cast(TargetId as int)+1) as varchar(10)) ,'1') from SAL_SlsTargetItem
	--if @TransactionType = 'prdplan' 
	--	Select @Result = isnull(cast(max(cast(Id as int)+1) as varchar(10)) ,'1') from PRD_ProductionPlanning
	--if @TransactionType = 'contratelist' 
	--	Select @Result = isnull(cast(max(cast(Id as int)+1) as varchar(10)) ,'1') from HR_ContractorRates
	--if @TransactionType = 'stktrf' 
	--	Select @Result = 'STRF-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'STRF-','') as int)+1) as varchar(10)) ,'1') from STK_StockTransfer where InvoiceNo like 'STRF-%'		
	--if @TransactionType = 'purplan' 
	--	Select @Result = isnull(cast(max(cast(Id as int)+1) as varchar(10)) ,'1') from PUR_PurchasePlanning
	--if @TransactionType = 'prdallocationmachine' 
	--	Select @Result = isnull(cast(max(cast(Id as int)+1) as varchar(10)) ,'1') from PRD_ProductionAllocationtoMachines
	if @TransactionType = 'attendance' 
		Select @Result = isnull(cast(max(cast(Id as int)+1) as varchar(10)) ,'1') from HR_Attendance 

	--if @TransactionType = 'productionplant' 
	--	Select @Result = 'PRDP-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'PRDP-','') as int)+1) as varchar(10)) ,'1') from PRD_ProductionPlant where InvoiceNo like 'PRDP-%'		
	--if @TransactionType = 'productioncont' 
	--	Select @Result = 'PRDC-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'PRDC-','') as int)+1) as varchar(10)) ,'1') from PRD_ProductionContractor where InvoiceNo like 'PRDC-%'		

	if @TransactionType='opbal' 
		Select @Result = 'OB-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'OB-','') as int)+1) as varchar(10)) ,'1') from GL_Ledger where InvoiceNo like 'OB-%'	and CCode = @CCode	
	if @TransactionType = 'opstk' 
		Select @Result = 'OS-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'OS-','') as int)+1) as varchar(10)) ,'1') from STK_Stock where InvoiceNo like 'OS-%'	and CCode = @CCode	
	--if @TransactionType = 'policyvch' 
	--	Select @Result = 'POL-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'POL-','') as int)+1) as varchar(10)) ,'1') from SAL_PolicyVouchers where InvoiceNo like 'POL-%'		
	--if @TransactionType = 'ogp' 
	--	Select @Result = 'OGP-' + isnull(cast(max(cast(REPLACE(OGPNo, 'OGP-','') as int)+1) as varchar(10)) ,'1') from STK_OGP where OGPNo like 'OGP-%'
	if @TransactionType = 'stkadj' 
		Select @Result = 'SADJ-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'SADJ-','') as int)+1) as varchar(10)) ,'1') from STK_StockAdjustment where InvoiceNo like 'SADJ-%' and CCode = @CCode
	if @TransactionType = 'usergroup' 
		Select @Result = 'UG-' + isnull(cast(max(cast(REPLACE(UserGroupID, 'UG-','') as int)+1) as varchar(10)) ,'1') from UserGroup_Master where UserGroupID like 'UG-%'		
	if @TransactionType = 'crnote' 
		Select @Result = 'CRN-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'CRN-','') as int)+1) as varchar(10)) ,'1') from GL_Vouchers where InvoiceNo like 'CRN-%'		
	if @TransactionType = 'drnote' 
		Select @Result = 'DRN-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'DRN-','') as int)+1) as varchar(10)) ,'1') from GL_Vouchers where InvoiceNo like 'DRN-%'		
	--if @TransactionType = 'policydiscount' 
	--	Select @Result = 'PDS-' + isnull(cast(max(cast(REPLACE(InvoiceNo, 'PDS-','') as int)+1) as varchar(10)) ,'1') from GL_Vouchers where InvoiceNo like 'PDS-%'		
		
	RETURN @Result

END


----select dbo.GenerateInvoiceNo ('igp')
GO
/****** Object:  UserDefinedFunction [dbo].[Get_EffectiveProductRate]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Get_EffectiveProductRate]
(
 @ProductCode varchar(50),
 @InvoiceDate datetime	
	
)
RETURNS decimal
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Rate as decimal = 0
	
		select Top 1 @Rate = SRLD.Rate  
		from  SAL_RateList SRL
		inner join SAL_RateListDetail SRLD on SRL.RateListId = SRLD.RateListId
		where SRLD.ProductCode = @ProductCode
		and SRL.StartDate <= @InvoiceDate
		order by SRL.StartDate desc
    if(@Rate is null or @Rate = 0)
	begin
	 select @Rate = [Rate]
	 from 	[dbo].[STK_productMaster]
	 where [ProductID] = @ProductCode
	end	
		
	RETURN @Rate

END
GO
/****** Object:  UserDefinedFunction [dbo].[GetAccountAddress]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAccountAddress]
(	
	@Nameof varchar(50), @Code varchar(50),@CCode int
)
RETURNS varchar(500)
AS
BEGIN

declare @Address varchar(500)

	set @Address = 'N/A'
	
	if @Nameof = 'Customer'
		set @Address = (select top 1 CustomerAddress from SAL_Customer B where CustomerCode = @Code and CCode = @CCode)
	--select CustomerCode Code, CustomerName Name, CustomerAddress Address,(select top 1 CityName from City WHERE CityID = b.CityID) City from SAL_Customer B where CustomerCode = @Code

	if @Nameof= 'Supplier'
		set @Address = (select top 1 Address from PUR_Supplier b where SupplierCode = @Code and CCode = @CCode)

	if @Nameof = 'Employee'
		set @Address = (select top 1 EmployeeAddress from HR_Employee b where EmployeeCode = @Code and CCode = @CCode)

	if @Nameof = 'GL'
		set @Address = (select top 1 '' from chartofAccount where AcNo = @Code and CCode = @CCode)
	
	
	return @address
	
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetAccountCity]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAccountCity]
(	
	@Nameof varchar(50), @Code varchar(50),@CCode int
)
RETURNS varchar(500)
AS
BEGIN

declare @City varchar(500)

	set @City = 'N/A'
	
	if @Nameof = 'Customer'
		--set @City = (select top 1 CustomerAddress from SAL_Customer B where CustomerCode = @Code)
		set @City = (select (select top 1 CityName from City WHERE CityID = b.CityID and CCode = @CCode) City from SAL_Customer B where CustomerCode = @Code and CCode = @CCode)
	--select CustomerCode Code, CustomerName Name, CustomerAddress Address,(select top 1 CityName from City WHERE CityID = b.CityID) City from SAL_Customer B where CustomerCode = @Code

	if @Nameof= 'Supplier'
		--set @City = (select top 1 Address from PUR_Supplier b where SupplierCode = @Code)
		set @City = (select (select top 1 CityName from City WHERE CityID = b.CityID and CCode = @CCode) City from PUR_Supplier B where SupplierCode = @Code and CCode = @CCode)

	if @Nameof = 'Employee'
		--set @City = (select top 1 EmployeeAddress from HR_Employee b where EmployeeCode = @Code)
		set @City = (select (select top 1 CityName from City WHERE CityID = b.CityID and CCode = @CCode) City from HR_Employee B where EmployeeCode = @Code and CCode = @CCode)

	if @Nameof = 'GL'
		set @City = ''
	
	
	return @City
	
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetAccountInfoforInvoice]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE Function [dbo].[GetAccountInfoforInvoice]
(	@invoiceNo varchar(50), 
	@info varchar(50),@CCode int)
Returns varchar(50)
AS

BEGIN

	
	Declare @Code as varchar(50)
	declare @OrderOf varchar(30)
Select @Code = CustomerCode, @OrderOf=Invoiceof from SAL_InvoiceMaster where InvoiceNo = 'Sinv-1' and CCode = @CCode

Declare @Result varchar(50)

	
if @OrderOf = 'Customer'
	begin
		if @info = 'name'
			select @Result = CustomerName from SAL_Customer B where CustomerCode = @Code and CCode = @CCode
		
		if @info = 'Address'
			select @Result = CustomerAddress from SAL_Customer B where CustomerCode = @Code and CCode = @CCode
	end
/*if @OrderOf = 'Supplier'
	select SupplierCode code, SupplierName Name, Address,(select top 1 CityName from City WHERE CityID = b.CityID) City  from PUR_Supplier b where SupplierCode = @Code


if @OrderOf = 'Employee'
	select EmployeeCode code, EmployeeName Name, EmployeeAddress Address,(select top 1 CityName from City WHERE CityID = b.CityID) City  from HR_Employee b where EmployeeCode = @Code

if @OrderOf = 'GL'
	select AcNo code, Acname Name, '' Address, '' City from chartofAccount where AcNo = @Code
*/

Return @Result

END

GO
/****** Object:  UserDefinedFunction [dbo].[GetAccountName]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAccountName]
(	
	@Nameof varchar(50), @Code varchar(50),@CCode int
)
RETURNS varchar(500)
AS
BEGIN

declare @Name varchar(500)

	set @Name = 'N/A'
	
	if @Nameof = 'Customer'
		set @Name = (select top 1 CustomerName from SAL_Customer B where CustomerCode = @Code and CCode = @CCode)

	if @Nameof= 'Supplier'
		set @Name = (select top 1 SupplierName from PUR_Supplier b where SupplierCode = @Code and CCode = @CCode)

	if @Nameof = 'Employee'
		set @Name = (select top 1 EmployeeName from HR_Employee b where EmployeeCode = @Code and CCode = @CCode)

	if @Nameof = 'GL'
		set @Name = (select top 1 Acname from chartofAccount where AcNo = @Code and CCode = @CCode)
	
	
	return @name
	
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetStockCurrentRate]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetStockCurrentRate]
(
@PCode as varchar(50),@CCode int
)
RETURNS float

as
begin
declare @Rate Float

set @Rate = 
(select 
SUM((QtyIn-QtyOut)*Rate) /SUM(QtyIn-QtyOut) Rate 
from STK_Stock where RATE IS not NULL
and ProductCode = @PCode and CCode = @CCode)

return @Rate
end
GO
/****** Object:  UserDefinedFunction [dbo].[ServerDate]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ServerDate]()

RETURNS varchar(30)

AS
BEGIN


	declare @ServerDate varchar(50)
	--set @ParentAcno = '1002'
	--Select @Result = replace(str(isnull(max(cast(RIGHT(Acno,3) as int)),0) +1,3),' ','0') from chartofaccount where isnull(parentAcno,'') = @ParentAcno 
	select @ServerDate = replace( convert( varchar,GETDATE(), 102) , '.','-') + ' ' + convert( varchar,  GETDATE(), 108)


	-- Return the result of the function
	RETURN @ServerDate

END
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item VARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[Sub_GetItemsNetValue]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Sub_GetItemsNetValue]
(
	@FDate as Datetime,
	@TDate as Datetime,
	@PCode as varchar(50),
	@Code as varchar(50) = '',
	@SlsCode as varchar(50) = '',
	@CityId as int = '-1'
)
RETURNS float

AS

BEGIN
if @PCode = ''
	set @PCode = '%'
ELSE
	set @PCode = '%' + @PCode + '%'

if @Code = ''
	set @Code = '%'
ELSE
	set @Code = '%' + @Code + '%'

if @SlsCode = ''
	set @SlsCode = '%'
ELSE
	set @SlsCode = '%' + @SlsCode + '%'

declare @Amount Float
Declare @DisPercentage Float

declare @Discounts_Percent table(ID int identity, Invoiceno varchar(50), Amount Float, Discount float, percentage float)

insert into @Discounts_Percent(Invoiceno, Amount, Discount)
SELECT iNVOICEnO, SUM(Qty*Rate) Amt, (SELECT SUM(DisAmt) from SAL_InvoiceDiscounts where InvoiceNo = a.InvoiceNo)Discounts  FROM SAL_InvoiceDetail A
WHERE a.InvoiceNo IN (SELECT InvoiceNo FROM SAL_InvoiceMaster i  WHERE i.InvoiceDate >= @FDate and i.InvoiceDate <= @TDate)

GROUP BY InvoiceNo 

Update @Discounts_Percent set percentage = (Discount / Amount)*100
--set @DisPercentage =
--(select Invoiceno,ISNULL(percentage,0) from @Discounts_Percent)
	



Declare @ItemsDelivertoDealr table
(
	PCode varchar(50),
	Amount Float
)



insert into @ItemsDelivertoDealr
select c.MPCode,SUM((a.Qty*a.Rate)-((a.Qty*a.Rate)*p.percentage/100)) 
from SAL_InvoiceDetail a,SAL_InvoiceMaster b,STK_productMaster c,SAL_Customer cc, @Discounts_Percent p WHERE 
	a.InvoiceNo=b.InvoiceNo and a.InvoiceNo=p.Invoiceno
	and b.InvoiceDate > @FDate and b.InvoiceDate <= @TDate
	and a.ProductCode=c.ProductID AND a.ProductCode LIKE @PCode 
	and b.CustomerCode=cc.CustomerCode 
	and b.CustomerCode LIKE '%' + @Code + '%' and cc.SlsCode LIKE '%' + @SlsCode + '%' and 
	cc.CityId LIKE '%' + case when @CityId=-1 then '' else cast( @CityId as varchar(100)) end+ '%'	
	GROUP BY c.MPCode

--select c.MPCode,SUM((a.Qty*a.Rate)-((a.Qty*a.Rate)*@DisPercentage/100)) 
--from SAL_InvoiceDetail a,SAL_InvoiceMaster b,STK_productMaster c,SAL_Customer cc WHERE 
--	a.InvoiceNo=b.InvoiceNo 
--	and b.InvoiceDate > @FDate and b.InvoiceDate <= @TDate
--	and a.ProductCode=c.ProductID AND a.ProductCode LIKE @PCode 
--	and b.CustomerCode=cc.CustomerCode 
--	and b.CustomerCode LIKE '%' + @Code + '%' and cc.SlsCode LIKE '%' + @SlsCode + '%' and 
--	cc.CityId LIKE '%' + case when @CityId=-1 then '' else cast( @CityId as varchar(100)) end+ '%'	
--	GROUP BY c.MPCode
	
set @Amount = 
	(select SUM(Amount) Amount from @ItemsDelivertoDealr)

return @Amount
end
GO
/****** Object:  UserDefinedFunction [dbo].[Sub_GetItemsSoldQty]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Sub_GetItemsSoldQty]
(
	@FDate as Datetime,
	@TDate as Datetime,
	@PCode as varchar(50),
	@Code as varchar(50) = '',
	@SlsCode as varchar(50) = '',
	@CityId as int = '-1'
)
RETURNS float

AS

BEGIN

declare @Qty Float



if @PCode = ''
	set @PCode = '%'
ELSE
	set @PCode = '%' + @PCode + '%'

if @Code = ''
	set @Code = '%'
ELSE
	set @Code = '%' + @Code + '%'

if @SlsCode = ''
	set @SlsCode = '%'
ELSE
	set @SlsCode = '%' + @SlsCode + '%'

Declare @ItemsDelivertoDealr table
(
	PCode varchar(50),
	Qty Float
)
insert into @ItemsDelivertoDealr
select c.MPCode,a.Qty 
from SAL_InvoiceDetail a,SAL_InvoiceMaster b,STK_productMaster c,SAL_Customer cc WHERE a.InvoiceNo=b.InvoiceNo and 
	b.InvoiceDate > @FDate and b.InvoiceDate <= @TDate
	and a.ProductCode=c.ProductID AND a.ProductCode LIKE @PCode 
	and b.CustomerCode=cc.CustomerCode 
	and b.CustomerCode LIKE '%' + @Code + '%' and cc.SlsCode LIKE '%' + @SlsCode + '%' and 
	cc.CityId LIKE '%' + case when @CityId=-1 then '' else cast( @CityId as varchar(100)) end+ '%'

	--and b.CustomerCode LIKE @Code and cc.SlsCode LIKE @SlsCode and 
	--cc.CityId LIKE '%' + case when @CityId=-1 then '' else cast( @CityId as varchar(100)) end+ '%'
	

set @Qty = 
	(select SUM(Qty) Qty from @ItemsDelivertoDealr)

return @Qty
end
GO
/****** Object:  Table [dbo].[App_Version]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[App_Version](
	[versionId] [int] NULL,
	[Action] [int] NULL,
	[dtStamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuthenticationRules]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthenticationRules](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Pass] [varchar](50) NULL,
	[Employee] [bit] NULL,
	[Customer] [bit] NULL,
	[dtstamp] [datetime] NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[UserType] [nvarchar](10) NULL,
	[Ibsales] [bit] NULL,
	[Ibinventory] [bit] NULL,
	[IbReports] [bit] NULL,
	[Active] [bit] NULL,
	[IbFinance] [bit] NULL,
 CONSTRAINT [PK_AuthenticationRules] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuthenticationRules_Rights_Detail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthenticationRules_Rights_Detail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NULL,
	[ObjectName] [varchar](50) NULL,
	[Viewable] [bit] NULL,
	[Updatable] [bit] NULL,
	[Deletable] [bit] NULL,
 CONSTRAINT [PK_AuthenticationRules_Rights_Detail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuthenticationRules_UserGroup_Detail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthenticationRules_UserGroup_Detail](
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[UserGroupID] [varchar](20) NULL,
	[AuthenticationUser] [varchar](100) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BankNames]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankNames](
	[ID] [varchar](50) NOT NULL,
	[BankName] [varchar](250) NULL,
	[userName] [varchar](50) NULL,
	[dtStamp] [smalldatetime] NULL,
 CONSTRAINT [PK_BankNames] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chartofAccount]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chartofAccount](
	[AcNo] [varchar](30) NOT NULL,
	[AcName] [varchar](100) NULL,
	[AcLevel] [int] NULL,
	[ParentAcNo] [float] NULL,
	[LoginHistoryID] [bigint] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[PAcNo] [float] NULL,
	[CCode] [int] NOT NULL,
 CONSTRAINT [PK_chartofAccount] PRIMARY KEY CLUSTERED 
(
	[AcNo] ASC,
	[CCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[City]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[CityID] [varchar](50) NOT NULL,
	[CityName] [varchar](250) NULL,
	[userName] [varchar](50) NULL,
	[dtStamp] [smalldatetime] NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CNF_AppConfiguration]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CNF_AppConfiguration](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessCode] [nvarchar](50) NULL,
	[BusinessName] [nvarchar](100) NULL,
	[BusinessShortName] [nvarchar](25) NULL,
	[BusinessAddress] [nvarchar](200) NULL,
	[LandLine] [nvarchar](15) NULL,
	[Mobile] [nvarchar](15) NULL,
	[Email] [nvarchar](50) NULL,
	[NotificationEmail] [nvarchar](200) NULL,
	[SalesNotification] [bit] NULL,
	[SalesClosureNotification] [bit] NULL,
	[DailyStockNotification] [bit] NULL,
	[LowStockNotification] [bit] NULL,
	[PaymentDays] [int] NULL,
	[FirstPaymentNotification] [bit] NULL,
	[FirstNotificationDaysBefore] [int] NULL,
	[SecPaymentNotification] [bit] NULL,
	[SecNotificationDaysBefore] [int] NULL,
	[ThirdPaymentNotification] [bit] NULL,
	[ThirdNotificationDaysBefore] [int] NULL,
	[DefaultBankID] [int] NULL,
	[AccountNo] [nvarchar](20) NULL,
	[NotificationEmailProfile] [varchar](25) NULL,
	[DailyExpenseNotification] [bit] NULL,
	[SMSGateWayURL] [varchar](255) NULL,
	[SMSGateWayUser] [varchar](50) NULL,
	[SMSGateWayPwd] [varchar](25) NULL,
	[SalesSMSNotification] [bit] NULL,
	[SMSCountryCode] [varchar](5) NULL,
 CONSTRAINT [PK_CNF_AppConfiguration] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CNF_Bank]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CNF_Bank](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ShortName] [nvarchar](15) NULL,
	[Name] [nvarchar](50) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_CNF_Bank] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CNF_IncomeType]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CNF_IncomeType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
 CONSTRAINT [PK_CNF_IncomeType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CNF_ProductType]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CNF_ProductType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_CNF_ProductType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CNF_Supplier]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CNF_Supplier](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessName] [nvarchar](100) NULL,
	[ShortName] [nvarchar](25) NULL,
	[BusinessType] [nvarchar](25) NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[Address] [nvarchar](150) NULL,
	[LandLine] [nvarchar](15) NULL,
	[Mobile] [nvarchar](15) NULL,
	[Email] [nvarchar](50) NULL,
	[DefaultBankID] [int] NULL,
	[AccountNo] [nvarchar](20) NULL,
	[Active] [bit] NULL,
	[PaymentDays] [int] NULL,
 CONSTRAINT [PK_CNF_Supplier] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CCode] [int] NULL,
	[CompanyName] [varchar](100) NULL,
	[Address] [varchar](250) NULL,
	[Ph] [varchar](250) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CurrentLogins]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrentLogins](
	[UserName] [varchar](50) NULL,
	[MACAddress] [varchar](50) NULL,
	[IPAddress] [varchar](50) NULL,
	[ntLogin] [varchar](50) NULL,
	[LoginTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GL_Cash]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GL_Cash](
	[InvoiceNo] [varchar](50) NOT NULL,
	[Code] [varchar](50) NULL,
	[CashCode] [varchar](50) NULL,
	[Description] [varchar](250) NULL,
	[Date] [datetime] NULL,
	[RecDate] [datetime] NULL,
	[ReceiptNo] [numeric](18, 0) NULL,
	[Amount] [float] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[PostedBy_Code] [varchar](50) NULL,
	[PostedDate] [datetime] NULL,
	[Transof] [varchar](20) NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[AmountPaid] [float] NULL,
	[CCode] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GL_Ledger]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GL_Ledger](
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[InvoiceNo] [varchar](50) NULL,
	[AcNo] [varchar](30) NULL,
	[Description] [varchar](max) NULL,
	[Dr] [numeric](16, 2) NULL,
	[Cr] [numeric](16, 2) NULL,
	[TransationType] [int] NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[Code] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[DateTrns] [datetime] NULL,
	[PostStatus] [int] NULL,
	[Transof] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOG_NotificationSendingData]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOG_NotificationSendingData](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NotificationMessage] [nvarchar](max) NULL,
	[NotificationType] [nvarchar](15) NULL,
	[NotificationResponse] [nvarchar](1000) NULL,
	[NotificationStatus] [nvarchar](50) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_LOG_NotificationSendingData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login_History]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login_History](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[MACAddress] [varchar](50) NULL,
	[IPAddress] [varchar](50) NULL,
	[ntLogin] [varchar](50) NULL,
	[LoginType] [varchar](50) NULL,
	[dtStamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenueDetails]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenueDetails](
	[MenueID] [int] IDENTITY(1,1) NOT NULL,
	[MenueName] [varchar](100) NULL,
	[MenueText] [varchar](100) NULL,
	[dtstamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenueDetails_temp]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenueDetails_temp](
	[MenueName] [varchar](100) NULL,
	[MenueText] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewRateList]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewRateList](
	[ProductCode] [nvarchar](255) NULL,
	[Old_Rate] [float] NULL,
	[New_Rate] [float] NULL,
	[Increase_pct] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POActivityDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POActivityDetail](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityDate] [datetime] NULL,
	[SourceProductCode] [nvarchar](25) NULL,
	[SourceProductQty] [int] NULL,
	[TargetProductCode] [nvarchar](25) NULL,
	[TargetProductQty] [int] NULL,
	[ActivityType] [nvarchar](25) NULL,
	[Status] [nvarchar](25) NULL,
	[CompletionDate] [datetime] NULL,
	[TargetLocation] [nvarchar](50) NULL,
	[ActivityDetailDesc] [nvarchar](500) NULL,
	[NetDealerPrice] [decimal](18, 2) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[UserID] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
 CONSTRAINT [PK_POActivityDetail] PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POExpenseDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POExpenseDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExpenseDate] [datetime] NULL,
	[ExpenseType] [nvarchar](50) NULL,
	[ExpenseDesc] [nvarchar](1000) NULL,
	[ExpenseAmount] [decimal](18, 2) NULL,
	[Remarks] [nvarchar](500) NULL,
	[Status] [nvarchar](25) NULL,
	[AdjustedDate] [datetime] NULL,
 CONSTRAINT [PK_POExpenseDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POIncome]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POIncome](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PostingDate] [datetime] NULL,
	[IncomeType] [int] NULL,
	[PostingAmount] [decimal](18, 2) NULL,
	[Reference] [nchar](100) NULL,
	[CreatedBy] [nchar](50) NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [nchar](50) NULL,
	[AdjustedInPOS] [bit] NULL,
 CONSTRAINT [PK_POIncome] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POInventoryDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POInventoryDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[ProductCode] [nvarchar](25) NULL,
	[RetailPrice] [decimal](18, 2) NULL,
	[Qty] [int] NULL,
	[ProductDiscount] [decimal](18, 2) NULL,
	[DealerPrice] [decimal](18, 2) NULL,
	[NetProductDiscPct] [decimal](7, 4) NULL,
	[NetDealerPrice] [decimal](18, 2) NULL,
	[Remarks] [nvarchar](2000) NULL,
	[DealerDiscPct] [decimal](7, 4) NULL,
	[CreationDate] [datetime] NULL,
	[LastModifiedDate] [datetime] NULL,
	[UserName] [nvarchar](50) NULL,
	[IsManualRate] [bit] NULL,
 CONSTRAINT [PK_POInventoryDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POInventoryMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POInventoryMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderNo] [nvarchar](50) NULL,
	[OrderDate] [datetime] NULL,
	[DealerDisPct] [decimal](18, 2) NULL,
	[FreightCharges] [decimal](18, 2) NULL,
	[StdDisPct] [decimal](18, 2) NULL,
	[BreakupDisPct] [decimal](18, 2) NULL,
	[CatDisPct] [decimal](18, 2) NULL,
	[InvoiceAmount] [decimal](18, 2) NULL,
	[DueDate] [datetime] NULL,
	[PaymentDate] [datetime] NULL,
	[Reference] [nvarchar](100) NULL,
	[PaymentDisPct] [decimal](18, 2) NULL,
	[CreationDate] [datetime] NULL,
	[LastUpdateDate] [datetime] NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[SupplierID] [int] NULL,
	[PaymentStatus] [nvarchar](15) NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_POInventoryMaster] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POPaymentDisbursement]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POPaymentDisbursement](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SupplierID] [int] NULL,
	[PaymentMode] [nvarchar](20) NULL,
	[PaymentReference] [nvarchar](100) NULL,
	[PaymentBankID] [int] NULL,
	[PaymentAccount] [nvarchar](25) NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[AdjustmentAmount] [decimal](18, 2) NULL,
	[PaymentDate] [datetime] NULL,
	[Remarks] [nvarchar](100) NULL,
	[ReferenceDocument] [image] NULL,
	[CreationDate] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_POPaymentDisbursement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POPaymentDisbursementDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POPaymentDisbursementDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[DisbursementID] [int] NULL,
	[PaidPayment] [decimal](18, 2) NULL,
	[AdjustedPayment] [decimal](18, 2) NULL,
	[CreationDate] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_POPaymentDisbursementDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[POSaleDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POSaleDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SaleDate] [datetime] NULL,
	[CashInHand] [decimal](18, 2) NULL,
	[SaleClosure] [decimal](18, 2) NULL,
	[ClosureBy] [nvarchar](50) NULL,
	[Remarks] [nvarchar](500) NULL,
	[AdjustedExpense] [decimal](18, 2) NULL,
	[TotalSale] [decimal](18, 2) NULL,
	[WithdrawCash] [decimal](18, 2) NULL,
	[WithdrawBy] [nvarchar](50) NULL,
	[IsClosed] [bit] NULL,
	[LastModifiedOn] [datetime] NULL,
	[AdjustedIncomeLoss] [decimal](18, 2) NULL,
	[POCashAdjustment] [decimal](18, 2) NULL,
 CONSTRAINT [PK_POSaleDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_BarCode]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_BarCode](
	[ProductCode] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_PRDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_PRDetail](
	[InvoiceNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Qty] [numeric](10, 3) NULL,
	[Rate] [numeric](10, 3) NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_PRMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_PRMaster](
	[InvoiceNo] [varchar](50) NOT NULL,
	[vendorCode] [varchar](50) NULL,
	[ReferenceNo] [varchar](50) NULL,
	[PDate] [date] NULL,
	[Remarks] [varchar](300) NULL,
	[FreightBy] [varchar](50) NULL,
	[LoginHistoryID] [bigint] NULL,
	[UserName] [varchar](50) NULL,
	[dtstamp] [datetime] NULL,
	[GRNNo] [varchar](50) NULL,
	[Invoiceof] [varchar](50) NULL,
	[IGPNo] [varchar](50) NULL,
	[PONo] [varchar](50) NULL,
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CCode] [int] NOT NULL,
	[GodownId] [varchar](50) NULL,
 CONSTRAINT [PK_PUR_PRMaster] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[CCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_PurchaseDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_PurchaseDetail](
	[InvoiceNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Qty] [numeric](10, 3) NULL,
	[Rate] [numeric](10, 3) NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_PurchaseMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_PurchaseMaster](
	[InvoiceNo] [varchar](50) NOT NULL,
	[vendorCode] [varchar](50) NULL,
	[ReferenceNo] [varchar](50) NULL,
	[PDate] [date] NULL,
	[Remarks] [varchar](300) NULL,
	[FreightBy] [varchar](50) NULL,
	[LoginHistoryID] [bigint] NULL,
	[UserName] [varchar](50) NULL,
	[dtstamp] [datetime] NULL,
	[GRNNo] [varchar](50) NULL,
	[Invoiceof] [varchar](50) NULL,
	[IGPNo] [varchar](50) NULL,
	[PONo] [varchar](50) NULL,
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CCode] [int] NOT NULL,
	[GodownId] [varchar](50) NULL,
 CONSTRAINT [PK_PUR_PurchaseMaster] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[CCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_PurchaseOrderDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_PurchaseOrderDetail](
	[PONo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Qty] [int] NULL,
	[Rate] [numeric](18, 0) NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_PurchaseOrderMain]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_PurchaseOrderMain](
	[PONo] [varchar](50) NOT NULL,
	[SupplierID] [varchar](50) NULL,
	[ReferenceNo] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[PODate] [date] NULL,
	[FreightBy] [varchar](50) NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[Transof] [varchar](20) NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_PUR_PurchaseOrderMain] PRIMARY KEY CLUSTERED 
(
	[PONo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PUR_Supplier]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUR_Supplier](
	[SupplierCode] [varchar](50) NOT NULL,
	[SupplierName] [varchar](250) NULL,
	[BusinessName] [varchar](250) NULL,
	[Address] [varchar](250) NULL,
	[CityID] [varchar](50) NULL,
	[CountryID] [varchar](50) NULL,
	[ResPhone] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[EMail] [varchar](50) NULL,
	[AppByCode] [varchar](50) NULL,
	[STN] [varchar](50) NULL,
	[BankDetail] [varchar](250) NULL,
	[AppointmentDate] [date] NULL,
	[DateOfBirth] [date] NULL,
	[DateOfWedding] [date] NULL,
	[AcNo] [varchar](50) NULL,
	[MatCateID] [varchar](50) NULL,
	[SupplyDeedID] [varchar](50) NULL,
	[userName] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[dtstamp] [datetime] NULL,
	[LoginHistoryId] [int] NULL,
	[OldCode] [varchar](50) NULL,
	[ContactPerson] [varchar](250) NULL,
	[Mobile2] [varchar](50) NULL,
	[Mobile3] [varchar](50) NULL,
	[Mobile4] [varchar](50) NULL,
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[OldPurchaserId] [varchar](50) NULL,
	[Type] [varchar](20) NULL,
	[CCode] [int] NOT NULL,
 CONSTRAINT [pk_PUR_Supplier_SupCode] PRIMARY KEY CLUSTERED 
(
	[SupplierCode] ASC,
	[CCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RateList$]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RateList$](
	[ProductCode] [nvarchar](255) NULL,
	[ProductName] [nvarchar](255) NULL,
	[Rate] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_Customer]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_Customer](
	[CustomerCode] [varchar](50) NOT NULL,
	[CustomerName] [varchar](250) NULL,
	[BusinessName] [varchar](250) NULL,
	[CustomerAddress] [varchar](250) NULL,
	[CityID] [varchar](50) NULL,
	[CountryID] [varchar](50) NULL,
	[ResPhone] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[Fax] [varchar](50) NULL,
	[EMail] [varchar](50) NULL,
	[SlsCode] [varchar](50) NULL,
	[AppByCode] [varchar](50) NULL,
	[STN] [varchar](50) NULL,
	[AppointmentDate] [date] NULL,
	[DateOfBirth] [date] NULL,
	[DateOfWedding] [date] NULL,
	[AcNo] [varchar](50) NULL,
	[AddaID] [varchar](50) NULL,
	[RateListID] [varchar](50) NULL,
	[DisPolID] [varchar](50) NULL,
	[userName] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[dtstamp] [datetime] NULL,
	[TerrId] [varchar](50) NULL,
	[LoginHistoryId] [int] NULL,
	[Dealerships] [varchar](250) NULL,
	[ContactPerson] [varchar](250) NULL,
	[CrLimit] [float] NULL,
	[OldCode] [varchar](50) NULL,
	[Exclusive] [varchar](20) NULL,
	[Type] [varchar](20) NULL,
	[Mobile2] [varchar](50) NULL,
	[Mobile3] [varchar](50) NULL,
	[Mobile4] [varchar](50) NULL,
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CCode] [int] NOT NULL,
 CONSTRAINT [pk_SAL_Customer_cusCode] PRIMARY KEY CLUSTERED 
(
	[CustomerCode] ASC,
	[CCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_InvoiceDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_InvoiceDetail](
	[InvoiceNo] [varchar](50) NOT NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[Qty] [int] NULL,
	[Rate] [numeric](18, 0) NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[ListRate] [float] NULL,
	[DisP] [float] NULL,
	[CCode] [int] NULL,
	[NetRate] [float] NULL,
	[DisAmt] [float] NULL,
	[Status] [varchar](10) NULL,
	[ReferenceID] [int] NULL,
 CONSTRAINT [PK_SAL_InvoiceDetail] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[AutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_InvoiceMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_InvoiceMaster](
	[InvoiceNo] [varchar](50) NOT NULL,
	[CustomerCode] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[PostedBy_Code] [varchar](50) NULL,
	[PostedDate] [datetime] NULL,
	[Invoiceof] [varchar](20) NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[AddaId] [varchar](50) NULL,
	[GodownId] [varchar](50) NULL,
	[OrderNo] [varchar](50) NULL,
	[DCNo] [varchar](50) NULL,
	[OrderDate] [datetime] NULL,
	[DeliveryDate] [datetime] NULL,
	[SSName] [varchar](250) NULL,
	[SSAddress] [varchar](250) NULL,
	[SSCity] [varchar](250) NULL,
	[Bilty] [varchar](250) NULL,
	[CCode] [int] NOT NULL,
	[ReferenceNo] [varchar](50) NULL,
	[InvoiceType] [varchar](50) NULL,
	[CashAcNo] [varchar](50) NULL,
	[DisAcNo] [varchar](50) NULL,
	[Discount] [float] NULL,
	[Phone] [varchar](100) NULL,
	[IsNotify] [bit] NULL,
	[CreationDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [varchar](50) NULL,
	[ReceivedAmount] [decimal](18, 2) NULL,
	[BalanceAmount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_SAL_InvoiceMaster] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC,
	[CCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_QuotationDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_QuotationDetail](
	[QuotationNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Rate] [numeric](10, 3) NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_QuotationMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_QuotationMaster](
	[QuotationNo] [varchar](50) NOT NULL,
	[vendorCode] [varchar](50) NULL,
	[ReferenceNo] [varchar](50) NULL,
	[QDate] [date] NULL,
	[Remarks] [varchar](300) NULL,
	[LoginHistoryID] [bigint] NULL,
	[UserName] [varchar](50) NULL,
	[dtstamp] [datetime] NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_SAL_QuotationMaster] PRIMARY KEY CLUSTERED 
(
	[QuotationNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_RateList]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_RateList](
	[RateListId] [varchar](50) NOT NULL,
	[Name] [varchar](50) NULL,
	[username] [varchar](50) NULL,
	[dtStamp] [smalldatetime] NULL,
	[TerrId] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[LoginHistoryId] [int] NULL,
	[CCode] [int] NOT NULL,
 CONSTRAINT [PK_SAL_RateList] PRIMARY KEY CLUSTERED 
(
	[RateListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_RateListDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_RateListDetail](
	[RateListId] [varchar](50) NOT NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[Rate] [float] NULL,
	[username] [varchar](50) NULL,
	[dtStamp] [smalldatetime] NULL,
	[LoginHistoryId] [int] NULL,
	[SRRate] [float] NULL,
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_SAL_RateListDetail] PRIMARY KEY CLUSTERED 
(
	[RateListId] ASC,
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_SalesOrderDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_SalesOrderDetail](
	[OrderNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Qty] [int] NULL,
	[Rate] [numeric](18, 0) NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_SalesOrderMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_SalesOrderMaster](
	[OrderNo] [varchar](50) NOT NULL,
	[CustomerCode] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[OrderDate] [date] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[ApprovedBy_Code] [varchar](50) NULL,
	[ApprovalDate] [datetime] NULL,
	[Orderof] [varchar](20) NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[OrderType] [varchar](50) NULL,
	[AddaId] [varchar](50) NULL,
	[GodownId] [varchar](50) NULL,
	[RejectedBy_Code] [varchar](50) NULL,
	[RejectedDate] [datetime] NULL,
	[SSName] [varchar](250) NULL,
	[SSAddress] [varchar](250) NULL,
	[SSCity] [varchar](250) NULL,
	[SSPhone] [varchar](250) NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_SAL_SalesOrderMaster] PRIMARY KEY CLUSTERED 
(
	[OrderNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_SRInvoiceDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_SRInvoiceDetail](
	[InvoiceNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Qty] [float] NULL,
	[Rate] [numeric](18, 0) NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[Weight] [float] NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_SRInvoiceMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_SRInvoiceMaster](
	[InvoiceNo] [varchar](50) NOT NULL,
	[CustomerCode] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[PostedBy_Code] [varchar](50) NULL,
	[PostedDate] [datetime] NULL,
	[Invoiceof] [varchar](20) NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[AddaId] [varchar](50) NULL,
	[GodownId] [varchar](50) NULL,
	[OrderNo] [varchar](50) NULL,
	[IGPNo] [varchar](50) NULL,
	[Bilty] [varchar](250) NULL,
	[InvType] [varchar](10) NULL,
	[GRNNo] [varchar](50) NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_SAL_SRInvoiceMaster] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_Territory]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_Territory](
	[TerrId] [varchar](50) NULL,
	[TerrName] [varchar](250) NULL,
	[userName] [varchar](50) NULL,
	[dtstamp] [datetime] NULL,
	[LoginHistoryId] [int] NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAL_TransationType]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_TransationType](
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[TransationType] [int] NOT NULL,
	[TransationDescription] [varchar](100) NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[Grp] [varchar](50) NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_SAL_TransationType] PRIMARY KEY CLUSTERED 
(
	[TransationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMSCampaign]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMSCampaign](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CampaignName] [varchar](100) NULL,
	[CampaignMessage] [varchar](1000) NULL,
	[CreatedOn] [datetime] NULL,
	[CreateBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMSCampaignDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMSCampaignDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CampaignID] [int] NULL,
	[ContactNo] [varchar](15) NULL,
	[SendResponse] [varchar](500) NULL,
	[SendStatus] [varchar](10) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SMSLog]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMSLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MSISDN] [varchar](12) NULL,
	[SMS] [varchar](350) NULL,
	[Status] [varchar](10) NULL,
	[BroadcastedTime] [datetime] NULL,
	[UserName] [varchar](50) NULL,
	[LoginHistoryId] [int] NULL,
	[dtStamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_Godown]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_Godown](
	[GodownID] [varchar](50) NOT NULL,
	[GodownName] [varchar](50) NULL,
	[username] [varchar](50) NULL,
	[dtStamp] [date] NULL,
	[LoginHistoryID] [int] NULL,
	[CCode] [int] NOT NULL,
 CONSTRAINT [PK_STK_Godown] PRIMARY KEY CLUSTERED 
(
	[GodownID] ASC,
	[CCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_GRN]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_GRN](
	[GRNNo] [varchar](50) NOT NULL,
	[IGPNo] [varchar](50) NOT NULL,
	[Code] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](50) NULL,
	[GRNOf] [varchar](50) NULL,
	[RefNo] [varchar](50) NULL,
	[GodownId] [varchar](50) NULL,
	[POrdNo] [varchar](50) NULL,
	[AddaId] [varchar](50) NULL,
	[Bilty] [varchar](200) NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_GRN] PRIMARY KEY CLUSTERED 
(
	[GRNNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_GRNDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_GRNDetail](
	[GRNNo] [varchar](50) NULL,
	[IGPNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Qty] [float] NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[GodownId] [varchar](50) NULL,
	[IGPQty] [float] NULL,
	[Weight] [float] NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_IGP]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_IGP](
	[IGPNo] [varchar](50) NOT NULL,
	[Code] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](50) NULL,
	[IGPOf] [varchar](50) NULL,
	[Bilty] [varchar](250) NULL,
	[GodownId] [varchar](30) NULL,
	[AddaId] [varchar](30) NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_IGP] PRIMARY KEY CLUSTERED 
(
	[IGPNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_IGPDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_IGPDetail](
	[IGPNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[Qty] [float] NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[Weight] [float] NULL,
	[GodownId] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_ProductGroups]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_ProductGroups](
	[GroupId] [varchar](50) NOT NULL,
	[Groupname] [varchar](50) NULL,
	[username] [varchar](50) NULL,
	[dtStamp] [date] NULL,
	[LoginHistoryId] [int] NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_ProductGroups] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_productMaster]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_productMaster](
	[ProductID] [varchar](50) NOT NULL,
	[ProductName] [varchar](300) NULL,
	[Unit] [varchar](50) NULL,
	[Rate] [numeric](10, 3) NULL,
	[Category] [varchar](250) NULL,
	[UOMID] [varchar](50) NULL,
	[StdPackingID] [varchar](50) NULL,
	[PurchaserId] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[BlockTrans] [varchar](50) NULL,
	[SupplierId] [int] NULL,
	[OpDate] [date] NULL,
	[dtStamp] [date] NULL,
	[MinLevel] [float] NULL,
	[MaxLevel] [float] NULL,
	[ReOrdQty] [float] NULL,
	[ACNo] [varchar](50) NULL,
	[GroupId] [varchar](50) NULL,
	[SubGroupId] [varchar](50) NULL,
	[LeadTime] [float] NULL,
	[MPCode] [varchar](50) NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[CT] [float] NULL,
	[StdWeight] [float] NULL,
	[Consumable] [varchar](100) NULL,
	[ProdRate] [float] NULL,
	[OldCode] [varchar](50) NULL,
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[OldPurchaserId] [varchar](50) NULL,
	[OldSupplierId] [varchar](50) NULL,
	[ACNoCons] [varchar](50) NULL,
	[ProductNameUrdu] [nvarchar](250) NULL,
	[MatCateID] [varchar](50) NULL,
	[CCode] [int] NULL,
	[SRate] [float] NULL,
	[DisP] [float] NULL,
	[ProductTypeID] [int] NULL,
	[Active] [bit] NULL,
	[ShortName] [varchar](25) NULL,
	[POSShortcutBtn] [bit] NULL,
	[POSShortcutBtnSeq] [int] NULL,
 CONSTRAINT [pk_STK_ProductMaster_PCode] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_ProductSubGroup]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_ProductSubGroup](
	[GroupId] [varchar](50) NULL,
	[SubGroupname] [varchar](50) NULL,
	[SubGroupId] [varchar](50) NOT NULL,
	[dtStamp] [date] NULL,
	[username] [varchar](50) NULL,
	[LoginHistoryId] [int] NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_ProductSubGroup] PRIMARY KEY CLUSTERED 
(
	[SubGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_StdPacking]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_StdPacking](
	[Id] [varchar](50) NOT NULL,
	[Name] [varchar](50) NULL,
	[username] [varchar](50) NULL,
	[dtStamp] [date] NULL,
	[LoginHistoryId] [int] NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_StdPacking] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_Stock]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_Stock](
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[InvoiceNo] [varchar](50) NULL,
	[GodownId] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[QtyIn] [float] NULL,
	[QtyOut] [float] NULL,
	[TransationType] [int] NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[Rate] [float] NULL,
	[dtStamp] [datetime] NULL,
	[RefNo] [varchar](50) NULL,
	[Description] [varchar](250) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_StockAdjustment]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_StockAdjustment](
	[InvoiceNo] [varchar](50) NOT NULL,
	[Code] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[GodownId] [varchar](30) NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_StockAdjustment] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_StockAdjustmentDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_StockAdjustmentDetail](
	[InvoiceNo] [varchar](50) NULL,
	[ProductCode] [varchar](50) NULL,
	[QtyIn] [float] NULL,
	[QtyOut] [float] NULL,
	[Rate] [float] NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[LoginHistoryId] [int] NULL,
	[UserName] [varchar](50) NULL,
	[Stock] [float] NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_StockTransfer]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_StockTransfer](
	[InvoiceNo] [varchar](50) NOT NULL,
	[ReferenceNo] [varchar](50) NULL,
	[GodownF] [varchar](50) NULL,
	[GodownT] [varchar](50) NULL,
	[Remarks] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[dtStamp] [datetime] NULL,
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_StockTransfer] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STK_UOM]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STK_UOM](
	[Id] [varchar](50) NOT NULL,
	[UOMName] [varchar](50) NULL,
	[username] [varchar](50) NULL,
	[dtStamp] [date] NULL,
	[LoginHistoryId] [int] NULL,
	[CCode] [int] NULL,
 CONSTRAINT [PK_STK_UOM] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockReportM]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockReportM](
	[ProductID] [nvarchar](255) NULL,
	[StockInHand] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockReportS]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockReportS](
	[ProductID] [nvarchar](255) NULL,
	[StockinHand] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCompany]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCompany](
	[UserName] [varchar](50) NULL,
	[CCode] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGroup_Detail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroup_Detail](
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[UserGroupID] [varchar](20) NULL,
	[MenueID] [int] NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGroup_Master]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroup_Master](
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[UserGroupID] [varchar](20) NOT NULL,
	[UserGroupName] [varchar](100) NULL,
	[Status] [varchar](10) NULL,
	[LoginHistoryID] [int] NULL,
	[UserName] [varchar](100) NULL,
	[dtStamp] [datetime] NULL,
 CONSTRAINT [PK_UserGroup_Master] PRIMARY KEY CLUSTERED 
(
	[UserGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[App_Version] ADD  DEFAULT (getdate()) FOR [dtStamp]
GO
ALTER TABLE [dbo].[City] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[GL_Cash] ADD  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[GL_Cash] ADD  DEFAULT ((0)) FOR [AmountPaid]
GO
ALTER TABLE [dbo].[GL_Cash] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[GL_Ledger] ADD  CONSTRAINT [DF_GL_Ledger_Dr]  DEFAULT ((0)) FOR [Dr]
GO
ALTER TABLE [dbo].[GL_Ledger] ADD  CONSTRAINT [DF_GL_Ledger_Cr]  DEFAULT ((0)) FOR [Cr]
GO
ALTER TABLE [dbo].[GL_Ledger] ADD  CONSTRAINT [DF_GL_Ledger_PostStatus]  DEFAULT ((0)) FOR [PostStatus]
GO
ALTER TABLE [dbo].[GL_Ledger] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[POIncome] ADD  DEFAULT (NULL) FOR [AdjustedInPOS]
GO
ALTER TABLE [dbo].[POSaleDetail] ADD  DEFAULT (NULL) FOR [AdjustedIncomeLoss]
GO
ALTER TABLE [dbo].[PUR_PRDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[PUR_PRMaster] ADD  CONSTRAINT [DF_PRMaster_dtstamp]  DEFAULT (getdate()) FOR [dtstamp]
GO
ALTER TABLE [dbo].[PUR_PRMaster] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[PUR_PurchaseDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[PUR_PurchaseMaster] ADD  CONSTRAINT [DF_PurchaseMaster_dtstamp]  DEFAULT (getdate()) FOR [dtstamp]
GO
ALTER TABLE [dbo].[PUR_PurchaseMaster] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[PUR_PurchaseOrderDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[PUR_PurchaseOrderMain] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[PUR_Supplier] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_Customer] ADD  DEFAULT ((0)) FOR [CrLimit]
GO
ALTER TABLE [dbo].[SAL_Customer] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_InvoiceDetail] ADD  DEFAULT ((0)) FOR [ListRate]
GO
ALTER TABLE [dbo].[SAL_InvoiceDetail] ADD  DEFAULT ((0)) FOR [DisP]
GO
ALTER TABLE [dbo].[SAL_InvoiceDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_InvoiceDetail] ADD  DEFAULT ((0)) FOR [NetRate]
GO
ALTER TABLE [dbo].[SAL_InvoiceMaster] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_InvoiceMaster] ADD  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[SAL_InvoiceMaster] ADD  CONSTRAINT [DF_SAL_InvoiceMaster_IsNotify]  DEFAULT ((0)) FOR [IsNotify]
GO
ALTER TABLE [dbo].[SAL_QuotationDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_QuotationMaster] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_RateListDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_SalesOrderDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_SalesOrderMaster] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_SRInvoiceDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_SRInvoiceMaster] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_Territory] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[SAL_TransationType] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_Godown] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_GRN] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_GRNDetail] ADD  DEFAULT ((0)) FOR [Weight]
GO
ALTER TABLE [dbo].[STK_GRNDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_IGP] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_IGPDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_ProductGroups] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  CONSTRAINT [DF__STK_produ__MinLe__4222D4EF]  DEFAULT ((0)) FOR [MinLevel]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  CONSTRAINT [DF__STK_produ__MaxLe__4316F928]  DEFAULT ((0)) FOR [MaxLevel]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  CONSTRAINT [DF__STK_produ__ReOrd__440B1D61]  DEFAULT ((0)) FOR [ReOrdQty]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  CONSTRAINT [DF__STK_produ__LeadT__4BAC3F29]  DEFAULT ((0)) FOR [LeadTime]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  DEFAULT ((0)) FOR [ProdRate]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  DEFAULT ((0)) FOR [SRate]
GO
ALTER TABLE [dbo].[STK_productMaster] ADD  DEFAULT ((0)) FOR [DisP]
GO
ALTER TABLE [dbo].[STK_ProductSubGroup] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_StdPacking] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_Stock] ADD  CONSTRAINT [DF_STK_Stock_QtyIn]  DEFAULT ((0)) FOR [QtyIn]
GO
ALTER TABLE [dbo].[STK_Stock] ADD  CONSTRAINT [DF_STK_Stock_QtyOut]  DEFAULT ((0)) FOR [QtyOut]
GO
ALTER TABLE [dbo].[STK_Stock] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_StockAdjustment] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_StockAdjustmentDetail] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_StockTransfer] ADD  DEFAULT ('1') FOR [CCode]
GO
ALTER TABLE [dbo].[STK_UOM] ADD  DEFAULT ('1') FOR [CCode]
GO
/****** Object:  StoredProcedure [dbo].[sp_calculateInventoryDealerRate]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_calculateInventoryDealerRate]
	-- Add the parameters for the stored procedure here
	@OrderID AS int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @tbDealerRateDetail as table (orderID int,productCode nvarchar(50),RetailPrice decimal(18,2),DealerPrice decimal(18,2), NetDealerPrice decimal(18,2) ,NetDealerPct decimal(7,4))
	
	Declare @PaymentDisPct decimal(18,2)
	Declare @PaymentDate datetime

	select @PaymentDisPct = [PaymentDisPct],
			@PaymentDate = [PaymentDate]
	
	from [dbo].[POInventoryMaster]
	where ID = @OrderID


	insert into @tbDealerRateDetail
	select OrderID, ProductCode,RetailPrice ,DealerPrice, NetDealerPrice ,
	round((1 -(( NetDealerPrice/RetailPrice)))*100,4) as NetDealerRate

	from(

	select pom.ID as OrderID, pod.ProductCode, pod.RetailPrice, pod.ProductDiscount,
	Case 
	When IsNull(pod.IsManualRate,0) = 0 Then
		Round(((pod.RetailPrice*((100- isnull(pom.StdDisPct,0))/100))*((100- isnull(pom.BreakupDisPct,0))/100)*((100- isnull(pom.CatDisPct,0))/100)  - isnull(ProductDiscount,0)),2) 
	Else
		pod.DealerPrice
	End as DealerPrice
	,
	Case
		When IsNull(pod.IsManualRate,0) = 0 Then
		  Round(((pod.RetailPrice*((100- isnull(pom.StdDisPct,0))/100))*((100- isnull(pom.BreakupDisPct,0))/100)*((100- isnull(pom.CatDisPct,0))/100)  - isnull(ProductDiscount,0))  * ((100- isnull(pom.PaymentDisPct,0))/100),2) 
	Else
		pod.DealerPrice
	End	as NetDealerPrice
	from [dbo].[POInventoryMaster] pom
	inner join [dbo].[POInventoryDetail] pod on pom.ID = pod.OrderID
	where pom.ID = @OrderID
	)  tbDealerRate
/*
	if( @PaymentDisPct> 0.00 and @PaymentDate is not null)
	begin

	update @tbDealerRateDetail
	set NetDealerPrice = round(NetDealerPrice*(1- (@PaymentDisPct/100)),2,1),
		NetDealerPct   = round (( 1 - (round(NetDealerPrice*(1- (@PaymentDisPct/100)),2))/RetailPrice)*100, 4)

	end

*/	
	
	update pod
	set pod.[DealerPrice] = tdrd.DealerPrice ,pod.[NetDealerPrice] =tdrd.NetDealerPrice , pod.[NetProductDiscPct] = tdrd.NetDealerPct
	
	
	from  [dbo].[POInventoryDetail] pod

	inner join @tbDealerRateDetail tdrd on pod.OrderID = tdrd.orderID and pod.ProductCode = tdrd.productCode

	
	select @@ROWCOUNT

    -- Insert statements for procedure here
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dailyExpenseNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_dailyExpenseNotification]
 @reportDate  datetime
 as

begin
 
Declare @tbDailyExepense as table (ExpenseDate datetime, ExpenseType nvarchar(50), ExpenseDesc nvarchar(1000), ExpenseAmount decimal(18,2), Remarks nvarchar(500), Status nvarchar(25) , AdjustedDate datetime)
Declare @tbMonthlyExepense as table (ExpenseDate datetime, ExpenseType nvarchar(50), ExpenseDesc nvarchar(1000), ExpenseAmount decimal(18,2), Remarks nvarchar(500), Status nvarchar(25) , AdjustedDate datetime)
Declare @tbMonthlyExpenseOverview as table (ExpenseType nvarchar(50), ExpenseTypeAmount decimal(18,2))
Declare @tableHTML as nvarchar(max), @tableExpOverviewHTML as nvarchar(max)
Declare @MailItemID as int
Declare @TotalAdjusted as decimal(18,2)
Declare @TotalPending as decimal(18,2)
Declare @TotalMonthlyExpense as decimal(18,2)

Declare @som as datetime
set @som =  DATEADD(mm, DATEDIFF(mm, 0, @reportDate), 0) 
-- Current Date Expense 
insert into @tbDailyExepense(ExpenseDate , ExpenseType , ExpenseDesc, ExpenseAmount , Remarks, Status , AdjustedDate) 
exec [dbo].[sp_rp_dailExpenseDetail] @reportDate, @reportDate

 select @TotalAdjusted = sum( case Status when 'Adjusted' then ExpenseAmount else 0 end),
		@TotalPending = sum( case Status when 'Pending' then ExpenseAmount else 0 end)
 from @tbDailyExepense

 if (IsNull(@TotalAdjusted,0) + IsNull(@TotalPending,0)) > 0 
  begin
	  SET @tableHTML =
			N'<h2>Daily Expense(s)</h2>'+
			N'<h3>'+CONVERT(nvarchar(20),@reportDate,105)+'</h3>'+
			N'<table border=1 >' +
			N'<tr>'+
			N'<th>Expense Date</th><th>Type</th>' +
			N'<th>Decription</th><th>Expense Amount</th>'+
			N'<th>Remarks</th><th>Status</th>'+ 
			N'<th>Adjusted Date</th>'+
			N'</tr><tr>'
				
			+
			CAST ( ( select td =	convert(varchar(12), ExpenseDate, 105) , '', 
							td =	ExpenseType , '', 
							td =	IsNull(ExpenseDesc,'') ,'' ,
							td =	ExpenseAmount ,'' ,
							td =	Isnull(Remarks,'') ,'' ,
							td =    Status, '',
							td =	IsNull(convert(varchar(12), AdjustedDate, 105),'NA') ,'' 
                       			

							FROM @tbDailyExepense   
            
					  FOR XML PATH('tr'), TYPE 
			) AS NVARCHAR(MAX) ) +
			 N'<tr>'+
			N'<td colspan="3"><h4>Adjusted Expense</h4></td>' +
			N'<td colspan="4"><h4>'+CONVERT(varchar(20),@TotalAdjusted)+'</h4></td>'+ 
			N'</tr>'+
			 N'<tr>'+
			N'<td colspan="3"><h4>Pending Expense</h4></td>' +
			N'<td colspan="4"><h4>'+CONVERT(varchar(20),@TotalPending)+'</h4></td>'+ 
			N'</tr>'+
			 N'<tr>'+
			N'<td colspan="3"><h3>Total Expense</h3></td>' +
			N'<td colspan="4"><h3>'+CONVERT(varchar(20),@TotalPending+@TotalAdjusted)+'</h3></td>'+ 
			N'</tr>'+
			N'</table>' 
			-- End of Current Day expense
			-- Start of Monthly Expense overview
			-- Current Month Expense
			insert into @tbMonthlyExepense(ExpenseDate , ExpenseType , ExpenseDesc, ExpenseAmount , Remarks, Status , AdjustedDate) 
			exec [dbo].[sp_rp_dailExpenseDetail] @som, @reportDate
			
			insert into @tbMonthlyExpenseOverview
			select *
			From(
				Select ExpenseType, sum(ExpenseAmount) as ExpenseTypeAmount
				From @tbMonthlyExepense
				group by ExpenseType
			    ) ExpenseOverviewData
				Order by ExpenseTypeAmount desc

			select @TotalMonthlyExpense = sum(ExpenseTypeAmount)
			from @tbMonthlyExpenseOverview
			if isNull(@TotalMonthlyExpense,0)>0
			begin

				SET @tableExpOverviewHTML =  
				
				N'<h2>Monthly Expense Overview</h2>' +
				N'<h4>'+CONVERT(nvarchar(20),@som,105)+' To '+ CONVERT(nvarchar(20),@reportDate,105)+'</h4>'+
				N'<table border=1 >' +
				N'<tr>'+
				N'<th>Expense Type</th><th>Amount</th>' +
				N'</tr><tr>'
				
				+
				CAST ( ( select 
								td =	ExpenseType , '', 
								td =	ExpenseTypeAmount ,'' 
								  			
						 FROM @tbMonthlyExpenseOverview   
            
						  FOR XML PATH('tr'), TYPE 
				) AS NVARCHAR(MAX) ) +
				 N'<tr>'+
				N'<td><h3>Total Expense</h3></td>' +
				N'<td><h3>'+CONVERT(varchar(20),@TotalMonthlyExpense)+'</h3></td>'+ 
				N'</tr>'+
				N'</table>' 

			end
			
			SET @tableHTML = ISNULL(@tableHTML,'') + ISNULL(@tableExpOverviewHTML,'')
			BEGIN TRY
			
				--	select @tableHTML
			-- new way to send notidicarion email 
			Declare @title as nvarchar(50) = 'Daily Expense Notification!'
			select @tableHTML
			EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID output
			-- select @tableHTML
			END TRY
			BEGIN CATCH
			SELECT ERROR_MESSAGE()
			END CATCH
	end
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dailySaleClosure]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_dailySaleClosure] 
	-- Add the parameters for the stored procedure here
	@currentDate as datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--Monthend 	
	Declare @count as int = 0, @NextWorkingAddDD AS int = 1
	Declare @tbDailySale as table (SaleDate datetime,TotalSale decimal(18,2), TotalProfit  decimal(18,2), TotalAdjustedExpense decimal(18,2),PendingExpenses decimal(18,2),AdjustedPOSIncomeLoss decimal(18,2), OtherIncomeLoss decimal(18,2) )
	declare @tbClosingDay as table (closingDate datetime, LastClosingDate datetime, NextworkingDate datetime);
	declare @tbNextWorking as table (NextDayCashInHand decimal(18,2))
	declare @nextworkingDate as DATETIME

	if ((DATEName(dw, @currentDate)) = 'Saturday')
    begin
	set @NextWorkingAddDD = 2
    end
	
	insert into @tbClosingDay
	select @currentDate, (Select Max(SaleDate) from POSaleDetail), DATEADD(DD,@NextWorkingAddDD, @currentDate) 
	
	select @count = count(*) from POSaleDetail
	where SaleDate = @currentDate

	if (@count = 0)
	begin
	
		--Insert into @tbDailySale
		--Exec [dbo].[sp_rp_dailySaleStat] @currentDate, @currentDate
	
		--Insert into POSaleDetail(SaleDate, CashInHand, TotalSale, AdjustedExpense,AdjustedIncomeLoss,SaleClosure , ClosureBy, IsClosed ) 
		--output inserted.SaleClosure
		--into @tbNextWorking 
		--Select  closingDate, prevDay.SaleClosure, DailySale.TotalSale,DailySale.TotalAdjustedExpense,DailySale.AdjustedPOSIncomeLoss ,(isnull(prevDay.CashInHand,0)+isnull(DailySale.TotalSale,0)-isnull(DailySale.TotalAdjustedExpense,0) + IsNull(DailySale.AdjustedPOSIncomeLoss,0)), 'Dayend', 1
		--From @tbClosingDay closingDay
		--Left join  @tbDailySale DailySale on closingDay.closingDate = DailySale.SaleDate
		--Left join POSaleDetail prevDay on prevDay.SaleDate = closingDay.LastClosingDate

		Insert into POSaleDetail(SaleDate, CashInHand,ClosureBy,IsClosed ) 
		output inserted.CashInHand
		Select  closingDate, prevDay.SaleClosure,'Dayend', 0
		
		From @tbClosingDay closingDay
		Left join POSaleDetail prevDay on prevDay.SaleDate = closingDay.LastClosingDate

	end
	select @count = count(*) from POSaleDetail
	where SaleDate = @currentDate and isnull(IsClosed,0) = 1
	if (@count = 0)
	begin
		Insert into @tbDailySale
	    Exec [dbo].[sp_rp_dailySaleStat] @currentDate, @currentDate
		
		 update POSaleDetail	 
		 set IsClosed = 1, TotalSale= isnull(autoCalcSale.TotalSale,0), AdjustedExpense= isnull(autoCalcSale.TotalAdjustedExpense,0), AdjustedIncomeLoss =isnull(autoCalcSale.AdjustedPOSIncomeLoss,0)  , ClosureBy = 'Dayend', SaleClosure = ISNULL(CashInHand,0) +  isnull(autoCalcSale.TotalSale,0) - isnull(autoCalcSale.TotalAdjustedExpense,0) + isnull(autoCalcSale.AdjustedPOSIncomeLoss,0) - isnull(POSaleDetail.WithdrawCash,0) + isNull(POCashAdjustment,0)
		 output inserted.SaleClosure
		 into @tbNextWorking
		 From POSaleDetail
		 left join @tbDailySale autoCalcSale on  POSaleDetail.SaleDate = autoCalcSale.SaleDate
		 where POSaleDetail.SaleDate = @currentDate
	 end
	 else
	 begin
		  insert into @tbNextWorking
		  select SaleClosure from POSaleDetail
		  where  SaleDate = @currentDate
	 end
    if exists (select * from POSaleDetail 
						Inner Join @tbClosingDay ClosingDay on POSaleDetail.SaleDate = ClosingDay.NextworkingDate)
	begin
	      delete  
		  from POSaleDetail 
		   Where POSaleDetail.SaleDate = (select NextworkingDate from @tbClosingDay)
	end
	
	--else
	--	begin
	--		Insert into @tbDailySale
	--	    Exec [dbo].[sp_rp_dailySaleStat] @currentDate, @currentDate

	--		select @count = count(*) from POSaleDetail
	--		where SaleDate = @currentDate and isnull(IsClosed,0) = 1
	--		if (@count = 0)
	--		begin
	--		 update POSaleDetail	 
	--		 set IsClosed = 1, TotalSale= isnull(autoCalcSale.TotalSale,0), AdjustedExpense= isnull(autoCalcSale.TotalAdjustedExpense,0) , ClosureBy = 'Dayend', SaleClosure = ISNULL(CashInHand,0) +  isnull(autoCalcSale.TotalSale,0) - isnull(autoCalcSale.TotalAdjustedExpense,0) - isnull(POSaleDetail.WithdrawCash,0)
	--		 output inserted.SaleClosure
	--		 into @tbNextWorking
	--		 From POSaleDetail
	--		 left join @tbDailySale autoCalcSale on  POSaleDetail.SaleDate = autoCalcSale.SaleDate
	--		 where POSaleDetail.SaleDate = @currentDate
	--		end
	--		else
	--		begin
	--		  insert into @tbNextWorking
	--		  select SaleClosure from POSaleDetail
	--		  where  SaleDate = @currentDate
	--		end
	--	end

	insert into POSaleDetail(SaleDate, CashInHand, IsClosed)
	select ClosingDay.NextworkingDate, NextWorking.NextDayCashInHand,  0
	from @tbClosingDay ClosingDay 
	cross join @tbNextWorking NextWorking 

-- Insert statements for procedure here	

END
GO
/****** Object:  StoredProcedure [dbo].[sp_dailySaleClosureHistoryDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[sp_dailySaleClosureHistoryDetail]
 @fromDate  datetime,
 @toDate    datetime
 as

begin
  
 select SaleDate, CashInHand, isnull(TotalSale,0) TotalSale, isnull(AdjustedExpense,0) AdjustedExpense,Isnull(AdjustedIncomeLoss,0) AdjustedIncomeLoss,isnull(WithdrawCash,0) WithdrawCash,ISNULL(WithdrawBy,'') WithdrawBy,isNull(POCashAdjustment,0) POCashAdjustment,isnull(SaleClosure,0) SaleClosure,isnull([IsClosed],0) Closed ,ClosureBy
		 
 from POSaleDetail
 where SaleDate  between @fromDate and @toDate
 order by SaleDate desc
 
end
GO
/****** Object:  StoredProcedure [dbo].[sp_dailySaleClosureNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_dailySaleClosureNotification]
 @reportDate  datetime
 as

begin
 
Declare @tbDailySale as table (CashInHand decimal(18,2),TotalSale decimal(18,2),TotalAdjustedExpense decimal(18,2),WithdrawCash  decimal(18,2),WithdrawBy nvarchar(50),ClosingCash decimal(18,2),ClosureBy nvarchar(25), AdjustedIncomeLoss decimal(18,2),ClosingCashAdjustment decimal(18,2) )

Declare @tableHTML as nvarchar(max)
Declare @MailItemID as int



/* Old Logic
insert into @tbDailySale

Select CashInHand, isnull(DailySaleDetail.TotalSale,0), isnull(TotalProfit,0), isnull(TotalAdjustedExpense,0), CashInHand + isnull(DailySaleDetail.TotalSale,0) - isnull(TotalAdjustedExpense,0) as ClosingCash
From POSaleDetail 
Left Join(

	Select @reportDate as SaleDate,SUM( isnull(ProductSaleAmount,0)) TotalSale, sum(isnull(ProductProfit,0)) TotalProfit

	From ( 

			select DailySale.ProductCode, round((NetSalePrice*Qty),0) ProductSaleAmount, round((NetSalePrice - NetDealerPrice)*Qty,0) ProductProfit
			from
			(
				select ProductCode, Qty, NetRate as NetSalePrice
				from SAL_InvoiceMaster m
				inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
				where datediff(dd, InvoiceDate,@reportDate) = 0 
			) as DailySale
			inner join (
				select ProductCode, round(sum(NetDealerPrice)/COUNT(*),2) as NetDealerPrice
				from POInventoryDetail
				group by ProductCode

			) Inventory on Inventory.ProductCode = DailySale.ProductCode

		) DailySaleData
	
 ) DailySaleDetail on POSaleDetail.SaleDate = DailySaleDetail.SaleDate
 cross join
	( select sum(ExpenseAmount) TotalAdjustedExpense
		from POExpenseDetail
		where [Status] = 'Adjusted'
		and DATEDIFF(dd,AdjustedDate, @reportDate) = 0
	) ExpenseAdjusted
 where DATEDIFF(dd,POSaleDetail.SaleDate, @reportDate) = 0

*/
 
 insert into @tbDailySale(CashInHand,TotalSale,TotalAdjustedExpense, WithdrawCash,WithdrawBy,ClosingCash,ClosureBy,AdjustedIncomeLoss,ClosingCashAdjustment) 
 
 select CashInHand, isnull(TotalSale,0) TotalSale, isnull(AdjustedExpense,0) AdjustedExpense, isnull(WithdrawCash,0) WithdrawCash,ISNULL(WithdrawBy,'') WithdrawBy,isnull(SaleClosure,0) SaleClosure, ClosureBy,
		Isnull(AdjustedIncomeLoss,0) AdjustedIncomeLoss, isNull(POCashAdjustment,0) POCashAdjustment
 from POSaleDetail
 where SaleDate = @reportDate


  SET @tableHTML =
        N'<h2>Sales Closure('+CONVERT(nvarchar(20),@reportDate,111)+' )!</h2>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Starting Cash</th><th>Total Sale</th>' +
        N'<th>Expense Adjusted</th><th>Adjusted Income/Loss</th>'+
		N'<th>Cash Deposit</th><th>Received By</th>'+ 
		N'<th>Cash Adjustment</th><th>Closing Cash</th> <th>Closed By</th>'+
		N'</tr><tr>'
				
		+
        CAST ( ( select td =	CashInHand, '', 
                        td =	TotalSale , '', 
                        td =	TotalAdjustedExpense ,'' ,
						td =	AdjustedIncomeLoss ,'' ,
                        td =	WithdrawCash ,'' ,
						td =    WithdrawBy, '',
						td =	ClosingCashAdjustment ,'' ,
                        td =	ClosingCash,'' ,
						td =    ClosureBy
					

						FROM @tbDailySale   
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No Entry Available')
		BEGIN TRY
			
		--	declare @notificationEmailList as nvarchar(200), @businessEmail as nvarchar(100)

		--	select @notificationEmailList = NotificationEmail,  @businessEmail = Email
		--	from CNF_AppConfiguration


		--	EXEC msdb.dbo.sp_send_dbmail

		--	@profile_name			= 'BossEmailProfile',
		----	@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
		--    @recipients	            = @notificationEmailList,
		--	@subject				= 'Daily Sales Report!',
		--	@body_format			= 'HTML',
		--	@body					= @tableHTML,
		----	@from_address			= 'bossdrlhr@gmail.com',
		--	@from_address			= @businessEmail,
		--	@mailitem_id			= @MailItemID OUTPUT
						
		--	IF @MailItemID>0
		--	BEGIN
									
		--	select @MailItemID
						
		--	END
			
		--	select @tableHTML
		-- new way to send notidicarion email 
		Declare @title as nvarchar(50) = 'Sales Closure Notification!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID output
		--select @tableHTML
		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH

end
GO
/****** Object:  StoredProcedure [dbo].[sp_dailySaleReport]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_dailySaleReport]
 @reportDate  datetime
 as

begin
 
Declare @tbDailySale as table (CashInHand decimal(18,2),TotalSale decimal(18,2),TotalAdjustedExpense decimal(18,2),WithdrawCash  decimal(18,2),ClosingCash decimal(18,2),ClosureBy nvarchar(25) )

Declare @tableHTML as nvarchar(max)
Declare @MailItemID as int



/* Old Logic
insert into @tbDailySale

Select CashInHand, isnull(DailySaleDetail.TotalSale,0), isnull(TotalProfit,0), isnull(TotalAdjustedExpense,0), CashInHand + isnull(DailySaleDetail.TotalSale,0) - isnull(TotalAdjustedExpense,0) as ClosingCash
From POSaleDetail 
Left Join(

	Select @reportDate as SaleDate,SUM( isnull(ProductSaleAmount,0)) TotalSale, sum(isnull(ProductProfit,0)) TotalProfit

	From ( 

			select DailySale.ProductCode, round((NetSalePrice*Qty),0) ProductSaleAmount, round((NetSalePrice - NetDealerPrice)*Qty,0) ProductProfit
			from
			(
				select ProductCode, Qty, NetRate as NetSalePrice
				from SAL_InvoiceMaster m
				inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
				where datediff(dd, InvoiceDate,@reportDate) = 0 
			) as DailySale
			inner join (
				select ProductCode, round(sum(NetDealerPrice)/COUNT(*),2) as NetDealerPrice
				from POInventoryDetail
				group by ProductCode

			) Inventory on Inventory.ProductCode = DailySale.ProductCode

		) DailySaleData
	
 ) DailySaleDetail on POSaleDetail.SaleDate = DailySaleDetail.SaleDate
 cross join
	( select sum(ExpenseAmount) TotalAdjustedExpense
		from POExpenseDetail
		where [Status] = 'Adjusted'
		and DATEDIFF(dd,AdjustedDate, @reportDate) = 0
	) ExpenseAdjusted
 where DATEDIFF(dd,POSaleDetail.SaleDate, @reportDate) = 0

*/
 
 insert into @tbDailySale(CashInHand,TotalSale,TotalAdjustedExpense, WithdrawCash,ClosingCash,ClosureBy) 
 
 select CashInHand, isnull(TotalSale,0) TotalSale, isnull(AdjustedExpense,0) AdjustedExpense, isnull(WithdrawCash,0) WithdrawCash, isnull(SaleClosure,0) SaleClosure, ClosureBy
 from POSaleDetail
 where SaleDate = @reportDate


  SET @tableHTML =
        N'<h2>Sales Closure('+CONVERT(nvarchar(20),@reportDate,111)+' )!</h2>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Starting Cash</th><th>Total Sale</th>' +
        N'<th>Expense Adjusted</th><th>Cash Withdraw</th>'+ 
		N'<th>Closing Cash</th> <th>Closing By</th>'+
		N'</tr><tr>'
				
		+
        CAST ( ( select td =	CashInHand, '', 
                        td =	TotalSale , '', 
                        td =	TotalAdjustedExpense ,'' ,
                        td =	WithdrawCash ,'' ,
                        td =	ClosingCash,'' ,
						td =    ClosureBy
					

						FROM @tbDailySale   
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No Entry Available')
		BEGIN TRY
			
		--	declare @notificationEmailList as nvarchar(200), @businessEmail as nvarchar(100)

		--	select @notificationEmailList = NotificationEmail,  @businessEmail = Email
		--	from CNF_AppConfiguration


		--	EXEC msdb.dbo.sp_send_dbmail

		--	@profile_name			= 'BossEmailProfile',
		----	@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
		--    @recipients	            = @notificationEmailList,
		--	@subject				= 'Daily Sales Report!',
		--	@body_format			= 'HTML',
		--	@body					= @tableHTML,
		----	@from_address			= 'bossdrlhr@gmail.com',
		--	@from_address			= @businessEmail,
		--	@mailitem_id			= @MailItemID OUTPUT
						
		--	IF @MailItemID>0
		--	BEGIN
									
		--	select @MailItemID
						
		--	END
			
		--	select @tableHTML
		-- new way to send notidicarion email 
		Declare @title as nvarchar(50) = 'Sales Closure Notification!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID output

		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH

end



GO
/****** Object:  StoredProcedure [dbo].[sp_dailyStockChangeNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_dailyStockChangeNotification] 
	-- Add the parameters for the stored procedure here
	@reportDate  as datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Declare @tbStock as table (Sr int IDENTITY(1,1) NOT NULL,ShortName nvarchar(50),SupplierName nvarchar(50), ProductID nvarchar(50), ProductName nvarchar(250),ReOrdQty int,MinL int ,Stock int, PrevSell int, CurrSell int ,StockInHand int)
	
	Declare @tableHTML as nvarchar(Max)
	declare @stockChangedItem as nvarchar(max)
	Declare @MailItemID as int
	Declare @currentDateSaleCount int
	Declare @totalStockInHand int


	select @currentDateSaleCount= COUNT(*)
	from SAL_InvoiceMaster
	where DATEDIFF(dd,InvoiceDate,@reportDate) = 0 
  --select @currentDateSaleCount
  IF(@currentDateSaleCount>0)
  BEGIN
	insert into @tbStock
	exec [dbo].[sp_rp_dailyStock] @reportDate


    -- Old
	--select ROW_NUMBER() OVER (ORDER BY productMaster.ProductID ASC) as Sr,
		 
	--	Supplier.ShortName as SupplierName,productMaster.ProductID, productMaster.ProductName, inventory.Qty as Stock, isnull(prevsale.Qty,0) as PreSell,isnull(currsale.Qty,0) as currSell , inventory.Qty - isnull(prevsale.Qty,0) - isnull(currsale.Qty,0)  as StockInHand
	
	--from (
		
	--	select ProductCode, sum(Qty) as Qty
	--	From(
	--		select 	ProductCode, Qty
	--		from POInventoryDetail
	--		union all
	--		select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
	--		from POActivityDetail
	--		where ActivityType ='Exchange'
	--		and Status = 'Completed'
	--		union all
	--		select TargetProductCode ProductCode, TargetProductQty Qty
	--		from POActivityDetail
	--		where ActivityType ='Exchange'
	--		and Status = 'Completed'
	--		union all
	--		select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
	--		from POActivityDetail
	--		where ActivityType ='Returned'
	--		and Status = 'Completed'
	--	  )InvData			
		
	--	group by ProductCode
	--     ) inventory

	--	inner join STK_productMaster productMaster on inventory.ProductCode = productMaster.ProductID
	--	left join CNF_Supplier Supplier on productMaster.SupplierID = Supplier.ID
	--	left join 
	--	(
	--		select ProductCode, sum(Qty) as Qty 
	--		from SAL_InvoiceMaster sim
	--		inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
	--		where sim.InvoiceDate <  @reportDate
	--		group by ProductCode
	--	) prevsale on inventory.ProductCode = prevsale.ProductCode
	--	left join 
	--	(
	--		select ProductCode, sum(Qty) as Qty 
	--		from SAL_InvoiceMaster sim
	--		inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
	--		where sim.InvoiceDate =  @reportDate
	--		group by ProductCode
	--	) currsale on inventory.ProductCode = currsale.ProductCode
		
	--	order by Supplier.ID,productMaster.ProductID
		
		Select @totalStockInHand = sum(StockInHand) 
		From @tbStock


	--select 'Stock report', @reportDate
    -- Insert statements for procedure here
	
		SET @stockChangedItem = 
		
        CAST ( ( select 
						td =    SupplierName, '',
                        td =	ProductID , '', 
                        td =	ProductName ,'' ,
                        td =	Stock , '',
						td =	PrevSell  ,'',
						td =	CurrSell  ,'',					
						td =    StockInHand

						FROM @tbStock 
						WHERE  currSell>0 
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) )

		SET @stockChangedItem = REPLACE(@stockChangedItem, '<tr>', '<tr style = "background:yellow">')


	    SET @tableHTML =
        N'<h1>Stock Change Report ('+CONVERT(nvarchar(20),@reportDate,111)+' )!</h1>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Supplier</th><th>ProductCode</th>' +
        N'<th>ProductName</th><th>Total Stock</th>'+ 
		N'<th>Previous Sell</th><th>Today Sell</th> <th>StockInHand</th>' +
		N'</tr>'
		+
		@stockChangedItem		
		+
        CAST ( ( select 
						td =    SupplierName, '' ,
                        td =	ProductID , '', 
                        td =	ProductName ,'' ,
                        td =	Stock , '',
						td =	PrevSell  ,'',
						td =	CurrSell  ,'',					
						td =    StockInHand

						FROM @tbStock
						WHERE  currSell=0    
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		
        N'<tr>'+
		N'<td colspan="4"><h2>Total Stock In Hand</h2></td>' +
        N'<td colspan="2"><h2>'+CONVERT(varchar(20),@totalStockInHand)+'</h2></td>'+ 
		N'</tr>'+
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No Stock Available')
		BEGIN TRY
				
		Declare @title as nvarchar(50) = 'Stock Change on Sale/Return Report!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID OUTPUT
			
		--	EXEC msdb.dbo.sp_send_dbmail

		--	@profile_name			= 'BossEmailProfile',
		--	@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
		--	@subject				= 'Stock Change on Sale/Return Report!',
		--	@body_format			= 'HTML',
		--	@body					= @tableHTML,
		--	@from_address			= 'bossdrlhr@gmail.com',
		--	@mailitem_id			= @MailItemID OUTPUT
						
		--	IF @MailItemID>0
		--	BEGIN
									
		--	select @MailItemID
		--	END
			
		
		--select @tableHTML

		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH
	
  END -- if end

END




GO
/****** Object:  StoredProcedure [dbo].[sp_dailyStockReport]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_dailyStockReport] 
	-- Add the parameters for the stored procedure here
	@reportDate  as datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @tbStock as table (Sr int,SupplierName nvarchar(50), ProductID nvarchar(50), ProductName nvarchar(250), Stock int, PrevSell int, CurrSell int ,StockInHand int)
	Declare @tableHTML as nvarchar(Max)
	declare @stockChangedItem as nvarchar(max)
	Declare @MailItemID as int
	Declare @currentDateSaleCount int
	Declare @totalStockInHand int


	select @currentDateSaleCount= COUNT(*)
	from SAL_InvoiceMaster
	where DATEDIFF(dd,InvoiceDate,@reportDate) = 0 
  --select @currentDateSaleCount
  IF(@currentDateSaleCount>0)
  BEGIN
	insert into @tbStock
	select ROW_NUMBER() OVER (ORDER BY productMaster.ProductID ASC) as Sr,
		 
		Supplier.ShortName as SupplierName,productMaster.ProductID, productMaster.ProductName, inventory.Qty as Stock, isnull(prevsale.Qty,0) as PreSell,isnull(currsale.Qty,0) as currSell , inventory.Qty - isnull(prevsale.Qty,0) - isnull(currsale.Qty,0)  as StockInHand
	
	from (
		
		select ProductCode, sum(Qty) as Qty
		From(
			select 	ProductCode, Qty
			from POInventoryDetail
			union all
			select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
			from POActivityDetail
			where ActivityType ='Exchange'
			and Status = 'Completed'
			union all
			select TargetProductCode ProductCode, TargetProductQty Qty
			from POActivityDetail
			where ActivityType ='Exchange'
			and Status = 'Completed'
			union all
			select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
			from POActivityDetail
			where ActivityType ='Returned'
			and Status = 'Completed'
		  )InvData			
		
		group by ProductCode
	     ) inventory

		inner join STK_productMaster productMaster on inventory.ProductCode = productMaster.ProductID
		left join CNF_Supplier Supplier on productMaster.SupplierID = Supplier.ID
		left join 
		(
			select ProductCode, sum(Qty) as Qty 
			from SAL_InvoiceMaster sim
			inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			where sim.InvoiceDate <  @reportDate
			group by ProductCode
		) prevsale on inventory.ProductCode = prevsale.ProductCode
		left join 
		(
			select ProductCode, sum(Qty) as Qty 
			from SAL_InvoiceMaster sim
			inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			where sim.InvoiceDate =  @reportDate
			group by ProductCode
		) currsale on inventory.ProductCode = currsale.ProductCode
		
		order by Supplier.ID,productMaster.ProductID
		
		Select @totalStockInHand = sum(StockInHand) 
		From @tbStock


	--select 'Stock report', @reportDate
    -- Insert statements for procedure here
	
		SET @stockChangedItem = 
		
        CAST ( ( select 
						td =    SupplierName, '',
                        td =	ProductID , '', 
                        td =	ProductName ,'' ,
                        td =	Stock , '',
						td =	PrevSell  ,'',
						td =	CurrSell  ,'',					
						td =    StockInHand

						FROM @tbStock 
						WHERE  currSell>0 
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) )

		SET @stockChangedItem = REPLACE(@stockChangedItem, '<tr>', '<tr style = "background:yellow">')


	    SET @tableHTML =
        N'<h1>Stock Change Report ('+CONVERT(nvarchar(20),@reportDate,111)+' )!</h1>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Supplier</th><th>ProductCode</th>' +
        N'<th>ProductName</th><th>Total Stock</th>'+ 
		N'<th>Previous Sell</th><th>Today Sell</th> <th>StockInHand</th>' +
		N'</tr>'
		+
		@stockChangedItem		
		+
        CAST ( ( select 
						td =    SupplierName, '' ,
                        td =	ProductID , '', 
                        td =	ProductName ,'' ,
                        td =	Stock , '',
						td =	PrevSell  ,'',
						td =	CurrSell  ,'',					
						td =    StockInHand

						FROM @tbStock
						WHERE  currSell=0    
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		
        N'<tr>'+
		N'<td colspan="4"><h2>Total Stock In Hand</h2></td>' +
        N'<td colspan="2"><h2>'+CONVERT(varchar(20),@totalStockInHand)+'</h2></td>'+ 
		N'</tr>'+
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No Stock Available')
		BEGIN TRY
				
		Declare @title as nvarchar(50) = 'Stock Change on Sale/Return Report!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID OUTPUT
			
		--	EXEC msdb.dbo.sp_send_dbmail

		--	@profile_name			= 'BossEmailProfile',
		--	@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
		--	@subject				= 'Stock Change on Sale/Return Report!',
		--	@body_format			= 'HTML',
		--	@body					= @tableHTML,
		--	@from_address			= 'bossdrlhr@gmail.com',
		--	@mailitem_id			= @MailItemID OUTPUT
						
		--	IF @MailItemID>0
		--	BEGIN
									
		--	select @MailItemID
		--	END
			
		
		--select @tableHTML

		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH
	
  END -- if end

END




GO
/****** Object:  StoredProcedure [dbo].[sp_DatabaseBackupDayend]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_DatabaseBackupDayend]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	--DECLARE @DatabaseName udtNvarchar = 'NextGenERP_Dev'
	DECLARE @DatabaseName NVARCHAR(50) = DB_NAME()
	--SELECT @DatabaseName
	DECLARE @BackupPathRoot NVARCHAR(300) = 'E:\Db backup\Dayend Backup\'
	DECLARE @BackupFullPath NVARCHAR(300) = ''
	
	SET @BackupFullPath = @BackupPathRoot + @DatabaseName+'_'+CONVERT(NVARCHAR(25),GETDATE(),105) +'.bak'
		
	BACKUP DATABASE @DatabaseName
	TO DISK = @BackupFullPath
	--WITH FORMAT
	--,
	--NAME = CONCAT(@DatabaseName,'Full Database Backup');
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_dayend]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_dayend] 
	-- Add the parameters for the stored procedure here
	@currentDate as datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @eom as datetime
	set @currentDate = ISNULL(@currentDate, convert(date,GetDate()))
	declare @ib_salesNofification as bit, @ib_stockNotification bit, @ib_dailySaleClosueNotification bit, @ib_lowstockNotification bit, @ib_dailyExpenseNotification bit

	Select @ib_salesNofification = isnull(SalesNotification,0), @ib_stockNotification = ISNULL( DailyStockNotification,0), @ib_dailySaleClosueNotification = ISNULL(SalesClosureNotification,0),
	@ib_lowstockNotification = isnull(LowStockNotification,0), @ib_dailyExpenseNotification = ISNULL(DailyExpenseNotification,0)
	From CNF_AppConfiguration

	set @eom =  DATEADD(dd, -DAY(DATEADD(mm, 1, @currentDate)), DATEADD(mm, 1, @currentDate))
	-- if monthend on weekend then generate report one day before
   if ((DATEName(dw, @eom)) = 'Sunday')
    begin
	set @eom = DATEADD(DD, -1,@eom )
    end
			

	--Push Pending Sales Notifications!
	if @ib_salesNofification = 1
	begin
	  exec sp_NewSaleNotification
	end
	-- Daily Sale Closure
	 exec [dbo].[sp_dailySaleClosure] @currentDate
	 
	-- Daily Sale Closure Notication
	if @ib_dailySaleClosueNotification = 1
	begin
		exec dbo.sp_dailySaleClosureNotification @currentDate
	end

	-- Daily Expense Notification
	if @ib_dailyExpenseNotification = 1
	begin
	exec [dbo].[sp_dailyExpenseNotification] @currentDate
	end
	-- Daily Stock Report Notification
	if @ib_stockNotification = 1
	begin
	  exec sp_dailyStockChangeNotification @reportDate = @currentDate
	end 
	-- Low Stock notification
	if @ib_lowstockNotification = 1
	begin
	  exec sp_lowStockNotification @reportDate = @currentDate
	end 	
	-- Upcoming due invoices
	exec sp_UpcomingDueInvoicesNotification @currentDate
	
	-- Daily Backup
	exec dbo.sp_DatabaseBackupDayend
	
	
	--Monthend 	
	if (@currentDate =@eom)
	begin
		declare @som datetime;
		set @som = DATEADD(dd, -Day(@eom)+1,@eom)
		
		exec [dbo].sp_monthlySaleNotification  @som,@eom
		
	end
-- Insert statements for procedure here	


END
GO
/****** Object:  StoredProcedure [dbo].[sp_financialStatOverview]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_financialStatOverview]

 @startDate datetime ,
 @endDate datetime  
as
begin
select @startDate FromDate, @endDate ToDate , MAX(TotalPurchase) TotalPurchase ,SUM( isnull(ProductSaleAmount,0)) TotalSale, sum(isnull(ProductProfit,0)) TotalProfit, max(isnull(ExpenseAdjusted.TotalAdjustedExpense,0)) + max(isnull(ExpensePending.TotalPendingExpense,0)) TotalExpense

from ( 

	select MonthlySale.ProductCode, round((NetSalePrice*Qty),0) ProductSaleAmount, round((NetSalePrice - NetDealerPrice)*Qty,0) ProductProfit
	from
	(
		select ProductCode, Qty, NetRate as NetSalePrice
		from SAL_InvoiceMaster m
		inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
		where InvoiceDate between @startDate and @endDate
	) as MonthlySale
	inner join (
	select ProductCode, round(sum(NetDealerPrice)/COUNT(*),2) as NetDealerPrice
	from POInventoryDetail
	group by ProductCode

	) Inventory on Inventory.ProductCode = MonthlySale.ProductCode

) MonthlyProfitSaleData
cross join
( select sum(ExpenseAmount) TotalAdjustedExpense
	from POExpenseDetail
	where [Status] = 'AdjustInSale'
	and AdjustedDate between @startDate and @endDate
) ExpenseAdjusted
cross join
( select sum(ExpenseAmount) TotalPendingExpense
	from POExpenseDetail
	where [Status] = 'Pending'
	and ExpenseDate between @startDate and @endDate
) ExpensePending
cross join
( select SUM(m.InvoiceAmount) TotalPurchase
	from POInventoryMaster m 
	where InvoiceDate between @startDate and @endDate
) InventoryPurchase

end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAccountLedger]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_GetAccountLedger '0010080','Customer','01-Jan-16','6-Mar-16','Summary'
--exec sp_GetAccountLedger '0010080','Customer','01-Jan-16','6-Mar-16','Detail'

--exec sp_GetAccountLedger '0010080','Customer','01-Mar-16','6-Mar-16','Summary'
--exec sp_GetAccountLedger '0010080','Customer','01-Mar-16','6-Mar-16','Detail'

create PROCEDURE [dbo].[sp_GetAccountLedger]
	@Code as varchar(50),
	@Type as varchar(50),
	@FDate as Datetime,
	@TDate as Datetime,
	@ReportType as varchar(20) = 'Detail',
	@CCode as int
AS

BEGIN
	

	DECLARE @Party TABLE (ID int identity,Code varchar(50), Name varchar(250),
	Address varchar(250),City varchar(250),Phone varchar(250),Mobile varchar(250),ContactPerson varchar(250) )

	if @Type = 'Customer'
	insert into @Party
	select CustomerCode Code, CustomerName Name, CustomerAddress Address,(select top 1 CityName from City WHERE CityID = b.CityID) City,ResPhone Phone,Mobile,ContactPerson from SAL_Customer B where CustomerCode = @Code and CCode = @CCode

	if @Type = 'Supplier'
		insert into @Party
		select SupplierCode code, SupplierName Name, Address,(select top 1 CityName from City WHERE CityID = b.CityID) City,ResPhone Phone,Mobile, '' ContactPerson from PUR_Supplier b where SupplierCode = @Code and CCode = @CCode


	--if @Type = 'Employee'
	--	insert into @Party
	--	select EmployeeCode code, EmployeeName Name, EmployeeAddress Address,(select top 1 CityName from City WHERE CityID = b.CityID) City,ResPhone Phone,Mobile, '' ContactPerson from HR_Employee b where EmployeeCode = @Code
if @ReportType = 'Detail'
begin
	if @Type = 'GL'
		BEGIN	
		insert into @Party
		select AcNo code, Acname Name, '' Address, '' City,'' Phone,'' Mobile, '' ContactPerson  from chartofAccount where AcNo = @Code and CCode = @CCode

			select b.*,c.AutoID,
			c.Date,c.InvoiceNo,c.Description,c.Dr,c.Cr
			from @Party B , GL_Ledger c WHERE b.Code=c.AcNo and c.Date>= @FDate and c.Date <= @TDate and c.AcNo = @Code and c.CCode = @CCode
		END
	else
		BEGIN	
			select b.*,c.AutoID,
			c.Date,c.InvoiceNo,c.Description,c.Dr,c.Cr
			from @Party B , GL_Ledger c WHERE b.Code=c.Code and c.Date>= @FDate and c.Date <= @TDate and c.Code = @Code and c.CCode = @CCode
		END
end

if @ReportType = 'Summary'
begin

	--INSERT INTO @Ledger_T
	--EXEC paksondb.dbo.sp_GetAccountLedgerSummary @Code,@FDate,@TDate

Declare @Ledger_Temp Table(
AutoID bigint,
Code varchar(50),
Date datetime,
invoiceNo varchar(50),
DR Numeric(16,2),
CR Numeric(16,2),
Description varchar(max)
)

Declare @Ledger_T Table(
Code varchar(50),
invoiceNo varchar(50),
Date datetime,
Description varchar(max),
DR Numeric(16,2),
CR Numeric(16,2)
)


		insert into @Ledger_Temp(AutoID,Code, Date, invoiceNo, Description, DR, cr)
		select AutoID,Code, Date, InvoiceNo, Description, Dr, cr 
		from GL_Ledger c WHERE c.Date>= @FDate and c.Date <= @TDate and c.Code = @Code and c.CCode = @CCode

		insert into @Ledger_T (Code,Date, invoiceNo, Description, DR, CR)
		Select  a.Code, B.Date, A.InvoiceNo, B.description, NULL, A.balance from
		(select InvoiceNo,Code, abs(sum(dr - cr)) Balance from @Ledger_Temp
		group by InvoiceNo, Code having sum(dr - cr) <0 )A,
		
		(select Date, InvoiceNo, description from @Ledger_Temp
		where AutoID in( select min(AutoID) from @Ledger_Temp group by invoiceNo)
		)B
		where A.InvoiceNo = B.invoiceNo
		
		insert into @Ledger_T (Code, Date, invoiceNo, Description, DR, CR)
		Select A.Code, B.Date, A.InvoiceNo, B.description, A.balance, NULL from
		(select Code, InvoiceNo, sum(dr - cr) Balance from @Ledger_Temp
		group by InvoiceNo, code having sum(dr - cr) >=0 )A,
		
		(select Date, InvoiceNo, description from @Ledger_Temp
		where AutoID in( select min(AutoID) from @Ledger_Temp group by invoiceNo)
		)B
		where A.InvoiceNo = B.invoiceNo
		
		--select * from @Ledger_T 

	select 0 ID,b.Code,b.Name,b.Address,b.City,b.Phone,b.Mobile,b.ContactPerson,0 AutoID,A.Date ,a.InvoiceNo, a.Description,a.Dr,a.Cr from @Ledger_T a,@Party b 
	where a.Code=b.Code

end

END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetAccountLedgerView]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAccountLedgerView]

	@Type as varchar(50) = 'Customer',
	@FDate as Datetime = '01-Jan-15',
	@TDate as Datetime = '01-Jan-16',
	@Code as varchar(50) = 'GRW001',
	@ReportType as varchar(50) = '',
	@InvType as varchar(50) = '',
	@CCode int
	
as
	declare @OpBal as float
	
	DECLARE @LedgerView TABLE (ID int ,Code varchar(50), Name varchar(250),
	Address varchar(250),City varchar(250),Phone varchar(250),Mobile varchar(250),ContactPerson varchar(250), 
	AutoId int,cDate Datetime,InvoiceNo varchar(50),Description varchar(Max),Dr Numeric(16,2),Cr Numeric(16,2)
	)
	set @OpBal = (select SUM(Dr-Cr) as Bal from GL_Ledger WHERE Code = @Code and Date < @FDate and CCode = @CCode)
	
	if @OpBal > 0 
		insert into @LedgerView (InvoiceNo,Description,Dr,Cr) values 
		('','Previous Balance',@OpBal,0)
	if @OpBal < 0 
		insert into @LedgerView (InvoiceNo,Description,Dr,Cr) values 
		('','Previous Balance',0,abs(@OpBal))
	
	insert into @LedgerView
exec sp_GetAccountLedger @Code,@Type,@FDate,@Tdate,@ReportType,@CCode

select convert(varchar, cDate, 106) EntDate,InvoiceNo,Description,case when Dr = 0.00 then null else DR end DR,
case when Cr = 0.00 then null else Cr end Cr from @LedgerView where InvoiceNo LIKE '%' + @InvType + '%' ORDER BY cDate,AutoId

--exec sp_GetAccountLedgerView 'Customer','01-Jan-16','06-Mar-16','0010080'
GO
/****** Object:  StoredProcedure [dbo].[sp_GetBarCode]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetBarCode]
	@CCode varchar(10)='1'
as
begin
SELECT a.ProductCode,b.ProductName,(select top 1 a1.Rate from SAL_RateListDetail a1,SAL_RateList b1 WHERE a1.RateListId=b1.RateListId and a1.ProductCode=a.ProductCode and a1.CCode=b1.CCode and a1.CCode=@CCode ORDER BY b1.EndDate DESC) SRate FROM PUR_BarCode a,STK_productMaster b WHERE a.productCode=b.ProductID and a.CCode = @CCode
end
	
--exec sp_GetBarCode '3'
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCBVchs]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetCBVchs]
	@InvoiceNo as varchar(50),
	@Type as varchar(50),
	@CCode as int
	
AS

BEGIN
	

	if @Type = 'CRV' or @Type = 'CPV' 		
		--Select InvoiceNo,Date,Code,dbo.getAccountName(Transof,Code ) Name,Description,a.Amount Rec,a.AmountPaid Paid,a.RecDate,a.CashCode,(SELECT AcName from chartofAccount WHERE AcNo = a.CashCode) CashAcName from gl_Cash a WHERE InvoiceNo = @InvoiceNo		
		Select InvoiceNo,Date,Code,dbo.getAccountName(Transof,Code,@CCode ) Name,dbo.getAccountAddress(Transof,Code,@CCode ) Address,dbo.getAccountCity(Transof,Code ,@CCode) City,Description,isNull(a.Amount,0) Rec,isNull(a.AmountPaid,0) Paid,a.RecDate,a.ReceiptNo RecNo,a.CashCode,(SELECT AcName from chartofAccount WHERE AcNo = a.CashCode and CCode = @CCode) CashAcName,CASE WHEN Transof <> 'GL' THEN (select SUM(Dr-Cr) as Bal from GL_Ledger WHERE Code = a.Code and CCode = @CCode and Date <= a.Date and InvoiceNo <> a.InvoiceNo and PostStatus = 1) else 0 end Balance from GL_Cash a WHERE InvoiceNo = @InvoiceNo and CCode = @CCode
	if @Type = 'BRV' or @Type = 'BPV' 		
		--Select InvoiceNo,Date,Code,dbo.getAccountName(Transof,Code ) Name,Description,a.Amount Rec,a.AmountPaid Paid,a.RecDate,a.BankCode,(SELECT AcName from chartofAccount WHERE AcNo = a.BankCode) CashAcName from GL_Bank a WHERE InvoiceNo = @InvoiceNo
		Select InvoiceNo,Date,Code,dbo.getAccountName(Transof,Code,@CCode ) Name,dbo.getAccountAddress(Transof,Code,@CCode ) Address,dbo.getAccountCity(Transof,Code ,@CCode) City,Description,isNull(a.Amount,0) Rec,isNull(a.AmountPaid,0) Paid,a.RecDate,a.ReceiptNo RecNo,a.BankCode CashCode,(SELECT AcName from chartofAccount WHERE AcNo = a.BankCode and CCode = @CCode) CashAcName,CASE WHEN Transof <> 'GL' THEN (select SUM(Dr-Cr) as Bal from GL_Ledger WHERE Code = a.Code and CCode = @CCode and Date <= a.Date and InvoiceNo <> a.InvoiceNo and PostStatus = 1) else 0 end Balance from GL_Bank a WHERE InvoiceNo = @InvoiceNo and CCode = @CCode
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetChartofAccount]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_GetChartofAccount]

@CCode as varchar(50)

as
begin
select * FROM chartofAccount where CCode = @CCode

end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCurrentRate]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_GetCurrentRate]

@PCode as varchar(50)
--@GodownId as varchar(50)
as
begin
select 
round(SUM((QtyIn-QtyOut)*Rate) /SUM(QtyIn-QtyOut),2) Rate 
from STK_Stock where RATE IS not NULL
and ProductCode = @PCode HAVING SUM(QtyIn-QtyOut) <> 0

--select ProductCode, SUM((QtyIn-QtyOut)*Rate) amt,
--SUM(QtyIn-QtyOut) Qty,SUM((QtyIn-QtyOut)*Rate) /SUM(QtyIn-QtyOut) Rate 
--from STK_Stock where RATE IS not NULL
--and ProductCode = @PCode 
--group by ProductCode

end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCurrentRate1]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_GetCurrentRate1]

@PCode as varchar(50),
@GodownId as varchar(50),
@Date as datetime,
@CCode as varchar(50)

as
begin
select 
isNull(SUM((QtyIn-QtyOut)*Rate),0) Amt 
--SUM((QtyIn-QtyOut)*Rate) /SUM(QtyIn-QtyOut) Rate 
from STK_Stock where RATE IS not NULL
and ProductCode = @PCode AND GodownId = @GodownId and CCode = @CCode and Date < @Date

--select ProductCode, SUM((QtyIn-QtyOut)*Rate) amt,
--SUM(QtyIn-QtyOut) Qty,SUM((QtyIn-QtyOut)*Rate) /SUM(QtyIn-QtyOut) Rate 
--from STK_Stock where RATE IS not NULL
--and ProductCode = @PCode 
--group by ProductCode

end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetCurrentStock1]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_GetCurrentStock1]

@PCode as varchar(50),
@GodownId as varchar(50),
@Date as datetime = getdate,
@CCode as varchar(50)

as
begin

select ISNULL(round(SUM(QtyIn-QtyOut),2),0) as Stock from STK_stock a where a.ProductCode = @PCode and a.GodownId = @GodownId AND a.CCode = @CCode and a.Date < @Date
--select ISNULL(SUM(QtyIn-QtyOut),0) as Stock from STK_stock a where a.rate is not null and a.ProductCode = @PCode and a.GodownId = @GodownId and a.Date < @Date

end

GO
/****** Object:  StoredProcedure [dbo].[sp_GetCustomersBalances]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetCustomersBalances]
	@ToDate as Datetime,
	@CusCode as varchar(50) = '',
	@SlsCode as varchar(50) = '',
	@CityId as int	= '-1',
	@Type as varchar(20) = 'Customer',
	@CCode as int
AS

--exec sp_GetCustomersBalances '11-Aug-16','','','-1','Employee'
BEGIN
	
if @Type = 'Customer'
	SELECT b.Code,a.CustomerName,(select CityName from City WHERE CityID=a.CityID) City ,sum(b.Dr-b.Cr) Balance	
	FROM SAL_Customer a,GL_Ledger b
	WHERE b.Code=a.CustomerCode and
	a.CustomerCode LIKE '%' + @CusCode + '%' and a.SlsCode LIKE '%' + @SlsCode + '%' and b.Date <= @ToDate --and a.CityId LIKE '%' + @CityId + '%'
	and a.CCode=b.CCode and b.CCode = @CCode
	--and b.PostStatus = 1
	GROUP BY b.Code,a.CustomerName,a.CityID


END   
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGLBatch]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetGLBatch]
	@CashCode as varchar(20) = '',
	@FDate as Datetime,
	@TDate as Datetime,
	@CCode as varchar(10)
AS
--exec sp_GetGLBatch '301010010001','01-Jan-16','20-Aug-16','1'
BEGIN


	Select InvoiceNo,Date,Description,RecDate,Amount,AmountPaid,Code,dbo.getAccountName(Transof,Code,CCode) Name,CCode from GL_Cash WHERE Date >= @FDate and Date<= @TDate and CashCode = @CashCode
	union all
	select InvoiceNo,Date,Description,Date RecDate,Dr Amount,Cr AmountPaid,Code,dbo.getAccountName(Transof,Code,CCode) Name,CCode from GL_Ledger where InvoiceNo IN (SELECT InvoiceNo from SAL_InvoiceMaster where InvoiceType = 'Cash' and CCode = @CCode) and CCode = @CCode and Date >= @FDate and Date<= @TDate and AcNo = @CashCode
end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPLS]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPLS]
	@FDate as Datetime,
	@TDate as Datetime,
	@CCode as varchar(50)
AS
----exec sp_GetPLS '01-Jan-16','31-Dec-16','001'
DECLARE @pls TABLE (ID int identity,AcNo varchar(50),AcNoP varchar(50),AcNoP2 varchar(250),AcNoP3 varchar(250), AcName varchar(250),
Opening Float,Bal Float,Closing Float)

DECLARE @Pls2 TABLE (AcNo varchar(50), AcName varchar(250),
AcLevel int,ParentAcNo varchar(50),ParentAcNo3 varchar(50), L1Name varchar(250), L2Name varchar(250), L3Name varchar(250), L4Name varchar(250),Bal Numeric(12,2))

--DECLARE @PlsDet TABLE (AcNo varchar(50), AcName varchar(250),Bal Float)

Declare @AcNo varchar(50)
Declare @AcName varchar(250)
Declare @Opening Float
Declare @Bal Float
Declare @Closing Float,
@ClosingStockValue as Float,
@OpeningStockValue as Float


BEGIN

	insert into @pls (AcNo,Bal,AcNoP,AcNoP2,AcNoP3) 	
	SELECT a.AcNO,sum(b.Dr-b.Cr) Bal,LEFT(a.AcNo,8),LEFT(a.AcNo,3),LEFT(a.AcNo,5)
	FROM chartofAccount a,GL_Ledger b
	WHERE (Left(a.AcNo,1) = 1 OR Left(a.AcNo,1) = 2) AND b.AcNo=a.AcNo and b.Date >= @FDate and b.Date <= @TDate 
	--WHERE (Left(a.AcNo,1) = 1 OR Left(a.AcNo,1) = 1) AND b.AcNo=a.AcNo and b.Date >= @FDate and b.Date <= @TDate 
	--and b.PostStatus = 1 
	and b.CCode = @CCode
	GROUP BY a.AcNO


	INSERT INTO @Pls2 (AcNo,ParentAcNo,ParentAcNo3,AcName,L2Name,L3Name,Bal)
	SELECT a.AcNoP,Left(a.AcNoP,3),Left(a.AcNoP,5),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP and CCode = @CCode),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP2 and CCode = @CCode),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP3 and CCode = @CCode),sum(a.Bal) Bal from chartofAccount b , @pls a WHERE b.AcNo=A.AcNo and Left(a.AcNo,3)=101 and CCode = @CCode GROUP BY a.AcNoP,a.AcNoP3,a.AcNoP2 --ORDER BY b.ParentAcNo,b.AcLevel

	INSERT INTO @Pls2 (AcNo,ParentAcNo,ParentAcNo3,AcName,L2Name,L3Name,Bal)
	SELECT a.AcNoP,300,Left(a.AcNoP,5),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP and CCode = @CCode),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP2 and CCode = @CCode),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP3 and CCode = @CCode),sum(a.Bal) Bal from chartofAccount b , @pls a WHERE b.AcNo=A.AcNo and Left(a.AcNo,3)=102 and CCode = @CCode GROUP BY a.AcNoP,a.AcNoP2,a.AcNoP3 --ORDER BY b.ParentAcNo,b.AcLevel

	DECLARE @StockValue TABLE (PCode varchar(50),MPCode varchar(50), PName varchar(500),OldPCode varchar(50),Unit varchar(50),Qty Float,Value Float,Rate Float)	
	
	set @OpeningStockValue = 0
	set @ClosingStockValue = 0
		
	--insert into @StockValue
	--exec sp_GetStockValuation '',@FDate,'','Raw Material'
	
	--set @OpeningStockValue = (select SUM(Value) from @StockValue)
	--Declare @TDate Datetime = '01-Dec-16'
	--set @OpeningStockValue = (select SUM(Amount) TAmt from stk_StockValue where InvoiceNo = (select top 1 InvoiceNo from stk_StockValue WHERE Date <= @FDate ORDER BY Date DESC))

	--INSERT INTO @Pls2 (AcNo,ParentAcNo,AcName,Bal)
	--select '20001','200','Opening Stock',@OpeningStockValue
	
	--insert into @StockValue
	--exec sp_GetStockValuation '',@TDate,'','Raw Material'
	
	--set @ClosingStockValue = (select SUM(Value) from @StockValue)
	--set @ClosingStockValue = (select SUM(Amount) TAmt from stk_StockValue where InvoiceNo = (select top 1 InvoiceNo from stk_StockValue WHERE Date <= @TDate ORDER BY Date DESC))

	--INSERT INTO @Pls2 (AcNo,ParentAcNo,AcName,Bal)
	--select '20002','200','Closing Stock',0-@ClosingStockValue

	INSERT INTO @Pls2 (AcNo,ParentAcNo,ParentAcNo3,AcName,L2Name,L3Name,Bal)
	SELECT a.AcNoP,Left(a.AcNoP,3),Left(a.AcNoP,5),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP and CCode = @CCode),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP2 and CCode = @CCode),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP3 and CCode = @CCode),sum(a.Bal) Bal from chartofAccount b , @pls a WHERE b.AcNo=A.AcNo and Left(a.AcNo,1) = 2 and CCode = @CCode GROUP BY a.AcNoP,a.AcNoP3,a.AcNoP2 --ORDER BY b.ParentAcNo,b.AcLevel
	--SELECT a.AcNoP,Left(a.AcNoP,3),(SELECT AcName FROM ChartofAccount where AcNo = a.AcNoP),sum(a.Bal) Bal from chartofAccount b , @pls a WHERE b.AcNo=A.AcNo and Left(a.AcNo,1) = 2 and Cast(Left(a.AcNo,5) as int)<=20106 GROUP BY a.AcNoP --ORDER BY b.ParentAcNo,b.AcLevel
	
 select * from @Pls2
 --select * from @Pls2 where Left(AcNo,1)=2
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetProductLedger]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProductLedger]
	@Code as varchar(50),
	@GodownId as varchar(50),
	@FDate as Datetime,
	@TDate as Datetime,
	@CCode as varchar(50)
	
AS

BEGIN
	
	DECLARE @ProductLedger TABLE (ID int identity,Code varchar(50), Name varchar(250),
	Unit varchar(50))

	insert into @ProductLedger
	select ProductID Code, ProductName Name, (select top 1 UOMName from STK_UOM WHERE UOMID = b.UOMID) Unit from STK_productMaster B where ProductID = @Code and CCode = @CCode

	select b.*, (select top 1 GodownName from STK_Godown WHERE GodownID = c.GodownId and CCode = @CCode) GodownName,
	c.Date,c.InvoiceNo,c.Description,c.QtyIn,c.QtyOut,c.Rate
	from @ProductLedger B , STK_Stock c WHERE b.Code=c.ProductCode and c.GodownId = @GodownId and c.Date>= @FDate and c.Date <= @TDate and c.ProductCode = @Code and c.CCode = @CCode
END
--select * from STK_Stock
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurInvoice]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPurInvoice]
	@invoiceNo varchar(50),
	@CCode varchar(10)='1',
	@InvType varchar(20)
AS
BEGIN
--	EXEC sp_GetSalesInvoice 'SINV-6753','Sale'
	
	Declare @Code as varchar(50)

	DECLARE @SalesInvoice TABLE (ID int identity,InvoiceNo varchar(50),CustomerCode varchar(50),InvoiceDate Datetime, 
	ProductCode varchar(30), ProductName varchar(500), Qty Float,Rate FLoat, ListRate Float,DisP Float,		
	Name varchar(500), Address varchar(500),City varchar(50),Phone varchar(50),Mobile varchar(50),Discount Float,InvType varchar(50)
	)
begin
	if @InvType = 'Purchase'
	BEGIN
	Select @Code = vendorCode
	from PUR_PurchaseMaster where InvoiceNo = @invoiceNo and CCode = @CCode
		
	INSERT INTO @SalesInvoice (InvoiceNo,CustomerCode,InvoiceDate,
	ProductCode,ProductName,Qty,Rate)
	SELECT a.InvoiceNo,a.vendorCode,a.PDate,
	b.ProductCode,c.ProductName,b.Qty,b.Rate
	from PUR_PurchaseMaster a,PUR_PurchaseDetail b,STK_productMaster c WHERE a.InvoiceNo=b.InvoiceNo and b.ProductCode=c.ProductID and a.InvoiceNo = @invoiceNo and a.CCode=b.CCode and a.CCode = @CCode
	END

	if @InvType = 'PurchaseReturn'
	BEGIN
	Select @Code = vendorCode
	from PUR_PRMaster where InvoiceNo = @invoiceNo and CCode = @CCode
		
	INSERT INTO @SalesInvoice (InvoiceNo,CustomerCode,InvoiceDate,
	ProductCode,ProductName,Qty,Rate)
	SELECT a.InvoiceNo,a.vendorCode,a.PDate,
	b.ProductCode,c.ProductName,b.Qty,b.Rate
	from PUR_PRMaster a,PUR_PRDetail b,STK_productMaster c WHERE a.InvoiceNo=b.InvoiceNo and b.ProductCode=c.ProductID and a.InvoiceNo = @invoiceNo and a.CCode=b.CCode and a.CCode = @CCode
	END

end
	
	select * from @SalesInvoice

END

--EXEC sp_GetSalesInvoice 'SINV-1','Sale','1'
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPurRegister]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetPurRegister]
	@FDate as Datetime,
	@TDate as Datetime,
	@Type as varchar(20),
	@PCode as varchar(50) = '',
	@CCode as varchar(50)
AS
--select * from STK_Godown
--update SAL_InvoiceMaster set GodownId = '001' where CCode = '008'
--exec sp_GetSalesRegister '1-May-16','25-aUG-17','Detail','','008'
--exec sp_GetSalesRegister '1-May-16','25-May-16','Detail','','','-1','BP-102'
BEGIN
--if @Code = ''
--	set @Code = '%'
--ELSE
--	set @Code = '%' + @Code + '%'

if @PCode = ''
	set @PCode = '%'
ELSE
	set @PCode = '%' + @PCode + '%'

--if @SlsCode = ''
--	set @SlsCode = '%'
--ELSE
--	set @SlsCode = '%' + @SlsCode + '%'

	if @Type = 'Detail'
		SELECT a.InvoiceNo,b.PDate InvoiceDate,a.ProductCode,p.ProductName,a.Qty,a.Rate,
		b.GodownId,d.GodownName
		FROM PUR_PurchaseDetail a , PUR_PurchaseMaster b ,STK_Godown d,STK_productMaster p
		WITH (NOLOCK)
		WHERE a.InvoiceNo=b.InvoiceNo 
		and b.GodownId=d.GodownID 
		and a.ProductCode =p.ProductID
		and b.PDate>= @FDate and b.PDate <= @TDate 
		and a.CCode = @CCode and b.CCode = @CCode and d.CCode = @CCode 
		and a.ProductCode LIKE @PCode 
	if @Type = 'Summary' 	
		SELECT a.InvoiceNo,b.PDate InvoiceDate
		,sum(a.Qty*a.Rate) GAmt,				
		b.GodownId,d.GodownName
		FROM PUR_PurchaseDetail a, PUR_PurchaseMaster b,STK_Godown d WHERE a.InvoiceNo=b.InvoiceNo and b.GodownId=d.GodownID
		and b.pDate>= @FDate and b.PDate <= @TDate 		
		and a.CCode = @CCode and b.CCode = @CCode and d.CCode = @CCode 
--		and a.ProductCode LIKE @PCode 	
		GROUP BY a.InvoiceNo,b.PDate,b.GodownId,d.GodownName
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalesInvoice]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSalesInvoice]
	@invoiceNo varchar(50),
	@Type varchar(20),
	@CCode varchar(10)='1'
AS
BEGIN
--	EXEC sp_GetSalesInvoice 'SINV-371','Sale','8'
	
	Declare @Code as varchar(50)

	DECLARE @SalesInvoice TABLE (ID int identity,InvoiceNo varchar(50),CustomerCode varchar(50),InvoiceDate Datetime, 
	ProductCode varchar(30), ProductName varchar(500), Qty Float,Rate FLoat, ListRate Float,DisP Float,		
	Name varchar(500), Address varchar(500),City varchar(50),Phone varchar(50),Mobile varchar(50),Discount Float,InvType varchar(50)
	)
if @Type = 'Sale'
begin
	Select @Code = CustomerCode 
	from SAL_InvoiceMaster where InvoiceNo = @invoiceNo and CCode = @CCode
		
	INSERT INTO @SalesInvoice (InvoiceNo,CustomerCode,InvoiceDate,
	ProductCode,ProductName,Qty,Rate,ListRate,Discount,InvType,Address,Name,Mobile)
	SELECT a.InvoiceNo,a.CustomerCode,a.InvoiceDate,
	b.ProductCode,c.ProductName,b.Qty,b.Rate,b.ListRate,b.DisP,a.InvoiceType,(select top 1 CompanyName from Company where CCode = a.CCode),a.SSName,a.phone
	from SAL_InvoiceMaster a,SAL_InvoiceDetail b,STK_productMaster c WHERE a.InvoiceNo=b.InvoiceNo and b.ProductCode=c.ProductID and a.InvoiceNo = @invoiceNo and a.CCode=b.CCode and a.CCode = @CCode
end

--if @Type = 'Return'
--begin
--	Select @Code = CustomerCode, 
--	@OrderOf=Invoiceof,@AddaId=AddaId from SAL_SRInvoiceMaster where InvoiceNo = @invoiceNo
--end
	
--DECLARE @Discounts TABLE (ID int identity, PolicyID varchar(30), PolicyName varchar(30),   PolicyPrec numeric(10,2), Discount numeric(10,2))


--if @OrderOf = 'Customer'
--	update @SalesInvoice set Name = (select CustomerName from SAL_Customer B where CustomerCode = @Code),
--	Address = (select CustomerAddress from SAL_Customer B where CustomerCode = @Code),
--	City = (select (select top 1 CityName from City WHERE CityID = b.CityID) from SAL_Customer B where CustomerCode = @Code),
--	Phone = (select ResPhone from SAL_Customer B where CustomerCode = @Code),
--	Mobile = (select Mobile from SAL_Customer B where CustomerCode = @Code),
--	ContactPerson = (select ContactPerson from SAL_Customer B where CustomerCode = @Code),
--	Dealerships = (select Dealerships from SAL_Customer B where CustomerCode = @Code),
--	CrLimit = (select CrLimit from SAL_Customer B where CustomerCode = @Code),
--	Adda = (select Name from Adda WHERE AddaID = @AddaId)


--if @OrderOf = 'Supplier'
--	update @SalesInvoice set Name = (select SupplierName from PUR_Supplier B where SupplierCode = @Code),
--	Address = (select Address from PUR_Supplier B where SupplierCode = @Code),
--	City = (select (select top 1 CityName from City WHERE CityID = b.CityID) from HR_Employee B where EmployeeCode = @Code),
--	Phone = (select Phone from PUR_Supplier B where SupplierCode = @Code),
--	Mobile = (select Mobile from PUR_Supplier B where SupplierCode = @Code),
--	--ContactPerson = (select ContactPerson from SAL_Customer B where CustomerCode = @Code),
--	--Dealerships = (select Dealerships from SAL_Customer B where CustomerCode = @Code),
--	--CrLimit = (select CrLimit from SAL_Customer B where CustomerCode = @Code),
--	Adda = (select Name from Adda WHERE AddaID = @AddaId)
	
	select * from @SalesInvoice
--END	
END

--EXEC sp_GetSalesInvoice 'SINV-1','Sale','1'

--select * from Company
--select * from SAL_InvoiceMaster where InvoiceNo = 'SINV-1' and CCode = 8
--select * from SAL_InvoiceDetail where InvoiceNo = 'SINV-1' and CCode = 8
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalesItemTrend]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetSalesItemTrend]
	@ToDate as Datetime,
	@PCode as varchar(50) = '',
	@Group1 as varchar(Max) = '',
	@Group2 as varchar(Max) = ''
AS
	set @PCode = '%' + @PCode + '%'

	DECLARE @TempInvoiceDetail TABLE (InvoiceNo varchar(50),ProductCode varchar(50),Qty Float,Rate Float,DisP Float,NetRate Float,AutoId int) 
	DECLARE @TempInvoiceMaster TABLE (InvoiceNo varchar(50),CustomerCode varchar(50),InvoiceDate Datetime,Status varchar(20)) 
	
	
DECLARE @SalenItemTrend TABLE (ID int identity,PCode varchar(50), 
Qty1 Float,Qty2 Float,Qty3 Float,Qty4 Float,Qty5 Float,Qty6 Float,Qty7 Float,Qty8 Float,Qty9 Float,Qty10 Float,Qty11 Float,Qty12 Float,
Amt1 Float,Amt2 Float,Amt3 Float,Amt4 Float,Amt5 Float,Amt6 Float,Amt7 Float,Amt8 Float,Amt9 Float,Amt10 Float,Amt11 Float,Amt12 Float,
Date1 Datetime,Date2 Datetime,Date3 Datetime,Date4 Datetime,Date5 Datetime,Date6 Datetime,Date7 Datetime,Date8 Datetime,Date9 Datetime,Date10 Datetime,Date11 Datetime,Date12 Datetime
)

Declare @Date1 Datetime
Declare @Date2 Datetime
Declare @Date3 Datetime
Declare @Date4 Datetime
Declare @Date5 Datetime
Declare @Date6 Datetime
Declare @Date7 Datetime
Declare @Date8 Datetime
Declare @Date9 Datetime
Declare @Date10 Datetime
Declare @Date11 Datetime
Declare @Date12 Datetime


SELECT @Date1 = @ToDate,
@Date2 = dateadd(mm, -1, @ToDate),
@Date3 = dateadd(mm, -2, @ToDate),
@Date4 = dateadd(mm, -3, @ToDate),
@Date5 = dateadd(mm, -4, @ToDate),
@Date6 = dateadd(mm, -5, @ToDate),
@Date7 = dateadd(mm, -6, @ToDate),
@Date8 = dateadd(mm, -7, @ToDate),
@Date9 = dateadd(mm, -8, @ToDate),
@Date10 = dateadd(mm, -9, @ToDate),
@Date11 = dateadd(mm, -10, @ToDate),
@Date12 = dateadd(mm, -11, @ToDate)

SELECT @Date1 = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date1)),@Date1),101) ,
@Date2= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date2)),@Date2),101) ,
@Date3= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date3)),@Date3),101) ,
@Date4= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date4)),@Date4),101) ,
@Date5= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date5)),@Date5),101) ,
@Date6= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date6)),@Date6),101),
@Date7= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date7)),@Date7),101),
@Date8= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date8)),@Date8),101),
@Date9= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date9)),@Date9),101),
@Date10= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date10)),@Date10),101),
@Date11= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date11)),@Date11),101),
@Date12= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@Date12)),@Date12),101)


BEGIN
	
	if @Group1 is null
	INSERT INTO @TempInvoiceDetail (InvoiceNo ,ProductCode ,Qty ,Rate,DisP,NetRate ,AutoId )
	SELECT InvoiceNo,ProductCode,Qty,Rate,DisP,(Rate-(Rate*DisP/100)),AutoID FROM SAL_InvoiceDetail WHERE InvoiceNo IN (SELECT InvoiceNo FROM SAL_InvoiceMaster WHERE InvoiceDate >= @Date12 AND InvoiceDate <= @ToDate) and ProductCode IN (select Productid from STK_productMaster where ProductID LIKE @PCode AND Category = 'Finish Goods')

	if len(@Group1)<>0 
	INSERT INTO @TempInvoiceDetail (InvoiceNo ,ProductCode ,Qty ,Rate,DisP,NetRate ,AutoId )
	SELECT InvoiceNo,ProductCode,Qty,Rate,DisP,(Rate-(Rate*DisP/100)),AutoID FROM SAL_InvoiceDetail WHERE InvoiceNo IN (SELECT InvoiceNo FROM SAL_InvoiceMaster WHERE InvoiceDate >= @Date12 AND InvoiceDate <= @ToDate) and ProductCode IN (select Productid from STK_productMaster where ProductID LIKE @PCode AND Category = 'Finish Goods' and GroupID IN (select replace(ltrim(rtrim(item)),'''','') from dbo.splitString(@Group1,',')) and SubGroupID IN (select replace(ltrim(rtrim(item)),'''','') from dbo.splitString(@Group2,',')))
	
	INSERT INTO @TempInvoiceMaster (InvoiceNo ,CustomerCode ,InvoiceDate ,Status )
	SELECT InvoiceNo,CustomerCode,InvoiceDate,Status FROM SAL_InvoiceMaster WHERE InvoiceDate >= @Date12 AND InvoiceDate <= @ToDate

BEGIN   
		insert into @SalenItemTrend (PCode,Qty1)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date1 and b.InvoiceDate <= @ToDate --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty2)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date2 and b.InvoiceDate <= @Date1 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty3)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date3 and b.InvoiceDate <= @Date2 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty4)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date4 and b.InvoiceDate <= @Date3 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty5)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date5 and b.InvoiceDate <= @Date4 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty6)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date6 and b.InvoiceDate <= @Date5 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty7)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date7 and b.InvoiceDate <= @Date6 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty8)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date8 and b.InvoiceDate <= @Date7 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty9)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date9 and b.InvoiceDate <= @Date8 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty10)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date10 and b.InvoiceDate <= @Date9 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty11)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date11 and b.InvoiceDate <= @Date10 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Qty12)
		select a.ProductCode,sum(a.Qty)Qty from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date12 and b.InvoiceDate <= @Date11 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode
		
-->>>>>>>AMOUNT
		insert into @SalenItemTrend (PCode,Amt1)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date1 and b.InvoiceDate <= @ToDate --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt2)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date2 and b.InvoiceDate <= @Date1 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt3)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date3 and b.InvoiceDate <= @Date2 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt4)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date4 and b.InvoiceDate <= @Date3 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt5)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date5 and b.InvoiceDate <= @Date4 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt6)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date6 and b.InvoiceDate <= @Date5 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt7)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date7 and b.InvoiceDate <= @Date6 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt8)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date8 and b.InvoiceDate <= @Date7 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt9)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date9 and b.InvoiceDate <= @Date8 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt10)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date10 and b.InvoiceDate <= @Date9 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt11)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date11 and b.InvoiceDate <= @Date10 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode

		insert into @SalenItemTrend (PCode,Amt12)
		select a.ProductCode,sum(a.Qty*a.NetRate)Amt from @TempInvoiceDetail a,@TempInvoiceMaster b WHERE a.InvoiceNo=b.InvoiceNo and 
		b.InvoiceDate > @Date12 and b.InvoiceDate <= @Date11 --and a.ProductCode=c.ProductID --AND a.ProductCode LIKE @PCode 			
		GROUP BY a.ProductCode
				
	update @SalenItemTrend set Date1=@Date1,Date2=@Date2,Date3=@Date3,Date4=@Date4,Date5=@Date5,Date6=@Date6,Date7=@Date7,Date8=@Date8,Date9=@Date9,Date10=@Date10,Date11=@Date11,Date12=@Date12
	
END   

SELECT PCode,Date1,Date2,Date3,Date4,Date5,Date6,Date7,Date8,Date9,Date10,Date11,Date12,sum(Qty1) Qty1,sum(Qty2) Qty2,sum(Qty3) Qty3,sum(Qty4) Qty4,sum(Qty5) Qty5,sum(Qty6) Qty6,sum(Qty7) Qty7,sum(Qty8) Qty8,sum(Qty9) Qty9,sum(Qty10) Qty10,sum(Qty11) Qty11,sum(Qty12) Qty12,sum(Amt1) Amt1,sum(Amt2) Amt2,sum(Amt3) Amt3,sum(Amt4) Amt4,sum(Amt5) Amt5,sum(Amt6) Amt6,sum(Amt7) Amt7,sum(Amt8) Amt8,sum(Amt9) Amt9,sum(Amt10) Amt10,sum(Amt11) Amt11,sum(Amt12) Amt12 from @SalenItemTrend GROUP BY PCode,Date1,Date2,Date3,Date4,Date5,Date6,Date7,Date8,Date9,Date10,Date11,Date12
END

--exec sp_GetSalesnRecoveryComp '26-Jul-15','','SAL004',''

--exec sp_GetSalesItemTrend '31-Aug-16','','001','001','089'
--exec sp_GetSalesItemTrend '30-May-16','','','-1','','',''
--SELECT dbo.Sub_GetItemsSold ('01-Nov-15','01-DEC-15','B-102','','','-1')
--SELECT InvoiceNo,ProductCode,Qty,Rate,DisP,(Rate-(Rate*DisP/100)),AutoID FROM SAL_InvoiceDetail WHERE InvoiceNo IN (SELECT InvoiceNo FROM SAL_InvoiceMaster WHERE InvoiceDate >= '01-Sep-15' AND InvoiceDate <= '25-Aug-16') and ProductCode IN (select Productid from STK_productMaster where MPCode LIKE '%%' AND Category = 'Finish Goods' and MatCateID LIKE '%%')
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalesRateList]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSalesRateList]
	@RateListId as varchar(20),
	@CCode as varchar(10)
AS

BEGIN

select a.RateListId,a.Name,a.StartDate,b.ProductCode,c.ProductName,b.Rate [Sales Price],b.SRRate [Sales Return Price] from SAL_RateList a,SAL_RateListDetail b,STK_productMaster c WHERE a.RateListId=b.RateListId and b.ProductCode=c.ProductID
and a.RateListId = @RateListId and a.CCode=@CCode and a.CCode=b.CCode 

end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSalesRegister]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetSalesRegister]
	@FDate as Datetime,
	@TDate as Datetime,
	@Type as varchar(20),
	@PCode as varchar(50) = '',
	@CCode as varchar(50)
AS
--select * from STK_Godown
--update SAL_InvoiceMaster set GodownId = '001' where CCode = '008'
--exec sp_GetSalesRegister '1-May-16','25-aUG-17','Detail','','008'
--exec sp_GetSalesRegister '1-May-16','25-May-16','Detail','','','-1','BP-102'
BEGIN
	Declare @CashCode varchar(50),
	@OpCash Float,
	@ClsCash Float,
	@CRV Float,
	@CPV Float
--if @Code = ''
--	set @Code = '%'
--ELSE
--	set @Code = '%' + @Code + '%'

if @PCode = ''
	set @PCode = '%'
ELSE	
	set @PCode = '%' + @PCode + '%'

--if @SlsCode = ''
--	set @SlsCode = '%'
--ELSE
--	set @SlsCode = '%' + @SlsCode + '%'
DECLARE @SaleReg TABLE (InvoiceNo varchar(50),InvoiceDate Datetime,SSName varchar(200),Discount Float,ProductCode varchar(50),ProductName varchar(200),Qty Float,Rate Float,DisP Float,
	GodownId varchar(50),GodownName varchar(200),DisPrc Float,CRV Float,CPV Float,OpCash Float,ClsCash Float)
	
	if @Type = 'Detail'
		insert into @SaleReg (InvoiceNo,InvoiceDate,SSName,Discount,ProductCode,ProductName,Qty,Rate,DisP,GodownId,GodownName,DisPrc)
		SELECT a.InvoiceNo,b.InvoiceDate,b.SSName,b.Discount,a.ProductCode,p.ProductName,a.Qty,a.Rate,a.DisP,
		b.GodownId,d.GodownName,(b.Discount*100/isnull((SELECT sum(Qty*Rate) FROM SAL_InvoiceDetail WHERE InvoiceNo = b.InvoiceNo),1)) DisPrc
		FROM SAL_InvoiceDetail a , SAL_InvoiceMaster b ,STK_Godown d,STK_productMaster p
		WITH (NOLOCK)
		WHERE a.InvoiceNo=b.InvoiceNo 
		and b.GodownId=d.GodownID 
		and a.ProductCode =p.ProductID
		and b.InvoiceDate>= @FDate and b.InvoiceDate <= @TDate 
		and a.CCode = @CCode and b.CCode = @CCode and d.CCode = @CCode 
		and a.ProductCode LIKE @PCode 

        set @CashCode = (select top 1 CashAcNo from SAL_InvoiceMaster A where CCode = @CCode ORDER BY InvoiceDate DESC)
		SET @ClsCash = (select SUM(Dr-Cr) Bal from GL_Ledger where AcNo = @CashCode and Date <= @TDate and CCode = @CCode)
		SET @OpCash = (select SUM(Dr-Cr) Bal from GL_Ledger where AcNo = @CashCode and Date < @FDate and CCode = @CCode)
		
		SET @CRV = (select SUM(Dr-Cr) Bal from GL_Ledger where AcNo = @CashCode and Date >= @FDate and Date <= @tDate and CCode = @CCode and InvoiceNo LIKE 'CRV-%')
		SET @CPV = (select SUM(Cr-Dr) Bal from GL_Ledger where AcNo = @CashCode and Date >= @FDate and Date <= @tDate and CCode = @CCode and InvoiceNo LIKE 'CPV-%')
		
		update @SaleReg set OpCash=@OpCash,ClsCash=@ClsCash,CRV=@CRV,CPV=@CPV	
--	if @Type = 'Summary' 	
--		SELECT a.InvoiceNo,b.InvoiceDate
--		,sum(a.Qty*a.Rate) GAmt,				
--		b.GodownId,d.GodownName
--		FROM SAL_InvoiceDetail a, SAL_InvoiceMaster b,STK_Godown d WHERE a.InvoiceNo=b.InvoiceNo and b.GodownId=d.GodownID
--		and b.InvoiceDate>= @FDate and b.InvoiceDate <= @TDate 		
--		and a.CCode = @CCode and b.CCode = @CCode and d.CCode = @CCode 
----		and a.ProductCode LIKE @PCode 	
--		GROUP BY a.InvoiceNo,b.InvoiceDate,b.GodownId,d.GodownName
END
	select * from @SaleReg
GO
/****** Object:  StoredProcedure [dbo].[sp_GetStockPosition]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetStockPosition]
	@GodownId as varchar(Max),
	@FDate as Datetime,
	@TDate as Datetime,
	@CCode as int --varchar(10) 

	--exec sp_GetStockPosition '001','09-Feb-17','09-Feb-17','8'
--select * from stk_stock where ccode = '8'
AS

DECLARE @StockPosition TABLE (ID int identity,CCode int,GodownId varchar(50),OldPCode varchar(50),PCode varchar(50), PName varchar(500),
Opening Float,Rec Float,Issue Float,Closing Float)

Declare @OldPCode varchar(50)
Declare @PCode varchar(50)
Declare @PName varchar(250)
Declare @Opening Float
Declare @Rec Float
Declare @Issue Float
Declare @Closing Float

BEGIN
	
		
	insert into @StockPosition (PCode,GodownId,PName,Opening,Rec,Issue,Closing,CCode)
	SELECT a.ProductId PCode,b.GodownId,a.ProductName PName,0 Opening,0 Rec,0 Issue,sum(b.QtyIn-b.QtyOut) Closing,b.CCode
	FROM STK_productMaster a,STK_Stock b
	WHERE b.ProductCode=a.ProductId and b.Date <= @TDate --and b.GodownId = @GodownId 
	 --(' + @OrderList + ')
	and b.GodownId = @GodownId
	and b.CCode=@CCode --and b.CCode=a.CCode
	GROUP BY a.ProductId,a.ProductName,b.GodownId,b.CCode
	
	insert into @StockPosition (PCode,GodownId,PName,Rec,Issue,CCode)
	select a.ProductId ,b.GodownId,a.ProductName ,SUM(b.QtyIn),SUM(b.QtyOut),b.CCode FROM STK_productMaster a,STK_Stock b
	WHERE b.Date >= @FDate and b.Date <= @TDate and b.ProductCode=a.ProductId --and b.GodownId = @GodownId
	and b.GodownId = @GodownId
	and b.CCode=@CCode --and b.CCode=a.CCode

	GROUP BY a.ProductId ,b.GodownId,a.ProductName ,b.CCode
	
	insert into @StockPosition (PCode,GodownId,PName,Opening,CCode)
	select a.ProductId ,b.GodownId,a.ProductName ,SUM(b.QtyIn-b.QtyOut),b.CCode FROM STK_productMaster a,STK_Stock b
	WHERE b.Date < @FDate and b.ProductCode=a.ProductId --and b.GodownId = @GodownId
	and b.GodownId = @GodownId
	and b.CCode=@CCode --and b.CCode=a.CCode
	GROUP BY a.ProductId ,b.GodownId,a.ProductName ,b.CCode
		
END
	SELECT a.CCode,a.PCode,a.PName,(select UOMName from STK_UOM where id=b.UOMID) Unit,a.GodownId,SUM(a.Opening) Opening,SUM(a.Rec) Rec,SUM(a.issue) Issue,SUM(a.Closing) Closing from @StockPosition a,STK_productMaster b WHERE a.PCode=b.ProductID GROUP BY a.PCode,a.PName,a.GodownId,b.UOMID,a.CCode


GO
/****** Object:  StoredProcedure [dbo].[sp_GetStockValue]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetStockValue] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select CONVERT(date, getdate()) InventoryValueDate, sum(itemlevelTotal) InventoryValue
	from (
	
			select  inventory.ProductCode,inventory.Qty, isnull(sale.Qty,0) sqty, NetDealerPrice  ,(inventory.Qty - isnull(sale.Qty,0)) * NetDealerPrice as itemlevelTotal
	
			from (
		
				select 
		
				ProductCode, sum(Qty) as Qty , round(sum(distinct NetDealerPrice)/COUNT(distinct NetDealerPrice),2) as NetDealerPrice
				
					From(
						select 	ProductCode, Qty,NetDealerPrice
						from POInventoryDetail
						union all
						select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty, NetDealerPrice 
						from POActivityDetail
						where ActivityType ='Exchange'
						and Status = 'Done'
						union all
						select TargetProductCode ProductCode, TargetProductQty Qty ,NetDealerPrice
						from POActivityDetail
						where ActivityType ='Exchange'
						and Status = 'Done'
					  )InvData			
					group by ProductCode			
				 ) inventory
		 		
				left join 
				(
					select ProductCode, sum(Qty) as Qty 
					from SAL_InvoiceMaster sim
					inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			
					group by ProductCode
				) sale on inventory.ProductCode = sale.ProductCode
		
		)ItemLevelDetail
		
		
		
	
  

END


GO
/****** Object:  StoredProcedure [dbo].[sp_GetTrialBalance]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetTrialBalance]
	@FDate as Datetime,
	@TDate as Datetime,
	@CCode as varchar(50)
AS
--exec sp_GetTrialBalance '01-Jul-16','10-Aug-17','002'
DECLARE @TrialBalance TABLE (ID int identity,AcNo varchar(50), AcName varchar(250),
Opening Float,Bal Float,Closing Float)

Declare @AcNo varchar(50)
Declare @AcName varchar(250)
Declare @Opening Float
Declare @Bal Float
Declare @Closing Float


BEGIN
	insert into @TrialBalance (AcNo,AcName,Opening,Bal,Closing) 
	SELECT a.AcNO,a.AcName,0 Opening,0 Bal,sum(b.Dr-b.Cr) Closing
	FROM chartofAccount a,GL_Ledger b
	WHERE b.AcNo=a.AcNo and a.CCode = @CCode and b.CCode = @CCode and b.Date <= @TDate GROUP BY a.AcNO,a.AcName
	

	insert into @TrialBalance (AcNo,AcName,Opening,Bal,Closing) 	
	SELECT a.AcNO,a.AcName,0 Opening,sum(b.Dr-b.Cr) Bal,0 Closing
	FROM chartofAccount a,GL_Ledger b
	WHERE b.AcNo=a.AcNo and a.CCode = @CCode and b.CCode = @CCode and b.Date >= @FDate and b.Date <= @TDate GROUP BY a.AcNO,a.AcName

	insert into @TrialBalance (AcNo,AcName,Opening,Bal,Closing) 
	SELECT a.AcNO,a.AcName,sum(b.Dr-b.Cr) Opening,0 Bal,0 Closing
	FROM chartofAccount a,GL_Ledger b
	WHERE b.AcNo=a.AcNo and a.CCode = @CCode and b.CCode = @CCode and b.Date < @fDate GROUP BY a.AcNO,a.AcName


--	set @Bal = (select SUM(a.dr-a.cr) as Bal FROM GL_Ledger a 
--	WHERE a.Date >= @FDate and a.Date <= @TDate and a.AcNo = @AcNo)

--	set @Opening = (select SUM(a.dr-a.cr) as Bal FROM GL_Ledger a 
--	WHERE a.Date < @FDate and a.AcNo = @AcNo)

--	DECLARE db_cursor CURSOR FOR  


--OPEN db_cursor   
--FETCH NEXT FROM db_cursor INTO @AcNo,@AcName, @Opening , @Bal, @Closing	
--WHILE @@FETCH_STATUS = 0   
--BEGIN   
--	insert into @TrialBalance (AcNo,AcName,Opening,Bal,Closing) values 
--	(@AcNo,@AcName,@Opening,@Bal,@Closing)

--	set @Bal = (select SUM(a.dr-a.cr) as Bal FROM GL_Ledger a 
--	WHERE a.Date >= @FDate and a.Date <= @TDate and a.AcNo = @AcNo)

--	set @Opening = (select SUM(a.dr-a.cr) as Bal FROM GL_Ledger a 
--	WHERE a.Date < @FDate and a.AcNo = @AcNo)

	
--    update @TrialBalance set Opening = @Opening,Bal = @Bal
    
    
--    WHERE AcNo = @AcNo

--	FETCH NEXT FROM db_cursor INTO @AcNo,@AcName, @Opening , @Bal, @Closing	
--END   

--CLOSE db_cursor   
--DEALLOCATE db_cursor 
--SELECT AcNo,AcName,sum(Opening) Opening,sum(Bal) Bal,sum(Closing) Closing from @TrialBalance GROUP BY AcNo,AcName
SELECT b.AcNo,b.AcName,b.AcLevel,IsNull(b.ParentAcNo,b.AcNo) ParentAcNo,(SELECT AcName FROM ChartofAccount where AcNo = Left(b.AcNo,1) and CCode = @CCode) L1Name,(SELECT AcName FROM ChartofAccount where AcNo = Left(b.AcNo,3) and CCode = @CCode) L2Name,(SELECT AcName FROM ChartofAccount where AcNo = Left(b.AcNo,5) and CCode = @CCode) L3Name,(SELECT AcName FROM ChartofAccount where AcNo = Left(b.AcNo,8) and CCode = @CCode) L4Name,sum(a.Opening) Opening,sum(a.Bal) Bal,sum(a.Closing) Closing from chartofAccount b LEFT OUTER JOIN @TrialBalance a ON b.AcNo=A.AcNo GROUP BY b.AcNo,b.AcName,b.AcLevel,b.ParentAcNo ORDER BY b.ParentAcNo,b.AcLevel
END

GO
/****** Object:  StoredProcedure [dbo].[sp_lowStockNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_lowStockNotification] 
	-- Add the parameters for the stored procedure here
	@reportDate  as datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Declare @tbStock as table (Sr int IDENTITY(1,1) NOT NULL,SupplierName nvarchar(50), ProductID nvarchar(50), ProductName nvarchar(250),ReOrdQty int,MinL int ,Stock int, PrevSell int, CurrSell int ,StockInHand int)
	
	Declare @tableHTML as nvarchar(Max)
	declare @stockChangedItem as nvarchar(max)
	Declare @MailItemID as int
	Declare @currentDateSaleCount int
	Declare @totalStockInHand int


	select @currentDateSaleCount= COUNT(*)
	from SAL_InvoiceMaster
	where DATEDIFF(dd,InvoiceDate,@reportDate) = 0 
  --select @currentDateSaleCount
  IF(@currentDateSaleCount>0)
  BEGIN
	insert into @tbStock
	exec [dbo].[sp_rp_dailyStock] @reportDate
		
		Select @totalStockInHand = sum(isnull(MinL - StockInHand,0)) 
		From @tbStock
		WHERE  isnull(StockInHand,0) <  isnull(MinL,0)   

	--select 'Stock report', @reportDate
    -- Insert statements for procedure here
	
	    SET @tableHTML =
        N'<h1>Low Stock Notification ('+CONVERT(nvarchar(20),@reportDate,111)+' )!</h1>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Supplier</th><th>ProductCode</th>' +
        N'<th>ProductName</th><th>Total Stock</th>'+ 
		N'<th>Total Sell</th><th>StockInHand</th> <th>Min. Qty Level</th>' +
		N'<th>Short-fall Qty</th>'+
		N'</tr>'
			
		+
        CAST ( ( select 
						td =    SupplierName, '' ,
                        td =	ProductID , '', 
                        td =	ProductName ,'' ,
                        td =	isnull(Stock,0) , '',
						td =	isnull(PrevSell + CurrSell,0) ,'',
						td =	isnull(StockInHand,0)  ,'',					
						td =    isnull(MinL,0),'',
						td =  	isnull(MinL - StockInHand,0)				

						FROM @tbStock
						WHERE  isnull(StockInHand,0) <  isnull(MinL,0)
						order by  isnull(MinL - StockInHand,0)   
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		
        N'<tr>'+
		N'<td colspan="6"><h2>Total Short-fall Qty</h2></td>' +
        N'<td colspan="2"><h2>'+CONVERT(varchar(20),@totalStockInHand)+'</h2></td>'+ 
		N'</tr>'+
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No Low Stock Available')
		BEGIN TRY
				
		Declare @title as nvarchar(50) = 'Low Stock Item(s) Notification!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID OUTPUT
			
		--	EXEC msdb.dbo.sp_send_dbmail

		--	@profile_name			= 'BossEmailProfile',
		--	@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
		--	@subject				= 'Stock Change on Sale/Return Report!',
		--	@body_format			= 'HTML',
		--	@body					= @tableHTML,
		--	@from_address			= 'bossdrlhr@gmail.com',
		--	@mailitem_id			= @MailItemID OUTPUT
						
		--	IF @MailItemID>0
		--	BEGIN
									
		--	select @MailItemID
		--	END
			
		
		--select @tableHTML

		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH
	
  END -- if end

END




GO
/****** Object:  StoredProcedure [dbo].[sp_monthlySaleNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_monthlySaleNotification]
 @startDate  datetime, @endDate datetime 
 as

begin
 
Declare @tbMonthlySale as table (SaleDate datetime,TotalSale decimal(18,2), TotalProfit decimal(18,2),  TotalAdjustedExpense decimal(18,2),TotalPendingExpense decimal(18,2),
        AdjustedPOSIncomeLoss decimal(18,2), OtherIncomeLoss decimal(18,2)) 
Declare @tbMonthlySaleOverview as table(TotalSale decimal(18,2), TotalProfit decimal(18,2), IncomeLoss decimal(18,2), TotalExpense decimal(18,2))
Declare @tableHTML as nvarchar(max)
Declare @MailItemID as int

insert into @tbMonthlySale
exec [dbo].[sp_rp_dailySaleStat] @startDate,@endDate;

insert into @tbMonthlySaleOverview
select sum(TotalSale) as TotalSale, 
		sum(TotalProfit) as TotalProfit, 
		sum(isnull(AdjustedPOSIncomeLoss,0) + isnull(OtherIncomeLoss,0)) as IncomeLoss,
		sum(isnull(TotalAdjustedExpense,0) + isnull(TotalPendingExpense,0)) as TotalExpense

 from @tbMonthlySale


 

/*
insert into @tbMonthlySale

select SUM( isnull(ProductSaleAmount,0)) TotalSale, sum(isnull(ProductProfit,0)) TotalProfit, max(isnull(ExpenseAdjusted.TotalAdjustedExpense,0)) TotalAdjustedExpense, max(isnull(ExpensePending.TotalPendingExpense,0)) TotalPendingExpense

from ( 

	select MonthlySale.ProductCode, round((NetSalePrice*Qty),0) ProductSaleAmount, round((NetSalePrice - NetDealerPrice)*Qty,0) ProductProfit
	from
	(
		select ProductCode, Qty, NetRate as NetSalePrice
		from SAL_InvoiceMaster m
		inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
		where InvoiceDate between @startDate and @endDate
	) as MonthlySale
	inner join (
	select ProductCode, round(sum(NetDealerPrice)/COUNT(*),2) as NetDealerPrice
	from POInventoryDetail
	group by ProductCode

	) Inventory on Inventory.ProductCode = MonthlySale.ProductCode

) MonthlyProfitSaleData
cross join
( select sum(ExpenseAmount) TotalAdjustedExpense
	from POExpenseDetail
	where [Status] = 'Adjusted'
	and AdjustedDate between @startDate and @endDate
) ExpenseAdjusted
cross join
( select sum(ExpenseAmount) TotalPendingExpense
	from POExpenseDetail
	where [Status] = 'Pending'
	and ExpenseDate between @startDate and @endDate
) ExpensePending
*/


  SET @tableHTML =
        N'<h2>Monthly Sales Report('+CONVERT(nvarchar(20),@endDate,111)+' )!</h2>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Total Sale</th><th>Profit</th>' +
        N'<th>Income/Loss</th><th>Total Expense</th>'+ 
		
		N'</tr><tr>'
				
		+
        CAST ( ( select td =	TotalSale, '', 
                        td =	TotalProfit , '', 
                        td =	IncomeLoss ,'' ,
                        td =	TotalExpense 
					

						FROM @tbMonthlySaleOverview   
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No Montly Sale Available')
		BEGIN TRY

		Declare @title as nvarchar(50) = 'Monthly Sales Closure Notification!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID OUTPUT
		select 	@tableHTML
			--EXEC msdb.dbo.sp_send_dbmail

			--@profile_name			= 'BossEmailProfile',
			--@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
			--@subject				= 'Monthly Sale Report!',
			--@body_format			= 'HTML',
			--@body					= @tableHTML,
			--@from_address			= 'bossdrlhr@gmail.com',
			--@mailitem_id			= @MailItemID OUTPUT
						
			--IF @MailItemID>0
			--BEGIN
									
			--select @MailItemID
						
			--END
			
			--select @tableHTML
		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH


end
GO
/****** Object:  StoredProcedure [dbo].[sp_monthlySaleReport]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_monthlySaleReport]
 @startDate  datetime, @endDate datetime 
 as

begin
 
Declare @tbMonthlySale as table (TotalSale decimal(18,2), TotalProfit  decimal(18,2), TotalAdjustedExpense decimal(18,2), TotalPendingExpense decimal(18,2) )
Declare @tableHTML as nvarchar(max)
Declare @MailItemID as int

insert into @tbMonthlySale

select SUM( isnull(ProductSaleAmount,0)) TotalSale, sum(isnull(ProductProfit,0)) TotalProfit, max(isnull(ExpenseAdjusted.TotalAdjustedExpense,0)) TotalAdjustedExpense, max(isnull(ExpensePending.TotalPendingExpense,0)) TotalPendingExpense

from ( 

	select MonthlySale.ProductCode, round((NetSalePrice*Qty),0) ProductSaleAmount, round((NetSalePrice - NetDealerPrice)*Qty,0) ProductProfit
	from
	(
		select ProductCode, Qty, NetRate as NetSalePrice
		from SAL_InvoiceMaster m
		inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
		where InvoiceDate between @startDate and @endDate
	) as MonthlySale
	inner join (
	select ProductCode, round(sum(NetDealerPrice)/COUNT(*),2) as NetDealerPrice
	from POInventoryDetail
	group by ProductCode

	) Inventory on Inventory.ProductCode = MonthlySale.ProductCode

) MonthlyProfitSaleData
cross join
( select sum(ExpenseAmount) TotalAdjustedExpense
	from POExpenseDetail
	where [Status] = 'Adjusted'
	and AdjustedDate between @startDate and @endDate
) ExpenseAdjusted
cross join
( select sum(ExpenseAmount) TotalPendingExpense
	from POExpenseDetail
	where [Status] = 'Pending'
	and ExpenseDate between @startDate and @endDate
) ExpensePending



  SET @tableHTML =
        N'<h2>Monthly Sale Report('+CONVERT(nvarchar(20),@endDate,111)+' )!</h2>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Total Sale</th><th>Profit</th>' +
        N'<th>Expense Adjusted</th><th>Expense Pending</th>'+ 
		
		N'</tr><tr>'
				
		+
        CAST ( ( select td =	TotalSale, '', 
                        td =	TotalProfit , '', 
                        td =	TotalAdjustedExpense ,'' ,
                        td =	TotalPendingExpense 
					

						FROM @tbMonthlySale   
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No Montly Sale Available')
		BEGIN TRY

		Declare @title as nvarchar(50) = 'Monthly Sales Closure Notification!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID OUTPUT
			
			--EXEC msdb.dbo.sp_send_dbmail

			--@profile_name			= 'BossEmailProfile',
			--@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
			--@subject				= 'Monthly Sale Report!',
			--@body_format			= 'HTML',
			--@body					= @tableHTML,
			--@from_address			= 'bossdrlhr@gmail.com',
			--@mailitem_id			= @MailItemID OUTPUT
						
			--IF @MailItemID>0
			--BEGIN
									
			--select @MailItemID
						
			--END
			
			--select @tableHTML
		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH


end



GO
/****** Object:  StoredProcedure [dbo].[sp_NewSaleNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar
-- Create date: <Create Date,,>
-- Description:	For Sale Notification
-- =============================================
CREATE PROCEDURE [dbo].[sp_NewSaleNotification]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
	DECLARE @tableHTML  NVARCHAR(MAX)
	DECLARE @totalSale  Decimal(15,2) = 0.00
	DECLARE @MailItemID int
	DECLARE @tb_SalesNotificationData AS Table(
	InvoiceNo varchar(15),
	InvoiceDateTime varchar(25),
	InvoiceType varchar(15),
	CustomerName varchar(100),
	CustomerPhone varchar(50),
	ProductCode varchar(15),
	ProductName varchar(500),
	Rate		decimal(15,2),
	Qty			int,
	DisP		decimal(15,2),
	NetRate	decimal(15,2),
	ItemTotal decimal(15,2)
	)

	INSERT INTO @tb_SalesNotificationData
	SELECT InvoiceMaster.InvoiceNo, 
	CONVERT(varchar(25), InvoiceMaster.dtStamp,100) InvoiceDateTime,
	InvoiceMaster.InvoiceType,
	InvoiceMaster.SSName,
	InvoiceMaster.Phone,
	InvoiceDetail.ProductCode,
	productMaster.ProductName,
	InvoiceDetail.Rate,
	InvoiceDetail.Qty,
	InvoiceDetail.DisP,
	ROUND(InvoiceDetail.NetRate,2),
	(ROUND(InvoiceDetail.NetRate,2) * InvoiceDetail.Qty)

	FROM [dbo].[SAL_InvoiceMaster] InvoiceMaster
	INNER JOIN [dbo].[SAL_InvoiceDetail] InvoiceDetail ON InvoiceMaster.InvoiceNo = InvoiceDetail.InvoiceNo
	INNER JOIN	STK_productMaster productMaster on InvoiceDetail.ProductCode = productMaster.ProductID
	WHERE IsNull(InvoiceMaster.isNotify,0) = 0
	ORDER BY InvoiceMaster.dtStamp
	SELECT @totalSale = SUM(ItemTotal)
	FROM @tb_SalesNotificationData

	IF (@totalSale <> 0.00)
	BEGIN

	    SET @tableHTML =
        N'<h1>New Sale(s) Notification!</h1>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Invoice#</th><th>Invoice DateTime</th>' +
        N'<th>Customer</th><th>Contact#</th>'+ 
		N'<th>Code</th><th>Name</th>' +
		N'<th>Retail Price</th><th>Dis.%</th>' +
		N'<th>Dis. Price</th><th>QTY</th>' +
		N'<th>Total</th>'+
		N'</tr><tr>'
				
		+
        CAST ( ( select td =	InvoiceNo, '', 
                        td =	InvoiceDateTime , '', 
                        td =	isnull(CustomerName,'') , '',
						td =	isnull(CustomerPhone,'')  ,'',
						td =	ProductCode ,'',
						td =	ProductName ,'',
						td =	Rate ,'',
						td =	isnull(DisP,0) ,'',
						td =	NetRate,'',
						td =	Qty ,'',
						td =    ItemTotal

						FROM @tb_SalesNotificationData   
            
                  FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
		N'<tr>'+
		N'<td colspan="8"><h2>Total Sale</h2></td>' +
        N'<td colspan="8"><h2>'+CONVERT(varchar(20),@totalSale)+'</h2></td>'+ 
		N'</tr>'+
        N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'No New Sale')
		BEGIN TRY	
		
		Declare @title as nvarchar(50) = 'New Sale(s) Notification!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML, @MailItemID output

			

			--EXEC msdb.dbo.sp_send_dbmail

			--@profile_name			= 'BossEmailProfile',
			--@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
			--@subject				= 'New Sale(s) Notification!',
			--@body_format			= 'HTML',
			--@body					= @tableHTML,
			--@from_address			= 'bossdrlhr@gmail.com',
			--@mailitem_id			= @MailItemID OUTPUT
						
			IF @MailItemID>0
			BEGIN
						
				UPDATE [SAL_InvoiceMaster]
				SET isNotify = 1
				WHERE InvoiceNo IN ( SELECT InvoiceNo FROM @tb_SalesNotificationData)
				
			
			END
		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH

	
	END

END


GO
/****** Object:  StoredProcedure [dbo].[sp_POSCustomerSrhList]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_POSCustomerSrhList] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  Select Phone as ContactNo, 
  (Select top 1 SSName 
   From SAL_InvoiceMaster m 
   Where m.Phone = CustomerSearchData.Phone
   ) as CustomerName,
   totalBuyingWorth
  From
  (

	Select Phone , sum(BuyingWorth) as TotalBuyingWorth
	From(
			Select InvoiceDate ,
			SSName,
			Phone, 
			(
			select sum(NetRate*Qty) from 
			SAL_InvoiceDetail
			where InvoiceNo = sim.InvoiceNo
			 ) BuyingWorth

			From SAL_InvoiceMaster sim
			Where Phone != ''
		) CustomerData
	group by Phone
  ) CustomerSearchData
  Order by totalBuyingWorth desc



END
GO
/****** Object:  StoredProcedure [dbo].[sp_rp_dailExpenseDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_rp_dailExpenseDetail] 
	-- Add the parameters for the stored procedure here
	@fromDate datetime,
	@toDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @fromDate = convert(datetime,CONVERT(date,@fromDate))
	set @toDate = convert(datetime,CONVERT(date,@toDate))
	
	
	SELECT ExpenseDate, ExpenseType, ExpenseDesc, ExpenseAmount, Remarks, Status , AdjustedDate
	From POExpenseDetail
	where (ExpenseDate between @fromDate and @toDate)
	Or  (AdjustedDate between @fromDate and @toDate)

	order by ExpenseDate,ExpenseType, Status
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_rp_dailySaleStat]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_rp_dailySaleStat]
 @fromDate  datetime,
 @toDate datetime
 as

begin

Select  POSaleDetail.SaleDate,DailySale.TotalSale, TotalProfit,  TotalAdjustedExpense,TotalPendingExpense,
        AdjustedPOSIncomeLoss, OtherIncomeLoss  
From POSaleDetail 
Left Join(
	
	 select SaleDate, TotalSale,TotalProfit
	 from
	 (	
		
		Select SaleDate,SUM( isnull(ProductSaleAmount,0)) TotalSale, sum(isnull(ProductProfit,0)) TotalProfit 

		From ( 

			select DailySale.SaleDate, DailySale.ProductCode, round((NetSalePrice*Qty),0) ProductSaleAmount, round((NetSalePrice - NetDealerPrice)*Qty,0) ProductProfit
			from
			(
				select  convert(datetime,convert(date,m.InvoiceDate)) SaleDate, ProductCode, Qty, NetRate as NetSalePrice
				from SAL_InvoiceMaster m
				inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
				where convert(datetime,convert(date,InvoiceDate)) between @fromDate and @toDate
			) as DailySale
			inner join (
				select ProductCode, round(sum(NetDealerPrice)/COUNT(*),2) as NetDealerPrice
				from POInventoryDetail
				group by ProductCode

			) Inventory on Inventory.ProductCode = DailySale.ProductCode
			
		) SaleData
		group by SaleData.SaleDate

	) DailySaleData	 
	
 ) DailySale on POSaleDetail.SaleDate = DailySale.SaleDate
Left join
	( select AdjustedDate, sum(ExpenseAmount) TotalAdjustedExpense
		from POExpenseDetail
		where [Status] = 'Adjusted'
		and AdjustedDate between @fromDate and @toDate
		group by AdjustedDate
	) ExpenseAdjusted on ExpenseAdjusted.AdjustedDate = POSaleDetail.SaleDate 
	Left join
	( select ExpenseDate, sum(ExpenseAmount) TotalPendingExpense
		from POExpenseDetail
		where [Status] = 'Pending'
		and ExpenseDate between @fromDate and @toDate
		group by ExpenseDate
	) ExpensePending on ExpensePending.ExpenseDate = POSaleDetail.SaleDate 
  Left Join
  ( Select PostingDate, sum ( case IncomeType 
								when 2 then isnull(PostingAmount,0)*-1 
								else isnull(PostingAmount,0) end
								) AdjustedPOSIncomeLoss
     From POIncome 
	 Where IsNull([AdjustedInPOS],0) = 1	
	 And POIncome.PostingDate between @fromDate and @toDate
	 Group by POIncome.PostingDate
   ) tbAdjustedPOSIncomeLoss on tbAdjustedPOSIncomeLoss.PostingDate = POSaleDetail.SaleDate
   Left Join
    ( Select PostingDate, sum ( case IncomeType 
								when 2 then isnull(PostingAmount,0)*-1 
								else isnull(PostingAmount,0) end
								) OtherIncomeLoss
     From POIncome 
	 Where IsNull([AdjustedInPOS],0) = 0	
	 And POIncome.PostingDate between @fromDate and @toDate
	 Group by POIncome.PostingDate
   ) tbOtherIncomeLoss on tbOtherIncomeLoss.PostingDate = POSaleDetail.SaleDate
where POSaleDetail.SaleDate between @fromDate and @toDate
/*
Select  POSaleDetail.SaleDate,DailySaleExpense.TotalSale, TotalProfit,  TotalAdjustedExpense,TotalPendingExpense
From POSaleDetail 
Left Join(
	
	 select SaleDate, TotalSale,TotalProfit, TotalAdjustedExpense,TotalPendingExpense
	 from
	 (	
		
		Select SaleDate,SUM( isnull(ProductSaleAmount,0)) TotalSale, sum(isnull(ProductProfit,0)) TotalProfit 

		From ( 

			select DailySale.SaleDate, DailySale.ProductCode, round((NetSalePrice*Qty),0) ProductSaleAmount, round((NetSalePrice - NetDealerPrice)*Qty,0) ProductProfit
			from
			(
				select  convert(datetime,convert(date,m.InvoiceDate)) SaleDate, ProductCode, Qty, NetRate as NetSalePrice
				from SAL_InvoiceMaster m
				inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
				where convert(datetime,convert(date,InvoiceDate)) between @fromDate and @toDate
			) as DailySale
			inner join (
				select ProductCode, round(sum(NetDealerPrice)/COUNT(*),2) as NetDealerPrice
				from POInventoryDetail
				group by ProductCode

			) Inventory on Inventory.ProductCode = DailySale.ProductCode
			
		) SaleData
		group by SaleData.SaleDate

	   ) DailySaleData	
	Left join
	( select AdjustedDate, sum(ExpenseAmount) TotalAdjustedExpense
		from POExpenseDetail
		where [Status] = 'Adjusted'
		and convert(datetime,convert(date,AdjustedDate)) between @fromDate and @toDate
		group by AdjustedDate
	) ExpenseAdjusted on ExpenseAdjusted.AdjustedDate = DailySaleData.SaleDate 
	Left join
	( select ExpenseDate, sum(ExpenseAmount) TotalPendingExpense
		from POExpenseDetail
		where [Status] = 'Pending'
		and convert(datetime,convert(date,ExpenseDate)) between @fromDate and @toDate
		group by ExpenseDate
	) ExpensePending on ExpensePending.ExpenseDate = DailySaleData.SaleDate 


 ) DailySaleExpense on POSaleDetail.SaleDate = DailySaleExpense.SaleDate
 where POSaleDetail.SaleDate between @fromDate and @toDate
*/
 

end
GO
/****** Object:  StoredProcedure [dbo].[sp_rp_dailyStock]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
CREATE PROCEDURE [dbo].[sp_rp_dailyStock] 
	-- Add the parameters for the stored procedure here
	@reportDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--set @reportDate = IsNull(@reportDate, convert(datetime,convert(date ,GETDATE())));
	set @reportDate = convert(datetime,CONVERT(date, getdate()))

select Sup.ShortName,productMaster.ProductID,productMaster.shortName as ProductShortName,productMaster.ProductName,productMaster.ReOrdQty ,productMaster.MinLevel, isnull(inventory.Qty,0) as Stock, isnull(prevsale.Qty,0) as PreSell,isnull(currsale.Qty,0) as currSell , isnull(inventory.Qty,0) - isnull(prevsale.Qty,0) - isnull(currsale.Qty,0)  as StockInHand, dbo.Get_EffectiveProductRate(productMaster.ProductID, @reportDate) as EffectiveRate
from STK_productMaster productMaster
Left Join(
	select ProductCode, sum(Qty) as Qty
		From(
			select 	ProductCode, Qty
			from POInventoryDetail
			union all
			select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
			from POActivityDetail
			where ActivityType ='Exchange'
			and Status = 'Completed'
			union all
			select TargetProductCode ProductCode, TargetProductQty Qty
			from POActivityDetail
			where ActivityType ='Exchange'
			and Status = 'Completed'
			union all
			select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
			from POActivityDetail
			where ActivityType ='Returned'
			and Status = 'Completed'
			union all
			select SourceProductCode ProductCode, SourceProductQty  as Qty 
			from POActivityDetail
			where ActivityType ='TransferFrom'
			and Status = 'Completed'
			union all
			select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
			from POActivityDetail
			where ActivityType ='TransferTo'
			and Status = 'Completed'
		  )InvData	
			group by ProductCode
	) inventory on inventory.ProductCode = productMaster.ProductID
	left join CNF_Supplier Sup on productMaster.SupplierID = Sup.ID
		left join 
		(
			select ProductCode, sum(Qty) as Qty 
			from SAL_InvoiceMaster sim
			inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			where sim.InvoiceDate <  @reportDate
			group by ProductCode
		) prevsale on inventory.ProductCode = prevsale.ProductCode
		left join 
		(
			select ProductCode, sum(Qty) as Qty 
			from SAL_InvoiceMaster sim
			inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			where sim.InvoiceDate =  @reportDate
			group by ProductCode
		) currsale on inventory.ProductCode = currsale.ProductCode
		
 order by currSell desc, productMaster.ProductID
/*
select
		Sup.ShortName,productMaster.ProductID, productMaster.ProductName,productMaster.ReOrdQty ,productMaster.MinLevel, inventory.Qty as Stock, isnull(prevsale.Qty,0) as PreSell,isnull(currsale.Qty,0) as currSell , inventory.Qty - isnull(prevsale.Qty,0) - isnull(currsale.Qty,0)  as StockInHand
	
	from (
		select ProductCode, sum(Qty) as Qty
		From(
			select 	ProductCode, Qty
			from POInventoryDetail
			union all
			select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
			from POActivityDetail
			where ActivityType ='Exchange'
			and Status = 'Completed'
			union all
			select TargetProductCode ProductCode, TargetProductQty Qty
			from POActivityDetail
			where ActivityType ='Exchange'
			and Status = 'Completed'
			union all
			select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty 
			from POActivityDetail
			where ActivityType ='Returned'
			and Status = 'Completed'
		  )InvData	
			group by ProductCode
	     ) inventory

		inner join STK_productMaster productMaster on inventory.ProductCode = productMaster.ProductID
		left join CNF_Supplier Sup on productMaster.SupplierID = Sup.ID
		left join 
		(
			select ProductCode, sum(Qty) as Qty 
			from SAL_InvoiceMaster sim
			inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			where sim.InvoiceDate <  @reportDate
			group by ProductCode
		) prevsale on inventory.ProductCode = prevsale.ProductCode
		left join 
		(
			select ProductCode, sum(Qty) as Qty 
			from SAL_InvoiceMaster sim
			inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			where sim.InvoiceDate =  @reportDate
			group by ProductCode
		) currsale on inventory.ProductCode = currsale.ProductCode
		
		order by currSell desc, productMaster.ProductID
*/		

END


GO
/****** Object:  StoredProcedure [dbo].[sp_rp_MiscIncomeDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_rp_MiscIncomeDetail]
 @fromDate  datetime,
 @toDate datetime
 
 as

begin
	select [Name] IncomeType, [PostingDate],[PostingAmount],[AdjustedInPOS],[Reference]
	from [dbo].[POIncome] poi
	inner join [dbo].[CNF_IncomeType] ip on poi.[IncomeType] = ip.[ID]
	where [PostingDate] between @fromDate and @toDate
 

end

GO
/****** Object:  StoredProcedure [dbo].[sp_rp_orderInvoiceDetailReport]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rp_orderInvoiceDetailReport] 
	-- Add the parameters for the stored procedure here
	@orderID  as int = null,
	@SupplierID as int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT sup.ShortName,pim.OrderNo,pim.OrderDate, pim.InvoiceNo, pim.InvoiceDate,pim.InvoiceAmount, pim.DueDate,pim.StdDisPct, pim.BreakupDisPct, pim.CatDisPct,pim.PaymentDate, pim.PaymentDisPct,
	pid.ProductCode, productMaster.ProductName, pid.RetailPrice, pid.ProductDiscount, pid.Qty,pid.DealerPrice ,pid.NetDealerPrice, pid.NetProductDiscPct ,isnull(pim.PaymentStatus,'Pending') as PaymentStatus,
	isnull(pim.PaymentAmount,0) PaymentAmount
	FROM POInventoryMaster pim
	INNER JOIN POInventoryDetail pid on pim.ID = pid.OrderID
	inner join STK_productMaster productMaster on pid.ProductCode = productMaster.ProductID
	inner join CNF_Supplier sup on sup.ID = pim.SupplierID
	where pim.id = ISNULL(@orderID,pim.id ) and pim.SupplierID = ISNULL(@SupplierID, pim.SupplierID)

	order by pim.id, pid.ProductCode




END


GO
/****** Object:  StoredProcedure [dbo].[sp_rp_POPaymentHistoryDetailReport]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rp_POPaymentHistoryDetailReport] 
	-- Add the parameters for the stored procedure here
	@SupplierID as int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select sup.ShortName SupplierName, [DisbursementID], POPayMain.[PaymentDate], POPayMain.[PaymentMode], Bank.Name as BankName, [PaymentAccount], POPayMain.[PaymentAmount],POPayMain.[PaymentReference],POPayMain.[Remarks],
	pim.InvoiceNo,[PaidPayment], isnull(AdjustedPayment,0) AdjustedPayment
	From [dbo].[POPaymentDisbursement] POPayMain
	Inner Join [dbo].[POPaymentDisbursementDetail] POpayDetail on POPayMain.ID = POpayDetail.[DisbursementID]
	Inner Join POInventoryMaster pim on pim.ID = POpayDetail.[OrderID]
	inner join CNF_Supplier sup on sup.ID = POPayMain.SupplierID
	Left Join CNF_Bank Bank on POPayMain.[PaymentBankID] = Bank.ID
	Where POPayMain.SupplierID = ISNULL(@SupplierID,POPayMain.SupplierID)



END


GO
/****** Object:  StoredProcedure [dbo].[sp_rp_POSCustomerList]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rp_POSCustomerList] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select InvoiceDate, SSName, Phone , BuyingWorth
from(
	select InvoiceDate ,
	SSName,
	Phone, 
	(
	select sum(NetRate*Qty) from 
	SAL_InvoiceDetail
	where InvoiceNo = sim.InvoiceNo
	 ) BuyingWorth

	from SAL_InvoiceMaster sim
	where Phone != ''
	) CustomerData
order by BuyingWorth desc, Phone 



END

GO
/****** Object:  StoredProcedure [dbo].[sp_rp_productBarcode]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rp_productBarcode] 
	-- Add the parameters for the stored procedure here
	@supplierID int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--set @reportDate = IsNull(@reportDate, convert(datetime,convert(date ,GETDATE())));
	
select sup.ShortName as BusinessName, pm.ProductID, dbo.Get_EffectiveProductRate( pm.ProductID, convert(datetime,(convert(date, getDate()))) ) effectiveRate
from  STK_productMaster pm
inner join CNF_Supplier sup on pm.SupplierID = sup.ID
where sup.ID = ISNULL (@supplierID,sup.ID)		

END

GO
/****** Object:  StoredProcedure [dbo].[sp_rp_RegisterSaleInvoiceDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_rp_RegisterSaleInvoiceDetail]
 @fromDate  datetime,
 @toDate datetime,
 @invoiceNo varchar(25) = null
 as

begin

	Select m.InvoiceNo, convert(datetime,convert(date,m.InvoiceDate)) InvoiceDate, m.InvoiceType, m.ReferenceNo, m.Phone, m.SSName, m.Status as InvoiceStatus, m.UserName,m.receivedAmount, m.balanceAmount,
	 s.ProductCode,s.Rate, s.Qty, s.DisP, s.DisAmt ,s.NetRate, s.Status as ItemStatus , ac.BusinessName, ac.BusinessShortName,ac.BusinessAddress, ac.Mobile as BusinessMobile, ac.LandLine as BusinessLandLine, ac.Email as BusinessEmail
	From SAL_InvoiceMaster m
	Inner join SAL_InvoiceDetail s on m.InvoiceNo = s.InvoiceNo
	cross join CNF_AppConfiguration ac
	where convert(datetime,convert(date,InvoiceDate)) between @fromDate and @toDate
	And	  m.InvoiceNo = ISNULL(@invoiceNo, m.InvoiceNo ) 	

	order by InvoiceDate 
 

end

GO
/****** Object:  StoredProcedure [dbo].[sp_rpt_ProductActivityDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rpt_ProductActivityDetail] 
	-- Add the parameters for the stored procedure here
@fromDate Datetime,
@toDate Datetime	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 Select ActivityDate, SourceProductCode, SourceProductQty, TargetProductCode, TargetProductQty, ActivityType, Status, 
		CompletionDate, TargetLocation, ActivityDetailDesc, UserID
 From [dbo].[POActivityDetail]
 Where ActivityDate Between @fromDate And @toDate
 order by ActivityDate

END


GO
/****** Object:  StoredProcedure [dbo].[sp_rpt_StockInHandValueDetail]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rpt_StockInHandValueDetail] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 Select SupShortName, ProductCode,PrdQtyInHand, PrdInHandDealerValue,PrdInHandRetailValue,
     round((1 -(( PrdInHandDealerValue/PrdInHandRetailValue)))*100,4) as PrdInHandMarginRate
   From
   (		
	select  sup.[ShortName] as SupShortName, inventory.ProductCode,(inventory.Qty - isnull(sale.Qty,0)) PrdQtyInHand,(inventory.Qty - isnull(sale.Qty,0)) * NetDealerPrice as PrdInHandDealerValue, 
             (inventory.Qty - isnull(sale.Qty,0)) * [dbo].[Get_EffectiveProductRate](inventory.ProductCode, convert(datetime,CONVERT(date, getdate()))) as PrdInHandRetailValue
	
			from (
		
				select 	ProductCode, sum(Qty) as Qty , round(sum(distinct NetDealerPrice)/COUNT(distinct NetDealerPrice),2) as NetDealerPrice
				
					From(
							select 	ProductCode, Qty,NetDealerPrice
							from POInventoryDetail
							union all
							select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty, NetDealerPrice 
							from POActivityDetail
							where ActivityType ='Exchange'
							and Status = 'Completed'
							union all
							select TargetProductCode ProductCode, TargetProductQty Qty ,NetDealerPrice
							from POActivityDetail
							where ActivityType ='Exchange'
							and Status = 'Completed'
							union all
							select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty,NetDealerPrice 
							from POActivityDetail
							where ActivityType ='Returned'
							and Status = 'Completed'
							union all
							select SourceProductCode ProductCode, SourceProductQty  as Qty ,NetDealerPrice
							from POActivityDetail
							where ActivityType ='TransferFrom'
							and Status = 'Completed'
							union all
							select SourceProductCode ProductCode, (SourceProductQty * -1) as Qty, NetDealerPrice 
							from POActivityDetail
							where ActivityType ='TransferTo'
							and Status = 'Completed'
					  )InvData			
					group by ProductCode			
				 ) inventory
		 		Inner Join STK_productMaster pm on pm.ProductID = inventory.ProductCode
				Inner Join CNF_Supplier sup on sup.ID = pm.SupplierId
				left join 
				(
					select ProductCode, sum(Qty) as Qty 
					from SAL_InvoiceMaster sim
					inner join 	SAL_InvoiceDetail si on sim.InvoiceNo = si.InvoiceNo
			
					group by ProductCode
				) sale on inventory.ProductCode = sale.ProductCode
		) StockData
		Where PrdQtyInHand> 0
			
	   order by SupShortName, ProductCode

END


GO
/****** Object:  StoredProcedure [dbo].[sp_saleInvoice_itemDetailForReturn]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_saleInvoice_itemDetailForReturn]
 @InvoiceNo  varchar(25)
 as

begin
 
 select InvoiceNo, AutoID, ProductCode, Qty, PrevReturnedQty, (Qty -   isnull(PrevReturnedQty  ,0)) as AvailableQty
 
 From   [dbo].[SAL_InvoiceDetail] SInvD
 left Join ( Select ReferenceID, SUM(ABS(Qty)) PrevReturnedQty  --logic updated
			  From [dbo].[SAL_InvoiceDetail] group by ReferenceID) SInvRetDetail  on SInvD.AutoID = SInvRetDetail.ReferenceID  
  where SInvD.InvoiceNo = @InvoiceNo

end



GO
/****** Object:  StoredProcedure [dbo].[sp_sendEmailNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_sendEmailNotification] 
	-- Add the parameters for the stored procedure here
	@title as nvarchar(100),
	@content as nvarchar(max),
	 @MailItemID as int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--Monthend 	
		BEGIN TRY
			
			declare @notificationEmailList as nvarchar(200), @businessEmail as nvarchar(100),@EmailProfileName as nvarchar(100)

			select	@notificationEmailList = NotificationEmail,  
					@businessEmail = Email,
					@EmailProfileName = [NotificationEmailProfile]

			from CNF_AppConfiguration


			EXEC msdb.dbo.sp_send_dbmail

			@profile_name			= @EmailProfileName, --= 'BossEmailProfile',
		--	@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
		    @recipients	            = @notificationEmailList,
			@subject				= @title,
			@body_format			= 'HTML',
			@body					= @content,
		--	@from_address			= 'bossdrlhr@gmail.com',
			@from_address			= @businessEmail,
			@mailitem_id			= @MailItemID OUTPUT
						
			
			
		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[sp_TopSellingItemOverviewReport]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TopSellingItemOverviewReport]
	-- Add the parameters for the stored procedure here
	
	@PeriodTypeID AS INT
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	DECLARE @today			DATETIME
	DECLARE @last3Months	DATETIME 
	DECLARE @last1Month		DATETIME 
	DECLARE @last6Months	DATETIME 
	DECLARE @last1year		DATETIME 
	DECLARE @thisMonth		DATETIME 
	DECLARE @thisYear		DATETIME 
	DECLARE @startRange		DATETIME 
	DECLARE @endRange		DATETIME
    --SELECT DATEADD(month, DATEDIFF(month, 0, @mydate), 0) AS StartOfMonth
	-- SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)) end of month
	-- SELECT DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) start year
	-- SELECT DATEADD (dd, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) +1, 0)) end year

	 SELECT @today = convert(datetime,convert(DATE,getdate()))

	 SELECT
            @last1Month = DateAdd(MONTH, -1, @today),
            @last3Months = DateAdd(MONTH, -3, @today),
            @last6Months = DateAdd(MONTH, -6, @today),
            @last1year   = DateAdd(YEAR, -1, @today),
			@thisMonth   = DATEADD(month, DATEDIFF(month, 0, @today), 0),
			@thisYear    = DATEADD(yy, DATEDIFF(yy, 0, @today), 0)
	SET @endRange = CASE
					WHEN @PeriodTypeID =1 THEN DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0))
					WHEN @PeriodTypeID =6 THEN DATEADD (dd, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) +1, 0))
					ELSE @today
					END

	SELECT @startRange = CASE 
						WHEN @PeriodTypeID =1 THEN @thisMonth
						WHEN @PeriodTypeID =2 THEN @last1Month
						WHEN @PeriodTypeID =3 THEN @last3Months
						WHEN @PeriodTypeID =4 THEN @last6Months
						WHEN @PeriodTypeID =5 THEN @last1year
						WHEN @PeriodTypeID =6 THEN @thisYear

						END
                        


SELECT  SellData.ProductCode ProductCode, pm.ProductName ProductName, SellData.SoldQty SoldQty
FROM(	
	SELECT 
	InvoiceDetail.ProductCode,
	SUM(InvoiceDetail.Qty) AS SoldQty
	
	FROM [dbo].[SAL_InvoiceMaster] InvoiceMaster
	INNER JOIN [dbo].[SAL_InvoiceDetail] InvoiceDetail ON InvoiceMaster.InvoiceNo = InvoiceDetail.InvoiceNo
	WHERE  CONVERT(DATETIME,CONVERT(DATE,InvoiceMaster.InvoiceDate)) BETWEEN @startRange AND @endRange
	GROUP BY InvoiceDetail.ProductCode
	) SellData
	INNER JOIN dbo.STK_productMaster pm ON pm.ProductID = SellData.ProductCode

	ORDER BY SellData.SoldQty DESC
    

	

END







GO
/****** Object:  StoredProcedure [dbo].[sp_UpcomingDueInvoices]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar
-- Create date: <Create Date,,>
-- Description:	Due Invoice(s) Notification
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpcomingDueInvoices]
	-- Add the parameters for the stored procedure here
	@currentDate datetime
AS
BEGIN
	
	DECLARE @tableHTML  NVARCHAR(MAX)
	DECLARE @MailItemID int
	DECLARE @WithinFirstNotification as datetime ='1900-01-01'
	DECLARE @WithinSecNotification as datetime='1900-01-01'
	DECLARE @WithinThrdNotification as datetime='1900-01-01'
	DECLARE @InvCount as int
	Declare @FirstNotification as bit, @FirstNotificationDD as int
	Declare @SecNotification as bit, @SecNotificationDD as int
	Declare @ThrdNotification as bit, @ThrdNotificationDD as int


	Select top 1 @FirstNotification= Isnull(FirstPaymentNotification,0),
			@FirstNotificationDD = Isnull(FirstNotificationDaysBefore,0),
			@SecNotification=isnull(SecPaymentNotification,0),
			@SecNotificationDD = isnull(SecNotificationDaysBefore,0),
			@ThrdNotification = isnull(ThirdPaymentNotification,0),
			@ThrdNotificationDD = isnull(ThirdNotificationDaysBefore,0) 
	
	From CNF_AppConfiguration

	--set @WithinFIve = DATEADD(dd,5,@currentDate)
	--set @WithinTen	= DATEADD(dd,10,@currentDate)
	--set @WithinThree = DATEADD(dd,3,@currentDate)
	if (@FirstNotification =1 and @FirstNotificationDD>0)
	begin
		set @WithinFirstNotification = DATEADD(dd,@FirstNotificationDD,@currentDate)		
	end
	
	if (@SecNotification =1 and @SecNotificationDD>0)
	begin
		set @WithinSecNotification = DATEADD(dd,@SecNotificationDD,@currentDate)		
	end

	if (@ThrdNotification =1 and @ThrdNotificationDD>0)
	begin
		set @WithinThrdNotification = DATEADD(dd,@ThrdNotificationDD,@currentDate)		
	end

	
	select @InvCount = COUNT(*)
	 From POInventoryMaster
				 Where (DueDate = @WithinFirstNotification OR DueDate = @WithinSecNotification OR DueDate = @WithinThrdNotification)
	
	
	BEGIN

	    SET @tableHTML =
        N'<h1>Due Payment(s) Detail!</h1>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Supplier</th>'+
		N'<th>InvoiceNo</th><th>InvoiceDate</th>' +
       	N'<th>Due Amount</th><th>Due Date</th>' +
       	N'<th>Days Left</th>' +
       	
		N'</tr><tr>'
				
		+
        CAST ( ( Select 
						td =    ISNULL(Supplier.shortName,''),'',
						td =	InvoiceNo, '', 
                        td =	convert(varchar(12), InvoiceDate, 105) , '', 
                        td =	convert(varchar(20),InvoiceAmount - ISNULL(PaymentAmount,0)) , '',
						td =	convert(varchar(12), DueDate , 105)   , '',
						td =    datediff(dd,@currentDate, DueDate)

				 From POInventoryMaster
				 left join CNF_Supplier Supplier on POInventoryMaster.SupplierID = Supplier.ID
				 Where (DueDate = @WithinFirstNotification OR DueDate = @WithinSecNotification OR DueDate = @WithinThrdNotification)
				 and  IsNull(PaymentStatus,'Pending') != 'Paid'
				 order by  DueDate
            
                 FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
	    N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'NoDue')
	 
	 select @tableHTML
	 
	 if(@InvCount = 0) return
	 
		BEGIN TRY	
	--	select @tableHTML
		
		Declare @title as nvarchar(50) = 'Supplier(s) Upcoming Due Payment(s) Notification!!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML,@MailItemID OUTPUT

			--EXEC msdb.dbo.sp_send_dbmail

			--@profile_name			= 'BossEmailProfile',
			--@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
			--@subject				= 'Upcoming Due Invoice(s) Notification!',
			--@body_format			= 'HTML',
			--@body					= @tableHTML,
			--@from_address			= 'bossdrlhr@gmail.com',
			--@mailitem_id			= @MailItemID OUTPUT
						
		
		
	   END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH

	
	END

END

GO
/****** Object:  StoredProcedure [dbo].[sp_UpcomingDueInvoicesNotification]    Script Date: 10/18/2024 11:35:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar
-- Create date: <Create Date,,>
-- Description:	Due Invoice(s) Notification
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpcomingDueInvoicesNotification]
	-- Add the parameters for the stored procedure here
	@currentDate datetime
AS
BEGIN
	
	DECLARE @tableHTML  NVARCHAR(MAX)
	DECLARE @MailItemID int
	DECLARE @WithinFirstNotification as datetime ='1900-01-01'
	DECLARE @WithinSecNotification as datetime='1900-01-01'
	DECLARE @WithinThrdNotification as datetime='1900-01-01'
	DECLARE @InvCount as int
	Declare @FirstNotification as bit, @FirstNotificationDD as int
	Declare @SecNotification as bit, @SecNotificationDD as int
	Declare @ThrdNotification as bit, @ThrdNotificationDD as int


	Select top 1 @FirstNotification= Isnull(FirstPaymentNotification,0),
			@FirstNotificationDD = Isnull(FirstNotificationDaysBefore,0),
			@SecNotification=isnull(SecPaymentNotification,0),
			@SecNotificationDD = isnull(SecNotificationDaysBefore,0),
			@ThrdNotification = isnull(ThirdPaymentNotification,0),
			@ThrdNotificationDD = isnull(ThirdNotificationDaysBefore,0) 
	
	From CNF_AppConfiguration

	--set @WithinFIve = DATEADD(dd,5,@currentDate)
	--set @WithinTen	= DATEADD(dd,10,@currentDate)
	--set @WithinThree = DATEADD(dd,3,@currentDate)
	if (@FirstNotification =1 and @FirstNotificationDD>0)
	begin
		set @WithinFirstNotification = DATEADD(dd,@FirstNotificationDD,@currentDate)		
	end
	
	if (@SecNotification =1 and @SecNotificationDD>0)
	begin
		set @WithinSecNotification = DATEADD(dd,@SecNotificationDD,@currentDate)		
	end

	if (@ThrdNotification =1 and @ThrdNotificationDD>0)
	begin
		set @WithinThrdNotification = DATEADD(dd,@ThrdNotificationDD,@currentDate)		
	end

	
	select @InvCount = COUNT(*)
	 From POInventoryMaster
				 Where (DueDate = @WithinFirstNotification OR DueDate = @WithinSecNotification OR DueDate = @WithinThrdNotification)
	
	
	BEGIN

	    SET @tableHTML =
        N'<h1>Due Payment(s) Detail!</h1>'+
        N'<table border=1 >' +
        N'<tr>'+
		N'<th>Supplier</th>'+
		N'<th>InvoiceNo</th><th>InvoiceDate</th>' +
       	N'<th>Due Amount</th><th>Due Date</th>' +
       	N'<th>Days Left</th>' +
       	
		N'</tr><tr>'
				
		+
        CAST ( ( Select 
						td =    ISNULL(Supplier.shortName,''),'',
						td =	InvoiceNo, '', 
                        td =	convert(varchar(12), InvoiceDate, 105) , '', 
                        td =	convert(varchar(20),InvoiceAmount - ISNULL(PaymentAmount,0)) , '',
						td =	convert(varchar(12), DueDate , 105)   , '',
						td =    datediff(dd,@currentDate, DueDate)

				 From POInventoryMaster
				 left join CNF_Supplier Supplier on POInventoryMaster.SupplierID = Supplier.ID
				 Where (DueDate = @WithinFirstNotification OR DueDate = @WithinSecNotification OR DueDate = @WithinThrdNotification)
				 and  IsNull(PaymentStatus,'Pending') != 'Paid'
				 order by  DueDate
            
                 FOR XML PATH('tr'), TYPE 
        ) AS NVARCHAR(MAX) ) +
	    N'</table>' 
	
	 SET @tableHTML = ISNULL(@tableHTML,'NoDue')
	 
	 select @tableHTML
	 
	 if(@InvCount = 0) return
	 
		BEGIN TRY	
	--	select @tableHTML
		
		Declare @title as nvarchar(50) = 'Supplier(s) Upcoming Due Payment(s) Notification!!'
		EXEC [sp_sendEmailNotification] @title, @tableHTML,@MailItemID OUTPUT

			--EXEC msdb.dbo.sp_send_dbmail

			--@profile_name			= 'BossEmailProfile',
			--@recipients				= 'wqrana@gmail.com;qamar930@gmail.com',
			--@subject				= 'Upcoming Due Invoice(s) Notification!',
			--@body_format			= 'HTML',
			--@body					= @tableHTML,
			--@from_address			= 'bossdrlhr@gmail.com',
			--@mailitem_id			= @MailItemID OUTPUT
						
		
		
	   END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
		END CATCH

	
	END

END

GO
