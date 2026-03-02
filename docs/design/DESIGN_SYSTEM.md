# 🎨 SmileShift — UX Design System & Visual Language

## Design Philosophy

> **"Calm, confident, effortless."**

SmileShift should feel like a breath of fresh air in healthcare tech. No clutter, no anxiety, no learning curve. Every screen should feel like it was designed by someone who actually uses staffing apps and hates them.

---

## Color System

### Primary Palette
| Name | Hex | HSL | Usage |
|------|-----|-----|-------|
| **Mint** | `#2DD4A8` | `165, 64%, 50%` | Primary actions, success states |
| **Deep Teal** | `#0F766E` | `175, 77%, 26%` | Headers, emphasis |
| **Ocean** | `#155E75` | `193, 68%, 27%` | Secondary actions |

### Neutral Palette
| Name | Hex | Usage |
|------|-----|-------|
| **Snow** | `#FAFBFC` | Page backgrounds |
| **Cloud** | `#F1F5F9` | Card backgrounds |
| **Mist** | `#E2E8F0` | Borders, dividers |
| **Slate** | `#64748B` | Secondary text |
| **Charcoal** | `#1E293B` | Primary text |
| **Midnight** | `#0F172A` | Dark mode background |

### Semantic Colors
| Name | Hex | Usage |
|------|-----|-------|
| **Success** | `#10B981` | Confirmed, completed |
| **Warning** | `#F59E0B` | Pending, attention |
| **Error** | `#EF4444` | Cancel, errors |
| **Info** | `#3B82F6` | Tips, information |

### Gradients
```css
--gradient-primary: linear-gradient(135deg, #2DD4A8 0%, #155E75 100%);
--gradient-warm: linear-gradient(135deg, #2DD4A8 0%, #3B82F6 100%);
--gradient-subtle: linear-gradient(180deg, #FAFBFC 0%, #F1F5F9 100%);
--gradient-dark: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
```

---

## Typography

### Font Stack
```css
--font-display: 'Plus Jakarta Sans', system-ui, sans-serif;
--font-body: 'Inter', system-ui, sans-serif;
--font-mono: 'JetBrains Mono', monospace;
```

### Scale
| Level | Size | Weight | Line Height | Usage |
|-------|------|--------|-------------|-------|
| Display | 36px / 2.25rem | 800 | 1.1 | Hero headlines |
| H1 | 30px / 1.875rem | 700 | 1.2 | Page titles |
| H2 | 24px / 1.5rem | 700 | 1.25 | Section headers |
| H3 | 20px / 1.25rem | 600 | 1.3 | Card titles |
| Body | 16px / 1rem | 400 | 1.5 | Default text |
| Body Small | 14px / 0.875rem | 400 | 1.5 | Secondary text |
| Caption | 12px / 0.75rem | 500 | 1.4 | Labels, timestamps |
| Overline | 11px / 0.6875rem | 700 | 1.4 | ALL CAPS labels |

---

## Spacing & Layout

### Spacing Scale (4px base)
```
4px  → xs
8px  → sm  
12px → md
16px → base
20px → lg
24px → xl
32px → 2xl
40px → 3xl
48px → 4xl
64px → 5xl
```

### Border Radius
```css
--radius-sm: 6px;    /* Badges, small elements */
--radius-md: 10px;   /* Buttons, inputs */
--radius-lg: 16px;   /* Cards */
--radius-xl: 24px;   /* Modals, large cards */
--radius-full: 9999px; /* Avatars, pills */
```

### Shadows (Elevation)
```css
--shadow-sm: 0 1px 2px rgba(0,0,0,0.04);
--shadow-md: 0 4px 12px rgba(0,0,0,0.06);
--shadow-lg: 0 8px 24px rgba(0,0,0,0.08);
--shadow-xl: 0 16px 48px rgba(0,0,0,0.10);
--shadow-glow: 0 0 20px rgba(45, 212, 168, 0.15);
```

---

## Component Patterns

### Buttons
- **Primary**: Mint background, white text, rounded-md, subtle hover lift
- **Secondary**: White background, teal border, teal text
- **Ghost**: Transparent, text color only, subtle hover background
- **Danger**: Error red, only for destructive actions
- **All buttons**: 44px minimum touch target (WCAG), 200ms transitions

### Cards
- White background on `Snow` canvas
- 16px radius, `shadow-md` elevation
- 20px internal padding
- Subtle 1px border in `Mist`
- Hover: `shadow-lg` with 200ms ease

### Shift Card (The Core Component)
```
┌─────────────────────────────────────┐
│  🏥 Bright Smiles Dental    ★ 4.8  │
│  📍 2.3 mi away                     │
│                                     │
│  📅 Tomorrow, Mar 3                 │
│  🕐 8:00 AM – 4:00 PM              │
│  💰 $48/hr ($384 total)            │
│                                     │
│  🦷 Hygienist · General Practice    │
│                                     │
│  ┌─────────────────────────────┐    │
│  │    ✨ Apply Now              │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### Input Fields
- 48px height minimum (mobile touch)
- Rounded-md borders
- Focus: Mint ring (2px), slight glow
- Error: Red ring + inline error message
- Labels above inputs, never floating

### Navigation
- **Mobile**: Bottom tab bar (5 items max)
  - Home | Shifts | Messages | Calendar | Profile
- **Desktop**: Left sidebar, collapsible
- Active state: Mint underline/highlight

---

## Motion & Animation

### Principles
1. **Purposeful**: Every animation communicates state change
2. **Subtle**: Never distracting; 200-300ms durations
3. **Responsive**: Instant feedback on tap/click

### Timing
```css
--ease-out: cubic-bezier(0.16, 1, 0.3, 1);
--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);
--duration-fast: 150ms;
--duration-normal: 200ms;
--duration-slow: 300ms;
```

### Key Animations
- **Page transitions**: Slide + fade (300ms)
- **Card hover**: Lift 2px + shadow increase (200ms)
- **Button press**: Scale 0.98 (100ms)
- **Toast notifications**: Slide up + fade in (300ms)
- **Loading**: Gentle pulse skeleton screens (no spinners)
- **Success**: Checkmark draw animation (400ms)

---

## Accessibility (WCAG AA)

### Color Contrast
- All text on backgrounds: minimum 4.5:1 ratio
- Large text (18px+): minimum 3:1 ratio
- Interactive elements: 3:1 against adjacent colors

### Focus Management
- Visible focus rings on all interactive elements
- Focus trap in modals and dropdowns
- Logical tab order throughout

### Screen Readers
- All images have alt text
- ARIA labels on icon-only buttons
- Live regions for dynamic content updates
- Semantic HTML throughout (nav, main, aside, etc.)

### Touch Targets
- Minimum 44×44px for all interactive elements
- Adequate spacing between touch targets
- No hover-only interactions

---

## Responsive Breakpoints

```css
--breakpoint-sm: 640px;   /* Large phones */
--breakpoint-md: 768px;   /* Tablets */
--breakpoint-lg: 1024px;  /* Small laptops */
--breakpoint-xl: 1280px;  /* Desktops */
```

### Mobile-First Approach
1. Design for 375px width first (iPhone SE)
2. Scale up with progressive enhancement
3. No features hidden on mobile — full parity
4. Touch-optimized interactions everywhere

---

## Dark Mode

- Auto-detect system preference via `prefers-color-scheme`
- Manual toggle in settings
- All colors have dark mode variants
- Surfaces: `Midnight` → `Charcoal` → `Slate`
- Text: Inverted hierarchy
- Shadows: Reduced opacity, slight glow effect
