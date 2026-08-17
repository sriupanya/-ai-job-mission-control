# Copy/Paste Prompt — Build Your Own AI Job Mission Control

Paste the prompt below into Claude Code, Codex, Cursor, or another coding agent on your laptop.

---

You are setting up an **independent personal AI Job Mission Control** based on this public reference repository:

https://github.com/sriupanya/-ai-job-mission-control

Your job is to create a clean, secure installation for **me**, not to reuse or modify another person's private backend/data.

## Goal

Create a browser-based job-search workspace where I can:

- sign in securely
- upload my own PDF/TXT resume
- extract and review verified resume facts
- store my job-search preferences
- discover/import jobs into my own tracker
- paste full job descriptions
- assess fit using my resume as the only candidate evidence
- separate Direct / Transferable / Unsupported requirements
- generate tailored one-page ATS-friendly resumes
- store resume versions and downloadable PDFs
- track application stages
- maintain a networking/contact list
- draft short LinkedIn connection notes without sending them automatically
- suggest learning projects for skill gaps without pretending planned work is completed experience
- store alert preferences and provide an in-app job discovery feed

## Non-negotiable truth rules

1. A job description is never evidence of candidate experience.
2. Never invent skills, tools, years, metrics, responsibilities, leadership scope, certifications, projects, or outcomes.
3. Resume generation must use only facts extracted from and confirmed against my source resume plus later facts I explicitly approve.
4. Planned learning projects must be clearly labeled planned/in progress and must not become resume evidence until I confirm completion.
5. Preserve numerical metrics exactly unless I explicitly correct them.
6. Keep resume outputs ATS-readable and target one page without shrinking fonts/margins to absurd sizes.
7. Do not automate LinkedIn login, scraping, or message sending. Drafting + copy-to-clipboard + tracking is enough.

## Architecture requirements

Use a new Supabase project owned by me.

Use:
- Supabase Auth for sign-in
- PostgreSQL for data
- Supabase Storage for source resumes and generated resume artifacts
- Row Level Security on every user-owned table
- `auth.uid() = user_id` owner policies for both reads and writes
- Edge Functions or a secure server layer for model/API calls
- a private server-side AI API key; never expose it in browser JavaScript

Do not use a hard-coded user ID anywhere.
Do not accept `user_id` from the browser as proof of identity. Derive the user from the validated JWT/session.
Do not expose a service-role key in frontend code.

## Suggested user-owned data model

At minimum create:

- `user_profiles`
- `user_job_preferences`
- `user_resume_sources`
- `jobs`
- `resume_fit_reviews`
- `resume_generation_runs`
- `resume_versions`
- `contacts`
- `outreach_history`
- `personal_projects`
- `application_updates`
- `user_alert_preferences`

Optionally create a shared/public `job_catalog` that contains only public job-posting information; never put private candidate facts in that shared table.

## Resume workflow

Implement this exact sequence:

1. Upload source resume.
2. Extract structured facts.
3. Show them to the user.
4. Require explicit confirmation before tailoring is enabled.
5. Add/import a target job with full JD.
6. Run fit assessment.
7. Generate proposed resume changes only from verified evidence.
8. Generate complete LaTeX or another deterministic one-page document format.
9. Compile/export PDF.
10. Verify that PDF exists and preferably that page count = 1.
11. Store the resume as a version tied to the job.

If generation gets stuck, mark the run failed after a sensible timeout so the UI never spins forever.

## Fit assessment output

Return:

- candidate fit score
- current-resume fit score
- strongest matches
- Direct matches
- Transferable matches
- Unsupported gaps
- recommended resume changes
- optional learning-project suggestions

Never convert Unsupported gaps into resume claims.

## Friend-friendly UX

Make first use simple:

1. Sign in
2. Set target roles/locations/work-authorization preferences
3. Upload resume
4. Confirm extracted facts
5. See dashboard

Tabs:
- Jobs
- Discover / Alerts
- Networking
- Resumes
- Projects
- Settings

Use clear loading states and explicit errors. No permanent spinners.

## Alerts

For the initial version, an authenticated in-app discovery feed is enough.
Store target titles, target locations, work-authorization/sponsorship needs, minimum fit score, and alert cadence.

If adding scheduled external alerts:
- use a compliant/licensed job data source
- deduplicate jobs
- expire dead postings
- store notifications per user
- add AI/token quotas before batch scoring
- use a transactional email provider for opt-in digests

Do not build brittle mass scraping as the default solution.

## Required security tests

Create two test users A and B and verify:

- A cannot read B's jobs
- A cannot read B's resume
- A cannot read B's generated resumes
- A cannot read/write B's contacts
- A cannot read/write B's projects
- A cannot read/write B's application updates
- storage paths are isolated
- model functions derive identity from the JWT

Do not call the implementation complete until those tests pass.

## Deployment

Prefer a normal public HTTPS URL on Vercel, Netlify, Cloudflare Pages, GitHub Pages (for static frontend only), or a correctly served Supabase/Vercel application.

The page must render as HTML in a normal browser. Verify the production response has `Content-Type: text/html` and visually test it before giving me the link.

Configure the deployed URL in Supabase Authentication → URL Configuration → Redirect URLs so magic-link/OAuth callbacks return to the app.

## Cost safety

Add basic usage limits for AI operations. Show me where to configure:
- AI model key
- model name
- maximum generations per day/month
- expected external service costs

## Final deliverables

When done, give me:

1. the production URL
2. the GitHub repository URL
3. exact one-time setup instructions
4. `.env.example`
5. database migrations
6. RLS policies
7. deployment instructions
8. a smoke-test checklist
9. a brief architecture diagram/readme
10. confirmation that two-user isolation tests passed

Do not overwrite or depend on the original repository owner's private Supabase project. Fork/copy the code and create my own backend resources.

---
