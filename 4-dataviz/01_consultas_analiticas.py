import duckdb

def query(sql: str):
    con = duckdb.connect("dw.duckdb")
    return con.execute(sql).df()

df = query("""
SELECT COUNT(*) AS qtd_oltp
FROM oltp_orders;
           
SELECT COUNT(*) AS qtd_fato
FROM fact_orders;

""")
print(df)




# 1. Análise Temporal (linha do tempo)

#df = con.execute("SELECT COUNT(*) AS qtd_oltp FROM oltp_orders;").fetchdf()
#print(df)
#df = con.execute("SELECT COUNT(*) AS qtd_fact FROM fact_orders;").fetchdf()
#print(df) #tem zica, acho q no customer





#SELECT COUNT(*) FROM fact_orders WHERE sk_customer IS NULL; # tem zica!!
#SELECT COUNT(*) FROM fact_orders WHERE sk_product  IS NULL;
#SELECT COUNT(*) FROM fact_orders WHERE sk_seller   IS NULL;
#SELECT COUNT(*) FROM fact_orders WHERE sk_order_status IS NULL;
#SELECT COUNT(*) FROM fact_orders WHERE sk_date IS NULL;




# 2. Ranking / TOP N (os melhores/piores)

# 3. Agregação Multidimensional (várias perspectivas)

# 4. Análise de Cohort / Retenção (comportamento ao longo do tempo)

# 5. KPI (indicador-chave de negócio)
