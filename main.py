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

# ✅ Context (only latest conversation)
master_context = {'conversation': []}
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
            yield json.dumps({"agent_name": "system"})
            yield json.dumps({"tool_output": None})
            yield json.dumps({"ollama_output": "No query provided."})
            return

        # ⚡ Reset context — keep only the latest query
        master_context["conversation"].clear()
        master_context["conversation"].append({"role": "user", "content": query})

        messages = [{"role": "system", "content": SYSTEM_PROMPT}] + master_context["conversation"]
        response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages, tools=tools, think=False)

    except Exception as error:
        yield json.dumps({"agent_name": "system"})
        yield json.dumps({"tool_output": None})
        yield json.dumps({"ollama_output": f"Error: {error}"})
        return

    # ------------------ TOOL CALLS ------------------
    print(response.message.tool_calls)
    if response.message.tool_calls:
        for tool in response.message.tool_calls:
            func_name = tool.function.name
            args = tool.function.arguments
            func = available_functions.get(func_name)
            print(f"func_name:{func_name} and args:{args}")

            if not func:
                yield json.dumps({"agent_name": "system"})
                yield json.dumps({"tool_output": None})
                yield json.dumps({"ollama_output": f"Unknown tool: {func_name}"})
                continue

            # 1️⃣ Yield agent name
            yield json.dumps({"agent_name": func_name})

            # 2️⃣ Execute tool and yield output
            result = None
            if func_name in ["inventory_agent_function", "fulfillment_agent_function"]:
                result = func(**args)
                yield json.dumps({"tool_output": result})

                # ⚡ Get conversational follow-up from Ollama
                messages = [
                    {"role": "system", "content":
                         "You are an AI assistant for a car service platform. "
                        "Your role is to read the tool output and the user’s query, "
                        "then provide a short, direct, and natural reply that answers the query using the data provided. "
                        "Focus only on relevant information — do not restate the entire data. "
                        "Always keep responses concise and conversational (one or two sentences). "
                        "If appropriate, include a natural follow-up question to keep the conversation going. "
                        "Avoid bullet points, formatting, or explanations."
                    },
                    {"role": "user", "content": query},
                    {"role": "tool", "content": json.dumps(result)}  # ✅ FIXED
                ]
                followup_response = chat(model=OLLAMA_MODEL, messages=messages)
                followup_text = followup_response.message.content.strip() if followup_response.message.content else ""
                print("✅ Ollama follow-up generated:", followup_text)
                yield json.dumps({"ollama_output": followup_text})

                master_context["conversation"] = [
                    {"role": "user", "content": query},
                    {"role": "assistant", "content": followup_text}
                ]
            
                return



            elif func_name in ["conversational_agent_function", "recommendation_agent_function"]:
                result = func(**args)
                yield json.dumps({"tool_output": None})

            # ✅ Handle generator output properly
            final_text = ""
            if hasattr(result, "__iter__") and not isinstance(result, (str, dict, list)):
                for chunk in result:
                    final_text += str(chunk)
                    yield json.dumps({"ollama_output": chunk})
            else:
                final_text = str(result)
                yield json.dumps({"ollama_output": final_text})

            # ✅ Save resolved text, not generator object
            master_context["conversation"] = [
                {"role": "user", "content": query},
                {"role": "assistant", "content": final_text}
            ]


    # ------------------ NORMAL CHAT (no tool call) ------------------
    else:
        yield json.dumps({"agent_name": "error"})


@app.get("/stream")
def stream(user_query: str = Query(..., description="User query to send to Ollama")):
    print(master_context)
    return StreamingResponse(ollama_chat(user_query), media_type="text/event-stream")




#dkdskdskvfdkmgfbgmfk