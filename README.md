# NoSQL-DB-Dev
Welcome to the NoSQL Database Migration Project repository. This project is a part of the BSc (Hons) Computing program coursework, focusing on the practical application of database migration techniques from an SQL DBMS to a NoSQL DBMS. Specifically, this project involves the migration of a PostgreSQL database to MongoDB.

The source PostgreSQL database presents a zoo management system, and its schema and data can be accessed through the following link: [Relational Database Repository](https://github.com/anyaachan/Relational-Database-Practice).

## Migration Approach

The migration process is structured in the following way: 

1. **Data Model Rethink**: The initial step involved changing the data model to comply with MongoDB database design principles. The revised NoSQL data model visualization is available in the [assets](Assets) folder for review.
![structure](https://github.com/anyaachan/NoSQL-DB-Dev/assets/53533713/b62afd00-36dc-4451-8d40-cd595c3b483f)

3. **Data Export**: The data from the PostgreSQL database was exported in JSON, which is compatible with MongoDB documents format. The exported JSON files, representing the original tables, can be found in the [SQL-Tables-JSON](SQL-Tables-JSON) directory.
4. Exported JSON files with SQL tables data were transformed using a [Python script](json-convert.py) to conform to the new NoSQL data model. 
