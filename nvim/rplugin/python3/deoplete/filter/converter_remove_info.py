from .base import Base

class Filter(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = "converter_remove_info"
        self.description = "Remove unnecessary data from completions"

    def filter(self, context):
        for candidate in context["candidates"]:
            candidate.pop("info", None)
            if candidate.get("kind", None) == "Module":
                candidate.pop("menu", None)
        return context["candidates"]
