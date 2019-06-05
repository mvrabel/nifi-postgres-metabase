# NiFi ETL Template

## Work in progress

Template for using NiFi as **batch ingest tool** and **orchestrator** for **Data Warehouses**.

|  Abbreviation |     Full Name |
|           --- |           --- |
|            FF |      Flow File|
|            PG | Process Group |

### Principles
From 2 years of working and trying to make workflow as generic, modularized and simple to understadnd here are my principles I used to archive it.
1. Every logical step should output only 1 FF. e.g. One PG that ingests data from a source system and outputs one flow file into success or error connection.
1. Speficy credentials only once. e.g. If you use InvokeHTTP processor, create a workflow so that there won't be 2 InvokeHTTP processors with the same credentials set.
1. If you can, create a PG that will act as a blackbox. Show the user what's going on without going to unnecessary detail.


### Naming Convention:
|          Component|                  Naming Convention |                           Note | 
|               --- |                                --- |                            --- |
| flow file attriute|                     lowerCamelCase |          thisIsAnExampleForYou |
|        connection |  all lovercase separated with space|     this is an example for you |
|   processor group |                       Initial Caps |     This Is An Example For You |
|        input port |                                 in |   always use only this one name|
|       output port |                     success, error | use always only these two names|
|       connection  | success, error (whenever possible) | breaking rule example: Parsing log files and routing each line on log level: Info, Warn, Error |


### Description of the database schema this NiFi workflow relies on.
I used Postgres.
#### 3 schemas
|  Name |                                                Usage |
|   --- |                                                  --- |
| stage | here are data loaded _**as is**_ from source systems |
|  core |               cleaned integrated (foreign keys) data |
|  mart |                            very flat tables, reports |

#### 4 table types (defined by postfixes)
|            Postfix |                                Name |                                                usage | 
|                --- |                                 --- |                                                  --- |
|                \_i | input                               |              contains temporary data used during etl |
|                \_t | today                               |                              always has current data |
|               \_ih | input historized                    |                     scd2 historization of \_i tables |
|                \_d | exact copy (snapshot) of \_i tables |                                               backup |
| _withoput_postfix_ |                              report |  **Only in mart schema** (will be changed to **\_r**)|
