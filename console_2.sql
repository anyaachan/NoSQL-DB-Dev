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
                    enum: ["Biological", "Adoptive"],
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
                    enum: ["M", "F"],
                    description: "Must be one of the following: 'M', 'F'"
                }
         }
      }
   }
} );

db.createCollection("section", {
   validator: {
      $jsonSchema: {
         title: "Order object validator",
         required: ["section_name"],
         properties: {
                "enclosures": {
                    anyOf: [
                        {bsonType: "array"},
                        {bsonType: "null"}
                    ],
                    required: ["enclosuree_id", "capacity", "type_name"],
                    properties: {
                        "enclosure_id": {
                            bsonType: "int"
                        },
                        "capacity": {
                            bsonType: "int",
                            "minimum": 1 // should be greater than 0
                        },
                        "type_name": {
                            bsonType: "string"
                        }
                    }
                },
                "section_name": {
                    bsonType: "string"
                },
                "security_shifts": {
                    anyOf: [
                        {bsonType: "array"},
                        {bsonType: "null"}
                    ],
                    required: ["employee_id", "date"],
                    properties: {
                        "date": {
                            bsonType: "date"
                        },
                        "employee_id": {
                            bsonType: "int"
                        }
                    }
                }
         }
      }
   }
} );


db.createCollection("employee", {
   validator: {
      $jsonSchema: {
         title: "Order object validator",
         required: ["phone", "email", "employee_id", "name", "surname", "role"],
         properties: {
                "role": {
                    bsonType: "object",
                    required: ["role_name"],
                    properties: {
                        "role_name": {
                            bsonType: "string",
                            enum: ["zoo_keeper", "security_guard"]
                        },
                        "animals_specialization": {
                            anyOf: [
                                {bsonType: "string"},
                                {bsonType: "null"}
                            ],
                            enum: ["Mammals",
                                    "Birds",
                                    "Reptiles",
                                    "Amphibians",
                                    "Fish"]
                        },
                        "security_level": {
                            anyOf: [
                                {bsonType: "string"},
                                {bsonType: "null"}
                            ],
                            enum: ["Entry",
                                    "Intermediate",
                                    "Advanced"]
                        },
                        "emergency_role": {
                            anyOf: [
                                {bsonType: "string"},
                                {bsonType: "null"}
                            ]
                        },
                    }
                },
                "surname": {
                    bsonType: "string"
                },
                "name": {
                    bsonType: "string"
                },
                "email": {
                    bsonType: "string",
                    pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                },
                "phone": {
                    bsonType: "string"
                },
                "employee_id": {
                    bsonType: "int"
                },
         }
      }
   }
} );


db.createCollection("godparent", {
   validator: {
      $jsonSchema: {
         title: "Order object validator",
         required: ["godparent_id", "primary_contact", "name"],
         properties: {
                "sponsored_animal": {
                    anyOf: [
                        {bsonType: "array"},
                        {bsonType: "null"}
                    ],
                    required: ["animal_id", "donation_amount", "donation_period"],
                    properties: {
                        "donation_period": {
                            bsonType: "int"
                        },
                        "donation_amount": {
                            bsonType: "int"
                        },
                        "animal_id": {
                            bsonType: "int"
                        }
                    }
                },
                "name": {
                    bsonType: "string"
                },
                "godparent_id": {
                    bsonType: "int"
                },
                "primary_contact": {
                    bsonType: "string"
                },
                "surname": {
                    anyOf: [
                        {bsonType: "string"},
                         {bsonType: "null"}
                    ]
                },
                "secondary_contact": {
                    anyOf: [
                        {bsonType: "string"},
                         {bsonType: "null"}
                    ]
                }
         }
      }
   }
} );