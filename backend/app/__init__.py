from fastapi import FastAPI

app = FastAPI()

from .routes import knowledge, user, subscriptions

app.include_router(knowledge.router)
app.include_router(user.router)
app.include_router(subscriptions.router, prefix="/api")
