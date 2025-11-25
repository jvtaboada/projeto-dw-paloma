-- Hora de criar as dims e fact

-- INSERT INTO fact_orders

-- INSERT INTO dim_date

INSERT INTO dim_customer (customer_unique_id, customer_city, customer_state)
SELECT DISTINCT
    -- gerar sk_customer
       customer_unique_id,
       customer_city,
       customer_state
FROM stg_customers c

WHERE NOT EXISTS (
    SELECT 1 FROM dim_customer d
    WHERE d.customer_unique_id = c.customer_unique_id
);
