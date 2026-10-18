

-- Insert Employee Stored Procedure
CREATE PROCEDURE usp_InsertEmployee
    @EmployeeLastName NVARCHAR(50),
    @EmployeeFirstName NVARCHAR(50),
    @EmployeeMiddleInitial CHAR(1) = '',
    @EmployeeDateOfBirth DATE,
    @EmployeeNumber CHAR(7),
    @EmployeeGender CHAR(1),
    @EmployeeSSN CHAR(9)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO tblEmployee (EmployeeLastName, EmployeeFirstName, EmployeeMiddleInitial, EmployeeDateOfBirth, EmployeeNumber, EmployeeGender, EmployeeSSN)
        VALUES (@EmployeeLastName, @EmployeeFirstName, @EmployeeMiddleInitial, @EmployeeDateOfBirth, @EmployeeNumber, @EmployeeGender, @EmployeeSSN);

        DECLARE @EmployeeID INT = CAST(SCOPE_IDENTITY() AS INT);
        SELECT @EmployeeID AS EmployeeID;
    END TRY
    BEGIN CATCH
        INSERT INTO tblLogErrors (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorUser)
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SUSER_NAME());
        
        RAISERROR ('Error inserting employee.', 16, 1);
    END CATCH;
END;
GO

-- Update Employee Stored Procedure
CREATE PROCEDURE usp_UpdateEmployee
    @EmployeeID INT,
    @EmployeeLastName NVARCHAR(50),
    @EmployeeFirstName NVARCHAR(50),
    @EmployeeMiddleInitial CHAR(1) = '',
    @EmployeeDateOfBirth DATE,
    @EmployeeNumber CHAR(7),
    @EmployeeGender CHAR(1),
    @EmployeeSSN CHAR(9),
    @EmployeeActiveFlag BIT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE tblEmployee
        SET EmployeeLastName = @EmployeeLastName,
            EmployeeFirstName = @EmployeeFirstName,
            EmployeeMiddleInitial = @EmployeeMiddleInitial,
            EmployeeDateOfBirth = @EmployeeDateOfBirth,
            EmployeeNumber = @EmployeeNumber,
            EmployeeGender = @EmployeeGender,
            EmployeeSSN = @EmployeeSSN,
            EmployeeActiveFlag = @EmployeeActiveFlag
        WHERE EmployeeID = @EmployeeID;
    END TRY
    BEGIN CATCH
        INSERT INTO tblLogErrors (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorUser)
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SUSER_NAME());
        
        RAISERROR ('Error updating employee.', 16, 1);
    END CATCH;
END;
GO

-- Delete Employee Stored Procedure
CREATE PROCEDURE usp_DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM tblEmployee WHERE EmployeeID = @EmployeeID;
    END TRY
    BEGIN CATCH
        INSERT INTO tblLogErrors (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorUser)
        VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SUSER_NAME());
        
        RAISERROR ('Error deleting employee.', 16, 1);
    END CATCH;
END;
GO
