-- Coherency App - PostgreSQL Initialization Script
-- This script creates all tables and seeds them with 3 rows of sample data.
-- Fixed to ensure consistent UUID usage for user references

-- =================================================================
-- Section 1: Authentication & User Management (Prompts 1.1 & 1.2)
-- =================================================================

-- Table: users (Prompt 1.1)
-- Create users table with correct schema
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    is_email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login_at TIMESTAMP WITH TIME ZONE
);

-- Create user_credentials table (separate from users as per your design)
CREATE TABLE IF NOT EXISTS user_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    password_hash TEXT NOT NULL,
    password_salt TEXT NOT NULL,
    hash_algorithm VARCHAR(50) DEFAULT 'Argon2id',
    failed_login_attempts INTEGER DEFAULT 0,
    account_locked_until TIMESTAMP WITH TIME ZONE,
    password_changed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create login_attempts table
CREATE TABLE IF NOT EXISTS login_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    email VARCHAR(255) NOT NULL,
    attempt_result INTEGER NOT NULL, -- Enum: Success=0, Failed=1, Blocked=2
    failure_reason TEXT,
    ip_address TEXT,
    user_agent TEXT,
    attempted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_user_credentials_user_id ON user_credentials(user_id);
CREATE INDEX IF NOT EXISTS idx_login_attempts_email ON login_attempts(email);
CREATE INDEX IF NOT EXISTS idx_login_attempts_attempted_at ON login_attempts(attempted_at);
CREATE INDEX IF NOT EXISTS idx_login_attempts_user_id ON login_attempts(user_id);

-- Insert sample data with correct schema
INSERT INTO users (username, email, first_name, last_name, is_active, is_email_verified, last_login_at) VALUES
('patient_user', 'patient@coherency.io', 'Patient', 'User', TRUE, TRUE, NOW() - INTERVAL '1 day'),
('doctor_user', 'doctor@coherency.io', 'Doctor', 'Smith', TRUE, TRUE, NOW() - INTERVAL '2 hours'),
('admin_user', 'admin@coherency.io', 'Admin', 'Jones', TRUE, FALSE, NOW())
ON CONFLICT (email) DO NOTHING;

-- Table: user_profiles (Prompt 1.1) - Fixed to use UUID
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date_of_birth DATE,
    gender VARCHAR(50),
    profile_image TEXT,
    emergency_contact TEXT
);

-- Insert sample user profiles (will need to get actual UUIDs)
WITH user_uuids AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY created_at) as rn 
    FROM users 
    LIMIT 3
)
INSERT INTO user_profiles (user_id, date_of_birth, gender, profile_image) 
SELECT 
    id,
    CASE 
        WHEN rn = 1 THEN '1990-05-15'::DATE
        WHEN rn = 2 THEN '1985-08-20'::DATE
        ELSE '1980-01-01'::DATE
    END,
    CASE 
        WHEN rn = 1 THEN 'Male'
        WHEN rn = 2 THEN 'Female'
        ELSE 'Non-binary'
    END,
    CASE 
        WHEN rn = 1 THEN 'https://example.com/images/john.jpg'
        WHEN rn = 2 THEN 'https://example.com/images/jane.jpg'
        ELSE 'https://example.com/images/admin.jpg'
    END
FROM user_uuids;

-- Table: auth_tokens (Prompt 1.1) - Fixed to use UUID
CREATE TABLE IF NOT EXISTS auth_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    token_type VARCHAR(50) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    device_info TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: otp_verifications (Prompt 1.1) - Fixed to use UUID
CREATE TABLE IF NOT EXISTS otp_verifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    otp_code VARCHAR(10) NOT NULL,
    purpose VARCHAR(100) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    verified BOOLEAN DEFAULT FALSE,
    attempts INTEGER DEFAULT 0
);

-- Table: roles (Prompt 1.2)
CREATE TABLE IF NOT EXISTS roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    level INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO roles (name, description, level) VALUES
('Patient', 'Can view own medical records, book appointments.', 10),
('Doctor', 'Can view assigned patient records, manage appointments.', 50),
('Admin', 'Full system access.', 100);

-- Table: permissions (Prompt 1.2)
CREATE TABLE IF NOT EXISTS permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    description TEXT
);

INSERT INTO permissions (name, resource, action, description) VALUES
('read_own_record', 'medical_record', 'read', 'Allows a user to read their own medical record.'),
('write_patient_record', 'medical_record', 'write', 'Allows a doctor to write to an assigned patient record.'),
('manage_users', 'users', 'manage', 'Allows an admin to create, update, and delete users.');

-- Table: role_permissions (Prompt 1.2)
CREATE TABLE IF NOT EXISTS role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE
);

-- Table: user_roles (Prompt 1.2) - Fixed to use UUID
CREATE TABLE IF NOT EXISTS user_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    assigned_by UUID REFERENCES users(id) ON DELETE SET NULL,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- Table: permission_logs (Prompt 1.2) - Fixed to use UUID
CREATE TABLE IF NOT EXISTS permission_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    permission VARCHAR(100) NOT NULL,
    resource_id VARCHAR(100),
    action VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- Section 2: LiDAR Wound Detection System (Prompts 2.1 & 2.2)
-- =================================================================

-- Table: wounds (Prompt 2.1) - Fixed to use UUID for patient_id
CREATE TABLE IF NOT EXISTS wounds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL, -- Will reference patients table
    capture_date TIMESTAMP WITH TIME ZONE NOT NULL,
    wound_type VARCHAR(100),
    location_body VARCHAR(100),
    severity_level VARCHAR(50),
    lidar_data_url TEXT,
    images_urls TEXT[],
    measurements_json JSONB,
    status VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: wound_measurements (Prompt 2.1)
CREATE TABLE IF NOT EXISTS wound_measurements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wound_id UUID NOT NULL REFERENCES wounds(id) ON DELETE CASCADE,
    length_mm NUMERIC(10, 2),
    width_mm NUMERIC(10, 2),
    depth_mm NUMERIC(10, 2),
    area_sq_mm NUMERIC(10, 2),
    volume_cubic_mm NUMERIC(10, 2),
    perimeter_mm NUMERIC(10, 2),
    irregularity_score NUMERIC(5, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: wound_tracking (Prompt 2.1)
CREATE TABLE IF NOT EXISTS wound_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wound_id UUID NOT NULL REFERENCES wounds(id) ON DELETE CASCADE,
    measurement_date DATE NOT NULL,
    healing_progress NUMERIC(5, 2),
    notes TEXT,
    images_urls TEXT[],
    measured_by UUID REFERENCES users(id) ON DELETE SET NULL,
    treatment_applied TEXT,
    next_assessment_date DATE
);

-- Table: wound_analyses (Prompt 2.2)
CREATE TABLE IF NOT EXISTS wound_analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wound_id UUID NOT NULL REFERENCES wounds(id) ON DELETE CASCADE,
    model_version VARCHAR(50),
    analysis_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processing_time_ms INTEGER,
    wound_type_prediction JSONB,
    confidence_score NUMERIC(5, 4),
    severity_level VARCHAR(50),
    healing_stage VARCHAR(50),
    infection_risk NUMERIC(5, 2),
    treatment_recommendations JSONB,
    validated_by_doctor UUID REFERENCES users(id) ON DELETE SET NULL,
    doctor_feedback TEXT,
    accuracy_score NUMERIC(5, 4)
);

-- Table: ml_model_metrics (Prompt 2.2)
CREATE TABLE IF NOT EXISTS ml_model_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_version VARCHAR(50) UNIQUE NOT NULL,
    accuracy NUMERIC(5, 4),
    precision_val NUMERIC(5, 4),
    recall NUMERIC(5, 4),
    f1_score NUMERIC(5, 4),
    deployment_date DATE,
    performance_data JSONB,
    validation_dataset_size INTEGER
);

INSERT INTO ml_model_metrics (model_version, accuracy, precision_val, recall, f1_score, deployment_date) VALUES
('v1.2.0', 0.9512, 0.9433, 0.9601, 0.9516, '2023-10-01'),
('v1.2.1', 0.9605, 0.9587, 0.9655, 0.9621, '2023-11-15'),
('v1.1.0', 0.9240, 0.9100, 0.9300, 0.9200, '2023-08-01');

-- =================================================================
-- Section 3: Patient Management System (Prompts 3.1 & 3.2)
-- =================================================================

-- Table: patients (Prompt 3.1) - Fixed to use UUID
CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    medical_record_number VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    gender VARCHAR(50),
    blood_type VARCHAR(10),
    height NUMERIC(5,2),
    weight NUMERIC(5,2),
    phone TEXT,
    address TEXT,
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert sample patients using existing user UUIDs
WITH user_uuids AS (
    SELECT id, email, ROW_NUMBER() OVER (ORDER BY created_at) as rn 
    FROM users 
    WHERE email IN ('patient@coherency.io', 'doctor@coherency.io', 'admin@coherency.io')
)
INSERT INTO patients (user_id, medical_record_number, date_of_birth, blood_type) 
SELECT 
    id,
    CASE 
        WHEN rn = 1 THEN 'MRN001'
        WHEN rn = 2 THEN 'MRN002'
        ELSE 'MRN003'
    END,
    CASE 
        WHEN rn = 1 THEN '1990-05-15'::DATE
        WHEN rn = 2 THEN '1988-02-20'::DATE
        ELSE '1975-11-30'::DATE
    END,
    CASE 
        WHEN rn = 1 THEN 'O+'
        WHEN rn = 2 THEN 'A-'
        ELSE 'B+'
    END
FROM user_uuids;

-- Table: medical_history (Prompt 3.1)
CREATE TABLE IF NOT EXISTS medical_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    condition_name TEXT,
    diagnosis_date DATE,
    status VARCHAR(100),
    severity VARCHAR(50),
    diagnosed_by TEXT,
    treatment_notes TEXT,
    resolution_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table: medications (Prompt 3.1)
CREATE TABLE IF NOT EXISTS medications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    medication_name TEXT,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    start_date DATE,
    end_date DATE,
    prescribed_by TEXT,
    pharmacy TEXT,
    refill_date DATE,
    active_status BOOLEAN
);

-- Table: vital_signs (Prompt 3.1)
CREATE TABLE IF NOT EXISTS vital_signs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    measurement_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    blood_pressure_systolic INTEGER,
    blood_pressure_diastolic INTEGER,
    heart_rate INTEGER,
    temperature NUMERIC(4, 1),
    weight NUMERIC(5, 2),
    height NUMERIC(5, 2),
    oxygen_saturation NUMERIC(5, 2),
    recorded_by UUID REFERENCES users(id) ON DELETE SET NULL
);

-- Table: medical_documents (Prompt 3.2)
CREATE TABLE IF NOT EXISTS medical_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    category VARCHAR(100),
    subcategory VARCHAR(100),
    title TEXT,
    description TEXT,
    file_name TEXT,
    file_size BIGINT,
    file_type VARCHAR(50),
    file_url TEXT,
    upload_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expiration_date DATE,
    tags TEXT[],
    ocr_extracted_text TEXT,
    processed_status VARCHAR(50)
);

-- Table: document_shares (Prompt 3.2)
CREATE TABLE IF NOT EXISTS document_shares (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL REFERENCES medical_documents(id) ON DELETE CASCADE,
    shared_with_type VARCHAR(50),
    shared_with_id UUID REFERENCES users(id) ON DELETE CASCADE,
    permission_level VARCHAR(50),
    shared_by UUID REFERENCES users(id) ON DELETE SET NULL,
    shared_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    access_count INTEGER,
    last_accessed TIMESTAMP WITH TIME ZONE
);

-- Table: document_annotations (Prompt 3.2)
CREATE TABLE IF NOT EXISTS document_annotations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL REFERENCES medical_documents(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    annotation_type VARCHAR(50),
    coordinates JSONB,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- Section 4: Hospital & Doctor Directory System (Prompts 4.1 & 4.2)
-- =================================================================

-- Table: hospitals (Prompt 4.1)
CREATE TABLE IF NOT EXISTS hospitals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    type VARCHAR(100),
    address TEXT,
    latitude NUMERIC(9, 6),
    longitude NUMERIC(9, 6),
    phone TEXT,
    email TEXT,
    website TEXT,
    established_year INTEGER,
    bed_capacity INTEGER,
    emergency_services BOOLEAN,
    accreditation TEXT,
    ownership_type VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO hospitals (name, type, address, latitude, longitude, emergency_services, bed_capacity) VALUES
('City General Hospital', 'General', '123 Main St, Anytown', 40.7128, -74.0060, TRUE, 500),
('Oak Valley Community Clinic', 'Clinic', '456 Oak Ave, Suburbia', 34.0522, -118.2437, FALSE, 20),
('St. Jude Children''s Hospital', 'Specialty', '789 Hope Ln, Healville', 35.1205, -89.9912, TRUE, 150);

-- Table: appointments (Prompt 4.2)
CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    hospital_id UUID REFERENCES hospitals(id) ON DELETE SET NULL,
    appointment_date DATE,
    appointment_time TIME,
    appointment_type VARCHAR(100),
    status VARCHAR(50),
    consultation_fee NUMERIC(10, 2),
    payment_status VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancellation_reason TEXT
);

-- =================================================================
-- Section 5: E-commerce Medicine & Products (Prompts 5.1 & 5.2)
-- =================================================================

-- Table: medicines (Prompt 5.1)
CREATE TABLE IF NOT EXISTS medicines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    generic_name TEXT,
    brand_names TEXT[],
    manufacturer VARCHAR(255),
    strength VARCHAR(100),
    dosage_form VARCHAR(100),
    route_of_administration VARCHAR(100),
    therapeutic_class VARCHAR(255),
    prescription_required BOOLEAN,
    controlled_substance BOOLEAN,
    price NUMERIC(10, 2),
    availability INTEGER
);

INSERT INTO medicines (name, generic_name, manufacturer, strength, prescription_required, price) VALUES
('Tylenol', 'Acetaminophen', 'Johnson & Johnson', '500mg', FALSE, 9.99),
('Lisinopril', 'Lisinopril', 'Generic Pharma', '10mg', TRUE, 4.50),
('Amoxicillin', 'Amoxicillin', 'Sandoz', '250mg', TRUE, 15.75);

-- Table: orders (Prompt 5.2)
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_number VARCHAR(100) UNIQUE,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_amount NUMERIC(12, 2),
    tax_amount NUMERIC(10, 2),
    shipping_amount NUMERIC(10, 2),
    discount_amount NUMERIC(10, 2),
    payment_method VARCHAR(100),
    payment_status VARCHAR(50),
    shipping_address TEXT,
    delivery_date DATE,
    delivery_time_slot VARCHAR(100),
    order_status VARCHAR(50)
);

-- =================================================================
-- Section 6: Caregiver & Nanny Services (Prompts 6.1 & 6.2)
-- =================================================================

-- Table: caregivers (Prompt 6.1)
CREATE TABLE IF NOT EXISTS caregivers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    profile_image TEXT,
    date_of_birth DATE,
    gender VARCHAR(50),
    languages_spoken TEXT[],
    experience_years INTEGER,
    hourly_rate NUMERIC(10, 2),
    daily_rate NUMERIC(10, 2),
    background_check_status VARCHAR(50),
    certifications TEXT[],
    specializations TEXT[],
    bio TEXT
);

-- Table: service_bookings (Prompt 6.2)
CREATE TABLE IF NOT EXISTS service_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    caregiver_id UUID NOT NULL REFERENCES caregivers(id) ON DELETE CASCADE,
    service_type VARCHAR(100),
    booking_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    service_date DATE,
    start_time TIME,
    end_time TIME,
    duration_hours NUMERIC(5, 2),
    hourly_rate NUMERIC(10, 2),
    total_cost NUMERIC(12, 2),
    service_location TEXT,
    special_requirements TEXT,
    booking_status VARCHAR(50)
);

-- =================================================================
-- Section 7: Payment Processing & Billing (Prompts 7.1 & 7.2)
-- =================================================================

-- Table: payments (Prompt 7.1)
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    transaction_id TEXT,
    gateway_used VARCHAR(100),
    amount NUMERIC(12, 2),
    currency VARCHAR(10),
    payment_method TEXT,
    payment_status VARCHAR(50),
    transaction_type VARCHAR(100),
    reference_id TEXT,
    gateway_response JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processed_at TIMESTAMP WITH TIME ZONE
);

-- Table: invoices (Prompt 7.1)
CREATE TABLE IF NOT EXISTS invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    invoice_number VARCHAR(100) UNIQUE,
    invoice_date DATE,
    due_date DATE,
    total_amount NUMERIC(12, 2),
    tax_amount NUMERIC(10, 2),
    discount_amount NUMERIC(10, 2),
    paid_amount NUMERIC(12, 2),
    balance_amount NUMERIC(12, 2),
    payment_status VARCHAR(50),
    invoice_type VARCHAR(100),
    service_details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =================================================================
-- Section 8: Real-time Messaging & Communication (Prompts 8.1 & 8.2)
-- =================================================================

-- Table: conversations (Prompt 8.1)
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_type VARCHAR(50),
    participant_count INTEGER,
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_message_at TIMESTAMP WITH TIME ZONE,
    is_emergency BOOLEAN DEFAULT FALSE,
    conversation_name TEXT
);

-- Table: messages (Prompt 8.1)
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message_type VARCHAR(50),
    content TEXT,
    attachments JSONB,
    reply_to_message_id UUID REFERENCES messages(id) ON DELETE SET NULL,
    is_emergency BOOLEAN DEFAULT FALSE,
    encryption_key TEXT,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    delivered_at TIMESTAMP WITH TIME ZONE,
    read_at TIMESTAMP WITH TIME ZONE
);

-- =================================================================
-- Section 9: Analytics & Reporting System (Prompts 9.1 & 9.2)
-- =================================================================

-- Table: analytics_events (Prompt 9.1)
CREATE TABLE IF NOT EXISTS analytics_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    event_type VARCHAR(100),
    event_category VARCHAR(100),
    event_properties JSONB,
    session_id TEXT,
    device_info JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT
);

-- Table: custom_reports (Prompt 9.1)
CREATE TABLE IF NOT EXISTS custom_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    report_name TEXT,
    report_type VARCHAR(100),
    parameters JSONB,
    schedule VARCHAR(100),
    created_by UUID REFERENCES users(id) ON DELETE SET NULL,
    last_run TIMESTAMP WITH TIME ZONE,
    next_run TIMESTAMP WITH TIME ZONE,
    output_format VARCHAR(50),
    recipients TEXT[]
);

-- =================================================================
-- Section 10: Notification & Alert System (Prompts 10.1 & 10.2)
-- =================================================================

-- Table: notifications (Prompt 10.1)
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    notification_type VARCHAR(100),
    title TEXT,
    message TEXT,
    data_payload JSONB,
    channels TEXT[],
    priority_level VARCHAR(50),
    scheduled_time TIMESTAMP WITH TIME ZONE,
    sent_time TIMESTAMP WITH TIME ZONE,
    delivery_status VARCHAR(50),
    read_at TIMESTAMP WITH TIME ZONE,
    action_taken VARCHAR(100),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- Table: health_alerts (Prompt 10.2)
CREATE TABLE IF NOT EXISTS health_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    alert_type VARCHAR(100),
    severity_level VARCHAR(50),
    threshold_value TEXT,
    current_value TEXT,
    alert_message TEXT,
    triggered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    acknowledged_at TIMESTAMP WITH TIME ZONE,
    escalated_to UUID REFERENCES users(id) ON DELETE SET NULL,
    resolution_time TIMESTAMP WITH TIME ZONE,
    resolution_notes TEXT
);

-- Final message to confirm script completion in logs
\echo 'Coherency database initialization complete with consistent UUID usage.';