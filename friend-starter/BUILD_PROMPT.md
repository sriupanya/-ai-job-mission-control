# One-shot build prompt

Copy everything below into Claude Code, Codex, Cursor, or another coding agent after opening this repository locally.

---

You are building **my own independent AI Job Mission Control** from this repository. Treat `friend-starter/` as the product specification and starter package.

## Non-negotiable isolation

Do not connect to or reuse Sri's Supabase project, user ID, database rows, storage buckets, Anthropic/OpenAI keys, resume facts, job tracker, contacts, or application history. Create/configure a completely independent backend for me.

Do not hardcode another person's project URL or credentials anywhere in source code.

## Goal

Build a polished local-first web app that I can later deploy. It should let me upload my own resume once, confirm extracted facts, define target roles/locations/work-authorization constraints, discover and track jobs, assess fit, generate truthful tailored resumes, manage networking contacts and LinkedIn notes, track applications, and maintain a private resume/project library.

## Preferred stack

Use a simple maintainable stack:

- Next.js or Vite + React + TypeScript
- Supabase Auth, Postgres, Storage and Row Level Security
- Server-side/Edge Function calls for AI and resume generation
- Anthropic if I provide `ANTHROPIC_API_KEY`; otherwise ask me which supported AI provider to configure
- Do not expose AI keys or service-role keys in browser code

If this repository contains legacy single-user code, use it only as product inspiration. Do not copy hardcoded user IDs, credentials, URLs, personal facts or assumptions.

## Required product flow

1. Sign in with email/passwordless magic link.
2. New users see an empty private workspace.
3. Onboarding asks for name, current role/headline, location, LinkedIn URL, target job titles, target locations, sponsorship/work-authorization requirement, minimum fit score and alert cadence.
4. Upload PDF/TXT resume to a private per-user storage path.
5. Parse resume into structured facts: summary, experience, education, skills, projects, certifications, dates and metrics.
6. Show those facts for review. Tailored resume generation must stay locked until the user explicitly confirms them.
7. Add jobs manually by URL/JD or import from a shared public job catalog.
8. Fit assessment must use the confirmed resume as candidate evidence. The JD is requirements only and must never become fake experience.
9. Fit output should separate direct matches, transferable matches, unsupported gaps, risk flags and realistic gap-closing project ideas.
10. Generate a one-page ATS-friendly tailored resume from confirmed facts only. Preserve factual metrics exactly. Never invent skills, outcomes, tools, leadership scope, years, projects or certifications.
11. Store generated resume versions privately and make PDFs easy to open/download.
12. Networking tab: add contact name/company/title/LinkedIn URL, draft a concise human connection note under 300 characters grounded in the user's real background, copy it, and track outreach status. Do not automate LinkedIn login or sending.
13. Projects tab: suggested projects begin as `Planned` and `resume_eligible=false`. A project must not become resume evidence merely because it was suggested.
14. Jobs tab: statuses should include Review, Saved, Applied, Recruiter Screen, Hiring Manager, Interview, Final Interview, Offer, Pass and Closed. Preserve filters when status changes. Hide Closed/Pass by default but keep them available in history.
15. Alerts & Discover tab: store alert preferences and support a shared catalog. Make the external ingestion layer pluggable so a compliant job source can be added later without rewriting the tracker.

## Data/security requirements

Use `friend-starter/supabase/schema.sql` as the baseline and improve it if necessary.

Every user-owned table must have RLS enabled. Policies must scope rows to `auth.uid() = user_id` for read/write. Source resumes and generated resumes must use private storage paths under the signed-in user's ID. Shared public job catalog data must not contain private candidate data.

Never put a Supabase service-role key, AI-provider key, or other secret in frontend JavaScript or committed `.env` files.

## Resume-generation guardrails

- Source resume/profile is the only evidence of candidate experience.
- JD vocabulary can be used only where it accurately describes existing verified work.
- Unsupported major requirements should be called out, not manufactured.
- Keep final resume to one page unless the user explicitly changes that setting.
- Prefer concise accomplishment bullets with scope/action/result where supported.
- Do not silently add a suggested project to a resume.
- Do not backfill accomplishments from a skills list.

## Implementation tasks

Do the work rather than only explaining it:

1. Inspect this repository and the `friend-starter` files.
2. Create the frontend application and clean folder structure.
3. Create `.env.example`; never create a committed real `.env` containing secrets.
4. Ask me only for genuinely required external account details/keys that you cannot create yourself.
5. Create/apply the Supabase schema and RLS policies against **my** project.
6. Implement auth, onboarding, resume upload, resume confirmation, jobs, fit review, resume generation, contacts, projects, settings and alert preferences.
7. Add loading/error/empty states so the app never shows a blank screen.
8. Add an always-visible startup diagnostic if backend configuration is missing. It should say exactly which environment variable or setup step is missing.
9. Run lint/typecheck/tests.
10. Start the app locally and use a browser test to verify the first-use flow visually.
11. Create a two-user isolation test proving User A cannot access User B private records.
12. Do not deploy until the local smoke test passes.
13. When ready, ask me whether I want Vercel, Netlify, Cloudflare Pages or another host, then deploy and verify the actual live page rather than assuming a successful build means the site works.

## Acceptance test

Before calling the app ready, verify all of these with the running app:

- Landing/sign-in page visibly renders with JavaScript disabled or with the backend unavailable; no blank page.
- New account has zero private data belonging to anyone else.
- Resume upload works.
- Resume facts can be reviewed and confirmed.
- Tailoring is blocked before confirmation.
- Manual job add works.
- Fit assessment returns a structured result.
- A tailored resume PDF opens successfully.
- Networking note generation works and stays under 300 characters.
- Status updates persist without destroying active filters.
- Closed jobs are hidden by default.
- Sign out/sign back in preserves the user's own data only.
- Second test account cannot read the first account's data.

At the end, give me:

- the local URL,
- what remains manual,
- any API costs I should expect,
- exact deployment steps,
- and a concise test report.

Start now by inspecting `friend-starter/README.md`, `friend-starter/SETUP_CHECKLIST.md`, `friend-starter/.env.example`, and `friend-starter/supabase/schema.sql`.

---