from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import time
from agents.ollama_result import ollama_result
import json 

app = FastAPI()
hi = {
  "_id": {
    "$oid": "690b64f275ae7298d1eb80b0"
  },
  "center_name": "Volks Auto Service Mumbai",
  "address": {
    "street": "Plot 12, Andheri Industrial Estate",
    "city": "Mumbai",
    "state": "Maharashtra",
    "pincode": "400053"
  },
  "contact": "+91-9876543210",
  "location": {
    "type": "Point",
    "coordinates": [
      72.868,
      19.119
    ]
  },
  "parts_available": [
    {
      "part_name": "Brake Pad",
      "category": "Braking System",
      "quantity": 20,
      "price": 1800
    },
    {
      "part_name": "Engine Oil",
      "category": "Lubricants",
      "quantity": 50,
      "price": 700
    }
  ]
}

messages = [
        {"role": "system", "content": "Your're a helpful ai "},
        {"role": "user", "content": "write hello world in pyhton "}
    ]

def combined_stream():
    yield json.dumps({"initial_data": hi}) + "\n\n"

    for chunk in ollama_result(messages):
        yield json.dumps({"ollama_chunk": chunk}) + "\n\n"


@app.get("/stream")
def stream():
    return StreamingResponse(combined_stream(), media_type="text/event-stream")
