from ollama import chat, ChatResponse
from schema import agent_schema
from agents.inventory import inventory_agent
from agents.conversation import conversation_agent   # ← your new file here
from schema.system_prompt import SYSTEM_PROMT
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import json, time
from context_manager import AIContextManager
from agents.ollama_result import ollama_result  # (if you use it)

app = FastAPI()
context = AIContextManager()

# Map tool names to actual functions
available_functions = {
    "inventory_agent_function": inventory_agent,
    "conversational_agent_function": conversation_agent,
}

# Register tools with Ollama
tools = [agent_schema.inventory_agent_tool, agent_schema.conversational_agent_tool]
OLLAMA_MODEL = "llama3.2"


# 🧩 MAIN STREAMING FUNCTION
def ollama_chat(session_id: str):
    ctx = context.get(session_id)
    user_query = "show me availability of engine oil"

    # record query in context
    context.update_master(session_id, "user", user_query)

    # build message list from context
    messages = [
        {"role": "system", "content": SYSTEM_PROMT},
        *ctx["master_history"],
    ]

    print("🚀 Sending message to Ollama:", user_query)
    response: ChatResponse = chat(model=OLLAMA_MODEL, messages=messages, tools=tools )

    if response.message.tool_calls:
        # STEP 1️⃣: MASTER DECIDES TOOL TO CALL
        for tool in response.message.tool_calls:
            func_name = tool.function.name
            args = tool.function.arguments
            func = available_functions.get(func_name)

            if func:
                yield json.dumps({"status": f"⚙️ Calling {func_name}..."}) + "\n"
                print(f"⚙️ Executing {func_name} with args → {args}")

                # STEP 2️⃣: EXECUTE AGENT / TOOL FUNCTION
                try:
                    result = func(**args)
                    context.store_result(session_id, func_name, result)
                    context.update_agent(session_id, func_name, "assistant", result)
                    yield json.dumps({"tool_result": result}) + "\n"
                    print(f"✅ {func_name} Result:", result)

                except Exception as e:
                    err_msg = f"❌ Error calling {func_name}: {e}"
                    print(err_msg)
                    yield json.dumps({"error": err_msg}) + "\n"
                    continue

                # STEP 3️⃣: CONVERT TOOL OUTPUT INTO HUMAN-FRIENDLY MESSAGE
                conversational_input = (
                    f"User asked: {user_query}\n\n"
                    f"Tool `{func_name}` output:\n{json.dumps(result, indent=2)}\n\n"
                    "Please summarize and respond to the user naturally."
                )

                try:
                    conv_result = conversation_agent(conversational_input)
                    context.update_master(session_id, "assistant", conv_result)

                    yield json.dumps({
                        "final_response": conv_result
                    }) + "\n"
                    print("🗣️ Conversational Agent Output:", conv_result)

                except Exception as e:
                    print("❌ Conversation agent failed:", e)
                    yield json.dumps({"error": str(e)}) + "\n"

    else:
        # STEP 4️⃣: NO TOOL CALL, DIRECT MODEL OUTPUT
        assistant_msg = response.message.content
        context.update_master(session_id, "assistant", assistant_msg)
        yield json.dumps({"assistant": assistant_msg}) + "\n"
        print("💬 Direct Assistant Reply:", assistant_msg)

    # 🧾 PRINT CONTEXT MEMORY SNAPSHOT
    print("\n==============================")
    print("🧠 CONTEXT MEMORY DUMP")
    print("==============================")
    full_memory = json.dumps(context.get(session_id), indent=2)
    print(full_memory)
    print("==============================\n")


# 🌐 STREAMING ENDPOINT
@app.get("/stream")
def stream(session_id: str = "default"):
    return StreamingResponse(ollama_chat(session_id), media_type="text/event-stream")
