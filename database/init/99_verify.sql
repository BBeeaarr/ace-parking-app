PRINT '--- Verification: customer record ---';

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

PRINT 'Rows returned (customer) = ' + CAST(@@ROWCOUNT AS NVARCHAR(20));
GO

PRINT '--- Verification: invoice + customer join ---';

SELECT
    i.invoice_number,
    i.invoice_date,
    c.customer_name,
    c.customer_city,
    c.customer_state
FROM dbo.invoices i
JOIN dbo.customers c ON c.customer_id = i.customer_id
WHERE i.invoice_number = 5;

PRINT 'Rows returned (invoice join) = ' + CAST(@@ROWCOUNT AS NVARCHAR(20));
GO

PRINT '--- Verification: line items for invoice #5 ---';

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

PRINT 'Rows returned (line items) = ' + CAST(@@ROWCOUNT AS NVARCHAR(20));
GO

PRINT '--- Verification: invoice totals ---';
