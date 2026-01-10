PRINT '--- Invoice number sequence alignment start ---';

DECLARE @nextInvoiceNumber INT;
DECLARE @currentSeqValue INT;

SELECT @nextInvoiceNumber = ISNULL(MAX(invoice_number), 0) + 1
FROM dbo.invoices;

PRINT 'Next invoice number based on table = ' + CAST(@nextInvoiceNumber AS NVARCHAR(20));

-- Get current sequence value (may be NULL if never used)
SELECT @currentSeqValue = CAST(current_value AS INT)
FROM sys.sequences
WHERE object_id = OBJECT_ID(N'dbo.invoice_number_seq');

IF @currentSeqValue IS NULL
    PRINT 'Current sequence value = NULL (sequence not yet used)';
ELSE
    PRINT 'Current sequence value = ' + CAST(@currentSeqValue AS NVARCHAR(20));

-- Only bump the sequence forward if needed (never backward)
IF @nextInvoiceNumber > 1
BEGIN
    IF @currentSeqValue IS NULL OR @currentSeqValue < (@nextInvoiceNumber - 1)
    BEGIN
        PRINT 'Reseeding dbo.invoice_number_seq to ' + CAST(@nextInvoiceNumber AS NVARCHAR(20));

        DECLARE @sql NVARCHAR(200) =
            N'ALTER SEQUENCE dbo.invoice_number_seq RESTART WITH ' +
            CAST(@nextInvoiceNumber AS NVARCHAR(20)) + N';';

        EXEC sys.sp_executesql @sql;

        PRINT 'Sequence reseed complete.';
    END
    ELSE
    BEGIN
        PRINT 'Sequence already ahead of or equal to table max; no reseed needed.';
    END
END
ELSE
BEGIN
    PRINT 'Invoices table empty; no reseed required.';
END
GO

