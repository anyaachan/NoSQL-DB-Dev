// 1. Select all the employees that work as zoo keepers. Display their animal specialization and information.
// This query was automatically translated by the DataGrip from the SQL query.
db.getSiblingDB("annadanc").getCollection("employee").aggregate([
  {
    $match: {"role.role_name": {$eq: "zoo_keeper"}}
  },
  {
    $project: {"employee_id": 1, "animals_specialization": "$role.animals_specialization", "name": 1, "surname": 1, "phone": 1, "email": 1, "_id": 0}
  },
  {
    $group: {
      _id: null,
      "distinct": {$addToSet: "$$ROOT"}
    }
  },
  {
    $unwind: {
      path: "$distinct",
      preserveNullAndEmptyArrays: false
    }
  },
  {
    $replaceRoot: {
      newRoot: "$distinct"
    }
  }
])

//2. Select all animals that were not fed on December 2, 2023, by checking the absence of a corresponding feeding record on that date.
db.animal.aggregate([
    {
        $project: {
            animal_id: 1,  // select the following fields
            name: 1,
            enclosure: 1,
            feedings: 1,
            feedings_on_date: { // select all the feeding on december 2, 2023 and put them into the new field
                $filter: {
                    input: "$feedings", // array to filter
                    as: "feeding", // each element is referred to as feeding
                    cond: { // condition to filter
                        $eq: [ // check the equality
                            {$dateToString: {format: "%Y-%m-%d", date: { $dateFromString: { dateString: "$$feeding.timestamp"}}}},
                            "2023-12-02"]
                    }
                }
            }
        }
    },
    {
        $match: { // filter the document to return only fields where feedings_on_date is empty or where feedings is null
           $or: [
                {"feedings_on_date": {$size: 0 }},
                {"feedings": {$eq: null }}
            ]
        }
    }
])

// 3. Select all animals that reside in the Africa section. In addition to the animal information, output the Enclosure Type and Enclosure ID of each enclosure associated with an animal that resides in the Africa section.

db.animal.aggregate([
    {
        $lookup: { // perform a join
            from: "section",
            let: {animal_enclosure: "$enclosure"},
            pipeline: [
                {$unwind: "$enclosures"}, // deconstruct the array
                {$match: {$expr: {$eq: ["$enclosures.enclosure_id", "$$animal_enclosure"]}}}, // $expr allows to use $eq expression inside the $match statement
                {$match: {section_name: "Africa"}}
            ],
            as: "section_data"
        }
    },
    {$unwind: "$section_data"}, // filter out the documents with empty arrays
    {
        $project: {
            animal_id: 1,
            name: 1,
            species_binominal_name: 1,
            sex: 1,
            birth_date: 1,
            enclosure_id: "$enclosure",
            enc_type: "$section_data.enclosures.type_name",
            section_name: "$section_data.section_name"
        }
    },
    {$sort: {"animal_id": 1}}
])

// 4. Select all zoo keepers that never fed any animal.
db.employee.aggregate([
    {
        $lookup: {
            from: "animal",
            localField: "employee_id",
            foreignField: "feedings.employee_id",
            as: "feedings"
        }
    },
    {
        $match: {
            "role.role_name": "zoo_keeper",
            "feedings": { $size: 0 }
        }
    },
    {
        $project: {
            employee_id: 1,
            name: 1,
            surname: 1,
            email: 1,
            phone: 1,
            feedings: "$feedings.feedings"
        }
    }
])

// 5. Select all of the employees and list their role and specialization.
db.employee.aggregate([
    {
        $unwind: "$role"
    },
    {
        $project: {
            employee_id: 1,
            name: 1,
            surname: 1,
            role_name: "$role.role_name",
            specialization: "$role.animals_specialization",
            security_level: "$role.security_level",
            emergency_role: "$role.emergency_role"
        }
    }
])

// 6. Select empty enclosures

db.section.aggregate([
    {$unwind: "$enclosures"},
    {
        $lookup: {
            from: "animal",
            let: {enclosure_id: "$enclosures.enclosure_id"},
            pipeline: [
                {$match: {$expr: {$eq: ["$enclosure", "$$enclosure_id"]}}}
            ],
            as: "animal_enc"
        }
    },
        {
        $project: {
            enclosure_id: "$enclosures.enclosure_id",
            animals_in_enc: "$animal_enc"
        }
    },
    {
        $match: {"animals_in_enc": {$size: 0}}
    },
    {
        $sort: {enclosure_id: 1}
    }
])

// 7.  Determine the occupancy percentage of each enclosure, comparing the number of animals present to its total capacity, and orders the results from highest to lowest percentage of utilization.
// The query produces the same results as SQL query.
db.section.aggregate([
    {
    $unwind: "$enclosures"
    },
    {
        $lookup: {
            from: "animal",
            localField: "enclosures.enclosure_id",
            foreignField: "enclosure",
            as: "animals_in_enc"
        }
    },
    {
        $project: {
            enclosure_id: "$enclosures.enclosure_id",
            animal_count: { $size: "$animals_in_enc" },
            capacity: "$enclosures.capacity",
            occupancy_percentage: {
                $round: [
                    {$multiply: [
                        {$divide: [{$size: "$animals_in_enc"}, "$enclosures.capacity"]},
                        100
                    ]
                }, 0
                ]
            }
        }
    },
    {
        $sort: {occupancy_percentage: -1}
    }
])

// 8. Select all Mammals that were fed at least once.
// The query returns the same results as the SQL query.
db.animal.aggregate([
    {$unwind: "$feedings"},
    {
        $lookup: {
            from: "employee",
            localField: "feedings.employee_id",
            foreignField: "employee_id",
            as: "employee_info"
        }
    },
    {$match: {"employee_info.role.animals_specialization": "Mammals"}},
    {
        $group: {
            _id: "$animal_id",
            name: {$first: "$name"},
            enclosure: {$first: "$enclosure"},
            species_binominal_name: {$first: "$species_binominal_name"},
        }
    }
])

// 9. Select all of the enclosures in the zoo which were guarded by security guards with Advanced security level.

// 10. Count how many times each employee had a shift in each section.
// The results of the query are not particularly same as in the SQL database, as the query does not display the shift count
// for the section if the count is 0.
db.section.aggregate([
    {$unwind: "$security_shifts"},
    {$group: {
        _id: {employee_id: "$security_shifts.employee_id",
            section_name: "$section_name"},
        shifts_count: {$sum: 1}
    }},
    {
        $project: {
            _id: 0, // excluding the _id field
            employee_id: "$_id.employee_id",
            section_name: "$_id.section_name",
            shifts_count: 1
        }
    },
    {
        $sort: {"employee_id": 1}
    }
])

// 11.


// 12. Select all of the animals in the zoo that both have animal parents in the zoo and godparents (sponsors).
// This query provides the same output as in the SQL database, however, it was decided to add a field with an array of godparents sponsoring
db.animal.aggregate([
    {$lookup: { // Join animal and godparent tables
        from: "godparent",
        localField: "animal_id",
        foreignField: "sponsored_animal.animal_id",
        as: "godparent_animal_match"
    }},
    {$match: {
            "parents.animal_parent_id": {$ne: null, $not: {$size: 0}},
            "godparent_animal_match": {$ne: null, $not: {$size: 0}}
        }
    },
    {$unwind: "$godparent_animal_match"},
    {
    $group: {
            _id: "$animal_id", // grouping key
            birth_date: {$first: "$birth_date"},
            name: {$first: "$name"},
            sex: {$first: "sex"},
            enclosure: {$first: "enclosure"},
            species_binominal_name: {$first: "$species_binominal_name"},
            sponsoring_godparents: {$push: "$godparent_animal_match.godparent_id"}}
    },
    {
        $project: {
            animal_id: 1,
            birth_date: 1,
            species_binominal_name: 1,
            name: 1,
            sex: 1,
            enclosure: 1,
            sponsoring_godparents: 1
        }
    }
])
