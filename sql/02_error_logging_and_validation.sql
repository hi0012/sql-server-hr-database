

-- Create Custom Error Code 50000 and Logging Procedure
CREATE PROCEDURE usp_LogError
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO tblLogErrors (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage, ErrorUser)
        SELECT ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE(), SUSER_NAME();
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while logging error.';
    END CATCH;
END;
GO

-- Example of Raising Custom Errors
CREATE PROCEDURE usp_ValidateEmployeeData
    @EmployeeMiddleInitial CHAR(1),
    @EmployeeDateOfBirth DATE,
    @EmployeeGender CHAR(1),
    @EmployeeLastName NVARCHAR(50),
    @EmployeeFirstName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate Middle Initial
        IF (@EmployeeMiddleInitial IS NOT NULL AND LEN(@EmployeeMiddleInitial) > 1)
            RAISERROR ('Invalid Middle Initial', 16, 1);

        -- Validate DOB
        IF (@EmployeeDateOfBirth < '1900-01-01' OR @EmployeeDateOfBirth > DATEADD(YEAR, -18, GETDATE()))
            RAISERROR ('Invalid DOB', 16, 1);

        -- Validate Gender
        IF (@EmployeeGender NOT IN ('M', 'F'))
            RAISERROR ('Invalid Gender', 16, 1);

        -- Validate Required Fields
        IF (@EmployeeLastName IS NULL OR @EmployeeLastName = '')
            RAISERROR ('Missing Last Name', 16, 1);

        IF (@EmployeeFirstName IS NULL OR @EmployeeFirstName = '')
            RAISERROR ('Missing First Name', 16, 1);

        IF (@EmployeeDateOfBirth IS NULL)
            RAISERROR ('Missing DOB', 16, 1);

    END TRY
    BEGIN CATCH
        EXEC usp_LogError;
    END CATCH;
END;
GO
