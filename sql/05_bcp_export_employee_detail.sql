
/********************************************************************************
Author: Hisham Issa
Create Date: 2025-04-18
Description: SELECT-based Employee Detail Export
********************************************************************************/

IF OBJECT_ID('dbo.usp_EmployeeDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_EmployeeDetails;
GO

CREATE PROCEDURE dbo.usp_EmployeeDetails
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
        d.department_name AS DepartmentName,
        j.job_title AS JobTitle,
        m.last_name AS ManagerLastName,
        m.first_name AS ManagerFirstName
    FROM Employees e
    JOIN Departments d ON e.department_id = d.department_id
    JOIN Jobs j ON e.job_id = j.job_id
    LEFT JOIN Employees m ON e.manager_id = m.employee_id
    ORDER BY d.department_name, m.last_name, m.first_name, e.last_name, e.first_name;
END;
GO
