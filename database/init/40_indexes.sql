PRINT '--- Creating indexes ---';

-- Customers

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_customers_name'
      AND object_id = OBJECT_ID(N'dbo.customers')
)
BEGIN
    PRINT 'Creating index IX_customers_name...';

    CREATE NONCLUSTERED INDEX IX_customers_name
    ON dbo.customers (customer_name);

    PRINT 'Index IX_customers_name created.';
END
ELSE
BEGIN
    PRINT 'Index IX_customers_name already exists; skipping.';
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_customers_email'
      AND object_id = OBJECT_ID(N'dbo.customers')
)
BEGIN
    PRINT 'Creating index IX_customers_email...';

    CREATE NONCLUSTERED INDEX IX_customers_email
    ON dbo.customers (customer_email_address);

    PRINT 'Index IX_customers_email created.';
END
ELSE
BEGIN
    PRINT 'Index IX_customers_email already exists; skipping.';
END
GO

-- Products

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_products_name'
      AND object_id = OBJECT_ID(N'dbo.products')
)
BEGIN
    PRINT 'Creating index IX_products_name...';

    CREATE NONCLUSTERED INDEX IX_products_name
    ON dbo.products (product_name);

    PRINT 'Index IX_products_name created.';
END
ELSE
BEGIN
    PRINT 'Index IX_products_name already exists; skipping.';
END
GO

-- Invoices

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_invoices_customer_id'
      AND object_id = OBJECT_ID(N'dbo.invoices')
)
BEGIN
    PRINT 'Creating index IX_invoices_customer_id...';

    CREATE NONCLUSTERED INDEX IX_invoices_customer_id
    ON dbo.invoices (customer_id);

    PRINT 'Index IX_invoices_customer_id created.';
END
ELSE
BEGIN
    PRINT 'Index IX_invoices_customer_id already exists; skipping.';
END
GO

-- Invoice Line Items

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_invoice_line_items_invoice_number'
      AND object_id = OBJECT_ID(N'dbo.invoice_line_items')
)
BEGIN
    PRINT 'Creating index IX_invoice_line_items_invoice_number...';

    CREATE NONCLUSTERED INDEX IX_invoice_line_items_invoice_number
    ON dbo.invoice_line_items (invoice_number);

    PRINT 'Index IX_invoice_line_items_invoice_number created.';
END
ELSE
BEGIN
    PRINT 'Index IX_invoice_line_items_invoice_number already exists; skipping.';
END
GO
PRINT '--- Index creation complete ---';
