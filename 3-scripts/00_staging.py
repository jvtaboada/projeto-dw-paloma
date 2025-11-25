import duckdb

con = duckdb.connect("dw.duckdb")


# olist_orders_dataset
con.execute("""
    CREATE OR REPLACE VIEW stg_orders AS
    SELECT *
    FROM read_csv_auto('1-data/olist_orders_dataset.csv')
""")

df = con.execute("SELECT * FROM stg_orders LIMIT 10").fetchdf()
print(df)

# olist_order_items_dataset
con.execute("""
    CREATE OR REPLACE VIEW stg_order_items AS
    SELECT *
    FROM read_csv_auto('1-data/olist_order_items_dataset.csv')
""")

df = con.execute("SELECT * FROM stg_order_items LIMIT 10").fetchdf()
print(df)

# olist_products_dataset
con.execute("""
    CREATE OR REPLACE VIEW stg_products AS
    SELECT *
    FROM read_csv_auto('1-data/olist_products_dataset.csv')
""")

df = con.execute("SELECT * FROM stg_products LIMIT 10").fetchdf()
print(df)

# olist_sellers_dataset
con.execute("""
    CREATE OR REPLACE VIEW stg_sellers AS
    SELECT *
    FROM read_csv_auto('1-data/olist_sellers_dataset.csv')
""")

df = con.execute("SELECT * FROM stg_sellers LIMIT 10").fetchdf()
print(df)

# olist_customers_dataset
con.execute("""
    CREATE OR REPLACE VIEW stg_customers AS
    SELECT *
    FROM read_csv_auto('1-data/olist_customers_dataset.csv')
""")

df = con.execute("SELECT * FROM stg_customers LIMIT 10").fetchdf()
print(df)


# verificando todas as views criadas
views = con.execute("SELECT * FROM duckdb_views() WHERE sql LIKE '%stg%'").fetchdf()
print(views)