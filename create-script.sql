db.getCollection("animal").drop();

db.getCollection("employee").drop();

db.getCollection("godparent").drop();

db.getCollection("section").drop();

db.createCollection("animal", {
   validator: {
      $jsonSchema: {
         title: "Order object validator",
         required: ["animal_id", "species_binominal_name"],
         properties: {
                "animal_id": {
                    bsonType: "int",
                    description: "Must be an integer and is required"
                },
                "enclosure_id": {
                    anyOf: [
                        {bsonType: "int"},
                        {bsonType: "null"}],
                },
                "binominal_name": {
                    bsonType: "string"
                },
                "birth_date": {
                    anyOf: [
                        {bsonType: "date"},
                        {bsonType: "null"}
                    ]
                },
                "name": {
                    anyOf: [
                        {bsonType: "string"},
                        {bsonType: "null"}
                        ]
                },
                "parents.parenting_type": {
                    enum: ['Biological', 'Adoptive'],
                    description: "Must be one of the following: 'Biological', 'Adoptive'"
                },
                "feedings": {
                    anyOf: [
                        {bsonType: "array"},
                        {bsonType: "null"}
                    ],
                    required: ["timestamp", "employee_id"]
                },
                "sex": {
                    enum: ['M', 'F'],
                    description: "Must be one of the following: 'M', 'F'"
                }
         }
      }
   }
} );

