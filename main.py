from ollama import chat, ChatResponse
from schema import agent_schema
from agents.inventory import inventory_agent
from agents.conversation import conversation_agent
from agents.fullfilment import fulfillment_agent
from agents.recommendation import recommendation_agent
from schema.system_prompt import SYSTEM_PROMPT
import json
from fastapi import Query, FastAPI
from fastapi.responses import StreamingResponse

app = FastAPI()

# ✅ Registered tools
available_functions = { 
    'inventory_agent_function': inventory_agent,
    'conversational_agent_function': conversation_agent,
    'fulfillment_agent_function': fulfillment_agent,
    'recommendation_agent_function': recommendation_agent
}

# ✅ Context memory
master_context = {
    'conversation': [],
    'last_part': None   # <-- keeps track of last mentioned car part
}

tools = [
    agent_schema.inventory_agent_tool,
    agent_schema.conversational_agent_tool,
    agent_schema.fulfillment_agent_tool,
    agent_schema.recommendation_agent_tool
]
OLLAMA_MODEL = "llama3.2"


def ollama_chat(user_query):
    try:
        query = user_query.strip()
        if not query:
            yield json.dumps({"ollama_output": "No query provided."})
            return

        # ⚡ Keep context — don’t clear conversation
        master_context["conversation"].append({"role": "user", "content": query})

        # ✅ Use last part name for reference if user says “same” or “it”
        if any(word in query.lower() for word in ["same", "it", "that"]):
            if master_context.get("last_part"):
                query = query.replace("same", master_context["last_part"])
                query = query.replace("it", master_context["last_part"])
                query = query.replace("that", master_context["last_part"])

        messages = [{"role": "system", "content": SYSTEM_PROMPT}] + master_context["conversation"]
        response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages, tools=tools, think=False)

    except Exception as error:
        yield json.dumps({"ollama_output": f"Error: {error}"})
        return

    # ------------------ TOOL CALLS ------------------
# ------------------ TOOL CALLS ------------------
    print(response.message.tool_calls)
    if response.message.tool_calls:
        for tool in response.message.tool_calls:
            func_name = tool.function.name
            args = tool.function.arguments
            func = available_functions.get(func_name)
            print(f"func_name:{func_name} and args:{args}")

            if not func:
                yield json.dumps({"ollama_output": f"Unknown tool: {func_name}"})
                continue

            # 1️⃣ Yield agent name first
            yield json.dumps({"agent_name": func_name})

            # 🧩 CASE 1: Conversational or Recommendation Agent
            if func_name in ["conversational_agent_function", "recommendation_agent_function"]:
                # These shouldn’t have tool_output
                func(**args)
                yield json.dumps({"tool_output": None})

                # Generate quick natural reply from Ollama
                messages = [
                    {"role": "system", "content": 
                        "You are a friendly car service assistant. Reply naturally and briefly to the user query."},
                    {"role": "user", "content": query}
                ]
                followup_response = chat(model=OLLAMA_MODEL, messages=messages)
                followup_text = followup_response.message.content.strip() if followup_response.message.content else ""
                yield json.dumps({"ollama_output": followup_text})

                master_context["conversation"].append({"role": "assistant", "content": followup_text})
                return

            # 🧩 CASE 2: Inventory or Fulfillment Agent
            result = func(**args)
            if hasattr(result, "__iter__") and not isinstance(result, (str, dict, list)):
                result = list(result)

            yield json.dumps({"tool_output": result})

            # Track last mentioned part
            if "part_name" in args and args["part_name"]:
                master_context["last_part"] = args["part_name"]

            # Generate short follow-up
            messages = [
                {"role": "system", "content":
                    "You are an AI assistant for a car service platform. "
                    "Use the tool output and the user query to give a short, clear, and natural reply. "
                    "Focus only on the relevant info and add a follow-up question if appropriate."
                },
                {"role": "user", "content": query},
                {"role": "tool", "content": json.dumps(result)}
            ]
            followup_response = chat(model=OLLAMA_MODEL, messages=messages)
            followup_text = followup_response.message.content.strip() if followup_response.message.content else ""
            print("✅ Ollama follow-up generated:", followup_text)
            yield json.dumps({"ollama_output": followup_text})

            master_context["conversation"].append({"role": "assistant", "content": followup_text})
            return

    else:
        yield json.dumps({"agent_name": "none"})
        yield json.dumps({"ollama_output": "I couldn’t find a tool to handle that request."})


@app.get("/stream")
def stream(user_query: str = Query(..., description="User query to send to Ollama")):
    print(master_context)
    return StreamingResponse(ollama_chat(user_query), media_type="text/event-stream")
