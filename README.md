
# AI Smart Task Optimizer — API

The Rails API for [AI Smart Task Optimizer](#) — an AI-powered to-do app that breaks a plainly-written task into an ordered checklist of sub-steps with time estimates.

Frontend repo: [https://github.com/KipletingEdwin/AI-Smart-Task-Optimizer]

## How it works

1. The client sends a task title to this API.
2. Rails calls the Groq API (Llama / GPT-OSS models) with a structured system prompt.
3. The AI returns a JSON array of sub-tasks, each with a description and an estimated duration.
4. The API validates the AI's response shape, then persists the task and sub-tasks, scoped to the authenticated user.
5. The client receives the full task + sub-tasks back as JSON.

## Tech stack

- Ruby on Rails (API-only mode)
- SQLite (development)
- JWT authentication (hand-rolled — no Devise)
- bcrypt for password hashing
- Groq API — free tier, fast inference on Llama / GPT-OSS models

## Features

- **AI task breakdown** — one-line task in, ordered sub-tasks with time estimates out
- **JWT authentication** — signup/login, every task and sub-task scoped to its owner
- **Full CRUD on tasks** — create, view, update, delete
- **Sub-task completion tracking** — toggle completed state per step
- **Defensive AI-response handling** — validates the AI's JSON shape before writing to the database; malformed or incomplete responses fail loudly instead of corrupting data
- **Clean service-object architecture** — AI prompt-building, the Groq client, and orchestration logic are each isolated and independently testable

## Project structure

```
app/
├── controllers/api/v1/      # Tasks, Subtasks, Auth controllers
├── models/                  # User, Task, Subtask
└── services/ai/             # GroqClient, TaskBreakdownPrompt, TaskBreakdownService

lib/
└── json_web_token.rb        # JWT encode/decode helper
```

## Why this architecture

- **AI logic lives in `services/ai/`, not the controller.** The Groq client (how to talk to the API) is separate from the breakdown service (what to ask for, and what to do with the answer). This makes it straightforward to swap providers or models without touching the rest of the app.
- **JWT is hand-rolled rather than using Devise.** Implementing the encode/decode/authenticate flow directly demonstrates understanding of *how* token auth works, not just that it works.
- **Every query is scoped through `current_user`.** Tasks are fetched via `current_user.tasks`, never `Task.find(id)` directly, so one user can never access another's data even by guessing an ID.
- **The AI's output is never trusted blindly.** The response is parsed, shape-validated, and only then converted into database records — if the AI returns something malformed, the request fails cleanly with a clear error instead of silently saving bad data.

## Getting started

### Prerequisites
- Ruby (see `.ruby-version`)
- A free [Groq API key](https://console.groq.com)

### Setup

```bash
bundle install
rails db:create db:migrate
EDITOR="nano" rails credentials:edit
```

Add your Groq key inside the editor:
```yaml
groq:
  api_key: your_groq_api_key_here
```

Start the server:
```bash
rails s
```

API runs at `http://localhost:3000`.

## API reference

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/v1/auth/signup` | Create an account |
| POST | `/api/v1/auth/login` | Log in, receive a JWT |
| GET | `/api/v1/tasks` | List the current user's tasks |
| GET | `/api/v1/tasks/:id` | Get a single task |
| POST | `/api/v1/tasks/create_from_ai` | Create a task from a title via AI breakdown |
| PATCH | `/api/v1/tasks/:id` | Update a task |
| DELETE | `/api/v1/tasks/:id` | Delete a task |
| PATCH | `/api/v1/subtasks/:id/toggle` | Toggle a sub-task's completed state |

All routes except signup/login require an `Authorization: Bearer <token>` header.

## Roadmap

- [ ] Deployment (Render/Fly.io)
- [ ] Actual vs. estimated time tracking

## License

MIT