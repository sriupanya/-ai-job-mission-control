# Setup checklist

This is the human checklist. The coding agent should do the technical work.

## Before you start

- Create your own GitHub account if you do not have one.
- Create your own Supabase account/project.
- Install Claude Code, Codex, Cursor, or another coding agent.
- Have Node.js 20+ available. If you do not, ask the coding agent to install/check it.
- Decide which AI provider you want to use for resume parsing, fit assessment, resume tailoring and networking-note generation.

## Build

1. Download or clone this repository.
2. Open it in your coding agent.
3. Open `friend-starter/BUILD_PROMPT.md`.
4. Paste the full prompt into the agent.
5. When the agent asks for a Supabase project, give it **your own** project details only.
6. When the agent asks for an AI key, use **your own** key. Never paste secrets into source files or GitHub.
7. Let the agent apply the starter schema/RLS and create the app.
8. Run locally first.
9. Use a fresh test email and upload your own resume.
10. Complete the smoke test before deployment.

## Before deployment

Confirm the app visibly shows a useful error/setup page instead of a blank screen when configuration is missing.

Confirm a second user cannot see the first user's jobs, resumes, contacts, projects or application history.

Confirm resume tailoring uses only confirmed resume facts and does not invent JD requirements as experience.

Confirm real secrets are not committed to GitHub.

## Deployment

After the local test passes, ask the coding agent to deploy to a normal web host such as Vercel, Netlify or Cloudflare Pages. The agent must open the final live URL and visually verify it before calling deployment complete.

## LinkedIn boundary

The app may draft connection notes and track outreach. It should not log into LinkedIn, scrape profiles at scale or send messages automatically.