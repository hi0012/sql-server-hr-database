# SQL Server HR Database: Stored Procedures, Auditing & Data Exports

A Microsoft SQL Server (T-SQL) back end for a small Human Resources system. It covers schema design with business rules built into the tables, CRUD stored procedures with structured error handling, an audit trigger, centralized error logging, and automated CSV exports with the BCP utility.

I built it for Introduction to Database Management Systems at Wayne State University (Winter 2025).

## What's in here

| Script | What it does |
|---|---|
| `sql/01_schema_and_audit_trigger.sql` | Creates the `HumanResources` database, the `tblEmployee` table with CHECK constraints, the `tblLogErrors` table, and an `AFTER UPDATE` trigger that stamps `ModifyDate` / `ModifiedBy` |
| `sql/02_error_logging_and_validation.sql` | `usp_LogError`, a reusable error logger, and `usp_ValidateEmployeeData`, which raises custom errors with `RAISERROR` |
| `sql/03_crud_procedures.sql` | `usp_InsertEmployee`, `usp_UpdateEmployee` and `usp_DeleteEmployee`, each wrapped in `TRY...CATCH` with failures logged |
| `sql/04_bcp_export_employee_census.sql` | `usp_EmployeeCensus`: employees and their dependents, shaped for a benefits census file |
| `sql/05_bcp_export_employee_detail.sql` | `usp_EmployeeDetails`: employee, department, job and manager details joined into one export |

Run them in order in SQL Server Management Studio (SSMS) or `sqlcmd`. Scripts 04 and 05 use a separate `Employees` / `Departments` / `Jobs` / `Dependents` schema from a later assignment.

## Highlights

**Business rules in the schema.** Constraints reject bad data before it reaches any procedure:

- Employee number must match `[A-Z]______`
- Date of birth must be after 1900 and at least 18 years ago
- Gender is limited to `M` / `F`, and the middle initial to a single letter
- SSN must be exactly 9 digits

**Auditing.** Every row records who created it and when (`SUSER_NAME()`, `GETDATE()` defaults). An `AFTER UPDATE` trigger joins to the `inserted` pseudo-table to stamp who last changed it.

**Error handling.** Every procedure uses `TRY...CATCH` and writes `ERROR_NUMBER()`, `ERROR_SEVERITY()`, `ERROR_STATE()`, `ERROR_PROCEDURE()`, `ERROR_LINE()`, `ERROR_MESSAGE()` and the user into `tblLogErrors`, then re-raises a clean message to the caller. That gives you a single table to check when something fails.

**Data exports with BCP.** The export procedures return plain result sets, and BCP writes them to dated CSV files:

```bat
bcp "exec HumanResources.dbo.usp_EmployeeDetails" queryout "C:\HumanResources\DataTransfer\Employee\Acme_Employees_YYYYMMDD.csv" -c -t, -T -S localhost
bcp "exec HumanResources.dbo.usp_EmployeeCensus"  queryout "C:\HumanResources\DataTransfer\Census\All_Employees_Census_YYYYMMDD.csv"  -c -t, -T -S localhost
```

The server had `xp_cmdshell` disabled, which is the secure default, so I ran BCP from the Windows command line with a trusted connection (`-T`) instead of turning on shell access from inside SQL Server.

## Other work in the course

- Set up a local SQL Server development instance
- Keys and relational algebra exercises
- Normalized a dataset from unnormalized form through 1NF, 2NF and 3NF
- Wrote triggers and set up **database backup and restore** (`.bak`)
- Used cursors, scalar and table-valued functions, table variables and string aggregation

## Security review (what I'd change for production)

- **SSN is stored in plain text.** In production I'd protect it with **Always Encrypted** or column-level encryption, add **Dynamic Data Masking** so most users only see the last 4 digits, and restrict access with role-based permissions.
- **Least privilege.** Applications should get `EXECUTE` on the stored procedures only, with no direct table access.
- **Use the error log for monitoring.** Repeated failures from one user in `tblLogErrors` are worth alerting on.
- **Transactions.** Multi-step changes should be wrapped in `BEGIN TRAN` / `COMMIT` with `XACT_ABORT ON`.

## Tech

Microsoft SQL Server · T-SQL · SSMS · BCP · Stored procedures · Triggers · Backup/restore
