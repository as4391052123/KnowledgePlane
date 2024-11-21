from fastapi import APIRouter

router = APIRouter()

@router.get("/knowledge/{id}")
async def get_knowledge_point(id: int):
    return {"id": id, "name": "Sample Knowledge Point"}

@router.post("/knowledge/")
async def add_knowledge_point(data: dict):
    return {"status": "success", "data": data}
