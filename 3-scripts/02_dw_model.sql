-- fact_orders > dim_date, dim_customer, dim_product, dim_seller, dim_order_status

CREATE OR REPLACE TABLE fact_orders (
    -- Natural Keys - lógica dos pedidos: 1 order_id para N order_item_id
    order_id              VARCHAR,
    order_item_id         INTEGER,

    -- SKs das DIMs
    sk_date               INTEGER,
    sk_customer           INTEGER,
    sk_product            INTEGER,
    sk_seller             INTEGER,
    sk_order_status       INTEGER,

    -- KPIs
    price                 DECIMAL(10,2),
    freight_value         DECIMAL(10,2),
    total_value           DECIMAL(10,2),

    PRIMARY KEY(order_item_id, order_id)
);


CREATE OR REPLACE TABLE dim_date (
    sk_date        INTEGER PRIMARY KEY,
    date_value     DATE,
    year           INTEGER,
    month          INTEGER,
    month_name     VARCHAR,
    trim           VARCHAR
);


CREATE OR REPLACE TABLE dim_customer (
    sk_customer        INTEGER PRIMARY KEY,
    customer_id        VARCHAR,
    customer_unique_id VARCHAR,
    customer_city      VARCHAR,
    customer_state     CHAR(2),

    start_date         DATE,
    end_date           DATE,
    is_current         BOOLEAN
);


CREATE OR REPLACE TABLE dim_product (
    sk_product         INTEGER PRIMARY KEY,
    product_id         VARCHAR,
    product_categ      VARCHAR,

    start_date         DATE,
    end_date           DATE,
    is_current         BOOLEAN
);


CREATE OR REPLACE TABLE dim_seller (
    sk_seller         INTEGER PRIMARY KEY,
    seller_id          VARCHAR,
    seller_city        VARCHAR,
    seller_state       CHAR(2),

    start_date         DATE,
    end_date           DATE,
    is_current         BOOLEAN
);


CREATE OR REPLACE TABLE dim_order_status (
    sk_order_status   INTEGER PRIMARY KEY,
    status_name       VARCHAR
);