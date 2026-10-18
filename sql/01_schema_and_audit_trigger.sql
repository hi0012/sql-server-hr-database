

-- Create Database
CREATE DATABASE HumanResources;
GO
USE HumanResources;
GO

-- Create Employee Table
CREATE TABLE tblEmployee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeLastName NVARCHAR(50) NOT NULL,
    EmployeeFirstName NVARCHAR(50) NOT NULL,
    EmployeeMiddleInitial CHAR(1) NULL CHECK (EmployeeMiddleInitial LIKE '[A-Z]' OR EmployeeMiddleInitial = ''),
    EmployeeDateOfBirth DATE NOT NULL CHECK (EmployeeDateOfBirth BETWEEN '1900-01-01' AND DATEADD(YEAR, -18, GETDATE())),
    EmployeeNumber CHAR(7) NOT NULL CHECK (EmployeeNumber LIKE '[A-Z]______'),
    EmployeeGender CHAR(1) NOT NULL CHECK (EmployeeGender IN ('M', 'F')),
    EmployeeSSN CHAR(9) NOT NULL CHECK (EmployeeSSN LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    EmployeeActiveFlag BIT DEFAULT 1,
    CreateDate DATETIME DEFAULT GETDATE(),
    CreatedBy NVARCHAR(100) DEFAULT SUSER_NAME(),
    ModifyDate DATETIME NULL,
    ModifiedBy NVARCHAR(100) NULL
);
GO

-- Create Log Errors Table
CREATE TABLE tblLogErrors (
    ErrorLogID INT IDENTITY(1,1) PRIMARY KEY,
    ErrorNumber INT,
    ErrorSeverity INT,
    ErrorState INT,
    ErrorProcedure NVARCHAR(128),
    ErrorLine INT,
    ErrorMessage NVARCHAR(4000),
    ErrorUser NVARCHAR(500),
    ErrorDate DATETIME DEFAULT GETDATE()
);
GO

-- Create Triggers for ModifyDate and ModifiedBy
CREATE TRIGGER trg_UpdateModifyFields
ON tblEmployee
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE tblEmployee
    SET ModifyDate = GETDATE(),
        ModifiedBy = SUSER_NAME()
    FROM tblEmployee e
    INNER JOIN inserted i ON e.EmployeeID = i.EmployeeID;
END;
GO
