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

def transform_animal_data(animals_data, parent_child_data, feedings_data):
    transformed_data = []
    for animal in animals_data:
        transformed_animal = {
            "sex": animal["sex"],
            "birth_date": animal["birth_date"],
            "name": animal["name"],
            "species": {"binominal_name": animal["binominal_name"]},
            "parent": get_parent_data(animal["animal_id"], parent_child_data),
            "feedings":  get_feeding_data(animal["animal_id"], )
        }
        transformed_data.append(transformed_animal)
    return transformed_data

def get_parent_data(animal_id, parent_child_data):
    parents = []
    for entry in parent_child_data:
        if entry['animal_id'] == animal_id:
            parent_info = {
                "parent_id": entry['animal_parent_id'],
                "parenting_type": entry['parenting_type']
            }
            parents.append(parent_info)
    return parents

def get_feeding_data(animal_id, feedings_data):
    parents = []
    for entry in parent_child_data:
        if entry['animal_id'] == animal_id:
            parent_info = {
                "parent_id": entry['animal_parent_id'],
                "parenting_type": entry['parenting_type']
            }
            parents.append(parent_info)
    return parents


transformed_animals = transform_animal_data(animals_data, parent_child_data, feedings_data)
print(transformed_animals)