import duckdb
import pandas as pd
import plotly.express as px
import seaborn as sns
import matplotlib.pyplot as plt
from plotly.subplots import make_subplots


# Conectar ao DuckDB
con = duckdb.connect("dw.duckdb")

#######################################################################

# CONSULTAS e GERAÇÃO DE GRÁFICOS

## 1. GRÁFICO DE LINHAS: faturamento por ano
sql_faturamento_ano = """
SELECT
    d.year AS ano,
    SUM(f.total_value) AS faturamento
FROM fact_orders f
JOIN dim_date d ON d.sk_date = f.sk_date
GROUP BY d.year
ORDER BY d.year;
"""

# ajustar detalhe do ano 2016.5 #
df = con.execute(sql_faturamento_ano).df()

graf1 = px.line(df, x="ano", y="faturamento", title="Faturamento por ano")

graf1.write_image('1-grafico_faturamento_ano.png')

print(f"[OK] Gerado: 1-grafico_faturamento_ano.png")


#######################################################################

## 2. GRÁFICO DE BARRAS: top 5 cidades com maior faturamento
sql_top5 = """
SELECT
    dc.customer_city as cidade,
    SUM(f.total_value) AS faturamento
FROM fact_orders f
JOIN dim_customer dc ON dc.sk_customer = f.sk_customer
GROUP BY dc.customer_city
ORDER BY faturamento DESC
LIMIT 5;
"""

df = con.execute(sql_top5).df()

graf2 = px.bar(df, x='cidade', y='faturamento', title='Top 5 cidades por faturamento')

graf2.write_image('2_grafico_top5_cidades_faturamento.png')

print(f"[OK] Gerado: 2_grafico_top5_cidades_faturamento.png")


#######################################################################

## 3. GRÁFICO DE HEATMAP: faturamento por mês, por categoria
sql_fat_mes_categ = """
SELECT 
    d.year AS ano,
    d.month AS mes,
    p.product_categ AS categoria,
    SUM(f.price) AS faturamento
FROM fact_orders f
JOIN dim_date d ON d.sk_date = f.sk_date
JOIN dim_product p ON p.sk_product = f.sk_product
GROUP BY 
    ano, mes, categoria
ORDER BY 
    ano, mes, categoria
"""

df = con.execute(sql_fat_mes_categ).df()

pivot = df.pivot_table(
    index="categoria",
    columns="mes",
    values="faturamento",
    aggfunc="sum",
    fill_value=0
)

plt.figure(figsize=(14, 8))
sns.heatmap(
    pivot,
    annot=False,
    cmap="YlGnBu"
)

plt.title("Heatmap - Faturamento por Mês × Categoria")
plt.xlabel("Mês")
plt.ylabel("Categoria")
plt.tight_layout()
plt.savefig("3_grafico_heatmap_faturamento_mes_categoria.png", dpi=200)

print("[OK] Gerado: 3_grafico_heatmap_faturamento_mes_categoria.png")

#######################################################################

## 4. COMPOSIÇÃO DE GRÁFICOS

dash = make_subplots(rows=2, cols=2)

# Adiciona FIGURE 1 no subplot (1,1)
for tr in graf1.data:
    dash.add_trace(tr, row=1, col=1)

# Adiciona FIGURE 2 no subplot (1,2)
for tr in graf2.data:
    dash.add_trace(tr, row=1, col=2)

dash.write_html('4_dashboard_completo.html')

print("[OK] Gerado: 4_dashboard_completo.html")