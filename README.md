<div align="center">

# 📝 todo-backend-project

**A todo API backend — FastAPI + SQLModel + Alembic migrations.**

The classic CRUD project, done properly: versioned database migrations from day one.

![FastAPI](https://img.shields.io/badge/API-FastAPI-009688?logo=fastapi&logoColor=white)
![SQLModel](https://img.shields.io/badge/ORM-SQLModel-red)
![Alembic](https://img.shields.io/badge/Migrations-Alembic-black)

</div>

---

## 📖 About

A backend for a todo application, focused on doing the boring parts right: SQLModel models and Alembic-managed schema migrations instead of ad-hoc table creation.

> 🚧 **Work in progress** — scaffolding and migration setup are in place; endpoints are being built out.

## 🚀 Setup

Requires [`uv`](https://docs.astral.sh/uv/).

```sh
git clone https://github.com/tanishqsrivastavaa/todo-backend-project.git
cd todo-backend-project
uv sync

# apply migrations
uv run alembic -c backend/alembic.ini upgrade head

# run the app
uv run main.py
```

## 📁 Project Structure

```
todo-backend-project/
├── main.py               # Entrypoint
└── backend/
    └── alembic/          # Migration environment & versions
```
