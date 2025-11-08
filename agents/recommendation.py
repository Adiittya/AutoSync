from ollama import chat, ChatResponse
from db.config import get_database

db = get_database()
OLLAMA_MODEL = "llama3.2"

def recommendation_agent(user_query: str):
    """
    Generates AI car maintenance recommendations via Ollama,
    highlighting urgent alerts and crucial points.
    """
    user = db['users'].find_one()
    if not user:
        return {"error": "No user found."}

    vehicle_stats = user["vehicle"]["car_stats"]

    system_prompt = f"""
    You are an AI car maintenance assistant. Analyze the following vehicle stats
    and provide **concise, actionable recommendations** in **bullet points**.
    
    Requirements:
    - First, list **Critical Alerts** (things that need immediate action or attention).
    - Then, list **Other Tips** (important but not urgent).
    - Maximum 5 bullets in total, prioritize urgent issues.
    - Only include crucial maintenance items: oil, brakes, tires, engine, coolant, battery.
    - Do not include greetings, explanations, or extra commentary.
    
    Vehicle Stats:
    {vehicle_stats}
    """

    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_query}
    ]

    try:
        response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages)
        return {"recommendations": response.message.content}
    except Exception as e:
        return {"error": str(e)}

# Example usage
