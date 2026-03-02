# 🏗️ SmileShift — System Architecture

## Architecture Overview

SmileShift uses a **serverless-first, edge-deployed architecture** optimized for speed, cost-efficiency, and global scalability.

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │
│  │  PWA     │  │  Mobile  │  │  Desktop │  │  Admin       │   │
│  │  (iOS)   │  │  (Android)│  │  Web    │  │  Dashboard   │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └──────┬───────┘   │
│       └──────────────┼──────────────┼───────────────┘          │
│                      │ SvelteKit SSR/CSR                        │
└──────────────────────┼─────────────────────────────────────────┘
                       │ HTTPS / WebSocket
┌──────────────────────┼─────────────────────────────────────────┐
│                  EDGE LAYER (Vercel)                            │
│  ┌───────────────────┼──────────────────────────────────┐      │
│  │     SvelteKit Server (Edge Runtime)                  │      │
│  │  ┌────────────┐  ┌──────────┐  ┌────────────────┐   │      │
│  │  │  API Routes│  │ SSR Pages│  │ Middleware      │   │      │
│  │  │  /api/*    │  │ +page    │  │ (Auth, Rate)    │   │      │
│  │  └─────┬──────┘  └────┬─────┘  └───────┬────────┘   │      │
│  └────────┼──────────────┼─────────────────┼────────────┘      │
│           └──────────────┼─────────────────┘                   │
└──────────────────────────┼─────────────────────────────────────┘
                           │
┌──────────────────────────┼─────────────────────────────────────┐
│                   SERVICE LAYER                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────────┐   │
│  │  Supabase   │  │  Stripe     │  │  Edge Functions      │   │
│  │  ┌────────┐ │  │  Connect    │  │  ┌────────────────┐  │   │
│  │  │Auth    │ │  │  (Payments) │  │  │ Matching Engine │  │   │
│  │  │Realtime│ │  │             │  │  │ Notifications   │  │   │
│  │  │Storage │ │  │             │  │  │ Credential Svc  │  │   │
│  │  │PostgREST│ │  │            │  │  │ Review Svc      │  │   │
│  │  └────────┘ │  │             │  │  └────────────────┘  │   │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬───────────┘   │
│         │                │                      │              │
└─────────┼────────────────┼──────────────────────┼──────────────┘
          │                │                      │
┌─────────┼────────────────┼──────────────────────┼──────────────┐
│         │          DATA LAYER                   │              │
│  ┌──────┴──────┐  ┌──────┴──────┐  ┌───────────┴──────────┐   │
│  │  PostgreSQL │  │  Supabase   │  │  Redis (Upstash)     │   │
│  │  (Supabase) │  │  Storage    │  │  - Session cache     │   │
│  │  - Users    │  │  - Avatars  │  │  - Geo queries       │   │
│  │  - Shifts   │  │  - Docs     │  │  - Rate limiting     │   │
│  │  - Reviews  │  │  - Licenses │  │  - Real-time state   │   │
│  │  - Payments │  │             │  │                      │   │
│  │  + PostGIS  │  │             │  │                      │   │
│  └─────────────┘  └─────────────┘  └──────────────────────┘   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## Technology Justification

### Frontend: SvelteKit + TypeScript

**Why SvelteKit over Next.js/Remix:**

1. **Bundle size**: Svelte compiles to vanilla JS — no runtime overhead. Critical for mobile-first where every KB matters
2. **Performance**: Fastest Speed Index and FCP among modern frameworks (benchmarks show 30-40% smaller bundles)
3. **Developer velocity**: Less boilerplate, reactive by default, faster iteration
4. **SSR + Edge**: First-class support for Vercel Edge Runtime
5. **PWA support**: Excellent service worker integration via `@vite-pwa/sveltekit`

**Trade-offs acknowledged:**
- Smaller ecosystem than React (mitigated by Svelte's web-standards approach)
- Fewer enterprise case studies (acceptable for our startup stage)

### Backend: Supabase (PostgreSQL + Auth + Realtime)

**Why Supabase over custom backend:**

1. **Cost**: Generous free tier (500MB DB, 1GB storage, 50K monthly active users)
2. **Speed to market**: Auth, real-time subscriptions, REST/GraphQL — all built-in
3. **PostgreSQL**: Full SQL power, PostGIS for geolocation, row-level security
4. **Realtime**: WebSocket subscriptions for instant shift updates
5. **Open source**: No vendor lock-in; can self-host if needed
6. **Edge Functions**: Deno-based serverless functions for custom logic

### Payments: Stripe Connect

**Why Stripe Connect:**

1. **Direct payments**: Office pays hygienist directly; we never touch the money
2. **Instant payouts**: Hygienists can get paid same-day
3. **Compliance**: Stripe handles tax forms (1099), KYC, and banking regulations
4. **Platform model**: `destination` charges with optional platform fee (starts at $0)

### Hosting: Vercel Edge Network

**Why Vercel:**

1. **Edge deployment**: Code runs in 30+ regions globally (< 50ms latency)
2. **Free tier**: Generous for startups (100GB bandwidth, serverless functions included)
3. **Preview deployments**: Every PR gets its own URL for testing
4. **SvelteKit adapter**: First-class support via `@sveltejs/adapter-vercel`
5. **Analytics**: Built-in Web Vitals monitoring

### Caching: Upstash Redis

**Why Upstash:**

1. **Serverless Redis**: Pay-per-request, no idle costs
2. **Edge-compatible**: Works in edge runtime (unlike traditional Redis)
3. **Use cases**: Geo-queries, session caching, rate limiting, real-time leaderboards

---

## Core System Components

### 1. Authentication System

```
┌────────────────────────────────────────────┐
│           Authentication Flow              │
│                                            │
│  Phone/Email  ──→  Supabase Auth           │
│       │                │                   │
│       │            ┌───┴───┐               │
│       │            │  JWT  │               │
│       │            └───┬───┘               │
│       │                │                   │
│  Magic Link  ──→  Session Cookie           │
│  (or OTP)          (httpOnly)              │
│       │                │                   │
│       └───→  Role-Based Access             │
│             ┌──────┬──────┐                │
│             │      │      │                │
│         Hygienist Office Admin             │
└────────────────────────────────────────────┘
```

**Strategy**: Magic link / OTP authentication (no passwords to remember). 
Users select role during onboarding. JWT tokens stored as httpOnly cookies.

### 2. Matching Engine

The core algorithm that connects shifts with hygienists:

```
┌──────────────────────────────────────────────┐
│          MATCHING ENGINE (v1)                 │
│                                              │
│  Input: Shift Requirements                   │
│  ┌─────────────────────────────────────┐     │
│  │ • Date/Time range                   │     │
│  │ • Location (lat/lng)                │     │
│  │ • Required qualifications           │     │
│  │ • Hourly rate range                 │     │
│  │ • Office preferences               │     │
│  └──────────────┬──────────────────────┘     │
│                 │                             │
│  Step 1: Filter (Hard Requirements)          │
│  ├─ Available on date/time?                  │
│  ├─ Within max commute distance?             │
│  ├─ Valid license for state?                 │
│  ├─ Required certifications?                 │
│  └─ Not on office's block list?              │
│                 │                             │
│  Step 2: Score (Soft Preferences)            │
│  ├─ Distance score (closer = higher)    40%  │
│  ├─ Reliability score (history)         25%  │
│  ├─ Review score (office reviews)       20%  │
│  ├─ Rate match (within budget)          10%  │
│  └─ Preference match (favorites)         5%  │
│                 │                             │
│  Step 3: Rank & Notify                       │
│  ├─ Top 10 matches notified instantly        │
│  ├─ Push notification + in-app               │
│  └─ First to accept wins                     │
│                                              │
│  Output: Confirmed Match                     │
└──────────────────────────────────────────────┘
```

### 3. Real-time Communication

```
┌─────────────────────────────────────────┐
│          REAL-TIME SYSTEM               │
│                                         │
│  Supabase Realtime (WebSockets)         │
│  ├─ Shift status changes                │
│  ├─ New match notifications             │
│  ├─ Chat messages                       │
│  └─ Payment confirmations               │
│                                         │
│  Push Notifications (Web Push API)      │
│  ├─ New shift posted (matching prefs)   │
│  ├─ Shift confirmed/cancelled           │
│  ├─ Message received                    │
│  ├─ Payment processed                   │
│  └─ Credential expiry warnings          │
└─────────────────────────────────────────┘
```

### 4. Payment Flow

```
┌─────────────────────────────────────────────────────┐
│              PAYMENT FLOW                           │
│                                                     │
│  1. Office posts shift ($45/hr, 8 hrs)              │
│  2. Hygienist accepts shift                         │
│  3. Office confirms completion                      │
│  4. Stripe processes payment:                       │
│     ┌──────────────────────────────────────┐        │
│     │  Total: $360.00                      │        │
│     │  Stripe fee: -$10.74 (2.9% + $0.30) │        │
│     │  Platform fee: $0.00 (FREE!)         │        │
│     │  Hygienist receives: $349.26         │        │
│     └──────────────────────────────────────┘        │
│  5. Instant payout to hygienist's bank              │
│  6. Both parties prompted to review                 │
└─────────────────────────────────────────────────────┘
```

---

## Infrastructure Architecture

### Deployment Pipeline

```
┌──────────────────────────────────────────────────────────┐
│                 CI/CD PIPELINE                            │
│                                                          │
│  Developer                                               │
│     │                                                    │
│     ├──→ git push (feature branch)                       │
│     │       │                                            │
│     │    GitHub Actions                                  │
│     │       ├── Lint (ESLint + Prettier)                 │
│     │       ├── Type Check (TypeScript)                  │
│     │       ├── Unit Tests (Vitest)                      │
│     │       ├── Integration Tests (Playwright)           │
│     │       └── Deploy Preview (Vercel)                  │
│     │                                                    │
│     ├──→ Pull Request                                    │
│     │       ├── Auto-review bot                          │
│     │       ├── Preview URL for QA                       │
│     │       └── Required checks pass                     │
│     │                                                    │
│     └──→ Merge to main                                   │
│             │                                            │
│          GitHub Actions                                  │
│             ├── Full test suite                          │
│             ├── Supabase migration                       │
│             ├── Deploy to Production (Vercel)            │
│             └── Sentry release                           │
└──────────────────────────────────────────────────────────┘
```

### Scaling Strategy

| Users | Infrastructure | Cost/Month |
|-------|---------------|------------|
| 0–1K | Supabase Free + Vercel Free | $0 |
| 1K–10K | Supabase Pro ($25) + Vercel Pro ($20) | ~$50 |
| 10K–50K | Supabase Pro + Vercel Pro + Upstash ($10) | ~$80 |
| 50K–100K | Supabase Team + Vercel Enterprise + dedicated Redis | ~$500 |
| 100K+ | Self-hosted Supabase + dedicated infra | Custom |

### Security Architecture

```
┌──────────────────────────────────────────────┐
│           SECURITY LAYERS                    │
│                                              │
│  Layer 1: Network                            │
│  ├─ HTTPS everywhere (TLS 1.3)              │
│  ├─ DDoS protection (Vercel/Cloudflare)     │
│  └─ Rate limiting (Upstash)                 │
│                                              │
│  Layer 2: Authentication                     │
│  ├─ Supabase Auth (JWT)                     │
│  ├─ httpOnly secure cookies                 │
│  ├─ CSRF protection                         │
│  └─ Multi-factor auth (optional)            │
│                                              │
│  Layer 3: Authorization                      │
│  ├─ Row-Level Security (PostgreSQL RLS)     │
│  ├─ Role-based access control               │
│  └─ API route middleware                    │
│                                              │
│  Layer 4: Data                               │
│  ├─ Encryption at rest (AES-256)            │
│  ├─ Encryption in transit (TLS)             │
│  ├─ PII segregation                         │
│  └─ HIPAA-aware data handling               │
│                                              │
│  Layer 5: Monitoring                         │
│  ├─ Sentry error tracking                   │
│  ├─ Audit logging                           │
│  └─ Anomaly detection                       │
└──────────────────────────────────────────────┘
```

---

## AI & Automation Opportunities

### Phase 1 (MVP)
- **Smart Matching**: Score-based algorithm using distance, reliability, and preferences
- **Auto-verification**: License number lookup against state dental board APIs
- **Smart Notifications**: Only notify hygienists about relevant shifts

### Phase 2 (Growth)
- **Demand Forecasting**: Predict staffing needs based on historical patterns, season, day of week
- **Rate Optimization**: Suggest optimal hourly rates based on market data
- **Churn Prediction**: Identify at-risk users and trigger retention campaigns

### Phase 3 (Scale)
- **AI Auto-Scheduling**: Proactively fill schedules before offices even post
- **NLP Chat**: Natural language shift posting ("I need a hygienist Tuesday morning")
- **Computer Vision**: Auto-extract license info from photos
- **Sentiment Analysis**: Monitor review quality and flag issues

---

## Risk & Compliance

### Regulatory Compliance

| Area | Requirement | Solution |
|------|------------|----------|
| **HIPAA** | Patient data protection | No PHI stored; credential data encrypted |
| **State Licensing** | Verify active dental licenses | API integration with state boards |
| **Employment Law** | 1099 vs W-2 classification | Clear independent contractor terms |
| **Payment Regulation** | Money transmission laws | Stripe handles all compliance |
| **Data Privacy** | CCPA, state privacy laws | Privacy-by-design, data minimization |
| **Accessibility** | WCAG AA compliance | Built into design system, automated testing |

### Risk Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Low initial supply/demand | High | High | Focus on 1 metro area; manual onboarding |
| Competitor undercuts | Medium | Medium | Already free; compete on UX |
| Data breach | Critical | Low | RLS, encryption, SOC 2 prep |
| Platform abuse | Medium | Medium | Review system, reporting, AI moderation |
| Regulatory changes | High | Low | Legal counsel, compliance monitoring |
