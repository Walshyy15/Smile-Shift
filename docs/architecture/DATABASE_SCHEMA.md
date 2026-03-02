# 🗄️ SmileShift — Database Schema

## Overview
PostgreSQL (Supabase) with PostGIS for geolocation. All tables use Row-Level Security (RLS).

## Core Tables

### `profiles` — User profiles (extends Supabase auth)
| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| user_id | UUID FK → auth.users | Unique |
| role | TEXT | 'hygienist', 'office_admin', 'platform_admin' |
| first_name, last_name | TEXT | Required |
| phone, avatar_url, bio | TEXT | Optional |
| home_location | GEOGRAPHY(POINT) | For hygienists |
| max_commute_miles | INT | Default 25 |
| preferred_hours | JSONB | Schedule preferences |
| notification_prefs | JSONB | Push/email/sms toggles |
| avg_rating | NUMERIC(3,2) | Calculated |
| reliability_score | NUMERIC(3,2) | Default 100 |
| total_shifts_completed | INT | |
| is_active, is_verified | BOOLEAN | |
| created_at, updated_at | TIMESTAMPTZ | |

### `credentials` — Licenses & certifications
| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| profile_id | UUID FK → profiles | |
| type | TEXT | 'dental_license', 'cpr_bls', 'radiology_cert', etc. |
| license_number | TEXT | |
| issuing_state | TEXT | |
| expiry_date | DATE | |
| document_url | TEXT | Supabase Storage |
| verification_status | TEXT | 'pending', 'verified', 'rejected', 'expired' |

### `offices` — Dental practices
| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| owner_id | UUID FK → profiles | |
| name, description | TEXT | |
| practice_type | TEXT | 'general', 'pediatric', 'orthodontic', etc. |
| practice_size | TEXT | 'solo', 'small', 'medium', 'large', 'dso' |
| software_used | TEXT[] | e.g., ['dentrix', 'eaglesoft'] |
| avg_rating | NUMERIC(3,2) | |
| stripe_account_id | TEXT | Stripe Connect |

### `office_locations` — Multi-location support
| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| office_id | UUID FK → offices | |
| name | TEXT | e.g., "Downtown Office" |
| address fields | TEXT | line1, city, state, zip |
| location | GEOGRAPHY(POINT) | PostGIS indexed |
| timezone | TEXT | |
| chair_count | INT | |

### `shifts` — Core marketplace entity
| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| location_id | UUID FK → office_locations | |
| posted_by | UUID FK → profiles | |
| date | DATE | |
| start_time, end_time | TIME | |
| break_duration_minutes | INT | |
| hourly_rate | NUMERIC(6,2) | |
| total_hours | NUMERIC (generated) | Auto-calculated |
| total_pay | NUMERIC (generated) | Auto-calculated |
| role_needed | TEXT | 'hygienist', 'dental_assistant', 'front_office' |
| required_certifications | TEXT[] | |
| status | TEXT | 'open', 'filled', 'completed', 'cancelled', etc. |
| filled_by | UUID FK → profiles | |
| is_urgent, is_promoted | BOOLEAN | |
| payment_status | TEXT | |
| stripe_payment_intent_id | TEXT | |

### `shift_applications` — Hygienist bids on shifts
| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| shift_id | UUID FK → shifts | |
| hygienist_id | UUID FK → profiles | |
| status | TEXT | 'pending', 'accepted', 'rejected', 'withdrawn' |
| counter_rate | NUMERIC(6,2) | Optional counter-offer |
| match_score | NUMERIC(5,2) | Algorithm score |
| distance_miles | NUMERIC(6,2) | |
| UNIQUE(shift_id, hygienist_id) | | Prevent duplicates |

### `reviews` — Two-way review system
| Column | Type | Notes |
|--------|------|-------|
| id | UUID PK | |
| shift_id | UUID FK → shifts | |
| reviewer_id | UUID FK → profiles | |
| reviewee_id | UUID FK → profiles | |
| rating | INT (1-5) | |
| comment | TEXT | |
| ratings_breakdown | JSONB | Structured sub-ratings |
| UNIQUE(shift_id, reviewer_id) | | One review per shift |

### `messages` & `conversations` — In-app chat
### `favorites` — Bidirectional favorites
### `notifications` — Push notification records
### `block_list` — User blocking

## Key Indexes
- PostGIS GIST indexes on all location columns
- Composite index on `shifts(status, date)` for open shift queries
- Index on `notifications(recipient_id, is_read, created_at DESC)`

## Key Database Functions
- `find_nearby_shifts(location, max_distance, date)` — Geo-proximity search
- `calculate_match_score(shift_id, hygienist_id)` — Weighted matching algorithm
- Trigger functions for auto-updating `avg_rating` and `reliability_score`

## RLS Policies
- Profiles: Public read, self-update only
- Shifts: Open shifts visible to all; only poster can modify
- Messages: Only conversation participants can access
- Applications: Hygienist sees own; office sees shifts they posted
