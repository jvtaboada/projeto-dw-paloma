-- stg_customers > oltp_customers
CREATE OR REPLACE TABLE oltp_customers AS
       SELECT DISTINCT -- ??? TÁ CERTO ESSE DISTINCT AQUI JÁ ???
              --customer_id --id da transacao, vou ignorar
              CAST(customer_unique_id AS VARCHAR) customer_unique_id, --id unico, fica na dim
              --customer_zip_code_prefix
              CAST(customer_city as VARCHAR) as customer_city,
              CAST(customer_state as CHAR(2)) as customer_state --alias para varchar mesmo
       FROM stg_customers
       WHERE customer_unique_id IS NOT NULL;

SELECT * FROM oltp_customers;

-- stg_sellers > oltp_sellers
CREATE OR REPLACE TABLE oltp_sellers AS
       SELECT DISTINCT
              CAST(seller_id AS VARCHAR) AS seller_id,
              --seller_zip_code_prefix
              CAST(seller_city as VARCHAR) as seller_city,
              CAST(seller_state as CHAR(2)) as seller_state --alias para varchar mesmo
       FROM stg_sellers
       WHERE seller_id IS NOT NULL;

SELECT * FROM oltp_sellers;


-- stg_products > oltp_products
CREATE OR REPLACE TABLE oltp_products AS
       SELECT DISTINCT
              CAST(product_id AS VARCHAR) AS product_id,
              CAST(product_category_name AS VARCHAR) as product_categ
              --product_name_lenght
              --product_description_lenght
              --product_photos_qty
              --product_weight_g
              --product_length_cm
              --product_height_cm
              --product_width_cm
       FROM stg_products
       WHERE product_id IS NOT NULL;

SELECT * FROM oltp_products;


-- stg_orders > oltp_orders
CREATE OR REPLACE TABLE oltp_orders AS
       SELECT DISTINCT
              CAST(order_id AS VARCHAR) AS order_id,
              CAST(customer_id AS VARCHAR) AS customer_id,
              CAST(order_status AS VARCHAR) AS order_status,
              CAST(order_purchase_timestamp AS TIMESTAMP) AS purchase_ts,
              --order_approved_at
              --order_delivered_carrier_date
              CAST(order_delivered_customer_date AS TIMESTAMP) AS delivered_ts,
              --order_estimated_delivery_date
       FROM stg_orders
       WHERE order_id IS NOT NULL;

SELECT * FROM oltp_orders;


-- stg_order_items > oltp_order_items
CREATE OR REPLACE TABLE oltp_order_items AS
       SELECT DISTINCT
              CAST(order_id AS VARCHAR) AS order_id,
              CAST(order_item_id AS INTEGER) AS item_id,
              CAST(product_id AS VARCHAR) AS product_id,
              CAST(seller_id AS VARCHAR) AS seller_id,
              --shipping_limit_date
              CAST(price AS DECIMAL(10,2)) AS price,
              CAST(freight_value AS DECIMAL(10,2)) AS freight_value
       FROM stg_order_items
       WHERE order_id IS NOT NULL;

SELECT * FROM oltp_order_items;