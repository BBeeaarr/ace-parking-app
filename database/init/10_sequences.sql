IF OBJECT_ID(N'dbo.invoice_number_seq', N'SO') IS NULL
BEGIN
    PRINT 'Creating sequence dbo.invoice_number_seq...';

    CREATE SEQUENCE dbo.invoice_number_seq
        AS INT
        START WITH 1
        INCREMENT BY 1;
END
ELSE
BEGIN
    PRINT 'Sequence dbo.invoice_number_seq already exists.';
END
GO