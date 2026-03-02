# Contributing to SmileShift

Thank you for your interest in contributing to SmileShift! 🦷

## Development Setup

### Prerequisites
- Node.js 20+
- npm 10+
- Git
- [Supabase CLI](https://supabase.com/docs/guides/cli) (for local development)

### Getting Started

1. **Fork & Clone**
   ```bash
   git clone https://github.com/YOUR-USERNAME/Smile-Shift.git
   cd Smile-Shift
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment**
   ```bash
   cp .env.example .env.local
   # Fill in your Supabase and Stripe keys
   ```

4. **Start local Supabase** (optional, for full stack dev)
   ```bash
   supabase start
   ```

5. **Run dev server**
   ```bash
   npm run dev
   ```

## Branch Strategy

```
main ──────────────────────────────── production
  └── develop ─────────────────────── staging
        ├── feature/shift-posting ─── feature branches
        ├── feature/chat-system
        ├── fix/payment-bug
        └── chore/update-deps
```

- `main` — Production. Auto-deploys to production.
- `develop` — Staging. Auto-deploys to preview.
- `feature/*` — New features. Branch from `develop`.
- `fix/*` — Bug fixes. Branch from `develop` (or `main` for hotfixes).
- `chore/*` — Maintenance tasks.

## Pull Request Process

1. Create a feature branch from `develop`
2. Make your changes with clear, atomic commits
3. Ensure all checks pass (`npm run check && npm run lint && npm run test:unit`)
4. Open a PR against `develop`
5. Await code review
6. Squash and merge

## Code Style

- **TypeScript** for all `.ts` and `.svelte` files
- **Prettier** for formatting (auto-configured)
- **ESLint** for linting
- Prefer composition over inheritance
- Keep components small and focused
- Use Svelte stores for shared state

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add shift posting form
fix: correct payment calculation
docs: update API documentation
chore: update dependencies
test: add unit tests for matching engine
```
