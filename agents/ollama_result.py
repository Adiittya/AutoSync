from ollama import chat, ChatResponse
from dotenv import load_dotenv
import os

load_dotenv()
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL")


def ollama_result(messages: list):
    response : ChatResponse = chat(model=OLLAMA_MODEL, messages=messages, stream=True )
    for chunk in response:
        if chunk.message:
            yield chunk.message.content
            

for token in ollama_result(
     messages = [
        {"role": "system", "content": "HELPFULL AI"},
        {"role": "user", "content": "Good boii"}
    ]
):
    print(token, end="",flush= True)