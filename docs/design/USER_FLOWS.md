# 🔄 SmileShift — User Flows & Information Architecture

## Information Architecture

```
SmileShift
├── 🏠 Home (Landing/Dashboard)
│   ├── Hygienist Dashboard
│   │   ├── Available shifts nearby
│   │   ├── Upcoming confirmed shifts
│   │   ├── Quick stats (earnings, rating)
│   │   └── Urgent shifts banner
│   └── Office Dashboard
│       ├── Active shift postings
│       ├── Upcoming confirmed shifts
│       ├── Quick post shift CTA
│       └── Recent activity feed
│
├── 🔍 Shifts
│   ├── Browse shifts (list + map view)
│   ├── Shift detail page
│   ├── Apply / Post shift
│   └── Shift management
│       ├── Edit shift
│       ├── View applicants
│       ├── Confirm/reject
│       └── Cancel with reason
│
├── 💬 Messages
│   ├── Conversation list
│   └── Chat thread (per shift context)
│
├── 📅 Calendar
│   ├── Monthly/Weekly view
│   ├── Shift timeline
│   └── Availability management
│
├── 👤 Profile
│   ├── View/Edit profile
│   ├── Credentials management
│   ├── Reviews received
│   ├── Work history
│   └── Earnings (hygienist)
│
├── ⚙️ Settings
│   ├── Notification preferences
│   ├── Payment settings (Stripe)
│   ├── Availability schedule
│   ├── Privacy & blocking
│   └── Account management
│
└── 🏢 Office Management (office admins)
    ├── Locations
    ├── Team members
    ├── Analytics
    └── Billing
```

---

## Core User Flows

### Flow 1: Hygienist Onboarding (Target: < 3 minutes)

```
Landing Page
    │
    ├──→ "I'm a Hygienist" button
    │
    ▼
Enter Phone Number
    │ (Magic link / OTP sent)
    ▼
Verify Code (6-digit OTP)
    │
    ▼
Basic Info (1 screen)
    │ Name, photo (optional), zip code
    │ Max commute distance slider
    ▼
Add License (1 screen)
    │ Select state → enter license #
    │ OR take photo of license (OCR)
    │ Auto-verification in background
    ▼
Set Availability (1 screen)
    │ Simple weekly grid
    │ Tap days/times available
    ▼
Connect Payment (Stripe Connect)
    │ Bank account for payouts
    │ (Can skip, add later)
    ▼
🎉 Welcome Dashboard
    │ "You're all set! Here are shifts near you"
    │ Show matching shifts immediately
```

**Key UX decisions:**
- No passwords, ever (magic link/OTP)
- License verification happens in background — don't block
- Show value immediately (shifts) before asking for payment setup
- 5 screens total, each completable in < 30 seconds

---

### Flow 2: Office Onboarding (Target: < 5 minutes)

```
Landing Page
    │
    ├──→ "I'm a Dental Office" button
    │
    ▼
Enter Email / Phone
    │ (Magic link / OTP)
    ▼
Verify Code
    │
    ▼
Practice Info (1 screen)
    │ Practice name, type, size
    │ Logo (optional)
    ▼
Add Location (1 screen)
    │ Address (with autocomplete)
    │ Auto-geocode for map
    │ # of chairs, parking info
    ▼
Connect Payment (Stripe Connect)
    │ For paying hygienists
    │ (Required before posting shifts)
    ▼
🎉 Welcome Dashboard
    │ "Post your first shift in 30 seconds"
    │ Prominent "Post a Shift" CTA
```

---

### Flow 3: Post a Shift (Target: < 30 seconds)

```
Office Dashboard
    │
    ├──→ "Post a Shift" FAB button
    │
    ▼
Select Location (if multi-location)
    │ Pre-selected if single location
    ▼
Quick Post Form (1 screen, smart defaults)
    │
    │  ┌────────────────────────────────┐
    │  │ Role: [Hygienist ▼]           │
    │  │ Date: [Tomorrow ▼] (calendar) │
    │  │ Time: [8:00 AM] → [4:00 PM]   │
    │  │ Break: [60 min ▼]             │
    │  │ Rate: [$45/hr] (slider)       │
    │  │ Market avg: $42/hr            │
    │  │ Total: $315.00                │
    │  │                               │
    │  │ Notes: [Optional details...]   │
    │  │                               │
    │  │ [✨ Post Shift]               │
    │  └────────────────────────────────┘
    │
    ▼
Matching Engine Activates
    │ Top matches notified instantly
    │ Office sees "Finding matches..." animation
    ▼
Applicants Arrive (real-time)
    │ Each applicant card shows:
    │ - Name, photo, rating, distance
    │ - Shifts completed, reliability %
    │ - "Accept" or "View Profile"
    ▼
Office Accepts → Shift Confirmed!
    │ Both parties notified
    │ Added to both calendars
```

**Key UX decisions:**
- Smart defaults (tomorrow, standard hours, market rate)
- Real-time market rate guidance
- Auto-calculated total pay
- Single-screen form — no multi-step wizard

---

### Flow 4: Find & Apply for Shift (Target: < 15 seconds)

```
Hygienist Dashboard
    │ Shows nearby shifts automatically
    │
    ├──→ Browse shift cards (feed)
    │    OR tap "Map View" toggle
    │
    ▼
Tap Shift Card
    │
    ▼
Shift Detail (bottom sheet / modal)
    │ ┌──────────────────────────────┐
    │ │ 🏥 Bright Smiles Dental  ★4.8│
    │ │ 📍 2.3 mi · 8 min drive     │
    │ │ 📅 Tomorrow, 8 AM – 4 PM    │
    │ │ 💰 $48/hr ($384 total)      │
    │ │                              │
    │ │ General practice · 4 chairs  │
    │ │ Software: Dentrix            │
    │ │ Parking: Free lot            │
    │ │                              │
    │ │ Office Reviews (3)           │
    │ │ ★★★★★ "Great team!"         │
    │ │                              │
    │ │ [✨ Apply Now]  [💬 Message] │
    │ └──────────────────────────────┘
    │
    ├──→ "Apply Now" (instant)
    │    OR "Counter Offer" with rate
    │
    ▼
Application Sent!
    │ "You'll be notified when accepted"
    │ Push notification when response arrives
```

---

### Flow 5: Shift Completion & Payment

```
Shift Day
    │
    ├──→ Hygienist arrives
    │    (Optional: GPS check-in)
    ▼
During Shift
    │ Both parties can message in-app
    │ Timer visible (optional)
    ▼
Shift Ends
    │
    ├──→ Office confirms completion
    │    "Did [Name] complete the shift?"
    │    [✅ Yes, confirm] [❌ Report issue]
    │
    ▼ (if confirmed)
Payment Processed (automatic)
    │ Stripe charges office
    │ Funds sent to hygienist
    │ Both notified with receipt
    ▼
Review Prompt
    │ "How was your experience?"
    │ ★★★★★ + optional comment
    │ Quick structured ratings
    │ (can skip, reminded later)
    ▼
Done! → Back to dashboard
```

---

### Flow 6: Emergency Last-Minute Shift

```
Office: Hygienist calls out at 6 AM!
    │
    ├──→ Open app → "Urgent Shift" toggle
    │    (Same form, marked as urgent)
    ▼
Urgent Matching
    │ Wider notification radius
    │ Push to ALL available hygienists
    │ Highlighted in red/orange in feeds
    │ Higher match priority
    ▼
First to Accept → Auto-confirmed
    │ No waiting for office approval
    │ Instant confirmation for both
    ▼
Office notified: "Your shift is filled!"
```

---

## Navigation Structure

### Mobile (Bottom Tab Bar)
```
┌─────────────────────────────────────────┐
│                                         │
│            [active content]             │
│                                         │
├─────┬─────┬─────┬─────┬─────┬─────────┤
│ 🏠  │ 🔍  │  ➕  │ 💬  │ 👤  │         │
│Home │Shifts│Post │Chat │ Me  │         │
└─────┴─────┴─────┴─────┴─────┴─────────┘
```

### Desktop (Left Sidebar)
```
┌──────┬─────────────────────────────────┐
│ Logo │                                 │
│      │                                 │
│ 🏠   │       [active content]          │
│ 🔍   │                                 │
│ 📅   │                                 │
│ 💬   │                                 │
│ 🔔   │                                 │
│      │                                 │
│ ⚙️   │                                 │
│ 👤   │                                 │
└──────┴─────────────────────────────────┘
```
