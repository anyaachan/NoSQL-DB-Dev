import json
import os

def read_all_json_files(folder_path):
    data = {}
    for file in os.listdir(folder_path):
        if file.endswith('.json'):
            file_path = os.path.join(folder_path, file)
            with open(file_path, 'r') as json_file:
                # The file name without extension will be the key
                key = os.path.splitext(file)[0]
                data[key] = json.load(json_file)
    return data

# Usage
data = read_all_json_files("/Users/anna-alexandradanchenko/Documents/University/Second Year/Rel&NoSQL/Tables-JSON")

animals_data = data.get('animal', None)
parent_child_data = data.get('parent_child', None)
feedings_data = data.get('animal_feeding', None)

# Creating a generic function which will filter entries by "foreign key" (filter key) specified. 
def get_filtered_data(filter_key, filter_value, data, attributes):
    filtered_data = []
    for entry in data:
        if entry[filter_key] == filter_value:
            filtered_entry = {attr: entry.get(attr) for attr in attributes}
            filtered_data.append(filtered_entry)
    return filtered_data

def transform_animal_data(animals_data, parent_child_data, feedings_data):
    transformed_data = []
    for animal in animals_data:
        transformed_animal = {
            "animal_id": animal["animal_id"], # Adding animal_id so we can reference conviniently 
            "sex": animal["sex"],
            "birth_date": animal["birth_date"],
            "name": animal["name"],
            "species": {"binominal_name": animal["binominal_name"]},
            "parent": get_filtered_data("animal_id", animal["animal_id"], parent_child_data, ["animal_parent_id", "parenting_type"]),
            "feedings":  get_filtered_data("animal_id", animal["animal_id"], feedings_data, ["employee_id", "timestamp"])
        }
        transformed_data.append(transformed_animal)
    return transformed_data

transformed_animals = transform_animal_data(animals_data, parent_child_data, feedings_data)
print(transformed_animals)


# ### GODPARENT DATA ###
godparent_data = data.get('godparent', None)
animal_godparent_data = data.get('animal_godparent', None)

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
print(transformed_godparent)