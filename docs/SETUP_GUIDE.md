# 🚀 SmileShift — Zero-Cost Setup Guide

Get SmileShift running in under 10 minutes. **Total cost: $0.**

---

## What You Need (All Free)

| Service | Free Tier | What It Does | Signup |
|---------|-----------|--------------|--------|
| **Supabase** | 500MB DB, 1GB storage, 50K MAU | Database, auth, real-time, storage | [supabase.com](https://supabase.com) |
| **Vercel** | 100GB bandwidth, serverless functions | Hosting, CDN, preview deploys | [vercel.com](https://vercel.com) |
| **Stripe** | Test mode is 100% free | Payment processing (when needed) | [stripe.com](https://stripe.com) |
| **GitHub** | Unlimited public repos | Source control, CI/CD | [github.com](https://github.com) |

**NOT needed (we use free alternatives):**
- ~~OpenAI API~~ → Pure PostgreSQL matching engine
- ~~Google Maps / Mapbox~~ → Leaflet + OpenStreetMap (no API key)
- ~~Sentry~~ → Vercel's built-in analytics & error logs
- ~~Redis~~ → Not needed until 10K+ users

---

## Step 1: Set Up Supabase (5 minutes)

1. Go to [supabase.com](https://supabase.com) and sign in with GitHub
2. Click **"New project"**
3. Fill in:
   - **Name**: `smileshift`
   - **Database Password**: (save this somewhere safe!)
   - **Region**: Choose closest to your target users
4. Wait ~2 minutes for project to provision
5. Go to **Settings → API** and copy:
   - `Project URL` → This is your `PUBLIC_SUPABASE_URL`
   - `anon public` key → This is your `PUBLIC_SUPABASE_ANON_KEY`
   - `service_role` key → This is your `SUPABASE_SERVICE_ROLE_KEY`

### Run the Database Migration

6. Go to **SQL Editor** in Supabase dashboard
7. Copy the contents of `supabase/migrations/00001_initial_schema.sql`
8. Paste and click **Run** — this creates all tables, indexes, and security policies

> **Tip**: Or install the [Supabase CLI](https://supabase.com/docs/guides/cli) and run:
> ```bash
> npx supabase link --project-ref YOUR_PROJECT_REF
> npx supabase db push
> ```

---

## Step 2: Set Up Stripe (3 minutes, optional for MVP)

> **Note**: Stripe is only needed when you want to process real payments.
> You can skip this entirely for initial development and design work.

1. Go to [stripe.com](https://stripe.com) and create an account
2. Stay in **Test Mode** (toggle in top-right — no real money involved)
3. Go to **Developers → API keys** and copy:
   - `Publishable key` → `PUBLIC_STRIPE_PUBLISHABLE_KEY`
   - `Secret key` → `STRIPE_SECRET_KEY`
4. For webhooks (later): **Developers → Webhooks → Add endpoint**

---

## Step 3: Configure Environment

```bash
# In the project root
cp .env.example .env.local
```

Edit `.env.local` with your keys from Steps 1 & 2:

```env
# Required
PUBLIC_SUPABASE_URL=https://abcdefgh.supabase.co
PUBLIC_SUPABASE_ANON_KEY=eyJhbGci...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...

# Required for payments (skip with placeholder for now)
PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Auto-set
PUBLIC_APP_URL=http://localhost:5173
PUBLIC_APP_NAME=SmileShift
```

---

## Step 4: Install & Run

```bash
npm install
npm run dev
```

Open [http://localhost:5173](http://localhost:5173) — you're running! 🎉

---

## Step 5: Deploy to Vercel (2 minutes)

### Option A: Via Vercel Dashboard (easiest)
1. Go to [vercel.com](https://vercel.com) and sign in with GitHub
2. Click **"Add New" → "Project"**
3. Import the `Smile-Shift` repository
4. Vercel auto-detects SvelteKit — just click **Deploy**
5. Add environment variables in **Settings → Environment Variables**

### Option B: Via CLI
```bash
npx vercel
# Follow the prompts — it auto-detects SvelteKit
```

### Set Up GitHub Actions Deployment
Add these secrets in **GitHub → Settings → Secrets and variables → Actions**:
- `VERCEL_TOKEN` — Get from [vercel.com/account/tokens](https://vercel.com/account/tokens)
- `VERCEL_ORG_ID` — Found in `.vercel/project.json` after first deploy
- `VERCEL_PROJECT_ID` — Found in `.vercel/project.json` after first deploy
- `PUBLIC_SUPABASE_URL` — Your Supabase URL
- `PUBLIC_SUPABASE_ANON_KEY` — Your Supabase anon key

Now every push to `main` auto-deploys, and every PR gets a preview URL! 🚀

---

## What's Free vs. What Costs Money

### 100% Free Forever
- ✅ SvelteKit framework
- ✅ Leaflet + OpenStreetMap (maps)
- ✅ PostgreSQL matching engine (all "smart" features)
- ✅ PostGIS geo-proximity search
- ✅ GitHub Actions CI/CD (2,000 min/month free)
- ✅ Supabase Auth (magic links, OTP)
- ✅ Supabase Realtime (WebSockets)
- ✅ Supabase Storage (1GB for avatars, license docs)
- ✅ Vercel hosting (100GB bandwidth)
- ✅ Web Push notifications (browser native)
- ✅ Vercel Analytics

### Free Until You Scale
- ⚡ Supabase (free up to 500MB DB, 50K users → then $25/mo)
- ⚡ Vercel (free up to 100GB → then $20/mo)
- ⚡ Stripe (free test mode → 2.9% + $0.30 per real transaction)

### Optional Paid Add-ons (NOT required)
- 💎 Sentry error tracking ($0 for 5K errors/mo)
- 💎 Upstash Redis ($0 for 10K commands/day)
- 💎 Custom domain (~$12/year)

---

## Quick Reference: Where Each Feature Comes From

| Feature | Powered By | API Key Needed? |
|---------|-----------|-----------------|
| User authentication | Supabase Auth | No (included) |
| Database | Supabase PostgreSQL | No (included) |
| Real-time updates | Supabase Realtime | No (included) |
| File storage | Supabase Storage | No (included) |
| Smart matching | PostgreSQL functions | **No** |
| Map display | Leaflet + OpenStreetMap | **No** |
| Geolocation search | PostGIS | **No** |
| Address autocomplete | Nominatim (free) | **No** |
| Payment processing | Stripe | Yes (free to create) |
| Hosting | Vercel | No (free tier) |
| CI/CD | GitHub Actions | No (free tier) |
| Push notifications | Web Push API | **No** |
