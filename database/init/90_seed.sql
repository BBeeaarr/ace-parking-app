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

PRINT '--- Seeding additional customers ---';

IF NOT EXISTS (SELECT 1 FROM dbo.customers WHERE customer_id = 'B1E5F9D0-1A5F-4B3E-9B9E-0E2A7F8B1111')
BEGIN
    PRINT 'Inserting customer Acme Corp...';

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
        'B1E5F9D0-1A5F-4B3E-9B9E-0E2A7F8B1111',
        N'Acme Corp',
        N'100 Industrial Way',
        NULL,
        N'Los Angeles',
        N'CA',
        N'90012',
        N'213-555-0100',
        N'Bob Builder',
        N'bob.builder@acmecorp.com'
    );

    PRINT 'Customer Acme Corp inserted.';
END
ELSE PRINT 'Customer Acme Corp already exists; skipping.';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.customers WHERE customer_id = 'C2A7D4F1-8F4C-4A7A-8C9D-2C1E0E222222')
BEGIN
    PRINT 'Inserting customer Pacific Logistics...';

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
        'C2A7D4F1-8F4C-4A7A-8C9D-2C1E0E222222',
        N'Pacific Logistics',
        N'450 Harbor Blvd',
        N'Building C',
        N'Long Beach',
        N'CA',
        N'90802',
        N'562-555-0188',
        N'Sarah Kim',
        N'sarah.kim@pacificlogistics.com'
    );

    PRINT 'Customer Pacific Logistics inserted.';
END
ELSE PRINT 'Customer Pacific Logistics already exists; skipping.';
GO

IF NOT EXISTS (SELECT 1 FROM dbo.customers WHERE customer_id = 'D3C9B6E2-6A91-4C9C-BE77-333333333333')
BEGIN
    PRINT 'Inserting customer Sierra Retail Group...';

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
        'D3C9B6E2-6A91-4C9C-BE77-333333333333',
        N'Sierra Retail Group',
        N'789 Market Street',
        N'Suite 500',
        N'Fresno',
        N'CA',
        N'93721',
        N'559-555-0144',
        N'Michael Torres',
        N'm.torres@sierraretail.com'
    );

    PRINT 'Customer Sierra Retail Group inserted.';
END
ELSE PRINT 'Customer Sierra Retail Group already exists; skipping.';
GO

PRINT '--- Customers seeded ---';


-- Invoice

PRINT '--- Seeding additional invoices (auto-numbered) ---';

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

DECLARE @AcmeCustomerId UNIQUEIDENTIFIER = 'B1E5F9D0-1A5F-4B3E-9B9E-0E2A7F8B1111';

IF NOT EXISTS (
    SELECT 1
    FROM dbo.invoices
    WHERE customer_id = @AcmeCustomerId
      AND invoice_date = '2025-01-05T10:00:00'
)
BEGIN
    PRINT 'Inserting invoice for Acme Corp (auto-number)...';

    INSERT INTO dbo.invoices (
        invoice_date,
        customer_id
    )
    VALUES (
        '2025-01-05T10:00:00',
        @AcmeCustomerId
    );

    PRINT 'Invoice for Acme Corp inserted.';
END
ELSE
BEGIN
    PRINT 'Invoice for Acme Corp already exists; skipping.';
END
GO

DECLARE @PacificCustomerId UNIQUEIDENTIFIER = 'C2A7D4F1-8F4C-4A7A-8C9D-2C1E0E222222';

IF NOT EXISTS (
    SELECT 1
    FROM dbo.invoices
    WHERE customer_id = @PacificCustomerId
      AND invoice_date = '2025-01-07T15:45:00'
)
BEGIN
    PRINT 'Inserting invoice for Pacific Logistics (auto-number)...';

    INSERT INTO dbo.invoices (
        invoice_date,
        customer_id
    )
    VALUES (
        '2025-01-07T15:45:00',
        @PacificCustomerId
    );

    PRINT 'Invoice for Pacific Logistics inserted.';
END
ELSE
BEGIN
    PRINT 'Invoice for Pacific Logistics already exists; skipping.';
END
GO
PRINT '--- Invoices seeded ---';

-- Products

PRINT '--- Seeding products ---';

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

IF NOT EXISTS (SELECT 1 FROM dbo.products WHERE product_id = 'E4B7A6F2-5C91-4F2E-9D3A-8A9B11111111')
BEGIN
    PRINT 'Inserting product Blizzard Rustler 10...';
    INSERT INTO dbo.products (product_id, product_name, product_cost)
    VALUES ('E4B7A6F2-5C91-4F2E-9D3A-8A9B11111111', N'Blizzard Rustler 10', 699.00);
END
ELSE PRINT 'Product Blizzard Rustler 10 already exists; skipping.';
GO

PRINT '--- Products seeded ---';

-- Invoice Line Items

PRINT '--- Seeding invoice line items ---';

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

-- Line items: Acme Corp invoice (2025-01-05)
DECLARE @AcmeCustomerId UNIQUEIDENTIFIER = 'B1E5F9D0-1A5F-4B3E-9B9E-0E2A7F8B1111';
DECLARE @AcmeInvoiceNumber INT;

SELECT @AcmeInvoiceNumber = invoice_number
FROM dbo.invoices
WHERE customer_id = @AcmeCustomerId
  AND invoice_date = '2025-01-05T10:00:00';

IF @AcmeInvoiceNumber IS NOT NULL
BEGIN
    -- Gadget x3
    IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = 'A1111111-0001-0000-0000-000000000001')
    BEGIN
        PRINT 'Inserting Acme line item: Gadget x3...';

        INSERT INTO dbo.invoice_line_items (
            line_item_id, invoice_number, product_id, quantity,
            product_name, product_cost, total_cost
        )
        VALUES (
            'A1111111-0001-0000-0000-000000000001',
            @AcmeInvoiceNumber,
            '3C85F645-CE57-43A8-B192-7F46F8BBC273', -- Gadget
            3,
            N'Gadget',
            5.15,
            15.45
        );
    END

    -- Widget x4
    IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = 'A1111111-0002-0000-0000-000000000002')
    BEGIN
        PRINT 'Inserting Acme line item: Widget x4...';

        INSERT INTO dbo.invoice_line_items (
            line_item_id, invoice_number, product_id, quantity,
            product_name, product_cost, total_cost
        )
        VALUES (
            'A1111111-0002-0000-0000-000000000002',
            @AcmeInvoiceNumber,
            '9E3EF8CE-A6FD-4C9B-AC5D-C3CB471E1E27', -- Widget
            4,
            N'Widget',
            2.50,
            10.00
        );
    END
END
ELSE
BEGIN
    PRINT 'Acme invoice not found; skipping line items.';
END
GO

-- Line items: Pacific Logistics invoice (2025-01-07)
DECLARE @PacificCustomerId UNIQUEIDENTIFIER = 'C2A7D4F1-8F4C-4A7A-8C9D-2C1E0E222222';
DECLARE @PacificInvoiceNumber INT;

SELECT @PacificInvoiceNumber = invoice_number
FROM dbo.invoices
WHERE customer_id = @PacificCustomerId
  AND invoice_date = '2025-01-07T15:45:00';

IF @PacificInvoiceNumber IS NOT NULL
BEGIN
    -- Blizzard Rustler 10 x2
    IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = 'B2222222-0001-0000-0000-000000000001')
    BEGIN
        PRINT 'Inserting Pacific line item: Blizzard Rustler 10 x2...';

        INSERT INTO dbo.invoice_line_items (
            line_item_id, invoice_number, product_id, quantity,
            product_name, product_cost, total_cost
        )
        VALUES (
            'B2222222-0001-0000-0000-000000000001',
            @PacificInvoiceNumber,
            'E4B7A6F2-5C91-4F2E-9D3A-8A9B11111111', -- Blizzard Rustler 10
            2,
            N'Blizzard Rustler 10',
            699.00,
            1398.00
        );
    END

    -- Gizmo x10
    IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = 'B2222222-0002-0000-0000-000000000002')
    BEGIN
        PRINT 'Inserting Pacific line item: Gizmo x10...';

        INSERT INTO dbo.invoice_line_items (
            line_item_id, invoice_number, product_id, quantity,
            product_name, product_cost, total_cost
        )
        VALUES (
            'B2222222-0002-0000-0000-000000000002',
            @PacificInvoiceNumber,
            'A102E2B7-30D6-4AB6-B92B-8570A7E1659C', -- Gizmo
            10,
            N'Gizmo',
            1.00,
            10.00
        );
    END
END
ELSE
BEGIN
    PRINT 'Pacific invoice not found; skipping line items.';
END
GO

-- Line items: Smith, LLC second invoice (2025-01-10)
DECLARE @SmithCustomerId UNIQUEIDENTIFIER = 'AA5FD07A-05D6-460F-B8E3-6A09142F9D71';
DECLARE @SmithInvoice2Number INT;

SELECT @SmithInvoice2Number = invoice_number
FROM dbo.invoices
WHERE customer_id = @SmithCustomerId
  AND invoice_date = '2025-01-10T09:15:00';

IF @SmithInvoice2Number IS NOT NULL
BEGIN
    -- Thingie x6
    IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = 'C3333333-0001-0000-0000-000000000001')
    BEGIN
        PRINT 'Inserting Smith line item: Thingie x6...';

        INSERT INTO dbo.invoice_line_items (
            line_item_id, invoice_number, product_id, quantity,
            product_name, product_cost, total_cost
        )
        VALUES (
            'C3333333-0001-0000-0000-000000000001',
            @SmithInvoice2Number,
            '26812D43-CEE0-4413-9A1B-0B2EABF7E92C', -- Thingie
            6,
            N'Thingie',
            2.00,
            12.00
        );
    END

    -- Widget x1
    IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = 'C3333333-0002-0000-0000-000000000002')
    BEGIN
        PRINT 'Inserting Smith line item: Widget x1...';

        INSERT INTO dbo.invoice_line_items (
            line_item_id, invoice_number, product_id, quantity,
            product_name, product_cost, total_cost
        )
        VALUES (
            'C3333333-0002-0000-0000-000000000002',
            @SmithInvoice2Number,
            '9E3EF8CE-A6FD-4C9B-AC5D-C3CB471E1E27', -- Widget
            1,
            N'Widget',
            2.50,
            2.50
        );
    END
END
ELSE
BEGIN
    PRINT 'Smith second invoice not found; skipping line items.';
END
GO

PRINT '--- Invoice line items seeded ---';


PRINT '--- Seeding complete ---';