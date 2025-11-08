# import requests
# import json

# url = "http://localhost:8000/stream"

# with requests.get(url, stream=True) as response:
#     response.raise_for_status()

#     for line in response.iter_lines():
#         if not line:
#             continue

#         try:
#             data = json.loads(line.decode('utf-8'))

#             if "initial_data" in data:
#                 print("📦 Initial Data Received:")
#                 print(json.dumps(data["initial_data"], indent=2))

#             elif "ollama_chunk" in data:
#                 chunk = data["ollama_chunk"]

#                 # sometimes chunk can be a dict (depending on ollama_result)
#                 if isinstance(chunk, dict):
#                     msg = chunk.get("message", {}).get("content", "")
#                     if msg:
#                         print(msg, end="", flush=True)
#                 else:
#                     print(chunk, end="", flush=True)

#             # optional: show the full JSON for debugging
#             # print("Received:", data)

#         except json.JSONDecodeError:
#             print("Raw chunk:", line.decode('utf-8'))
from agents.recommendation import recommendation_agent
print(recommendation_agent("whats advice for my car ?"))