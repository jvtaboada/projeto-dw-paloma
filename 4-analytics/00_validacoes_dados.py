import duckdb

def query(sql: str):
    con = duckdb.connect("dw.duckdb")
    return con.execute(sql).df()


print("\n###############\n1: Conta linhas > oltp_order_items PRECISA TER O MESMO NÚMERO DE LINHAS QUE A fact_orders\n###############")

df = query("""
WITH checks AS (

    -- Total de linhas da tabela bruta
    SELECT 
        'Total linhas oltp_order_items' AS teste,
        COUNT(*) AS resultado
    FROM oltp_order_items

    UNION ALL

    -- Total de linhas da fato
    SELECT 
        'Total linhas fact_orders',
        COUNT(*)
    FROM fact_orders

    UNION ALL

    -- Diferença: precisa ser 0
    SELECT 
        'Diferenca (oltp_order_items - fact_orders)',
        (SELECT COUNT(*) FROM oltp_order_items)
        -
        (SELECT COUNT(*) FROM fact_orders)

)

SELECT * FROM checks;
""")
print(df)

print()

print("\n###############\n2: Sem NULLs nas chaves estrangeiras > não pode haver colunas SKs nulas, pois isso indica erro no ETL Load\n###############")

df = query("""
WITH checks AS (

    -- Total de linhas da fato
    SELECT 
        'Total linhas fato' AS teste,
        COUNT(*) AS resultado
    FROM fact_orders

    UNION ALL

    -- Nulls em sk_date
    SELECT 
        'Nulls em sk_date',
        COUNT(*) 
    FROM fact_orders
    WHERE sk_date IS NULL

    UNION ALL

    -- Nulls em sk_customer
    SELECT 
        'Nulls em sk_customer',
        COUNT(*) 
    FROM fact_orders
    WHERE sk_customer IS NULL

    UNION ALL

    -- Nulls em sk_product
    SELECT 
        'Nulls em sk_product',
        COUNT(*) 
    FROM fact_orders
    WHERE sk_product IS NULL

    UNION ALL

    -- Nulls em sk_seller
    SELECT 
        'Nulls em sk_seller',
        COUNT(*) 
    FROM fact_orders
    WHERE sk_seller IS NULL

    UNION ALL

    -- Nulls em sk_order_status
    SELECT 
        'Nulls em sk_order_status',
        COUNT(*) 
    FROM fact_orders
    WHERE sk_order_status IS NULL

)

SELECT * FROM checks;
""")

print(df)

print()

print("\n###############\n3: Todas os pedidos têm cliente/produto/vendedor/status válidos\n###############")

df = query("""
SELECT COUNT(*) AS sk_customer_invalidos
FROM fact_orders f
LEFT JOIN dim_customer c
    ON c.sk_customer = f.sk_customer
WHERE c.sk_customer IS NULL;
""")
print(df)
print()
df = query("""
SELECT COUNT(*) AS sk_product_invalidos
FROM fact_orders f
LEFT JOIN dim_product p
    ON p.sk_product = f.sk_product
WHERE p.sk_product IS NULL;
""")
print(df)
print()
df = query("""
SELECT COUNT(*) AS sk_seller_invalidos
FROM fact_orders f
LEFT JOIN dim_seller s
    ON s.sk_seller = f.sk_seller
WHERE s.sk_seller IS NULL;
""")
print(df)
print()
df = query("""
SELECT COUNT(*) AS sk_order_status_invalidos
FROM fact_orders f
LEFT JOIN dim_order_status os
    ON os.sk_order_status = f.sk_order_status
WHERE os.sk_order_status IS NULL;
""")
print(df)
print()
