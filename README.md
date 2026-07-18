# Excel ORM Skyway PoC

This project is a Proof of Concept (PoC) validating Software Tree's [ORM Skyway](https://github.com/SoftwareTree/orm_skyway_automation) pipeline against **Microsoft Excel**. It demonstrates data access and AI-agent integration for Excel using JDX, Gilhari, and ORMCP.

## Project Overview

**The pipeline workflow:**

```mermaid
flowchart TD
    A[(Excel Workbook)] -->|Phase 1: Reverse Engineer| B(JDX Object Model)
    B -->|Phase 3: Package| C(Gilhari REST Microservice)
    C -->|Phase 5: Connect AI| D(ORMCP Server)
    D --> E((AI Agent))
```

This reflects the ORM Skyway automated workflow layers:
```text
ORMCP Pipeline   ─────────────────────────────────  ← AI / MCP layer
                              ↑
Gilhari Pipeline ─────────────────────────────────  ← REST microservice layer
                              ↑
JDX Pipeline     ─────────────────────────────────  ← Java/JSON ORM layer
                              ↑
Excel Data       ═════════════════════════════════  ← foundation
```
This project successfully proves that Excel (via the CData JDBC driver) supports:
- Data access via REST
- Live natural-language querying via AI agents connected through MCP.

## Project Structure

This project uses the following file structure:
```text
excel_poc/
├── .git/
├── bin/                          # Compiled Java classes
├── config/                       # Driver jars, generated reverse engineering configs, and data file
├── gilhari/                      # Generated Gilhari configuration, Dockerfile, and curl scripts
├── scripts/                      # Helper scripts
├── src/                          # Generated Java object model source files
├── .gitattributes                
├── .gitignore                    
├── LICENSE                       # Project license
├── README.md                     # This file
├── orm_skyway_config_excel.json  # Pipeline configuration (gitignored)
└── sources.txt                   # Java source files compilation list (gitignored)
```

## Prerequisites & Environment Setup

- **Java & Python**: JDK 8+ and Python 3.8+
- **Gilhari SDK**: Required for JDX ORM libraries.
- **Excel JDBC Driver**: CData JDBC Driver for Excel. Place `cdata.jdbc.excel.jar` and your `.xlsx` data file in the correct paths.
- **Docker**: For running the Gilhari REST microservice.

### Configuring the Project

For security and portability, paths are configured via a JSON file. 

1. **Pipeline Configuration (`orm_skyway_config_excel.json`)**
   Create or edit `orm_skyway_config_excel.json` in the root directory (this file is gitignored). You must set up the local paths for the JDX SDK, JDBC driver, and Excel workbook. A standard setup looks like this:
   ```json
   {
       "jdbc_url": "jdbc:excel:URI=./customers.xlsx",
       "db_schema": "",
       "db_user": "",
       "db_password": "",
       "jdbc_driver_jar": "/path/to/cdata.jdbc.excel.jar",
       "jdbc_driver_class": "cdata.jdbc.excel.ExcelDriver",
       "db_type": "",
       "jx_home": "/path/to/Gilhari-0.8.0b-SDK",
       "object_model_package": "com.poc.excel.model",
       "docker_image_name": "excel-poc-service",
       "docker_image_tag": "1.0",
       "gilhari_host_port": 80
   }
   ```

## Running the Pipeline

1. **Reverse Engineer & Build (Phases 1 & 3)**
   Run the ORM Skyway automation script pointing to the JSON config in this repository:
   ```bash
   python /path/to/orm_skyway_automation/orm_skyway.py -f orm_skyway_config_excel.json --phase 1+3
   ```

2. **Start the Microservice (Phase 4)**
   Run the generated Docker container script:
   ```bash
   # Windows
   gilhari\run_docker_app.cmd
   
   # Linux/macOS
   ./gilhari/run_docker_app.sh
   ```
   The service will be exposed on port 80.

3. **Verify REST API**
   You can verify the Gilhari REST endpoints using `curl.exe`:
   ```bash
   curl.exe -s http://localhost:80/gilhari/v1/health/check
   ```

4. **Connect AI Agent via ORMCP (Phase 5)**
   Use ORMCP to expose the REST API to Claude Desktop or Antigravity IDE. Add the following to your MCP server config:
   ```json
   "excel-ormcp": {
       "command": "ormcp-server",
       "args": [],
       "env": {
           "GILHARI_BASE_URL": "http://localhost:80/gilhari/v1/",
           "MCP_SERVER_NAME": "excel-ormcp",
           "GILHARI_NAME": "excel-poc-service",
           "GILHARI_IMAGE": "excel-poc-service:1.0",
           "GILHARI_PORT": "80",
           "READONLY_MODE": "True"
       }
   }
   ```
