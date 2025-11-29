# run_all.ps1
# -------------------------------------------------------
# Orquestra o pipeline completo de ETL + Analytics
# 1. Executa o staging (Python)
# 2. Executa as queries SQL no DuckDB
# 3. Roda validacoes, consultas analiticas e graficos
# -------------------------------------------------------

Write-Host "== INICIANDO PIPELINE ==" -ForegroundColor Cyan
Start-Sleep -Seconds 2


# 1. STAGING ----------------------------------------------------------
Write-Host "`n[1/7] Executando 00_staging.py ..." -ForegroundColor Yellow
try {
    python ".\3-scripts\00_staging.py"
    Write-Host "[OK] Staging concluido." -ForegroundColor Green
}
catch {
    Write-Host "Erro ao executar 00_staging.py" -ForegroundColor Red
    exit 1
}
Start-Sleep -Seconds 2


# 2. OLTP -------------------------------------------------------------
Write-Host "`n[2/7] Executando 01_oltp.sql ..." -ForegroundColor Yellow
duckdb dw.duckdb -c ".read '3-scripts\01_oltp.sql'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao executar 01_oltp.sql" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] OLTP carregado." -ForegroundColor Green
Start-Sleep -Seconds 2


# 3. DW MODEL ---------------------------------------------------------
Write-Host "`n[3/7] Executando 02_dw_model.sql ..." -ForegroundColor Yellow
duckdb dw.duckdb -c ".read '3-scripts\02_dw_model.sql'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao executar 02_dw_model.sql" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Modelo DW criado." -ForegroundColor Green
Start-Sleep -Seconds 2


# 4. ETL LOAD ---------------------------------------------------------
Write-Host "`n[4/7] Executando 03_etl_load.sql ..." -ForegroundColor Yellow
duckdb dw.duckdb -c ".read '3-scripts\03_etl_load.sql'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao executar 03_etl_load.sql" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Carga do DW concluida." -ForegroundColor Green
Start-Sleep -Seconds 2


# 5. VALIDACOES -------------------------------------------------------
Write-Host "`n[5/7] Executando validacoes de dados (00_validacoes_dados.py) ..." -ForegroundColor Yellow
try {
    python ".\4-analytics\00_validacoes_dados.py"
    Write-Host "[OK] Validacoes concluidas." -ForegroundColor Green
}
catch {
    Write-Host "Erro ao executar 00_validacoes_dados.py" -ForegroundColor Red
    exit 1
}
Start-Sleep -Seconds 2


# 6. CONSULTAS ANALITICAS---------------------------------------------
Write-Host "`n[6/7] Executando consultas analiticas (01_consultas_analiticas.sql) ..." -ForegroundColor Yellow
duckdb dw.duckdb -c ".read '4-analytics\01_consultas_analiticas.sql'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao executar 01_consultas_analiticas.sql" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Consultas analiticas concluidas." -ForegroundColor Green
Start-Sleep -Seconds 2


# 7. GERAÇÃO DE GRAFICOS ----------------------------------------------
Write-Host "`n[7/7] Gerando graficos (02_gera_graficos.py) ..." -ForegroundColor Yellow
try {
    python ".\4-analytics\02_gera_graficos.py"
    Write-Host "[OK] Graficos gerados com sucesso!" -ForegroundColor Green
}
catch {
    Write-Host "Erro ao executar 02_gera_graficos.py" -ForegroundColor Red
    exit 1
}
Start-Sleep -Seconds 2


Write-Host "`n== PIPELINE FINALIZADO ==" -ForegroundColor Cyan