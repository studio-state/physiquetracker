# Physique Tracker — Cloud Edition

## One-time setup

1. Create a free Supabase project.
2. Open Supabase → SQL Editor.
3. Paste and run `supabase_schema.sql`.
4. In Supabase → Project Settings → API, copy:
   - Project URL
   - Publishable key (or legacy anon key)
5. Put those values into `supabase-config.js`.
6. Upload the files to your GitHub Pages repository:
   - index.html
   - manifest.webmanifest
   - sw.js
   - supabase-config.js
   - .nojekyll
7. Open the published app and use **Edit Workouts → Cloud Sync → Sign In / Create Account**.

## What is cloud-synced

- Workout program
- Exercises, sets, and rep ranges
- Completed workout sessions
- Every logged set
- Body weight

The app still keeps a local copy for fast/offline use.

## Security

Only the browser-safe Supabase publishable/anon key belongs in `supabase-config.js`.
Never put a Supabase service-role key in the frontend.

Row Level Security in `supabase_schema.sql` restricts each user's records to that user.

Supabase's free plan currently includes a Postgres database, authentication, 500 MB database size, and up to 50,000 monthly active users, although free projects can pause after inactivity.
