from sqlalchemy.orm import Session
from app.models import KnowledgePoint, User

def get_knowledge_points(db: Session):
    return db.query(KnowledgePoint).all()

def create_knowledge_point(db: Session, knowledge):
    db_knowledge = KnowledgePoint(**knowledge.dict())
    db.add(db_knowledge)
    db.commit()
    db.refresh(db_knowledge)
    return db_knowledge

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

def create_user(db: Session, user):
    db_user = User(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
