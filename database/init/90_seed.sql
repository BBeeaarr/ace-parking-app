PRINT '--- Seeding base data ---';

DECLARE @CustomerId UNIQUEIDENTIFIER = 'AA5FD07A-05D6-460F-B8E3-6A09142F9D71';
DECLARE @InvoiceNumber INT = 5;

-- Customer

IF NOT EXISTS (SELECT 1 FROM dbo.customers WHERE customer_id = @CustomerId)
BEGIN
    PRINT 'Inserting customer Smith, LLC...';

    INSERT INTO dbo.customers (
        customer_id,
        customer_name,
        customer_address1,
        customer_address2,
        customer_city,
        customer_state,
        customer_postal_code,
        customer_telephone,
        customer_contact_name,
        customer_email_address
    )
    VALUES (
        @CustomerId,
        N'Smith, LLC',
        N'505 Central Avenue',
        N'Suite 100',
        N'San Diego',
        N'CA',
        N'90383',
        N'619-483-0987',
        N'Jane Smith',
        N'email@jane.com'
    );

    PRINT 'Customer inserted.';
END
ELSE
BEGIN
    PRINT 'Customer already exists; skipping.';
END
GO

-- Invoice

DECLARE @CustomerId UNIQUEIDENTIFIER = 'AA5FD07A-05D6-460F-B8E3-6A09142F9D71';
DECLARE @InvoiceNumber INT = 5;

IF NOT EXISTS (SELECT 1 FROM dbo.invoices WHERE invoice_number = @InvoiceNumber)
BEGIN
    PRINT 'Inserting invoice #5...';

    INSERT INTO dbo.invoices (
        invoice_number,
        invoice_date,
        customer_id
    )
    VALUES (
        @InvoiceNumber,
        '2024-12-20T14:30:00',
        @CustomerId
    );

    PRINT 'Invoice inserted.';
END
ELSE
BEGIN
    PRINT 'Invoice already exists; skipping.';
END
GO

-- Products

IF NOT EXISTS (SELECT 1 FROM dbo.products WHERE product_id = '26812D43-CEE0-4413-9A1B-0B2EABF7E92C')
BEGIN
    PRINT 'Inserting product Thingie...';
    INSERT INTO dbo.products (product_id, product_name, product_cost)
    VALUES ('26812D43-CEE0-4413-9A1B-0B2EABF7E92C', N'Thingie', 2.00);
END
ELSE PRINT 'Product Thingie already exists; skipping.';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.products WHERE product_id = '3C85F645-CE57-43A8-B192-7F46F8BBC273')
BEGIN
    PRINT 'Inserting product Gadget...';
    INSERT INTO dbo.products (product_id, product_name, product_cost)
    VALUES ('3C85F645-CE57-43A8-B192-7F46F8BBC273', N'Gadget', 5.15);
END
ELSE PRINT 'Product Gadget already exists; skipping.';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.products WHERE product_id = 'A102E2B7-30D6-4AB6-B92B-8570A7E1659C')
BEGIN
    PRINT 'Inserting product Gizmo...';
    INSERT INTO dbo.products (product_id, product_name, product_cost)
    VALUES ('A102E2B7-30D6-4AB6-B92B-8570A7E1659C', N'Gizmo', 1.00);
END
ELSE PRINT 'Product Gizmo already exists; skipping.';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.products WHERE product_id = '9E3EF8CE-A6FD-4C9B-AC5D-C3CB471E1E27')
BEGIN
    PRINT 'Inserting product Widget...';
    INSERT INTO dbo.products (product_id, product_name, product_cost)
    VALUES ('9E3EF8CE-A6FD-4C9B-AC5D-C3CB471E1E27', N'Widget', 2.50);
END
ELSE PRINT 'Product Widget already exists; skipping.';
GO

-- Invoice Line Items

IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = '9D91681F-0971-4170-BBA4-1617E53E7E8C')
BEGIN
    PRINT 'Inserting line item (Gadget x5)...';

    INSERT INTO dbo.invoice_line_items (
        line_item_id,
        invoice_number,
        product_id,
        quantity,
        product_name,
        product_cost,
        total_cost
    )
    VALUES (
        '9D91681F-0971-4170-BBA4-1617E53E7E8C',
        5,
        '3C85F645-CE57-43A8-B192-7F46F8BBC273',
        5,
        N'Gadget',
        5.15,
        25.75
    );

    PRINT 'Line item inserted.';
END
ELSE
BEGIN
    PRINT 'Line item Gadget already exists; skipping.';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = '91C75521-B7C5-45BB-B0C6-FDCA3A89ECD9')
BEGIN
    PRINT 'Inserting line item (Thingie x2)...';

    INSERT INTO dbo.invoice_line_items (
        line_item_id,
        invoice_number,
        product_id,
        quantity,
        product_name,
        product_cost,
        total_cost
    )
    VALUES (
        '91C75521-B7C5-45BB-B0C6-FDCA3A89ECD9',
        5,
        '26812D43-CEE0-4413-9A1B-0B2EABF7E92C',
        2,
        N'Thingie',
        2.00,
        4.00
    );

    PRINT 'Line item inserted.';
END
ELSE
BEGIN
    PRINT 'Line item Thingie already exists; skipping.';
END
GO
PRINT '--- Seeding complete ---';