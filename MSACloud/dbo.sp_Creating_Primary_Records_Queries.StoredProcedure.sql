USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[sp_Creating_Primary_Records_Queries]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Adeel Siddiqui  
-- Create date: 12-MAR-2018  
-- Description: Creates the Primary Records  
-- =============================================  
Create PROCEDURE [dbo].[sp_Creating_Primary_Records_Queries]   
  @ClientID BIGINT  
 ,@UserID VARCHAR(max)  
 ,@PIN VARCHAR(max)  
 ,@LastName VARCHAR(max)  
 ,@FirstName VARCHAR(max)  
AS  
BEGIN  
 DECLARE @DISTID BIGINT  
  ,@SchID BIGINT  
  ,@CustID BIGINT  
  ,@SGID BIGINT  
  ,@ResultCode INT  
  ,@ErrorMessage VARCHAR(4000)  
  ,@CustAssignList AS dbo.CustomerSchoolAssignments  
  ,@SecGroup VARCHAR(max)  
  ,@sql NVARCHAR(4000)  
  ,@paramdefs NVARCHAR(4000)  
  ,@emptyStr NVARCHAR(1)  
  ,@msg NVARCHAR(max)  
  
 SET @CustID = - 1  
 --SET @UserID = 'MTR744'  
 --SET @PIN = 'MTR744'  
 --SET @LastName = 'Administrator'  
 SET @msg = '' --School Name -> 16 letter max  
 SET @DistID = - 3  
 SET @SchID = - 3  
 SET @emptyStr = ''  
 SET @SecGroup = 'Administrators'  
  
 --District  
 IF NOT EXISTS (  
   SELECT *  
   FROM District  
   WHERE ClientID = @ClientID  
   )  
 BEGIN  
  -- CREATE Administrative District  
  SET @sql = N'SET IDENTITY_INSERT District ON ' + ' ' + 'INSERT INTO District ' + '(ClientID,Id,Emp_Administrator_Id,Emp_Director_Id,DistrictName,Address1,Address2,City,State,Zip,Phone1,Phone2,isDeleted,BankCity,BankState,BankZip,BankName,BankAddr1,BankAddr2  ,BankRoute,BankAccount,BankMICR,SpecialSetup,Forms_Admin_Id,Forms_Director_Id,UseDistNameDirector,UseDistNameAdmin,Forms_Admin_Title,Forms_Admin_Phone,Forms_Dir_Title,Forms_Dir_Phone,AppUpdateDelay,UpdatePositiveID,Local_ID) ' + 'values ' + '(@ClientID,@DistID,NULL,NULL,@DistName,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,0,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,NULL,0,NULL,NULL,0,0,NULL,NULL,NULL,NULL,0,0,-3) ' + 'SET IDENTITY_INSERT District OFF ' + ' '  
  SET @paramdefs = N'@ClientID bigint, @DistID bigint, @DistName varchar(max), @emptyStr nvarchar(1)'  
  
  EXEC sp_executesql @sql  
   ,@paramdefs  
   ,@ClientID = @ClientID  
   ,@DistID = @DistID  
   ,@DistName = 'Administrative'  
   ,@emptyStr = ''  
  Print 'District Done'  
  SET @sql = ''  
   --select * from District  
 END  
  
 --School  
 IF NOT EXISTS (  
   SELECT *  
   FROM Schools  
   WHERE ClientID = @ClientID  
   )  
 BEGIN  
  -- CREATE Administrative School  
  SET @sql = 'SET IDENTITY_INSERT Schools ON ' + ' ' + 'INSERT INTO Schools ' + '(ClientID,Id,District_Id,Emp_Director_Id,Emp_Administrator_Id,SchoolID,SchoolName,Address1,Address2,City,State,Zip,Phone1,Phone2,Comment,isSevereNeed,isDeleted,UseDistDirAdmin,Forms_Director_Id,Forms_Admin_Id,UseDistFormsDirAdmin,UseDistNameDirector,UseDistNameAdmin,Forms_Admin_Title,Forms_Admin_Phone,Forms_Dir_Title,Forms_Dir_Phone,Local_ID) ' + 'values ' + '(@ClientID,@SchID,@DistID,NULL,NULL,@SchIDName,@SchName,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,@emptyStr,0,0,1,NULL,NULL,1,0,0,NULL,NULL,NULL,NULL,-3) ' + 'SET IDENTITY_INSERT Schools OFF ' + ' '  
  SET @paramdefs = N'@ClientID bigint, @SchID bigint, @DistID bigint, @SchIDName varchar(max), @SchName varchar(max), @emptyStr nvarchar(1)'  
  
  EXEC sp_executesql @sql  
   ,@paramdefs  
   ,@ClientID = @ClientID  
   ,@SchID = @SchID  
   ,@DistID = @DistID  
   ,@SchIDName = 'N/A'  
   ,@SchName = 'Administrative'  
   ,@emptyStr = ''  
  
  SET @sql = ''  
   --select * from Schools  
 END  
  
 -- CREATE Cash Sale Accounts  
 SET @sql = 'SET IDENTITY_INSERT Customers ON '  
  
 IF NOT EXISTS (  
   SELECT *  
   FROM Customers  
   WHERE ClientID = @ClientID  
    AND ID = - 3  
   )  
 BEGIN  
  SET @sql = @sql + ' INSERT INTO Customers ' + '(ClientID,Id,District_Id,Language_Id,Grade_Id,HomeRoom_Id,isStudent,UserID,PIN,LastName,FirstName,Middle,Gender,SSN,Address1,Address2,City,[State],Zip,Phone,LunchType,AllowAlaCarte,CashOnly,isActive,GraduationDate,SchoolDat,isDeleted,ExtraInfo,EMail,DOB,ACH,isSnack,isStudentWorker,isVeteran,Ethnicity_Id,Disability,isHomeless,[Disabled],CreationDate,NotInDistrict,MealPlan_Id,MealsLeft,STUD_MGMT_ID,DeactiveDate,ReactiveDate,GradDate,Local_ID) ' + 'values ' + '(@ClientID,-3,@DistID,NULL,NULL,NULL,0,@CSS,@CSS,@CashSale,@Student,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,NULL,@SchoolDat,0,NULL,NULL,@NoCreateDate,0,0,0,NULL,NULL,NULL,NULL,0,Cast(Convert(varchar,GETDATE(),101) as datetime),0,NULL,0,NULL,NULL,NULL,NULL,-3) '  
 END  
  
 IF NOT EXISTS (  
   SELECT *  
   FROM Customers  
   WHERE ClientID = @ClientID  
    AND ID = - 2  
   )  
 BEGIN  
  SET @sql = @sql + ' INSERT INTO Customers ' + '(ClientID,Id,District_Id,Language_Id,Grade_Id,HomeRoom_Id,isStudent,UserID,PIN,LastName,FirstName,Middle,Gender,SSN,Address1,Address2,City,[State],Zip,Phone,LunchType,AllowAlaCarte,CashOnly,isActive,GraduationDate,SchoolDat,isDeleted,ExtraInfo,EMail,DOB,ACH,isSnack,isStudentWorker,isVeteran,Ethnicity_Id,Disability,isHomeless,[Disabled],CreationDate,NotInDistrict,MealPlan_Id,MealsLeft,STUD_MGMT_ID,DeactiveDate,ReactiveDate,GradDate,Local_ID) ' + 'values ' + '(@ClientID,-2,@DistID,NULL,NULL,NULL,0,@CSG,@CSG,@CashSale,@Guest,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,NULL,@SchoolDat,0,NULL,NULL,@NoCreateDate,0,0,0,NULL,NULL,NULL,NULL,0,Cast(Convert(varchar,GETDATE(),101) as datetime),0,NULL,0,NULL,NULL,NULL,NULL,-2) '  
 END  
  
 SET @sql = @sql + ' SET IDENTITY_INSERT Customers OFF '  
 SET @paramdefs = N'@ClientID bigint, @DistID bigint, @CSS varchar(max), @CSG varchar(max), @CashSale varchar(max), @Student varchar(max), @Guest varchar(max), @SchoolDat varchar(1), @NoCreateDate datetime'  
  
 EXEC sp_executesql @sql  
  ,@paramdefs  
  ,@ClientID = @ClientID  
  ,@DistID = @DistID  
  ,@CSS = 'CSS'  
  ,@CSG = 'CSG'  
  ,@CashSale = 'Cash Sale'  
  ,@Student = 'Student'  
  ,@Guest = 'Guest'  
  ,@SchoolDat = 'F'  
  ,@NoCreateDate = '1900-12-30 00:00:00'  
  
 SET @sql = ''  
 Print 'Customers Done'  
  
 --select * from Customers  
 -- CREATE Administrative Customer/User  
 IF NOT EXISTS (  
    SELECT id  
    FROM customers  
    WHERE UserID=@UserID and PIN=@PIN
    )  
 BEGIN  
  EXEC dbo.Admin_Customer_Save @ClientID  
   ,@CustID OUT  
   ,@DistID  
   ,@SchID  
   ,@UserID  
   ,@PIN  
   ,@LastName  
   ,@FirstName  
   ,NULL  
   ,0  
   ,@CustAssignList  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,DEFAULT  
   ,''  
   ,''  
   ,''  
   ,''  
   ,- 2  
   ,@ResultCode OUT  
   ,@ErrorMessage OUT  
 END  
 Print 'Admin Customer Done'  
  
 --select * from customers  
 -- CREATE Security Group (Administrators)  
 IF NOT EXISTS (  
   SELECT id  
   FROM SecurityGroup  
   WHERE ClientID = @ClientID  
    AND GroupName = @SecGroup  
   )  
 BEGIN  
  INSERT INTO securitygroup (  
   ClientID  
   ,GroupName  
   )  
  VALUES (  
   @ClientID  
   ,@SecGroup  
   )  
  
  SET @SGID = SCOPE_IDENTITY()  
 END  
 ELSE  
 BEGIN  
  SELECT @SGID = id  
  FROM SecurityGroup  
  WHERE ClientID = @ClientID  
   AND GroupName = @SecGroup  
 END  
 Print 'Security Group Done'  
 --select * from SecurityGroup  
 -- CREATE Access Rights (Administrators Group)  
 -- Integers table will help with getting a range to ObjectIDs change the between statement for what ObjectIds you need  
 DECLARE @integers TABLE (i INT);  
  
 INSERT INTO @integers (i)  
 VALUES (0)  
  ,(1)  
  ,(2)  
  ,(3)  
  ,(4)  
  ,(5)  
  ,(6)  
  ,(7)  
  ,(8)  
  ,(9)  
  
 DECLARE @ObjectID INT  
  
 DECLARE MyRights CURSOR LOCAL  
 FOR  
 SELECT (tens.i * 10) + units.i AS x  
 FROM @integers AS units  
 CROSS JOIN @integers AS tens  
 WHERE ((tens.i * 10) + units.i) BETWEEN 1  
   AND 73  
 ORDER BY x  
  
 OPEN MyRights  
  
 FETCH NEXT  
 FROM MyRights  
 INTO @ObjectID  
  
 WHILE (@@FETCH_STATUS = 0)  
 BEGIN  
 SET @msg =  'ObjectID='+cast(@ObjectID as nvarchar(100))+' SecurityGroup_Id=' +cast(@SGID as nvarchar(100))  
  IF NOT EXISTS (  
    SELECT id  
    FROM AccessRights  
    WHERE ClientID = @ClientID  
     AND SecurityGroup_Id = @SGID  
     AND ObjectID = @ObjectID  
    )  
  BEGIN  
     
   INSERT INTO dbo.AccessRights (  
    ClientID  
    ,ObjectID  
    ,SecurityGroup_Id  
    ,canInsert  
    ,canDelete  
    ,canView  
    ,canEdit  
    )  
   VALUES (  
    @ClientID  
    ,@ObjectID  
    ,@SGID  
    ,1  
    ,1  
    ,1  
    ,1  
    )  
	  END  
   FETCH NEXT  
   FROM MyRights  
   INTO @ObjectID  

  RAISERROR(@msg, 0, 1) WITH NOWAIT  
 END  
 Print 'Access Right Done'  
 CLOSE MyRights  
  
 DEALLOCATE MyRights  
  
 --SELECT * FROM accessrights  
  
IF (NOT EXISTS(select customer_Id from employee where LoginName = @UserID))   
 BEGIN  
  -- CREATE Employee (Administrative User)  
  INSERT INTO employee (  
   ClientID  
   ,Customer_Id  
   ,SecurityGroup_Id  
   ,LoginName  
   ,Password  
   ,isDeleted  
   ,UserRoles_ID  
   )  
  VALUES (  
   @ClientID  
   ,@CustID  
   ,@SGID  
   ,@UserID  
   ,@PIN  
   ,0  
   ,NULL  
   )  
   --select * from employee  
 END  
 Print 'Insert Employee Done'  
END
GO
