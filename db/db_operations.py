from config import get_database
import json
from bson.json_util import dumps  

db = get_database()



def inventory_agent(action, part_name=None, center_name=None):
    """
    Handles inventory queries for car centers.
    """
    try:
        collection = db["car_centers"]

        # Fetch all records
        if action == "fetch_all":
            records = list(collection.find())

        # Fetch centers that have a matching part
        elif action == "fetch_by_part" and part_name:
            records = list(collection.find({
                "parts_available.part_name": {"$regex": part_name, "$options": "i"}
            }))

        # Fetch inventory for a specific center
        elif action == "fetch_by_center" and center_name:
            records = list(collection.find({
                "center_name": {"$regex": center_name, "$options": "i"}
            }))

        else:
            return {"error": "Invalid action or missing required parameters."}

        # Convert ObjectIds safely
        json_data = json.loads(dumps(records))
        print(f"✅ {len(json_data)} record(s) fetched for action '{action}'")
        return json_data

    except Exception as e:
        print("❌ Error in inventory_agent:", e)
        return {"error": str(e)}
    
    
# print(fetch_record({"parts_available.part_name":"engine oil"}))

# 1️⃣ Get all centers
# inventory_agent("fetch_all")

 # 2️⃣ Search by part name (fuzzy search)
# inventory_agent("fetch_by_part", part_name="oil")

# 3️⃣ Search by service center name
#inventory_agent("fetch_by_center", center_name="service vasai")
