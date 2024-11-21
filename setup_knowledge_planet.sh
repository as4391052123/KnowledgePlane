#!/bin/bash

# 定义项目目录
PROJECT_NAME="KnowledgePlanet"
VERSION="0.0.1"

echo "Initializing project: $PROJECT_NAME"

# 创建目录结构
mkdir -p $PROJECT_NAME/{backend/app/{models,routes,services,utils},backend/tests,frontend/src/{components,pages,services},frontend/public,data/{raw,processed},docs}

# 初始化 README
cat > $PROJECT_NAME/README.md <<EOL
# Knowledge Planet

Knowledge Planet is an open-source knowledge graph tool designed for individuals and organizations.

## Version
Current version: $VERSION
EOL

# 初始化后端代码

## backend/app/__init__.py
cat > $PROJECT_NAME/backend/app/__init__.py <<EOL
from fastapi import FastAPI

app = FastAPI()

from .routes import knowledge, user, subscriptions

app.include_router(knowledge.router)
app.include_router(user.router)
app.include_router(subscriptions.router, prefix="/api")
EOL

## backend/app/main.py
cat > $PROJECT_NAME/backend/app/main.py <<EOL
from . import app

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
EOL

## backend/app/routes/knowledge.py
cat > $PROJECT_NAME/backend/app/routes/knowledge.py <<EOL
from fastapi import APIRouter

router = APIRouter()

@router.get("/knowledge/{id}")
async def get_knowledge_point(id: int):
    return {"id": id, "name": "Sample Knowledge Point"}

@router.post("/knowledge/")
async def add_knowledge_point(data: dict):
    return {"status": "success", "data": data}
EOL

## backend/app/routes/user.py
cat > $PROJECT_NAME/backend/app/routes/user.py <<EOL
from fastapi import APIRouter

router = APIRouter()

@router.get("/users/{id}")
async def get_user(id: int):
    return {"id": id, "name": "Sample User"}
EOL

## backend/app/routes/subscriptions.py
cat > $PROJECT_NAME/backend/app/routes/subscriptions.py <<EOL
from fastapi import APIRouter, HTTPException
from backend.app.services.subscription_config import SubscriptionConfig

router = APIRouter()
config = SubscriptionConfig()

@router.get("/subscriptions")
def get_all_subscriptions():
    """获取所有订阅配置"""
    return config.get_all()

@router.get("/subscriptions/{name}")
def get_subscription_by_name(name: str):
    """根据名称获取订阅配置"""
    subscription = config.get_by_name(name)
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    return subscription

@router.post("/subscriptions")
def update_subscriptions(new_config: dict):
    """更新订阅配置"""
    updated_config = config.update(new_config)
    return {"status": "success", "updated_config": updated_config}
EOL

## backend/app/services/subscription_config.py
cat > $PROJECT_NAME/backend/app/services/subscription_config.py <<EOL
import yaml

class SubscriptionConfig:
    def __init__(self, config_path="data/subscriptions.yaml"):
        self.config_path = config_path

    def get_all(self):
        with open(self.config_path, "r") as file:
            return yaml.safe_load(file)

    def get_by_name(self, name):
        config = self.get_all()
        for subscription in config.get("subscriptions", []):
            if subscription["name"] == name:
                return subscription
        return None

    def update(self, new_config):
        with open(self.config_path, "w") as file:
            yaml.dump(new_config, file)
        return new_config
EOL

## backend/requirements.txt
cat > $PROJECT_NAME/backend/requirements.txt <<EOL
fastapi
uvicorn
py2neo
requests
beautifulsoup4
pyyaml
EOL

# 初始化前端代码

## frontend/src/App.vue
cat > $PROJECT_NAME/frontend/src/App.vue <<EOL
<template>
  <div>
    <h1>Knowledge Planet</h1>
  </div>
</template>

<script>
export default {
  name: "App"
};
</script>

<style scoped>
h1 {
  font-family: Arial, sans-serif;
}
</style>
EOL

## frontend/package.json
cat > $PROJECT_NAME/frontend/package.json <<EOL
{
  "name": "knowledge-planet-frontend",
  "version": "$VERSION",
  "description": "Frontend for Knowledge Planet",
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build"
  },
  "dependencies": {
    "vue": "^3.0.0"
  },
  "devDependencies": {
    "@vue/cli-service": "^5.0.0"
  }
}
EOL

# 初始化订阅配置
cat > $PROJECT_NAME/data/subscriptions.yaml <<EOL
subscriptions:
  - name: github_project_updates
    type: github
    config:
      repos:
        - "owner/repo1"
        - "owner/repo2"
      events:
        - "commits"
        - "issues"
        - "pull_requests"
    schedule: "daily"

  - name: ai_news_updates
    type: news
    config:
      sources:
        - "https://ai.googleblog.com/"
        - "https://openai.com/blog/"
        - "https://huggingface.co/blog"
    keywords:
      - "GPT"
      - "large language models"
      - "AI research"
    schedule: "hourly"

  - name: ai_job_market
    type: job_market
    config:
      platforms:
        - "https://www.lagou.com/"
        - "https://www.51job.com/"
      filters:
        job_title_keywords:
          - "AI开发"
          - "大模型"
        salary_range: [20000, 100000]
        industries: ["IT", "金融", "医疗"]
    schedule: "weekly"
EOL

# 初始化 Git 仓库
cd $PROJECT_NAME
git init
git add .
git commit -m "Initial commit, version $VERSION"
git tag "$VERSION"

echo "Project initialized and Git repository set up at version $VERSION."
