IF DB_ID(N'AceInvoice') IS NULL
BEGIN
    PRINT 'Creating database AceInvoice...';
    CREATE DATABASE [AceInvoice];
END
ELSE
BEGIN
    PRINT 'Database AceInvoice already exists.';
END
GO

-- Switch context explicitly
USE [AceInvoice];
GO