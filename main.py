from ollama import chat, ChatResponse
from schema import agent_schema
from agents.inventory import inventory_agent
from agents.conversation import conversation_agent
from agents.fullfilment import fulfillment_agent
from agents.recommendation import recommendation_agent
from schema.system_prompt import SYSTEM_PROMPT
import json
from fastapi import FastAPI
from fastapi.responses import StreamingResponse

app = FastAPI()

# ✅ Registered tools
available_functions = { 
    'inventory_agent_function': inventory_agent,
    'conversational_agent_function': conversation_agent,
    'fulfillment_agent_function' : fulfillment_agent,
    "recommendation_agent_function" : recommendation_agent
}

# ✅ Contexts (structured and filtered)
master_context = {'conversation': []}
tools = [agent_schema.inventory_agent_tool, agent_schema.conversational_agent_tool, agent_schema.fulfillment_agent_tool, agent_schema.recommendation_agent_tool]
OLLAMA_MODEL = "llama3.2"

def clean_context():
    """Return only user and assistant messages for context."""
    return [
        {"role": msg["role"], "content": msg["content"]}
        for msg in master_context["conversation"]
        if msg.get("role") in ("user", "assistant")
    ]


def ollama_chat():
    while True:
        try:
            query = input("Enter query: ").strip()
            if not query:
                continue

            # ✅ Add only user message to context
            master_context["conversation"].append({"role": "user", "content": query})

            messages = [{"role": "system", "content": SYSTEM_PROMPT}] + clean_context()
            response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages, tools=tools)

        except Exception as error:
            print("❌ Error:", error)
            continue

        if response.message.tool_calls:
            # ✅ Tool call handling
            for tool in response.message.tool_calls:
                func_name = tool.function.name
                args = tool.function.arguments
                func = available_functions.get(func_name)

                if not func:
                    print(f"❌ Unknown tool: {func_name}")
                    continue

                print(f"⚙️ Executing {func_name} with args: {args}")
                yield json.dumps({func_name: "Tool execution started..."})

                result = func(**args)
                if hasattr(result, '__iter__') and not isinstance(result, (str, dict, list)):
                    collected = ""
                    for chunk in result:
                        collected += chunk
                        yield chunk
                    tool_output = collected
                else:
                    tool_output = result
                    yield json.dumps(result)

                # ✅ Append only clean summary of tool result
                master_context["conversation"].append({
                    "role": "assistant",
                    "content": f"Tool {func_name} executed successfully. Result summary: {str(tool_output)[:300]}"
                })

                # ✅ Let conversational agent respond to the result naturally
                if func_name != "conversational_agent_function":
                    for chunk in conversation_agent(context_message=tool_output):
                        yield chunk

        else:
            # ✅ Normal chat (no tool call)
            content = response.message.content.strip()
            master_context["conversation"].append({"role": "assistant", "content": content})
            yield json.dumps({"response": content})


@app.get("/stream")
def stream():
    return StreamingResponse(ollama_chat(), media_type="text/event-stream")
