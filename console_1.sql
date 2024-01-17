// Select all the employees that work as zoo keepers. Display their animal specialization and information.
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

//Select all animals that were not fed on December 2, 2023, by checking the absence of a corresponding feeding record on that date.
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

