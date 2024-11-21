from fastapi import APIRouter

router = APIRouter()

@router.get("/users/{id}")
async def get_user(id: int):
    return {"id": id, "name": "Sample User"}
