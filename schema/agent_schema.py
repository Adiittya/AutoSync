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


fulfillment_agent_tool = {
    "type": "function",
    "function": {
        "name": "fulfillment_agent_function",
        "description": (
            "Handles fulfillment tasks like finding service centers for a requested service or part. "
            "If no specific part/service is mentioned, backend automatically returns the nearest top 3 centers."
        ),
        "parameters": {
            "type": "object",
            "required": ["action"],
            "properties": {
                "action": {
                    "type": "string",
                    "enum": [
                        "fetch_centers_by_service",   # user asked for a type of service
                        "fetch_centers_by_part",      # user asked for a specific part
                        "fetch_user_bookings"         # internal use by backend only
                    ],
                    "description": "Defines which fulfillment operation to perform."
                },
                "service_type": {
                    "type": "string",
                    "description": (
                        "The service requested by the user, e.g., 'full service', 'tyre replacement'. "
                        "Optional — if not provided, backend will return nearest centers."
                    )
                },
                "part_name": {
                    "type": "string",
                    "description": (
                        "The specific car part the user is looking for, e.g., 'engine oil', 'brake pad'. "
                        "Optional — used only when action = 'fetch_centers_by_part'."
                    )
                }
            }
        }
    }
}


recommendation_agent_tool = {
    "type": "function",
    "function": {
        "name": "recommendation_agent_function",
        "description": (
            "Generates AI-driven car maintenance recommendations based on the user's vehicle stats. "
            "The assistant analyzes engine oil, brake pads, tire pressure, battery, coolant, and other telemetry."
        ),
        "parameters": {
            "type": "object",
            "required": ["user_query"],
            "properties": {
                "user_query": {
                    "type": "string",
                    "description": (
                        "The user message asking for car recommendations or advice, e.g., "
                        "'What should I do next for my car?'"
                    )
                }
            }
        }
    }
}
