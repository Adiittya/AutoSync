from ollama import chat, ChatResponse
from dotenv import load_dotenv
import os

load_dotenv()
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL")
print(OLLAMA_MODEL)


def conversation_agent(user_query: str):
    """
    Handles normal user conversations that do not require database or inventory lookups.
    This simply chats using the model in a friendly, conversational tone.
    """
    system_prompt = """
    You are a friendly and professional customer support assistant for a car service brand.
    Respond naturally and conversationally.
    Avoid technical jargon or database talk.
    """

    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_query}
    ]

    try:
        response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages)
        return response.message.content
    except Exception as e:
        print("❌ Error in conversation_agent:", e)
        return None
