from pymongo import MongoClient

def get_database(db_name: str = "volks_db"):
    """
    Connect to a local MongoDB instance and return the database object.

    Args:
        db_name (str): Name of the database to connect to. Default is 'mydatabase'.

    Returns:
        Database: A pymongo database object.
    """
    try:
        # Create a MongoDB client (default localhost:27017)
        client = MongoClient("mongodb://localhost:27017/")
        db = client[db_name]
        print(f"✅ Connected to MongoDB database: {db_name}")
        return db
    except Exception as e:
        print("❌ MongoDB connection failed:", e)
        return None
    
    
item_3 = {
  "center_name": "Volks Auto Service Mumbai",
  "address": {
    "street": "Plot 12, Andheri Industrial Estate",
    "city": "Mumbai",
    "state": "Maharashtra",
    "pincode": "400053"
  },
  "contact": "+91-9876543210",
  "location": {
    "type": "Point",
    "coordinates": [72.868, 19.119] 
  },
  "parts_available": [
    {
      "part_name": "Brake Pad",
      "category": "Braking System",
      "quantity": 20,
      "price": 1800
    },
    {
      "part_name": "Engine Oil",
      "category": "Lubricants",
      "quantity": 50,
      "price": 700
    }
  ]
}

# Get DB connection
# db = get_database()

# # Get a collection (like a table)
# collection = db["car_centers"]

# # Insert document into the collection
# result = collection.insert_one(item_3)
# print(f"✅ Inserted item with ID: {result.inserted_id}")