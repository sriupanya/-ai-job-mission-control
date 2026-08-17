# AI Job Mission Control — Friend Quick Start

## Recommended option: build your own independent copy

The earlier hosted proof-of-concept was not reliable enough to share. The safe path is now the `friend-starter` package in this repository.

Open:

**https://github.com/sriupanya/-ai-job-mission-control/tree/main/friend-starter**

Then:

1. Download or clone the repository.
2. Open it in Claude Code, Codex, Cursor, or another coding agent.
3. Open `friend-starter/BUILD_PROMPT.md`.
4. Copy the entire prompt and give it to the coding agent.
5. Let the agent build and test the app locally first.
6. Use your own Supabase project and your own AI-provider key when prompted.
7. Upload your own resume during onboarding.
8. Do not deploy until the local smoke test and two-user privacy test pass.

## What your independent copy should include

- Private sign-in and per-user workspace
- Resume upload and resume-fact confirmation
- Job tracker and application status history
- Search preferences and alert rules
- Resume-grounded fit assessment
- Truthful tailored one-page resume generation
- Resume library
- Networking/contact tracker
- LinkedIn connection-note drafting
- Skill-gap project suggestions
- Shared/public job-catalog architecture that can later connect to a compliant external source

## Privacy

Your copy must not use Sri's Supabase project, user ID, database rows, storage, API keys, resume facts, job data, contacts, or application history.

## LinkedIn boundary

The app may draft messages and track outreach. It should not log into LinkedIn, scrape profiles at scale, or send messages automatically.

## Files to use

- `friend-starter/README.md`
- `friend-starter/BUILD_PROMPT.md`
- `friend-starter/SETUP_CHECKLIST.md`
- `friend-starter/.env.example`
- `friend-starter/supabase/schema.sql`

The coding agent should verify the actual running app in a browser before calling it complete.