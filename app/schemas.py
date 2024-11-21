from pydantic import BaseModel

class KnowledgePointSchema(BaseModel):
    title: str
    content: str
    tags: str

class UserSchema(BaseModel):
    username: str
    email: str
    password: str
