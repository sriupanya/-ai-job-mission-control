# AI Job Mission Control — Multi-user implementation and friend setup

## What this version does

The shareable version keeps each signed-in user's private career data separate while reusing a shared catalog of public job postings.

Implemented now:

- Passwordless Supabase Auth sign-in.
- Per-user profile and job-search preferences.
- Private PDF/TXT master-resume upload.
- AI resume fact extraction with an explicit confirmation gate before tailoring.
- Private jobs, application state, contacts, outreach history, projects, resume versions, fit reviews and generation runs.
- Shared public-job catalog that users can import into their own tracker.
- Resume-grounded fit assessment with unsupported-gap reporting.
- Skill-gap project suggestions that remain `Planned` and `resume_eligible=false` until deliberately completed/verified.
- Tailored one-page LaTeX/PDF resume generation using the user's confirmed source resume as candidate evidence.
- LinkedIn connection-note drafting under 300 characters, with manual send/copy workflow.
- In-app Alerts & Discover feed driven by target-title preferences.
- Private Storage bucket for source resumes, with user-folder RLS.
- RLS owner policies on previously unprotected/policyless user tables.

Not yet fully automated:

- Continuous ingestion from external job boards.
- Scheduled email delivery of new-job alerts.
- Automated LinkedIn profile scraping, login or message sending. The product intentionally drafts/tracks outreach but leaves sending to the user.

## Architecture

### Public/shareable UI

`share.html` is a generic frontend. It contains no candidate-specific resume facts. It uses the public Supabase publishable key and relies on authenticated JWTs + RLS for data access.

Public Edge Function:

- `mission-control-share` — serves `share.html` only. It does not read user data.

Authenticated Edge Function:

- `mission-control-user-api` — `verify_jwt=true`; derives the signed-in user from the request token and scopes every private read/write to that user.

### Database additions

- `user_profiles`
- `user_job_preferences`
- `user_resume_sources`
- `user_alert_preferences`
- `job_catalog` — public job-posting metadata readable only by authenticated users; no application status or personal notes.

### Storage

Bucket: `resume-source-files`

Files are stored under:

`<auth.uid()>/<timestamp>-<filename>`

Storage RLS permits authenticated users to read/write/delete only objects inside their own top-level folder.

### Existing private tables

The existing tracker tables continue to be user-owned. Owner policies use `auth.uid() = user_id`. RLS is now also enabled for `application_updates` and `resume_generation_run_payload_archive`, and owner policies were added for the previously policyless resume/project tables used by the multi-user path.

## One-time setup before sharing with a friend

1. Open Supabase Dashboard for the `ai-job-mission-control` project.
2. Go to **Authentication → URL Configuration**.
3. Add the friend-facing URL to **Redirect URLs**:

   `https://mqzibilzogyuxorjdkwq.supabase.co/functions/v1/mission-control-share`

4. Confirm the existing email provider/magic-link configuration is enabled.
5. Confirm `ANTHROPIC_API_KEY` exists in Edge Function secrets. AI usage for all users is billed to the project owner's API key unless billing is redesigned.
6. Open the share URL in a private/incognito browser and perform the smoke test below.

## Friend onboarding — exact user flow

1. Open the share URL.
2. Enter an email address and request a sign-in link.
3. Open the email link and return to Mission Control.
4. Enter name, current headline, location, LinkedIn URL, target roles, target locations, minimum fit score and sponsorship requirement.
5. Upload the master resume as PDF or TXT. PDF is recommended.
6. Mission Control extracts structured facts from the resume.
7. Review the extracted facts. If anything is wrong, replace the resume. Do not confirm inaccurate data.
8. Click **These facts look correct**. Resume generation remains locked until this confirmation.
9. Use **Alerts & Discover** to import relevant roles from the shared catalog, or use **+ Add job** and paste a full JD.
10. On a job card, click **Assess fit**. The model compares the confirmed resume to the JD and records direct matches, transferable evidence, unsupported gaps and optional learning-project ideas.
11. Click **Tailor resume** to create the role-specific PDF. The generator is instructed to use only source-resume facts and to produce one page.
12. Use **Networking** to add a target contact and generate a short LinkedIn connection note. Copy/send it manually in LinkedIn, then mark the outreach status.
13. Use **Projects** to review skill-gap project ideas. They are suggestions only and are not resume evidence until completed and verified.
14. Update application status from the job card as the process advances.

## Smoke test before giving out the link

Use an incognito browser with a test email that is not the original account.

1. Sign in successfully.
2. Confirm the dashboard starts empty/private rather than showing another user's jobs.
3. Save a test profile and preferences.
4. Upload a one-page PDF resume and confirm the extracted name belongs to the test user.
5. Import one catalog job.
6. Run Fit Assessment and verify no claim appears that is absent from the test resume.
7. Generate a tailored resume and open the resulting PDF.
8. Add a networking contact and generate a connection note.
9. Sign out, sign back in as the original account and verify the test user's job/contact does not appear.
10. Delete the test data when finished if desired.

## How the truth/approval guardrail works

The uploaded resume is candidate evidence. The job description is never candidate evidence. Resume parsing first creates a structured profile marked `Parsed — confirm facts`. The user must confirm it before tailored-resume generation is allowed. Fit reviews may suggest projects, but those are created as planned learning items and are not automatically added to a resume.

## How to make alerts fully automatic

The current `Alerts & Discover` feed works from `job_catalog`, including roles already accumulated in Mission Control and new roles explicitly added through the multi-user API. To make it a true hands-off alert service:

1. Choose a compliant job-source provider or search API.
2. Create a scheduled Supabase Edge Function that fetches new postings and normalizes them into `job_catalog`.
3. Deduplicate by canonical application URL + company + title.
4. Re-verify links and close/expire dead postings.
5. Match new catalog rows to each user's `user_job_preferences`.
6. Add a notification table with `user_id`, `job_catalog_id`, match score, reason and seen/sent timestamps.
7. Add an email provider (for example, a transactional email integration) and send daily/weekly digests only to users who opted in.
8. Add per-user throttles and a global cost/rate limit.
9. Keep all external-job content separate from candidate evidence used for resume generation.

## LinkedIn implementation boundary

Mission Control stores contact names/roles/URLs supplied by the user, generates a short connection note from the user's own resume, opens the supplied LinkedIn URL, and tracks outreach status. It does not automate LinkedIn login, scraping or message sending. This avoids making the app dependent on brittle or unauthorized browser automation.

## Recommended production hardening

1. Add rate limits around AI-heavy actions (`parse_resume`, `job_assess`, `resume_generate`, `linkedin_note`).
2. Add a monthly per-user AI budget or usage table.
3. Add CAPTCHA/abuse protection to sign-in if the link becomes broadly public.
4. Add retention controls and a **Delete my data** action.
5. Add a signed-in-only support/admin view rather than using direct database access for routine support.
6. Migrate the original single-user legacy Edge Functions to the JWT-scoped API, then retire the hard-coded legacy endpoints after the original dashboard has been verified on the new path.
7. Add automated end-to-end tests with two test users to catch cross-user data leakage.
8. Add monitoring for failed resume compilation and stale AI runs.

## Files / deployed components

- GitHub: `share.html`
- GitHub: `MULTI_USER_IMPLEMENTATION.md`
- Supabase Edge Function: `mission-control-share`
- Supabase Edge Function: `mission-control-user-api`
- Migration: `multi_user_onboarding_and_rls`
- Migration: `shared_job_catalog`
- Storage bucket: `resume-source-files`

## Rollback

The original `index.html` and original Mission Control endpoints were not replaced by this work. If the friend-facing version needs to be withdrawn, stop sharing/disable `mission-control-share`; the original tracker remains separate. Do not delete the new tables until any friend data has been exported or deliberately removed.
