# 🦷 SmileShift

**The effortless dental staffing platform — free, fast, and frictionless.**

SmileShift connects dental offices with qualified hygienists and assistants in seconds. Think Uber for dental staffing — instant matching, zero friction, completely free.

---

## ✨ Why SmileShift?

| Feature | GoTu / Competitors | SmileShift |
|---------|-------------------|------------|
| Cost | Service fees / markups | **100% Free** |
| Time to fill a shift | Minutes to hours | **< 30 seconds** |
| Training required | Yes | **Zero** |
| Transparency | Limited office reviews | **Full two-way reviews** |
| Payment issues | Reported delays | **Instant pay via Stripe** |
| Mobile experience | App with friction | **Mobile-first PWA** |

## 🏗️ Tech Stack

| Layer | Technology | Cost | Why |
|-------|-----------|------|-----|
| Frontend | **SvelteKit** + TypeScript | ✅ Free | Smallest bundle, fastest load, mobile-first |
| Mobile | **PWA** (Progressive Web App) | ✅ Free | Install-free, works offline, push notifications |
| Backend | **Supabase** (PostgreSQL + Auth + Realtime) | ✅ Free | 500MB DB, 50K MAU, real-time, row-level security |
| API Layer | **SvelteKit API Routes** + **Edge Functions** | ✅ Free | Co-located with frontend, edge-deployed |
| Payments | **Stripe Connect** | ✅ Free* | Direct payments, no middleman (*standard processing fee only) |
| Maps/Geo | **Leaflet** + **OpenStreetMap** | ✅ Free | No API key needed, 42KB, open source |
| Matching | **PostgreSQL + PostGIS** | ✅ Free | Pure SQL scoring, geo-proximity, zero latency |
| Hosting | **Vercel** (Edge) | ✅ Free | Global CDN, auto-scaling, generous free tier |
| CI/CD | **GitHub Actions** | ✅ Free | Automated testing, preview deploys, production releases |
| Monitoring | **Vercel Analytics** | ✅ Free | Built-in Web Vitals, error tracking |

> **💡 Total cost to launch: $0.** No paid APIs required. The only fees are Stripe's standard 2.9% + $0.30 per transaction when real payments are processed.

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/Walshyy15/Smile-Shift.git
cd Smile-Shift

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env.local

# Run development server
npm run dev
```

## 📁 Project Structure

```
Smile-Shift/
├── .github/
│   └── workflows/          # GitHub Actions CI/CD
├── docs/
│   ├── architecture/       # System architecture docs
│   ├── design/             # UX/UI design system
│   └── database/           # Schema & ERD
├── src/
│   ├── lib/
│   │   ├── components/     # Reusable UI components
│   │   ├── stores/         # Svelte stores (state management)
│   │   ├── utils/          # Utility functions
│   │   ├── server/         # Server-side utilities
│   │   └── types/          # TypeScript type definitions
│   ├── routes/
│   │   ├── (auth)/         # Auth pages (login, register)
│   │   ├── (app)/          # Main app routes
│   │   │   ├── dashboard/  # Role-based dashboards
│   │   │   ├── shifts/     # Shift management
│   │   │   ├── profile/    # User profiles
│   │   │   └── settings/   # App settings
│   │   └── api/            # API endpoints
│   └── app.html            # HTML shell
├── static/                 # Static assets
├── tests/                  # Test files
├── supabase/               # Supabase migrations & config
├── svelte.config.js
├── vite.config.ts
├── package.json
└── README.md
```

## 📄 License

MIT License — Built with ❤️ for the dental community.
