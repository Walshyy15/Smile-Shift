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

| Layer | Technology | Why |
|-------|-----------|-----|
| Frontend | **SvelteKit** + TypeScript | Smallest bundle, fastest load, mobile-first |
| Mobile | **PWA** (Progressive Web App) | Install-free, works offline, push notifications |
| Backend | **Supabase** (PostgreSQL + Auth + Realtime) | Free tier, real-time subscriptions, row-level security |
| API Layer | **SvelteKit API Routes** + **Edge Functions** | Co-located with frontend, edge-deployed |
| Payments | **Stripe Connect** | Direct office→hygienist payments, no middleman |
| Maps/Geo | **Mapbox** or **Google Maps** | Proximity matching, commute time estimates |
| AI/ML | **OpenAI API** + custom models | Smart matching, demand forecasting |
| Hosting | **Vercel** (Edge) | Global CDN, auto-scaling, generous free tier |
| CI/CD | **GitHub Actions** | Automated testing, preview deploys, production releases |
| Monitoring | **Sentry** + **Vercel Analytics** | Error tracking, performance monitoring |

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
