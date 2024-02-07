
# Directory containing JSON files
DIRECTORY="/Users/anna-alexandradanchenko/Documents/University/SecondYear/RelNoSQL/python_scripts/JSON-transformed"

# Iterate over each file in the directory
for FILE in "$DIRECTORY"/*
do
    # Extract the base name of the file (without path and extension)
    BASENAME=$(basename "$FILE" .json)

    # Import the file into MongoDB
    # The collection name is set to the name of the file
    mongoimport --uri "mongodb://lenochod.org:27017/annadanc" --username "annadanc" --password "soa3Oox@ohB^e0h" --collection "$BASENAME" --file "$FILE" --jsonArray
done