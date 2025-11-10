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
    You are an AI car maintenance assistant.

    Analyze the following vehicle stats and give a short, plain text response.

    Focus only on the most critical maintenance issues that need immediate attention
    (such as oil, brakes, tires, engine, coolant, or battery).

    Do not include greetings, explanations, bullet points, or formatting — only direct, concise text.

    Vehicle Stats:
    {vehicle_stats}
    """


    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_query}
    ]

    try:
        response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages )
        return {response.message.content}
    except Exception as e:
        return {"error": str(e)}

# Example usage
