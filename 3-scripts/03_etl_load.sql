/* Popular o modelo dimensional definido:  gerar dimensão data, remover duplicatas, criar SKs, criar colunas de SCD2 e gerar tabela fato de acordo com a regra de negócio */

-- Dimensão Date -- TÁ ERRADASSA SLC: OLHA AÍ Q PRECISA BATER NA DATA DA PURCHASE
INSERT INTO dim_date
SELECT
    CAST(strftime('%Y%m%d', dt) AS INTEGER) AS sk_date,
    dt AS date_value,
    EXTRACT(YEAR  FROM dt) AS year,
    EXTRACT(MONTH FROM dt) AS month,
    strftime('%B', dt) AS month_name,
    'T' || EXTRACT(QUARTER FROM dt) AS trim
FROM (
    SELECT DISTINCT
        CAST(purchase_ts AS DATE) AS dt
    FROM oltp_orders
)
ORDER BY dt;



-- Dimensão Customer
WITH c AS (
    SELECT DISTINCT
        customer_id,
        TRIM(customer_unique_id) AS customer_unique_id,
        customer_city,
        customer_state
    FROM oltp_customers
)
INSERT INTO dim_customer (
    sk_customer,
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state,
    start_date,
    end_date,
    is_current
)
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id) AS sk_customer,
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state,
    CURRENT_DATE,
    NULL,
    TRUE
FROM c;


-- Dimensão Product
WITH p AS (
    SELECT DISTINCT
        TRIM(product_id) AS product_id,
        product_categ
    FROM oltp_products
)
INSERT INTO dim_product (
    sk_product,
    product_id,
    product_categ,
    start_date,
    end_date,
    is_current
)
SELECT
    ROW_NUMBER() OVER (ORDER BY product_id) AS sk_product,
    product_id,
    product_categ,
    CURRENT_DATE,
    NULL,
    TRUE
FROM p;


-- Dimensão Seller
WITH s AS (
    SELECT DISTINCT
        TRIM(seller_id) AS seller_id,
        seller_city,
        seller_state
    FROM oltp_sellers
)
INSERT INTO dim_seller (
    sk_seller,
    seller_id,
    seller_city,
    seller_state,
    start_date,
    end_date,
    is_current
)
SELECT
    ROW_NUMBER() OVER (ORDER BY seller_id) AS sk_seller,
    seller_id,
    seller_city,
    seller_state,
    CURRENT_DATE,
    NULL,
    TRUE
FROM s;


-- Dimensão Order Status
WITH st AS (
    SELECT DISTINCT
        COALESCE(NULLIF(TRIM(order_status), ''), 'UNKNOWN') AS order_status
    FROM oltp_orders
)
INSERT INTO dim_order_status (
    sk_order_status,
    status_name
)
SELECT
    ROW_NUMBER() OVER (ORDER BY order_status) AS sk_order_status,
    order_status AS status_name
FROM st;


-- Fato Orders
INSERT INTO fact_orders (
    order_id,
    order_item_id,
    sk_date,
    sk_customer,
    sk_product,
    sk_seller,
    sk_order_status,
    price,
    freight_value,
    total_value
)
SELECT
    -- Natual Keys
    oi.order_id,
    oi.item_id,

    -- SKs
    dd.sk_date,
    dc.sk_customer,
    dp.sk_product,
    ds.sk_seller,
    dos.sk_order_status,

    -- KPIs
    oi.price,
    oi.freight_value,            
    (oi.price + oi.freight_value)
FROM oltp_order_items oi
JOIN oltp_orders o ON oi.order_id = o.order_id
LEFT JOIN dim_date dd ON dd.sk_date = CAST(strftime('%Y%m%d', o.purchase_ts) AS INTEGER)
LEFT JOIN dim_customer dc ON dc.customer_id = o.customer_id AND dc.is_current = TRUE
LEFT JOIN dim_product dp ON dp.product_id = oi.product_id AND dp.is_current = TRUE
LEFT JOIN dim_seller ds ON ds.seller_id = oi.seller_id AND ds.is_current = TRUE
LEFT JOIN dim_order_status dos ON dos.status_name = o.order_status;