# cicd-demo

[![CI](https://github.com/mobeen97-cloud/cicd-demo/actions/workflows/ci.yml/badge.svg)](https://github.com/mobeen97-cloud/cicd-demo/actions/workflows/ci.yml)
[![CD](https://github.com/mobeen97-cloud/cicd-demo/actions/workflows/cd.yml/badge.svg)](https://github.com/mobeen97-cloud/cicd-demo/actions/workflows/cd.yml)

A beginner CI/CD demo: a tiny Node.js + Express API, tested with Jest,
packaged with Docker, and built, tested and published automatically by GitHub Actions.

## The pipeline

```
git push ──► CI (ci.yml)                         ──► CD (cd.yml)
             test job:   npm ci → lint → test        only if CI passed on main:
             docker job: build image → /health       build → push to ghcr.io
                         (skipped if tests fail)     tags: latest + <commit-sha>
```

## API

| Endpoint | Example | Response |
|---|---|---|
| `GET /health` | `/health` | `{"status":"ok"}` |
| `GET /add` | `/add?a=2&b=3` | `{"result":5}` |
| `GET /add` (bad input) | `/add?a=x&b=3` | `400 {"error":"a and b must be numbers"}` |

## Run locally (no Docker)

```bash
npm install
npm run lint     # ESLint
npm test         # Jest + coverage
npm start        # http://localhost:3000
```

## Run with Docker (optional)

```bash
./deploy.ps1               # pull the image CD published, start it, smoke-test it
./deploy.ps1 -Tag <sha>    # deploy or roll back to an exact commit
```

## Everyday workflow

1. Change code, then run `npm run lint` and `npm test` locally.
2. `git commit` and `git push`.
3. Watch the **Actions** tab: CI must be green before CD publishes anything.

## Project layout

```
src/app.js                 Express routes (imported by tests)
src/server.js              starts the server
tests/app.test.js          Jest + supertest tests
.github/workflows/ci.yml   CI: lint, test, docker build + smoke test
.github/workflows/cd.yml   CD: publish image to ghcr.io after CI passes
Dockerfile                 image recipe
docker-compose.yml         laptop "deployment" of the published image
deploy.ps1                 deploy + smoke test script
```
