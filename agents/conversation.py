from ollama import chat, ChatResponse
from dotenv import load_dotenv
import os, json

load_dotenv()
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL")
print("Model:", OLLAMA_MODEL)


def conversation_agent(user_query: str = None, context_message=None):
    """
    Handles both normal conversation and post-tool (JSON-based) responses.
    Chooses the right system prompt automatically based on context type.
    """

    # ✅ Two prompt modes — auto-switched
    normal_prompt = """
    You are a warm, friendly, and knowledgeable customer support assistant 
    for a car service company in India.
    - Speak naturally, like chatting with a real person.
    - Keep answers short, clear, and professional.
    - NEVER mention tools, JSON, databases, or system internals.
    - Example: 
      User: "What services do you offer?"
      Assistant: "We offer full car servicing, oil changes, brake inspections, and more!"
    """

    context_prompt = """
    You are a polite, smart, and professional customer support assistant 
    for a car service company in India.

    You will sometimes receive structured data or technical JSON from an internal system.
    Your job is to interpret it and reply to the user in a *fully natural* way.

    Rules:
    - NEVER mention or hint that this came from a tool, JSON, or system.
    - Just explain the meaning conversationally, as if you personally looked it up.
    - Focus on what matters: part names, availability, price, city, etc.
    - If multiple centers or parts are listed, summarize them neatly in short sentences.

    Example transformation:
    RAW DATA: {'city': 'Mumbai', 'parts': [{'part': 'Engine Oil', 'price': 700}]}
    REPLY: "Yes! Engine oil is available at our Mumbai service center for ₹700."

    Keep tone friendly, confident, and clear.
    """

    # ✅ Detect which mode to use
    is_context = bool(context_message)
    system_prompt = context_prompt if is_context else normal_prompt

    messages = [{"role": "system", "content": system_prompt}]

    if is_context:
        try:
            parsed = json.loads(context_message) if isinstance(context_message, str) else context_message
            context_summary = json.dumps(parsed, indent=2)[:1000]  # limit size
        except Exception:
            context_summary = str(context_message)[:1000]
        messages.append({
            "role": "user",
            "content": f"This is the tool output or previous context you should summarize:\n{context_summary}"
        })

    if user_query:
        messages.append({"role": "user", "content": user_query})

    try:
        response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages)
        yield response.message.content
    except Exception as e:
        print("❌ Error in conversation_agent:", e)
        return None
