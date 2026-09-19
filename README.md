# Application Tracker — deploy guide

This folder is a complete, self-contained site: one `index.html` file, plus
the SQL and config Netlify needs. No build step, no server code — Netlify
just serves `index.html`, and the page talks straight to Supabase.

## 1. Create the database (Supabase)

1. Go to https://supabase.com, sign up free, and create a new project.
   Pick any name/region; save the database password it generates (you
   won't need it for this app, but keep it somewhere safe).
2. Once the project is ready, open **SQL Editor** in the left sidebar,
   click **New query**, paste in the contents of `supabase-schema.sql`
   from this folder, and click **Run**. This creates the `applications`
   table and the access policies the app needs.
3. Open **Project Settings → API**. You'll need two values from this page:
   - **Project URL** — looks like `https://xxxxxxxx.supabase.co`
   - **anon public** key — a long string under "Project API keys"

## 2. Connect the app to your database

1. Open `index.html` in a text editor.
2. Find this block near the top of the `<script>` section (search for `CONFIG`):
   ```js
   var SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
   var SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
   ```
3. Replace the two placeholder strings with the **Project URL** and
   **anon public** key from step 1.3, then save the file.

Until you do this, the app still works — it just quietly falls back to
storing data in that one browser only, and the status pill in the top
right will read "This device only" instead of "Synced".

## 3. Deploy to Netlify

**Fastest way (drag and drop):**
1. Go to https://app.netlify.com/drop
2. Drag this whole folder onto the page.
3. Netlify gives you a live `*.netlify.app` URL immediately.

**Recommended way (keeps updating automatically):**
1. Push this folder to a new GitHub repository.
2. In Netlify: **Add new site → Import an existing project → GitHub**,
   pick the repo.
3. Build settings: leave the build command empty and set the publish
   directory to `.` (this repo already includes `netlify.toml` with
   that configured for you).
4. Click **Deploy site**.

## 4. Connect your own domain

1. In your new Netlify site, go to **Domain management → Add a domain**.
2. Enter your domain (e.g. `tracker.yourdomain.com` or the root domain).
3. Netlify shows you either:
   - DNS records to add at your domain registrar (a `CNAME` for a
     subdomain, or an `A` record for a root/apex domain), or
   - The option to point your domain's nameservers at Netlify DNS
     (simplest if you don't need DNS for anything else).
4. Add whichever records it gives you at your registrar (GoDaddy,
   Namecheap, Cloudflare, wherever you bought the domain). DNS changes
   can take a few minutes to a few hours to propagate.
5. Netlify auto-provisions a free HTTPS certificate once the domain
   resolves — no extra steps needed.

## What stays fully functional after deploying

Everything from the app: adding applications, moving them through
Applied → Interviewed → Hired with the dynamic platform/role filtering,
the dashboard counts, the Manage entries modal (reset all / remove one
by one), and CSV export. The only thing that's genuinely different is
*where* the data lives — instead of Claude's built-in database, it's
now your own Supabase table, which is exactly what lets it work from
your own domain, shared live across every device and every visitor of
that link.

## A note on access

The policies in `supabase-schema.sql` make the `applications` table
fully readable and writable by anyone who has your site's URL — there's
no login. That's normal for a personal tracker like this one, but if
you ever want to restrict it (e.g. put it behind a password or Supabase
Auth login), that's a further step I can help with — just ask.
