## ⚙️ Pré-requisitos locais
- Git configurado
- Python 3.14.0 (ou superior)
- Windows e PowerShell


<br>

## 🛠️ Como rodar o projeto

1. Baixe o código do projeto e entre no diretório
 ```pwsh
   git clone https://github.com/jvtaboada/projeto-dw-paloma.git
   cd projeto-dw-paloma
   ```

2. Crie o ambiente virtual venv
```pwsh
    python -m venv venv
```

3. Ative o ambiente virtual venv
```pwsh
    .\venv\Scripts\activate.ps1
```

4. Instale as dependências do projeto
```pwsh
    pip install -r requirements.txt
```

5. Projeto configurado ✅

6. Execute o Pipeline ETL
```pwsh
    .\run_all.ps1
```