/* =========================================================
   AceInvoice - init.sql
   - Creates database (if missing)
   - Creates schema objects (idempotent)
   - Optional seed data
   ========================================================= */

-- 1) Create database if it doesn't exist
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

-- 2) Switch context explicitly
USE [AceInvoice];
GO

-- 3) Create tables (idempotent)

IF OBJECT_ID(N'dbo.customers', N'U') IS NULL
BEGIN
    PRINT 'Creating table dbo.customers...';

    CREATE TABLE dbo.customers (
        customer_id            UNIQUEIDENTIFIER NOT NULL,
        customer_name          NVARCHAR(200)     NOT NULL,
        customer_address1      NVARCHAR(200)     NOT NULL,
        customer_address2      NVARCHAR(200)     NULL,
        customer_city          NVARCHAR(100)     NOT NULL,
        customer_state         NCHAR(2)          NOT NULL,
        customer_postal_code   NVARCHAR(20)      NOT NULL,
        customer_telephone     NVARCHAR(32)      NULL,
        customer_contact_name  NVARCHAR(150)     NULL,
        customer_email_address NVARCHAR(254)     NULL,

        CONSTRAINT PK_customers PRIMARY KEY CLUSTERED (customer_id)
    );
END
ELSE
BEGIN
    PRINT 'Table dbo.customers already exists.';
END
GO

IF OBJECT_ID(N'dbo.invoices', N'U') IS NULL
BEGIN
    PRINT 'Creating table dbo.invoices...';

    CREATE TABLE dbo.invoices (
        invoice_number  INT              NOT NULL,
        invoice_date    DATETIME2(0)     NOT NULL,
        customer_id     UNIQUEIDENTIFIER NOT NULL,
        created_at      DATETIME2(0)     NOT NULL CONSTRAINT DF_invoices_created_at DEFAULT (SYSUTCDATETIME()),

        CONSTRAINT PK_invoices PRIMARY KEY CLUSTERED (invoice_number)
    );
END
ELSE
BEGIN
    PRINT 'Table dbo.invoices already exists.';
END
GO

IF OBJECT_ID(N'dbo.invoice_line_items', N'U') IS NULL
BEGIN
    PRINT 'Creating table dbo.invoice_line_items...';

    CREATE TABLE dbo.invoice_line_items (
        line_item_id    UNIQUEIDENTIFIER NOT NULL,
        invoice_number  INT              NOT NULL,
        product_id      UNIQUEIDENTIFIER NOT NULL,
        quantity        INT              NOT NULL,
        product_name    NVARCHAR(200)     NOT NULL,
        product_cost    DECIMAL(19,4)     NOT NULL,
        total_cost      DECIMAL(19,4)     NOT NULL,

        CONSTRAINT PK_invoice_line_items PRIMARY KEY CLUSTERED (line_item_id),
        CONSTRAINT CK_invoice_line_items_quantity CHECK (quantity > 0),
        CONSTRAINT CK_invoice_line_items_money_nonneg CHECK (product_cost >= 0 AND total_cost >= 0)
    );
END
ELSE
BEGIN
    PRINT 'Table dbo.invoice_line_items already exists.';
END
GO

-- 4) Foreign Keys

IF OBJECT_ID(N'dbo.FK_invoices_customers', N'F') IS NULL
BEGIN
    ALTER TABLE dbo.invoices
    ADD CONSTRAINT FK_invoices_customers
    FOREIGN KEY (customer_id) REFERENCES dbo.customers(customer_id);
END
GO

IF OBJECT_ID(N'dbo.FK_invoice_line_items_invoices', N'F') IS NULL
BEGIN
    ALTER TABLE dbo.invoice_line_items
    ADD CONSTRAINT FK_invoice_line_items_invoices
    FOREIGN KEY (invoice_number) REFERENCES dbo.invoices(invoice_number)
    ON DELETE CASCADE;
END
GO

-- 5) Optional indexes (create only if missing)

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_customers_name'
      AND object_id = OBJECT_ID(N'dbo.customers')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_customers_name
    ON dbo.customers (customer_name);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_customers_email'
      AND object_id = OBJECT_ID(N'dbo.customers')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_customers_email
    ON dbo.customers (customer_email_address);
END
GO

-- Indexes for invoices and line items

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_invoices_customer_id'
      AND object_id = OBJECT_ID(N'dbo.invoices')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_invoices_customer_id
    ON dbo.invoices (customer_id);
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_invoice_line_items_invoice_number'
      AND object_id = OBJECT_ID(N'dbo.invoice_line_items')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_invoice_line_items_invoice_number
    ON dbo.invoice_line_items (invoice_number);
END
GO

-- 6) Optional seed data (safe to re-run)

DECLARE @CustomerId UNIQUEIDENTIFIER = 'AA5FD07A-05D6-460F-B8E3-6A09142F9D71';
DECLARE @InvoiceNumber INT = 5;

-- Customer 
IF NOT EXISTS (SELECT 1 FROM dbo.customers WHERE customer_id = @CustomerId)
BEGIN
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
END
GO


DECLARE @CustomerId UNIQUEIDENTIFIER = 'AA5FD07A-05D6-460F-B8E3-6A09142F9D71';
DECLARE @InvoiceNumber INT = 5;
-- Invoice (orderDetail)
IF NOT EXISTS (SELECT 1 FROM dbo.invoices WHERE invoice_number = @InvoiceNumber)
BEGIN
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
END
GO

-- Line Items (lineItems[])
IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = '9D91681F-0971-4170-BBA4-1617E53E7E8C')
BEGIN
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
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.invoice_line_items WHERE line_item_id = '91C75521-B7C5-45BB-B0C6-FDCA3A89ECD9')
BEGIN
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
END
GO

SELECT
    c.customer_id,
    c.customer_name,
    c.customer_address1,
    c.customer_address2,
    c.customer_city,
    c.customer_state,
    c.customer_postal_code,
    c.customer_telephone,
    c.customer_contact_name,
    c.customer_email_address
FROM dbo.customers c
WHERE c.customer_id = 'AA5FD07A-05D6-460F-B8E3-6A09142F9D71';
GO

-- Verification: invoice + customer join
SELECT
    i.invoice_number,
    i.invoice_date,
    c.customer_name,
    c.customer_city,
    c.customer_state
FROM dbo.invoices i
JOIN dbo.customers c ON c.customer_id = i.customer_id
WHERE i.invoice_number = 5;
GO

-- Verification: line items for invoice #5
SELECT
    i.invoice_number,
    li.line_item_id,
    li.product_id,
    li.quantity,
    li.product_name,
    li.product_cost,
    li.total_cost
FROM dbo.invoices i
JOIN dbo.invoice_line_items li
  ON li.invoice_number = i.invoice_number
WHERE i.invoice_number = 5
ORDER BY li.product_name;
GO

-- Verification: totals
SELECT
    i.invoice_number,
    SUM(li.total_cost) AS invoice_total
FROM dbo.invoices i
JOIN dbo.invoice_line_items li ON li.invoice_number = i.invoice_number
WHERE i.invoice_number = 5
GROUP BY i.invoice_number;
GO