PRINT '--- Table Creation Start ---';

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

IF OBJECT_ID(N'dbo.products', N'U') IS NULL
BEGIN
    PRINT 'Creating table dbo.products...';

    CREATE TABLE dbo.products (
        product_id    UNIQUEIDENTIFIER NOT NULL,
        product_name  NVARCHAR(200)     NOT NULL,
        product_cost  DECIMAL(19,4)     NOT NULL,

        CONSTRAINT PK_products PRIMARY KEY CLUSTERED (product_id),
        CONSTRAINT CK_products_cost_nonneg CHECK (product_cost >= 0)
    );
END
ELSE
BEGIN
    PRINT 'Table dbo.products already exists.';
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
PRINT '--- Table Creation Complete ---';