# NiFi ETL Template

## Work in progress

Template for using NiFi as **batch ingest tool** and **orchestrator** for **Data Warehouses**.

### This specifc template relies on this (postgres) database schema:
#### 3 schemas
| name | usage |
| --- | --- |
| stage | here are data loaded _**as is**_ from source systems |
| core | cleaned integrated (foreign keys) data |
| mart | very flat tables, reports |

#### 4 table types (defined by postfixes)
| Postfix | Name | usage | 
| --- | --- | --- |
| \_i | input | contains temporary data used during etl |
| \_t | today | always has current data |
| \_ih | input historized | scd2 historization of \_i tables |
| \_d | exact copy (snapshot) of \_i tables |
| _withoput_postfix_ | report |  **Only in mart schema** (will be changed to **\_r**)|
