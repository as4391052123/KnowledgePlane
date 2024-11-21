from fastapi import APIRouter
from app.models import KnowledgePoint
from app.schemas import KnowledgePointSchema
from app.crud import get_knowledge_points, create_knowledge_point

router = APIRouter()

@router.post("/knowledge")
def create_knowledge(knowledge: KnowledgePointSchema):
    return create_knowledge_point(knowledge)

@router.get("/knowledge")
def read_knowledge():
    return get_knowledge_points()
