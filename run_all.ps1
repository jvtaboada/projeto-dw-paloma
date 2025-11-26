# run_all.ps1
# -------------------------------------------------------
# Orquestra o pipeline completo de ETL
# 1. Executa o staging (Python)
# 2. Executa as queries SQL no DuckDB
# -------------------------------------------------------

Write-Host "== INICIANDO PIPELINE ==" -ForegroundColor Cyan
Start-Sleep -Seconds 2


# 1. STAGING
Write-Host "`n[1/4] Executando 00_staging.py ..." -ForegroundColor Yellow
try {
    python ".\3-scripts\00_staging.py"
    Write-Host "✔ Staging concluído." -ForegroundColor Green
}
catch {
    Write-Host "Erro ao executar 00_staging.py" -ForegroundColor Red
    exit 1
}

Start-Sleep -Seconds 2


# 2. OLTP
Write-Host "`n[2/4] Executando 01_oltp.sql ..." -ForegroundColor Yellow
duckdb dw.duckdb -c ".read '3-scripts\01_oltp.sql'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao executar 01_oltp.sql" -ForegroundColor Red
    exit 1
}
Write-Host "✔ OLTP carregado." -ForegroundColor Green

Start-Sleep -Seconds 2


# 3. DW MODEL
Write-Host "`n[3/4] Executando 02_dw_model.sql ..." -ForegroundColor Yellow
duckdb dw.duckdb -c ".read '3-scripts\02_dw_model.sql'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao executar 02_dw_model.sql" -ForegroundColor Red
    exit 1
}
Write-Host "✔ Modelo DW criado." -ForegroundColor Green

Start-Sleep -Seconds 2


# 4. ETL LOAD
Write-Host "`n[4/4] Executando 03_etl_load.sql ..." -ForegroundColor Yellow
duckdb dw.duckdb -c ".read '3-scripts\03_etl_load.sql'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erro ao executar 03_etl_load.sql" -ForegroundColor Red
    exit 1
}
Write-Host "✔ Carga do DW concluída." -ForegroundColor Green

Start-Sleep -Seconds 2


Write-Host "`n== PIPELINE FINALIZADO ==" -ForegroundColor Cyan