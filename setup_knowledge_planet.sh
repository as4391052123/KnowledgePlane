#!/bin/bash

# 项目根目录
PROJECT_NAME="KnowledgePlanet"
#mkdir -p $PROJECT_NAME

# 创建主目录结构
echo "Setting up main directories..."
mkdir -p $PROJECT_NAME/{app/{routers,services,db},data/{industry,forum},tests}

# 创建文件
echo "Creating main files..."

# 主文件
cat > $PROJECT_NAME/app/main.py <<EOL
from fastapi import FastAPI
from app.db.base import Base
from app.db.session import engine
from app.routers import knowledge, user

app = FastAPI()

Base.metadata.create_all(bind=engine)

app.include_router(knowledge.router)
app.include_router(user.router)
EOL

cat > $PROJECT_NAME/app/models.py <<EOL
from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from app.db.base import Base
from datetime import datetime

class KnowledgePoint(Base):
    __tablename__ = "knowledge_points"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    content = Column(Text)
    tags = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    password = Column(String)
EOL

cat > $PROJECT_NAME/app/schemas.py <<EOL
from pydantic import BaseModel

class KnowledgePointSchema(BaseModel):
    title: str
    content: str
    tags: str

class UserSchema(BaseModel):
    username: str
    email: str
    password: str
EOL

cat > $PROJECT_NAME/app/crud.py <<EOL
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
EOL

# 服务模块
cat > $PROJECT_NAME/app/services/scraper.py <<EOL
import requests
from bs4 import BeautifulSoup

def scrape_forum_data(url: str):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    posts = soup.find_all('div', class_='post')
    data = []
    for post in posts:
        content = post.get_text()
        data.append(content)
    return data
EOL

cat > $PROJECT_NAME/app/services/summarizer.py <<EOL
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans

def categorize_knowledge(data):
    vectorizer = TfidfVectorizer(stop_words='english')
    X = vectorizer.fit_transform(data)
    model = KMeans(n_clusters=5)
    model.fit(X)
    labels = model.labels_
    return labels
EOL

cat > $PROJECT_NAME/app/services/notifier.py <<EOL
def send_email_notification(user_email, subject, content):
    # 模拟发送邮件的逻辑
    print(f"Sending email to {user_email} with subject '{subject}'")
EOL

# 路由模块
cat > $PROJECT_NAME/app/routers/knowledge.py <<EOL
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
EOL

cat > $PROJECT_NAME/app/routers/user.py <<EOL
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
EOL

# 数据库模块
cat > $PROJECT_NAME/app/db/base.py <<EOL
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
EOL

cat > $PROJECT_NAME/app/db/session.py <<EOL
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
EOL

cat > $PROJECT_NAME/app/config.py <<EOL
class Settings:
    GITHUB_TOKEN = "your_github_token"
    DATABASE_URL = "sqlite:///./test.db"

settings = Settings()
EOL

# 测试文件
cat > $PROJECT_NAME/tests/test_scraper.py <<EOL
def test_scrape_forum_data():
    assert True  # Add actual test logic here
EOL

cat > $PROJECT_NAME/tests/test_knowledge.py <<EOL
def test_create_knowledge():
    assert True  # Add actual test logic here
EOL

# 其他文件
cat > $PROJECT_NAME/requirements.txt <<EOL
fastapi
sqlalchemy
pydantic
requests
beautifulsoup4
scikit-learn
EOL

cat > $PROJECT_NAME/Dockerfile <<EOL
FROM python:3.9
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOL

cat > $PROJECT_NAME/README.md <<EOL
# KnowledgePlanet
An open-source knowledge graph tool for individuals and organizations.
EOL

echo "Project setup complete in $PROJECT_NAME"
