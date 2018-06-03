from .base import Base

class Filter(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = "converter_lc_signature"
        self.description = "Add the function's signature to the description"

    def filter(self, context):
        for candidate in context["candidates"]:
            if candidate.get("kind") == "Function":
                candidate["info"] = \
                    f"{candidate['menu']}\n\n{candidate['info']}".strip()
        return context["candidates"]
