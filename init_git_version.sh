#!/bin/bash

# 项目目录
PROJECT_NAME="KnowledgePlanet"
cd $PROJECT_NAME || { echo "Directory $PROJECT_NAME does not exist"; exit 1; }

# 初始化 Git 仓库
echo "Initializing Git repository..."
git init

# 添加文件到暂存区
echo "Adding files to Git..."
git add .

# 提交初始版本
echo "Committing initial version..."
git commit -m "Initial commit: Set up KnowledgePlanet project structure"

# 创建版本标签
VERSION="v0.0.1"
echo "Tagging version $VERSION..."
git tag -a $VERSION -m "Version $VERSION: Initial project setup"

# 生成 Release Note
RELEASE_NOTE="release_notes_$VERSION.md"
cat > $RELEASE_NOTE <<EOL
# Release Notes: $VERSION

## Summary
This is the initial release of the KnowledgePlanet project. The project provides a foundational structure for a knowledge graph tool that supports personal and organizational use cases.

## Features
1. **Knowledge Management**:
   - Add, edit, and query knowledge points.
   - Supports user annotations and tagging.

2. **GitHub Project Updates**:
   - Subscribe to GitHub project updates (commits, pull requests, issues).
   - Classify issue severity.

3. **AI Large Model Trends**:
   - Scrape and aggregate updates about domestic and international large AI models.

4. **Job Data Subscription**:
   - Gather and summarize job postings for large model application developers.

5. **Microservices Structure**:
   - Modular FastAPI services.
   - SQLite for lightweight database management.

## Technical Highlights
- Uses FastAPI for backend development.
- Includes a service layer for scraping and summarization.
- Provides Dockerfile for containerized deployment.
- Preconfigured test structure for extensibility.

## Installation
1. Clone the repository.
2. Install dependencies from `requirements.txt`.
3. Start the application with:
