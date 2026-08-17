# AI Job Mission Control — Friend Starter

This folder is the recommended way to share Mission Control with a friend.

It does not connect to Sri's Supabase project, jobs, resumes, contacts, or AI keys. Each person should create an independent copy using her own accounts.

## Fastest path

1. Install one coding agent: Claude Code, Codex, Cursor, or VS Code with an AI coding agent.
2. Download or clone this repository.
3. Open the repository folder in the coding agent.
4. Open `friend-starter/BUILD_PROMPT.md`.
5. Copy the entire prompt and give it to the coding agent.
6. Follow the agent's instructions when it asks you to create/connect your own Supabase project and AI-provider key.
7. Upload your own resume during onboarding.

The coding agent should do the implementation work, database setup, local run, testing, and deployment for you.

## Your copy should include

- Private sign-in and per-user workspace
- Resume upload and resume-fact confirmation
- Job tracker and application status history
- Job preferences and alert rules
- Resume-grounded fit assessment
- Tailored one-page resume generation
- Resume library
- Networking / LinkedIn connection-note drafting
- Contact/outreach tracking
- Skill-gap project suggestions
- A job-discovery catalog that can later be connected to a compliant external job source

## Important privacy rule

Never use Sri's Supabase URL, publishable key, service-role key, Anthropic key, user ID, or existing database as your backend. Your copy must create/use your own Supabase project.

## Files in this folder

- `BUILD_PROMPT.md` — one prompt to give the coding agent
- `SETUP_CHECKLIST.md` — simple human checklist
- `.env.example` — generic environment-variable names only
- `supabase/schema.sql` — clean multi-user starter schema with RLS

If you only want to try the idea locally, tell the coding agent: "Run this locally first. Do not deploy until the full smoke test passes."