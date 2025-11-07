inventory_agent_tool = {
    "type": "function",
    "function": {
        "name": "inventory_agent_function",
        "description": "Handles all inventory-related queries for the car_centers MongoDB collection. Fetches, filters, and searches car parts, service centers, and their availability.",
        "parameters": {
            "type": "object",
            "required": ["action"],
            "properties": {
                "action": {
                    "type": "string",
                    "enum": [
                        "fetch_all",        # Retrieve all centers and inventories
                        "fetch_by_part",    # Find centers having a specific part
                        "fetch_by_center"   # Find inventory of a particular center
                    ],
                    "description": "Specifies the type of operation to perform."
                },
                "part_name": {
                    "type": "string",
                    "description": "The name or partial name of the part to search for, e.g., 'Brake' or 'Oil'."
                },
                "center_name": {
                    "type": "string",
                    "description": "The name or partial name of the service center, e.g., 'Volks Auto'."
                },
               
            }
        }
    }
}

conversational_agent_tool = {
    "type": "function",
    "function": {
        "name": "conversational_agent_function",
        "description": (
            "Used when the user's query does not require inventory lookup or database access. "
            "It simply forwards the raw user message for general or conversational assistance — "
            "for example, questions about services, general queries, or natural chat that isn’t related to inventory."
        ),
        "parameters": {
            "type": "object",
            "required": ["user_query"],
            "properties": {
                "user_query": {
                    "type": "string",
                    "description": (
                        "The complete user message that should be passed to a general conversational model "
                        "for further assistance. Example: 'Tell me about your services' or 'What do you recommend for car maintenance?'."
                    )
                }
            }
        }
    }
}


