# AI Job Mission Control — Friend Quick Start

## Easiest option: use the hosted app

Open:

**https://sriupanya.github.io/-ai-job-mission-control/**

You do **not** need to clone the repository or install anything for the hosted version.

### First-time setup

1. Open the hosted link in Chrome, Safari, Edge, or Firefox.
2. Enter your own email address and request a sign-in link.
3. Open the sign-in email in the same browser.
4. Fill in your name, current role/headline, location, target job titles, target locations, and work-authorization/sponsorship preference.
5. Upload your own resume as PDF or TXT.
6. Review the facts extracted from your resume and confirm them before generating any tailored resume.
7. Use **Alerts & Discover** to import a role, or use **+ Add Job** and paste a complete job description.
8. Use **Assess fit** before tailoring. The job description is treated as requirements only; it is never treated as proof that you have those skills.
9. Use **Tailor resume** to create a role-specific PDF.
10. Use **Networking** to create a short LinkedIn connection note, then send it yourself in LinkedIn.
11. Track the application status in Mission Control.

## Privacy

Each signed-in user has a separate workspace. Jobs, resume sources, tailored resumes, contacts, application history, projects, and preferences are scoped to the authenticated user.

## What the hosted version does today

- Private resume-first onboarding
- Job tracker and application statuses
- Shared in-app job discovery catalog
- Resume-grounded fit assessment
- Tailored one-page resume generation
- Resume library
- Networking/contact tracker
- LinkedIn connection-note drafting
- Skill-gap project suggestions
- Search and alert preferences

## What is not automatic yet

- It does not log into LinkedIn or send LinkedIn messages automatically.
- It does not continuously scrape external job boards.
- Scheduled email job digests are a future phase; the current discovery feed is in-app.

## If the hosted link ever fails

The legacy Supabase share URL redirects to the GitHub Pages app. For a completely independent installation, use [`BUILD_YOUR_OWN_MISSION_CONTROL_PROMPT.md`](./BUILD_YOUR_OWN_MISSION_CONTROL_PROMPT.md). It is designed for Claude Code, Codex, Cursor, or a similar coding agent on a laptop and tells the agent to create an independent Supabase deployment rather than modifying another user's workspace.
