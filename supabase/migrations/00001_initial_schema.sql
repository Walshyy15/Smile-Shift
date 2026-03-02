-- SmileShift Initial Schema Migration
-- Enables PostGIS and sets up all core tables

-- ═══════════════════════════════════════════
-- Extensions
-- ═══════════════════════════════════════════
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- for text search

-- ═══════════════════════════════════════════
-- PROFILES
-- ═══════════════════════════════════════════
CREATE TABLE public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  role TEXT NOT NULL CHECK (role IN ('hygienist', 'office_admin', 'platform_admin')),
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  phone TEXT,
  avatar_url TEXT,
  bio TEXT,
  home_location GEOGRAPHY(POINT, 4326),
  max_commute_miles INTEGER DEFAULT 25,
  preferred_hours JSONB DEFAULT '{}',
  notification_prefs JSONB DEFAULT '{"push": true, "email": true, "sms": true}',
  avg_rating NUMERIC(3,2) DEFAULT 0,
  total_reviews INTEGER DEFAULT 0,
  reliability_score NUMERIC(3,2) DEFAULT 100,
  total_shifts_completed INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  onboarding_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_profiles_location ON profiles USING GIST(home_location);
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_user_id ON profiles(user_id);

-- ═══════════════════════════════════════════
-- CREDENTIALS
-- ═══════════════════════════════════════════
CREATE TABLE public.credentials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('dental_license','cpr_bls','radiology_cert','anesthesia_cert','liability_insurance','other')),
  license_number TEXT,
  issuing_state TEXT,
  issued_date DATE,
  expiry_date DATE,
  document_url TEXT,
  verification_status TEXT DEFAULT 'pending' CHECK (verification_status IN ('pending','verified','rejected','expired')),
  verified_at TIMESTAMPTZ,
  verified_by UUID REFERENCES profiles(id),
  rejection_reason TEXT,
  renewal_reminder_sent BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_credentials_profile ON credentials(profile_id);
CREATE INDEX idx_credentials_expiry ON credentials(expiry_date);

-- ═══════════════════════════════════════════
-- OFFICES
-- ═══════════════════════════════════════════
CREATE TABLE public.offices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  logo_url TEXT,
  website TEXT,
  phone TEXT,
  practice_type TEXT CHECK (practice_type IN ('general','pediatric','orthodontic','periodontic','endodontic','oral_surgery','cosmetic','multi_specialty')),
  practice_size TEXT CHECK (practice_size IN ('solo','small','medium','large','dso')),
  software_used TEXT[] DEFAULT '{}',
  avg_rating NUMERIC(3,2) DEFAULT 0,
  total_reviews INTEGER DEFAULT 0,
  stripe_account_id TEXT,
  stripe_onboarding_complete BOOLEAN DEFAULT false,
  is_verified BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_offices_owner ON offices(owner_id);

-- ═══════════════════════════════════════════
-- OFFICE LOCATIONS
-- ═══════════════════════════════════════════
CREATE TABLE public.office_locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  office_id UUID REFERENCES offices(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  address_line1 TEXT NOT NULL,
  address_line2 TEXT,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  zip_code TEXT NOT NULL,
  country TEXT DEFAULT 'US',
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  timezone TEXT NOT NULL DEFAULT 'America/New_York',
  parking_info TEXT,
  special_instructions TEXT,
  chair_count INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_office_locations_geo ON office_locations USING GIST(location);
CREATE INDEX idx_office_locations_office ON office_locations(office_id);

-- ═══════════════════════════════════════════
-- SHIFTS
-- ═══════════════════════════════════════════
CREATE TABLE public.shifts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  location_id UUID REFERENCES office_locations(id) ON DELETE CASCADE NOT NULL,
  posted_by UUID REFERENCES profiles(id) NOT NULL,
  date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  break_duration_minutes INTEGER DEFAULT 0,
  hourly_rate NUMERIC(6,2) NOT NULL,
  role_needed TEXT NOT NULL CHECK (role_needed IN ('hygienist','dental_assistant','front_office')),
  required_certifications TEXT[] DEFAULT '{}',
  experience_min_years INTEGER DEFAULT 0,
  notes TEXT,
  dress_code TEXT,
  status TEXT DEFAULT 'open' CHECK (status IN ('draft','open','filled','in_progress','completed','cancelled','disputed')),
  filled_by UUID REFERENCES profiles(id),
  filled_at TIMESTAMPTZ,
  is_urgent BOOLEAN DEFAULT false,
  is_promoted BOOLEAN DEFAULT false,
  auto_match BOOLEAN DEFAULT true,
  cancellation_reason TEXT,
  cancelled_at TIMESTAMPTZ,
  payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending','authorized','captured','paid','refunded','disputed')),
  stripe_payment_intent_id TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_shifts_date ON shifts(date);
CREATE INDEX idx_shifts_status ON shifts(status);
CREATE INDEX idx_shifts_open ON shifts(status, date) WHERE status = 'open';
CREATE INDEX idx_shifts_location ON shifts(location_id);
CREATE INDEX idx_shifts_posted_by ON shifts(posted_by);

-- ═══════════════════════════════════════════
-- SHIFT APPLICATIONS
-- ═══════════════════════════════════════════
CREATE TABLE public.shift_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shift_id UUID REFERENCES shifts(id) ON DELETE CASCADE NOT NULL,
  hygienist_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending','accepted','rejected','withdrawn','expired')),
  counter_rate NUMERIC(6,2),
  message TEXT,
  match_score NUMERIC(5,2),
  distance_miles NUMERIC(6,2),
  applied_at TIMESTAMPTZ DEFAULT NOW(),
  responded_at TIMESTAMPTZ,
  UNIQUE(shift_id, hygienist_id)
);

CREATE INDEX idx_applications_shift ON shift_applications(shift_id);
CREATE INDEX idx_applications_hygienist ON shift_applications(hygienist_id);

-- ═══════════════════════════════════════════
-- REVIEWS
-- ═══════════════════════════════════════════
CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shift_id UUID REFERENCES shifts(id) ON DELETE CASCADE NOT NULL,
  reviewer_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  reviewee_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  ratings_breakdown JSONB DEFAULT '{}',
  is_flagged BOOLEAN DEFAULT false,
  is_visible BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(shift_id, reviewer_id)
);

CREATE INDEX idx_reviews_reviewee ON reviews(reviewee_id);

-- ═══════════════════════════════════════════
-- CONVERSATIONS & MESSAGES
-- ═══════════════════════════════════════════
CREATE TABLE public.conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  participant_1 UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  participant_2 UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  shift_id UUID REFERENCES shifts(id),
  last_message_at TIMESTAMPTZ,
  last_message_preview TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE NOT NULL,
  sender_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id, created_at);

-- ═══════════════════════════════════════════
-- FAVORITES & BLOCK LIST
-- ═══════════════════════════════════════════
CREATE TABLE public.favorites (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  favorite_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(profile_id, favorite_id)
);

CREATE TABLE public.block_list (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  blocker_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  blocked_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(blocker_id, blocked_id)
);

-- ═══════════════════════════════════════════
-- NOTIFICATIONS
-- ═══════════════════════════════════════════
CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  data JSONB DEFAULT '{}',
  shift_id UUID REFERENCES shifts(id),
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_notifications_recipient ON notifications(recipient_id, is_read, created_at DESC);

-- ═══════════════════════════════════════════
-- ROW LEVEL SECURITY
-- ═══════════════════════════════════════════
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE credentials ENABLE ROW LEVEL SECURITY;
ALTER TABLE offices ENABLE ROW LEVEL SECURITY;
ALTER TABLE office_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE shifts ENABLE ROW LEVEL SECURITY;
ALTER TABLE shift_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE block_list ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Profiles: public read, self update
CREATE POLICY "profiles_select" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles_update" ON profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "profiles_insert" ON profiles FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Shifts: open shifts are public
CREATE POLICY "shifts_select" ON shifts FOR SELECT USING (true);
CREATE POLICY "shifts_insert" ON shifts FOR INSERT WITH CHECK (
  posted_by = (SELECT id FROM profiles WHERE user_id = auth.uid())
);
CREATE POLICY "shifts_update" ON shifts FOR UPDATE USING (
  posted_by = (SELECT id FROM profiles WHERE user_id = auth.uid())
);

-- Notifications: only recipient
CREATE POLICY "notifications_select" ON notifications FOR SELECT USING (
  recipient_id = (SELECT id FROM profiles WHERE user_id = auth.uid())
);

-- ═══════════════════════════════════════════
-- FUNCTIONS
-- ═══════════════════════════════════════════

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (user_id, role, first_name, last_name)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'role', 'hygienist'),
    COALESCE(NEW.raw_user_meta_data->>'first_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'last_name', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Update timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER offices_updated_at BEFORE UPDATE ON offices FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER shifts_updated_at BEFORE UPDATE ON shifts FOR EACH ROW EXECUTE FUNCTION update_updated_at();
