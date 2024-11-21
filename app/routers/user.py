from fastapi import APIRouter
from app.models import User
from app.schemas import UserSchema
from app.crud import get_user_by_email, create_user

router = APIRouter()

@router.post("/register")
def register(user: UserSchema):
    return create_user(user)

@router.post("/login")
def login(user: UserSchema):
    return get_user_by_email(user.email)
