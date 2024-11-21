from fastapi import FastAPI
from app.db.base import Base
from app.db.session import engine
from app.routers import knowledge, user

app = FastAPI()

Base.metadata.create_all(bind=engine)

app.include_router(knowledge.router)
app.include_router(user.router)
