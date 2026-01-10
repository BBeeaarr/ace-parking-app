-- Add default constraint for invoice_number
IF NOT EXISTS (
    SELECT 1
    FROM sys.default_constraints dc
    JOIN sys.columns c
      ON dc.parent_object_id = c.object_id
     AND dc.parent_column_id = c.column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'dbo.invoices')
      AND c.name = N'invoice_number'
)
BEGIN
    PRINT 'Adding default constraint DF_invoices_invoice_number...';

    ALTER TABLE dbo.invoices
    ADD CONSTRAINT DF_invoices_invoice_number
    DEFAULT (NEXT VALUE FOR dbo.invoice_number_seq)
    FOR invoice_number;
END
ELSE
BEGIN
    PRINT 'Default constraint for dbo.invoices.invoice_number already exists.';
END
GO

-- Foreign Key Constraints
PRINT '--- Adding foreign key constraints ---';

IF OBJECT_ID(N'dbo.FK_invoices_customers', N'F') IS NULL
BEGIN
    PRINT 'Adding FK_invoices_customers...';

    ALTER TABLE dbo.invoices
    ADD CONSTRAINT FK_invoices_customers
    FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id);

    PRINT 'FK_invoices_customers added.';
END
ELSE
BEGIN
    PRINT 'FK_invoices_customers already exists; skipping.';
END
GO

IF OBJECT_ID(N'dbo.FK_invoice_line_items_invoices', N'F') IS NULL
BEGIN
    PRINT 'Adding FK_invoice_line_items_invoices...';

    ALTER TABLE dbo.invoice_line_items
    ADD CONSTRAINT FK_invoice_line_items_invoices
    FOREIGN KEY (invoice_number) REFERENCES dbo.invoices(invoice_number)
    ON DELETE CASCADE;

    PRINT 'FK_invoice_line_items_invoices added.';
END
ELSE
BEGIN
    PRINT 'FK_invoice_line_items_invoices already exists; skipping.';
END
GO

IF OBJECT_ID(N'dbo.FK_invoice_line_items_products', N'F') IS NULL
BEGIN
    PRINT 'Adding FK_invoice_line_items_products...';

    ALTER TABLE dbo.invoice_line_items
    ADD CONSTRAINT FK_invoice_line_items_products
    FOREIGN KEY (product_id) REFERENCES dbo.products(product_id);

    PRINT 'FK_invoice_line_items_products added.';
END
ELSE
BEGIN
    PRINT 'FK_invoice_line_items_products already exists; skipping.';
END
GO