# SQL to NoSQL Migration
Welcome to the **NoSQL Database Migration Project** repository. This project is a part of the BSc (Hons) Computing program coursework, focusing on the practical application of database migration techniques from an SQL DBMS to a NoSQL DBMS. Specifically, this project involves the migration of a **PostgreSQL** database to **MongoDB**.

The source PostgreSQL database presents a zoo management system, and its schema and data can be accessed through the following link: [Relational Database Repository](https://github.com/anyaachan/Relational-Database-Practice).

## Migration Approach

The migration process is structured in the following way: 

1. **Data Model Rethink**: The initial step involved changing the data model to comply with MongoDB database design principles. The revised NoSQL data model visualization is available in the [assets](assets) folder for review.
![structure](https://github.com/anyaachan/NoSQL-DB-Dev/assets/53533713/b62afd00-36dc-4451-8d40-cd595c3b483f)

2. **Data Export**: The data from the PostgreSQL database was exported in JSON, which is compatible with MongoDB documents format. The exported JSON files, representing 13 SQL tables, can be found in the [SQL-Tables-JSON](SQL-Tables-JSON) directory.
3. **Data Transformation**: The exported JSON files were then transformed using a [Python script](json-convert.py) to match the NoSQL data model. This transformation resulted in four JSON documents ready for import into MongoDB.
4. **JSON Schema Validation**: To maintain the integrity, consistency and safety of the data within the MongoDB database, the [JSON Schema Validation](create-script.sql) was set up.
5. **Database Population**: Using the [Bash script](bash-script.sh) along with **mongoimport** tool, the transformed JSON populates the MongoDB database with data.
