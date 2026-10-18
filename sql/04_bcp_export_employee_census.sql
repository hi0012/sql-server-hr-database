
/********************************************************************************
Author: Hisham Issa
Create Date: 2025-04-18
Description: SELECT-based Employee Census Export
********************************************************************************/

IF OBJECT_ID('dbo.usp_EmployeeCensus', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_EmployeeCensus;
GO

CREATE PROCEDURE dbo.usp_EmployeeCensus
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        RIGHT('000000' + CAST(e.employee_id AS VARCHAR), 6) AS EmployeeID,
        e.last_name AS EmployeeLastName,
        e.first_name AS EmployeeFirstName,
        e.email AS EmployeeEmail,
        e.phone_number AS EmployeePhoneNumber,
        e.hire_date AS EmployeeHireDate,
        e.salary AS EmployeeSalary,
        d.last_name AS DependentLastName,
        d.first_name AS DependentFirstName,
        d.relationship AS DependentRelationship
    FROM Employees e
    LEFT JOIN Dependents d ON e.employee_id = d.employee_id
    ORDER BY e.last_name, e.first_name, e.employee_id, d.last_name, d.first_name, d.relationship;
END;
GO
