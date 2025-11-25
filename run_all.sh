# aqui orquestro o ETL todo!

python '.\3-scripts\00_staging.py'
duckdb dw.duckdb -c ".read  '3-scripts\01_oltp.sql'"
duckdb dw.duckdb -c ".read  '3-scripts\02_dw_model.sql'"
duckdb dw.duckdb -c ".read  '3-scripts\03_etl_load.sql'"