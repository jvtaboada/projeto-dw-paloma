-- 1. Análise Temporal (linha do tempo) > faturamento por ano
SELECT
    d.year,
    SUM(f.total_value) AS faturamento
FROM fact_orders f
JOIN dim_date d ON d.sk_date = f.sk_date
GROUP BY d.year
ORDER BY d.year;


-- 2. Ranking / TOP N (os melhores/piores) > top 5 cidades com maior faturamento
SELECT
    dc.customer_city,
    SUM(f.total_value) AS faturamento
FROM fact_orders f
JOIN dim_customer dc ON dc.sk_customer = f.sk_customer
GROUP BY dc.customer_city
ORDER BY faturamento DESC
LIMIT 5;


-- 3. Agregação Multidimensional (várias perspectivas) > vendas por categoria e por estado
SELECT
    p.product_categ,
    c.customer_state,
    COUNT(DISTINCT f.order_id) AS qtd_pedidos -- 1 order_id para N order_item_id
FROM fact_orders f
JOIN dim_product p ON p.sk_product = f.sk_product
JOIN dim_customer c ON c.sk_customer = f.sk_customer
GROUP BY p.product_categ, c.customer_state
ORDER BY qtd_pedidos DESC;



-- 4. Análise de Cohort / Retenção (comportamento ao longo do tempo) > quantos clientes voltaram a comprar?
WITH purchases AS (
    SELECT 
        c.customer_unique_id,
        d.date_value
    FROM fact_orders f
    JOIN dim_customer c ON c.sk_customer = f.sk_customer
    JOIN dim_date d ON d.sk_date = f.sk_date
),
first_purchase AS (
    SELECT 
        customer_unique_id,
        MIN(date_value) AS first_purchase_date
    FROM purchases
    GROUP BY customer_unique_id
),
returned_customers AS (
    SELECT 
        fp.customer_unique_id,
        fp.first_purchase_date
    FROM purchases p
    JOIN first_purchase fp USING (customer_unique_id)
    WHERE p.date_value > fp.first_purchase_date
    GROUP BY fp.customer_unique_id, fp.first_purchase_date
)
SELECT 
    first_purchase_date,
    COUNT(*) AS clientes_que_voltaram
FROM returned_customers
GROUP BY first_purchase_date
ORDER BY first_purchase_date;


-- 5. KPI (indicador-chave de negócio) > ticket médio por estado
SELECT
    c.customer_state,
    SUM(f.total_value) / COUNT(DISTINCT f.order_id) AS ticket_medio, -- 1 order_id para N order_item_id
    COUNT(DISTINCT f.order_id) AS qtd_pedidos
FROM fact_orders f
JOIN dim_customer c ON c.sk_customer = f.sk_customer
GROUP BY c.customer_state
ORDER BY ticket_medio DESC;
