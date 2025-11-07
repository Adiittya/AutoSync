from ollama import chat, ChatResponse
from schema import agent_schema
from agents.inventory import inventory_agent
from agents.conversation import conversation_agent
import json
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import time
from agents.ollama_result import ollama_result

app = FastAPI()
system_prompt = """
You are an intelligent and polite customer support + inventory assistant for a car service network across India.

You have access to TWO specialized tools:

1. **inventory_agent**
   - Use ONLY when the user asks about:
     • Car parts, their availability, stock, price, or quantity
     • Which service centers have a particular part
     • Listing or showing *all* service centers and their inventories
   - Example triggers:
     "Do you have engine oil?"
     "Where can I get brake pads?"
     "Show all service centers"
     "List every center across India"
     "What are all service centers?"

2. **skip_agent**
   - Use ONLY when the user's query is NOT related to inventory or service center data.
   - Examples:
     "Hey, how are you?"
     "Tell me about your car services"
     "What’s your working time?"
     "What’s the best car oil to use?"

Behavior Rules:
────────────────────────────────────────────
1. If user asks to **list, show, or get all service centers**, use `inventory_agent` with `action = "fetch_all"`.
2. For normal or non-inventory questions, use the `skip_agent` to handle the message normally.
3. Never mention databases, MongoDB, or internal logic.
4. Always respond naturally like a helpful support executive.
5. If unsure — prefer using **inventory_agent** instead of skipping.

Response Style:
────────────────────────────────────────────
Friendly, concise, professional. Keep it conversational but useful.
"""

available_functions = { 
    'inventory_agent_function': inventory_agent,
    'conversational_agent_function': conversation_agent,

}

tools = [agent_schema.inventory_agent_tool, agent_schema.conversational_agent_tool]
OLLAMA_MODEL = "llama3.2"
# query = input("Enter your query")
# message = [
#     {'role':'system', 'content':system_prompt},
#     {'role':'user', 'content':query},
# ]

def ollama_chat():
    try:
        print("trgfdgtf")
        query = "show me availablility of engine oil"
        message = [
            {'role':'system', 'content':system_prompt},
            {'role':'user', 'content':query},
        ]

        response: ChatResponse = chat(model= OLLAMA_MODEL, messages= message, tools=tools)
        # return response
    except Exception as error:
        print("Error", error)
        

    if response.message.tool_calls:
        for tool in  response.message.tool_calls:
            func_name = tool.function.name
            args = tool.function.arguments  # already a dict, no json.loads() needed!

            func = available_functions.get(func_name)
            if func:
                print(f"⚙️ Calling function: {func_name} with args: {args}")
                yield json.dumps(
                    {func_name:"fdfdvfdbvf"}
                )
                result = func(**args)  # call dynamically with unpacked arguments
                print("✅ Function result:", result)
                yield json.dumps(result)
                
            else:
                print(f"Unknown function: {func_name}")
    else:
        print("💬 Assistant:", response.message.content)


@app.get("/stream")
def stream():
    return StreamingResponse(ollama_chat(), media_type="text/event-stream")
