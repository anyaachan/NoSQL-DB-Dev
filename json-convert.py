import json
import os
from datetime import datetime
import bson

def read_all_json_files(folder_path):
    data = {}
    for file in os.listdir(folder_path):
        if file.endswith(".json"):
            file_path = os.path.join(folder_path, file)
            with open(file_path, "r") as json_file:
                # The file name will be the key
                key = os.path.splitext(file)[0]
                data[key] = json.load(json_file)
    return data

# Usage
data = read_all_json_files("Tables-JSON")

animals_data = data.get("animal", None)
parent_child_data = data.get("parent_child", None)
feedings_data = data.get("animal_feeding", None)

# Creating a generic function which will filter entries by "foreign key" (filter key) specified. 
def get_filtered_data(filter_key, filter_value, data, attributes):
    filtered_data = []
    for entry in data:
        if entry[filter_key] == filter_value:
            filtered_entry = {attr: entry.get(attr) for attr in attributes}
            filtered_data.append(filtered_entry)
    if filtered_data:
        return filtered_data

### TRANSFORM ANIMAL DATA ###
def transform_animal_data(animals_data, parent_child_data, feedings_data):
    transformed_data = []
    for animal in animals_data:
        year, month, day = animal["birth_date"].split("-")
        transformed_animal = {
            "animal_id": animal["animal_id"], # Adding animal_id so we can reference conviniently 
            "sex": animal["sex"],
            "birth_date": {"$date": bson.datetime.datetime(int(year), int(month), int(day)).isoformat(timespec="milliseconds") + "Z"} ,
            "name": animal["name"],
            "enclosure": animal["enclosure_id"],
            "species_binominal_name": animal["binominal_name"],
            "parents": get_filtered_data("animal_id", animal["animal_id"], parent_child_data, ["animal_parent_id", "parenting_type"]),
            "feedings":  get_filtered_data("animal_id", animal["animal_id"], feedings_data, ["employee_id", "timestamp"])
        }
        transformed_data.append(transformed_animal)
    return transformed_data

transformed_animals = transform_animal_data(animals_data, parent_child_data, feedings_data)
#print(transformed_animals)


### TRANSFORM GODPARENT DATA ###
godparent_data = data.get("godparent", None)
animal_godparent_data = data.get("animal_godparent", None)

def transform_godparent_data(godparent_data, animal_godparent_data):
    transformed_data = []
    for entry in godparent_data:
        transformed_animal = {
            "godparent_id": entry["godparent_id"],
            "primary_contact": entry["primary_contact"],
            "name": entry["name"],
            "surname": entry["surname"],
            "secondary_contact": entry["secondary_contact"],
            "sponsored_animal": get_filtered_data("godparent_id", entry["godparent_id"], animal_godparent_data, ["animal_id", "donation_amount", "donation_period"])
        }
        transformed_data.append(transformed_animal)
    return transformed_data


transformed_godparent = transform_godparent_data(godparent_data, animal_godparent_data)
#print(transformed_godparent)

### TRANSFORM EMPLOYEE DATA ###
employee_data = data.get("employee", None)
zoo_keeper_data = data.get("zoo_keeper", None)
security_guard_data = data.get("security_guard", None)


def transform_employee_data(employee_data, zoo_keeper_data, security_guard_data):
    transformed_data = []
    for entry in employee_data:
        transformed_employee = {
            "employee_id": entry["employee_id"],
            "phone": entry["phone"],
            "email": entry["email"],
            "name": entry["name"],
            "surname": entry["surname"],
            "role": get_employee_role(entry["employee_id"], zoo_keeper_data, security_guard_data)
        }
        transformed_data.append(transformed_employee)
    return transformed_data

def get_employee_role(employee_id, zoo_keeper_data, security_guard_data):
    for entry in zoo_keeper_data:
        if entry["employee_id"] == employee_id:
            transformed_zoo_keeper = {
                "role_name": "zoo_keeper", 
                "animals_specialization": entry["animals_specialization"]
                }
            if transformed_zoo_keeper:
                return transformed_zoo_keeper

    for entry in security_guard_data:
        if entry["employee_id"] == employee_id:
            transformed_security_guard = {
                "role_name": "security_guard", 
                "security_level": entry["security_level"],
                "emergency_role": entry["emergency_role"]
                }
            if transformed_security_guard:
                return transformed_security_guard
        
    return None #If there is no role assigned for the employee
 
transformed_employee = transform_employee_data(employee_data, zoo_keeper_data, security_guard_data)
#print(transformed_employee)

### TRANSFORM SECTION DATA ###

section_data = data.get("section", None)
security_shifts_data = data.get("security_shift", None)
enclosure_data = data.get("enclosure", None)
enclosure_type_data = data.get("enclosure_type", None)

def transform_section_data(section_data, enclosure_data, security_shifts_data):
    transformed_data = []
    for entry in section_data:
        transformed_section = {
            "section_name": entry["section_name"],
            "enclosures": get_filtered_data("section_name", entry["section_name"], enclosure_data, ["enclosure_id", "capacity", "type_name"]),
            "security_shifts": get_filtered_data("section_name", entry["section_name"], security_shifts_data, ["employee_id", "date"])
        }
        transformed_data.append(transformed_section)
    return transformed_data

transformed_section = transform_section_data(section_data, enclosure_data, security_shifts_data)
#print(transformed_section)

for_export = [transformed_godparent, transformed_animals, transformed_employee, transformed_section]
export_names = ["godparent", "animal", "employee", "section"]

def export_to_files(for_export, export_names, folder_path):
    for dataset, name in zip(for_export, export_names):
        file_path = os.path.join(folder_path, f"{name}.json")
        with open(file_path, 'w') as json_file:
            json.dump(dataset, json_file, indent=4)

export_to_files(for_export, export_names, "JSON-transformed")