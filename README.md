# What is it ? 
It's a framework for small scale out-of-the-box BI infrastructure.

Each compoment can be replaced by a technology of you choice. Don't like postgres ? replace it with Oracle. The principles will still be the same.

# How to run it

1. Install docker https://docs.docker.com/install/
1. From root folder run.
`docker-compose up`
1. Wait until the containers are running.
1. Done :)


|          Container|                       Link |         Credentials |                                                       Note |
|               --- |                        --- |                 --- |                                                        --- |
|          NiFi     |  http://127.0.0.1:8080/nifi| None                | TODO: OpenLDAP in the future                               |
|          Postgres |  http://127.0.0.1:5432     | postgres:secret123  | to view the schema I added a https://dbschema.com/ project. /postgres/dwh/dbschema_dwh_project.dbs | 
|          Metabase |  http://127.0.0.1:3000     | You create your own |                                                            |
|          PgAdmin  |  http://127.0.0.1:8090     | admin:admin         |                                                            |
|          openldap |            localhost:38999 | None                |                                                            |
|          jira-api |             localhost:8000 | None                | Mock of https://\<your server\>/rest/api/3/ API              |
|     pipedrive-api |             localhost:8100 | None                | Mock of https://developers.pipedrive.com/docs/api/v1/ API  |
| restcountries-api |             localhost:8200 | None                | Mock of https://restcountries.eu/ API                      |

# Core Components

### NiFi
* Fetch data
* Store them in Postgres
* Execute Postgres stored procedures
* Single point of scheduling/dataflow
### Postgres
* Data store - staging
* Clean integrated data - core
* Reports - mart
* \+Transformations between areas
### Metabase
* View Reports/tables stored in mart
* Make aggregates/filters
* Share them via URLs

# NiFi
- I'm using NiFi as a **batch ingest tool** and **orchestrator** for **Data Warehouse**.

## Principles
From 2 years of working and trying to make workflow as generic, modularized and simple to understadnd here are my principles I used to archive it.
1. Every logical step should output only 1 flow file. e.g. One Processor group that ingests data from a source system and outputs one flow file into success or error connection.
1. Speficy credentials only once. e.g. If you use InvokeHTTP processor, create a workflow so that there won't be 2 InvokeHTTP processors with the same credentials set.
1. If you can, create a Processor group that will act as a blackbox. Show the user what's going on without going to unnecessary detail.

## Naming Convention:
|          Component|                  Naming Convention |                           Note | 
|               --- |                                --- |                            --- |
| flow file attriute|                     lowerCamelCase |          thisIsAnExampleForYou |
|        connection |  all lovercase separated with space|     this is an example for you |
|   processor group |                       Initial Caps |     This Is An Example For You |
|        input port |                                 in |   always use only this one name|
|       output port |                     success, error | use always only these two names|
|       connection  | success, error (whenever possible) | breaking rule example: Parsing log files and routing each line on log level: Info, Warn, Error |


# Postgres
### 3 schemas
|  Name |                                                Usage |
|   --- |                                                  --- |
| stage | here are data loaded _**as is**_ from source systems |
|  core |               cleaned integrated (foreign keys) data |
|  mart |                            very flat tables, reports |

### 4 table types (defined by postfixes)
|            Postfix |                                Name |                                                usage | 
|                --- |                                 --- |                                                  --- |
|                \_i | input                               |              contains temporary data used during etl |
|                \_t | today                               |                              always has current data |
|               \_ih | input historized                    |                     scd2 historization of \_i tables |
|                \_d | exact copy (snapshot) of \_i tables |                                               backup |
| _withoput_postfix_ |                              report |  **Only in mart schema** (will be changed to **\_r**)|

# Metabase
