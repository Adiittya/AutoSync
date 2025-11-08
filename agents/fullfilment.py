from db.config import get_database
from bson.json_util import dumps
import json

db = get_database()

def fulfillment_agent(action, service_type=None, part_name=None):
    """
    Handles service center fulfillment logic:
    - Fetches centers by service or part.
    - Fetches the single user's bookings (prototype mode).
    - Returns top 3 nearest centers if no match found.
    """
    try:
        centers_collection = db["car_centers"]
        bookings_collection = db["bookings"]
        users_collection = db["users"]

        # ✅ Always fetch single user (prototype mode)
        user = users_collection.find_one()
        if not user:
            return {"error": "No user found in users collection."}
        user_id = user.get("user_id")

        # 1️⃣ Centers offering service
        if action == "fetch_centers_by_service" and service_type:
            records = list(centers_collection.find())
            result_type = f"Centers offering {service_type}"

        # 2️⃣ Centers with specific part
        elif action == "fetch_centers_by_part" and part_name:
            records = list(centers_collection.find({
                "parts_available.part_name": {"$regex": part_name, "$options": "i"}
            }))
            result_type = f"Centers having part '{part_name}'"

        # 3️⃣ Fetch this user's bookings
        elif action == "fetch_user_bookings":
            records = list(bookings_collection.find({
                "customer_name": user["name"],
                "status": {"$in": ["pending", "confirmed"]}
            }))
            result_type = f"Active bookings for {user['name']}"

        # 4️⃣ Default: nearest centers (dummy top 3)
        elif action == "fetch_nearest_centers":
            records = list(centers_collection.find().limit(3))
            result_type = "Top 3 nearest service centers"

        else:
            return {"error": "Invalid action or missing parameters."}

        json_data = json.loads(dumps(records))
        print(f"✅ {len(json_data)} record(s) fetched for action '{action}' → {result_type}")
        return json_data

    except Exception as e:
        print("❌ Error in fulfillment_agent:", e)
        return {"error": str(e)}
