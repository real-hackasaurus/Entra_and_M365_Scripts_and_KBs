# M365 Power Platform

Scripts and source files for Microsoft 365 Power Platform services — currently focused on Power BI data source connections.

## Subfolders

### [Power BI](./Power%20BI)
Power Query (`.pq`) source files for connecting Power BI to Microsoft 365 data sources.

---

## Files

### Power BI — Advanced Hunting Connection

| File | Description |
|------|-------------|
| [Connect-PowerBIToAdvancedHunting.pq](./Power%20BI/Sources/Security_Portal_Advanced_Hunting/Connect-PowerBIToAdvancedHunting.pq) | Power Query M script that connects Power BI to the Microsoft 365 Defender Advanced Hunting API, enabling custom security dashboards and reports built from Advanced Hunting query results. |

---

## Usage

To use the Power Query source file:
1. Open Power BI Desktop.
2. Go to **Get Data** → **Blank Query**.
3. Open the **Advanced Editor** and paste the contents of the `.pq` file.
4. Authenticate with your Microsoft 365 credentials when prompted.
5. Customize the embedded KQL query as needed.

## Permissions

The account used to connect must have access to the **Microsoft 365 Defender** portal and the **Advanced Hunting** feature (typically requires **Security Reader** or **Security Operator** role).
