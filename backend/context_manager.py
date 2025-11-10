# context_manager.py
from collections import defaultdict
import time

class AIContextManager:
    def __init__(self):
        self.contexts = defaultdict(lambda: {
            "master_history": [],
            "agents": defaultdict(lambda: {"history": [], "last_output": None}),
            "shared_memory": {},
            "last_updated": time.time()
        })

    def get(self, session_id):
        return self.contexts[session_id]

    def update_master(self, session_id, role, content):
        ctx = self.contexts[session_id]
        ctx["master_history"].append({"role": role, "content": content})
        ctx["last_updated"] = time.time()

    def update_agent(self, session_id, agent_name, role, content):
        ctx = self.contexts[session_id]
        ctx["agents"][agent_name]["history"].append({"role": role, "content": content})
        ctx["last_updated"] = time.time()

    def store_result(self, session_id, agent_name, result):
        ctx = self.contexts[session_id]
        ctx["agents"][agent_name]["last_output"] = result
        ctx["shared_memory"][agent_name] = result
