-- =====================================================
-- Google Services Database (PostgreSQL)
-- schema_and_data.sql
-- For each of the 18 tables: CREATE TABLE, then 5 sample rows.
-- Tables are ordered so every FOREIGN KEY points to a table
-- that already exists. All data is synthetic.
-- Run once on an empty database.
-- =====================================================


-- =====================================================
-- 1. Users
-- =====================================================
CREATE TABLE Users (
    user_id             SERIAL PRIMARY KEY,
    email               VARCHAR(255) UNIQUE NOT NULL,
    password_hash       VARCHAR(255) NOT NULL,
    created_at          TIMESTAMP DEFAULT NOW(),
    last_login          TIMESTAMP,
    full_name           VARCHAR(150),
    profile_picture_url TEXT,
    locale              VARCHAR(10),
    account_status      VARCHAR(20)
);

INSERT INTO Users (email, password_hash, created_at, last_login, full_name, profile_picture_url, locale, account_status) VALUES
('dilnoza.karimova@example.com', 'fake_hash_user1', '2024-01-15 09:30:00', '2026-11-17 18:20:00', 'Dilnoza Karimova', 'https://example.com/avatars/1.png', 'uz-UZ', 'active'),
('jasur.yusupov@example.com',    'fake_hash_user2', '2024-03-02 14:10:00', '2026-11-16 08:45:00', 'Jasur Yusupov',    'https://example.com/avatars/2.png', 'uz-UZ', 'active'),
('john.smith@example.com',       'fake_hash_user3', '2024-05-21 11:00:00', '2026-10-30 21:05:00', 'John Smith',       'https://example.com/avatars/3.png', 'en-US', 'suspended'),
('olga.petrova@example.com',     'fake_hash_user4', '2024-08-09 16:45:00', '2026-11-18 07:15:00', 'Olga Petrova',     'https://example.com/avatars/4.png', 'ru-RU', 'active'),
('emma.brown@example.com',       'fake_hash_user5', '2025-02-27 10:20:00', '2026-09-12 19:40:00', 'Emma Brown',       'https://example.com/avatars/5.png', 'en-GB', 'deleted');


-- =====================================================
-- 2. Search_History
-- =====================================================
CREATE TABLE Search_History (
    search_entry_id   SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    search_query_text TEXT,
    timestamp         TIMESTAMP DEFAULT NOW(),
    result_count      INT,
    clicks_on_results INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Search_History (user_id, search_query_text, timestamp, result_count, clicks_on_results) VALUES
(1, 'sql window functions',        '2026-11-10 20:15:00', 4520000, 3),
(2, 'weather samarkand',           '2026-11-11 07:30:00', 1280000, 1),
(3, 'cheap flights to istanbul',   '2026-11-12 13:05:00', 9340000, 4),
(4, 'power bi dashboard tutorial', '2026-11-14 18:50:00', 2150000, 2),
(1, 'data analyst jobs',           '2026-11-15 10:25:00', 7800000, 5);


-- =====================================================
-- 3. Calendar_Events
-- =====================================================
CREATE TABLE Calendar_Events (
    event_id     SERIAL PRIMARY KEY,
    user_id      INT NOT NULL,
    title        VARCHAR(255),
    start_time   TIMESTAMP,
    end_time     TIMESTAMP,
    location     VARCHAR(255),
    is_recurring BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Calendar_Events (user_id, title, start_time, end_time, location, is_recurring) VALUES
(1, 'English class',      '2026-11-20 09:00:00', '2026-11-20 10:30:00', 'University',  TRUE),
(2, 'Team meeting',       '2026-11-21 11:00:00', '2026-11-21 11:30:00', 'Online',      TRUE),
(3, 'Dentist appointment','2026-11-22 15:00:00', '2026-11-22 16:00:00', 'Clinic',      FALSE),
(4, 'Project deadline',   '2026-11-25 18:00:00', '2026-11-25 18:30:00', 'Office',      FALSE),
(5, 'Gym session',        '2026-11-23 07:00:00', '2026-11-23 08:00:00', 'Fitness club',TRUE);


-- =====================================================
-- 4. Contacts
-- =====================================================
CREATE TABLE Contacts (
    contact_entry_id SERIAL PRIMARY KEY,
    user_id          INT NOT NULL,
    contact_user_id  INT,
    name             VARCHAR(150),
    primary_email    VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (contact_user_id) REFERENCES Users(user_id)
);

INSERT INTO Contacts (user_id, contact_user_id, name, primary_email) VALUES
(1, 2, 'Jasur Yusupov',   'jasur.yusupov@example.com'),
(1, 4, 'Olga Petrova',    'olga.petrova@example.com'),
(2, 1, 'Dilnoza Karimova','dilnoza.karimova@example.com'),
(3, 5, 'Emma Brown',      'emma.brown@example.com'),
(4, 3, 'John Smith',      'john.smith@example.com');


-- =====================================================
-- 5. Location_History
-- =====================================================
CREATE TABLE Location_History (
    location_entry_id      SERIAL PRIMARY KEY,
    user_id                INT NOT NULL,
    latitude_decimal       NUMERIC(9,6),
    longitude_decimal      NUMERIC(9,6),
    timestamp              TIMESTAMP DEFAULT NOW(),
    accuracy_radius_meters INT,
    place_name             VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Location_History (user_id, latitude_decimal, longitude_decimal, timestamp, accuracy_radius_meters, place_name) VALUES
(1, 39.627000, 66.975000, '2026-11-17 08:00:00', 15, 'Samarkand'),
(2, 41.299500, 69.240100, '2026-11-17 09:30:00', 10, 'Tashkent'),
(3, 39.768100, 64.455600, '2026-11-16 12:15:00', 25, 'Bukhara'),
(4, 40.386400, 71.786400, '2026-11-16 17:40:00', 20, 'Fergana'),
(5, 41.377500, 60.364000, '2026-11-15 14:05:00', 30, 'Khiva');


-- =====================================================
-- 6. Drive (one row per user)
-- =====================================================
CREATE TABLE Drive (
    user_id                   INT PRIMARY KEY,
    total_storage_quota_bytes BIGINT,
    storage_used_bytes        BIGINT,
    account_type              VARCHAR(30),
    last_synced_at            TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Drive (user_id, total_storage_quota_bytes, storage_used_bytes, account_type, last_synced_at) VALUES
(1,   16106127360,    9663676416, 'free',             '2026-11-17 18:00:00'),
(2,  107374182400,   42949672960, 'google_one_100gb', '2026-11-16 08:30:00'),
(3,   16106127360,   14173392076, 'free',             '2026-10-30 21:00:00'),
(4, 2199023255552,  549755813888, 'google_one_2tb',   '2026-11-18 07:10:00'),
(5,   16106127360,    1610612736, 'free',             '2026-09-12 19:30:00');


-- =====================================================
-- 7. Drive_Files
-- =====================================================
CREATE TABLE Drive_Files (
    file_id          SERIAL PRIMARY KEY,
    drive_id         INT NOT NULL,
    drive_user_id    INT NOT NULL,
    file_name        VARCHAR(255),
    file_type        VARCHAR(50),
    file_size_bytes  BIGINT,
    mime_type        VARCHAR(100),
    created_at       TIMESTAMP DEFAULT NOW(),
    last_modified_at TIMESTAMP,
    is_public_link   BOOLEAN DEFAULT FALSE,
    is_shared        BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (drive_id) REFERENCES Drive(user_id),
    FOREIGN KEY (drive_user_id) REFERENCES Users(user_id)
);

INSERT INTO Drive_Files (drive_id, drive_user_id, file_name, file_type, file_size_bytes, mime_type, created_at, last_modified_at, is_public_link, is_shared) VALUES
(1, 1, 'resume.pdf',          'pdf',  245760,    'application/pdf',                                                                 '2026-01-10 10:00:00', '2026-10-05 12:00:00', TRUE,  TRUE),
(1, 1, 'budget_2026.xlsx',    'xlsx', 512000,    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',               '2026-02-14 09:20:00', '2026-11-01 16:45:00', FALSE, TRUE),
(2, 2, 'holiday_photo.jpg',   'jpg',  3145728,   'image/jpeg',                                                                      '2026-07-22 18:30:00', '2026-07-22 18:30:00', FALSE, TRUE),
(3, 3, 'project_slides.pptx', 'pptx', 8388608,   'application/vnd.openxmlformats-officedocument.presentationml.presentation',      '2026-04-03 13:15:00', '2026-09-18 11:00:00', FALSE, TRUE),
(4, 4, 'intro_video.mp4',     'mp4',  157286400, 'video/mp4',                                                                       '2026-06-30 20:00:00', '2026-06-30 20:00:00', TRUE,  TRUE);


-- =====================================================
-- 8. Drive_Permissions
-- =====================================================
CREATE TABLE Drive_Permissions (
    file_permission_id SERIAL PRIMARY KEY,
    file_id            INT NOT NULL,
    user_id            INT NOT NULL,
    permission_type    VARCHAR(10) CHECK (permission_type IN ('read', 'write')),
    granted_date       TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (file_id) REFERENCES Drive_Files(file_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Drive_Permissions (file_id, user_id, permission_type, granted_date) VALUES
(1, 2, 'read',  '2026-10-06 09:00:00'),
(2, 3, 'write', '2026-11-02 10:30:00'),
(3, 1, 'read',  '2026-07-23 08:15:00'),
(4, 5, 'read',  '2026-09-19 14:00:00'),
(5, 2, 'write', '2026-07-01 12:45:00');


-- =====================================================
-- 9. Gmail_Conversations (before Gmail_Emails)
-- =====================================================
CREATE TABLE Gmail_Conversations (
    conversation_id   SERIAL PRIMARY KEY,
    start_date        TIMESTAMP,
    last_message_date TIMESTAMP
);

INSERT INTO Gmail_Conversations (start_date, last_message_date) VALUES
('2026-11-01 09:00:00', '2026-11-03 17:30:00'),
('2026-11-05 11:20:00', '2026-11-05 11:20:00'),
('2026-11-08 19:10:00', '2026-11-09 08:00:00'),
('2026-11-12 07:45:00', '2026-11-12 07:45:00'),
('2026-11-14 15:00:00', '2026-11-16 10:10:00');


-- =====================================================
-- 10. Gmail_Emails
-- =====================================================
CREATE TABLE Gmail_Emails (
    email_id          SERIAL PRIMARY KEY,
    box_id            INT NOT NULL,
    sender_user_id    INT NOT NULL,
    recipient_user_id INT NOT NULL,
    subject           VARCHAR(255),
    body_text         TEXT,
    sent_at           TIMESTAMP DEFAULT NOW(),
    is_read           BOOLEAN DEFAULT FALSE,
    conversation_id   INT,
    FOREIGN KEY (box_id) REFERENCES Users(user_id),
    FOREIGN KEY (sender_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (recipient_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (conversation_id) REFERENCES Gmail_Conversations(conversation_id)
);

INSERT INTO Gmail_Emails (box_id, sender_user_id, recipient_user_id, subject, body_text, sent_at, is_read, conversation_id) VALUES
(2, 1, 2, 'Project update',        'Here is the latest update on our project.',  '2026-11-01 09:00:00', TRUE,  1),
(1, 2, 1, 'Re: Project update',    'Thanks, the numbers look good.',             '2026-11-03 17:30:00', TRUE,  1),
(4, 3, 4, 'Invoice attached',      'Please find the invoice attached.',          '2026-11-05 11:20:00', FALSE, 2),
(1, 5, 1, 'Weekend plans',         'Are you free on Saturday?',                  '2026-11-08 19:10:00', TRUE,  3),
(3, 4, 3, 'Meeting tomorrow',      'Reminder: our meeting is tomorrow at 10:00.','2026-11-12 07:45:00', FALSE, 4);


-- =====================================================
-- 11. YouTube_Channels
-- =====================================================
CREATE TABLE YouTube_Channels (
    channel_id        SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    channel_name      VARCHAR(150),
    description       TEXT,
    subscriber_count  INT DEFAULT 0,
    creation_date     TIMESTAMP DEFAULT NOW(),
    profile_image_url TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO YouTube_Channels (user_id, channel_name, description, subscriber_count, creation_date, profile_image_url) VALUES
(1, 'Dilnoza Cooking',     'Uzbek home recipes',            125000, '2024-02-01 10:00:00', 'https://example.com/channels/1.png'),
(2, 'Jasur Tech Talks',    'Gadget reviews and tutorials',   48200, '2024-04-10 12:00:00', 'https://example.com/channels/2.png'),
(3, 'John Travel Vlogs',   'Travel stories from Asia',       9300, '2024-06-18 15:30:00', 'https://example.com/channels/3.png'),
(4, 'Olga Music Studio',   'Piano covers and lessons',      310500, '2024-09-05 09:45:00', 'https://example.com/channels/4.png'),
(5, 'Emma Fitness Daily',  'Home workouts for everyone',     76400, '2025-03-12 08:00:00', 'https://example.com/channels/5.png');


-- =====================================================
-- 12. YouTube_Videos
-- =====================================================
CREATE TABLE YouTube_Videos (
    video_id         SERIAL PRIMARY KEY,
    channel_id       INT NOT NULL,
    title            VARCHAR(255),
    description      TEXT,
    uploaded_date    TIMESTAMP DEFAULT NOW(),
    view_count       BIGINT DEFAULT 0,
    duration_seconds INT,
    category_id      INT,
    is_private       BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (channel_id) REFERENCES YouTube_Channels(channel_id)
);

INSERT INTO YouTube_Videos (channel_id, title, description, uploaded_date, view_count, duration_seconds, category_id, is_private) VALUES
(1, 'How to cook perfect plov',     'Step-by-step plov recipe',         '2025-01-20 10:00:00', 1520000, 845,  26, FALSE),
(1, 'Samsa in 30 minutes',          'Quick samsa recipe',               '2025-05-11 11:30:00',  640000, 612,  26, FALSE),
(2, 'Top 10 phones of the year',    'Our ranking of the best phones',   '2025-09-02 14:00:00',  210000, 1130, 28, FALSE),
(2, 'Unboxing: new laptop',         'First look at the new laptop',     '2026-02-14 16:20:00',   89000, 540,  28, TRUE),
(3, 'Vlog: 7 days in Samarkand',    'A week exploring Samarkand',       '2025-10-08 09:15:00',   34000, 1420, 19, FALSE);


-- =====================================================
-- 13. YouTube_Comments (replies point to an earlier comment)
-- =====================================================
CREATE TABLE YouTube_Comments (
    comment_id        SERIAL PRIMARY KEY,
    video_id          INT NOT NULL,
    user_id           INT NOT NULL,
    parent_comment_id INT,
    comment_text      TEXT,
    created_at        TIMESTAMP DEFAULT NOW(),
    likes_count       INT DEFAULT 0,
    FOREIGN KEY (video_id) REFERENCES YouTube_Videos(video_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (parent_comment_id) REFERENCES YouTube_Comments(comment_id)
);

INSERT INTO YouTube_Comments (video_id, user_id, parent_comment_id, comment_text, created_at, likes_count) VALUES
(1, 2, NULL, 'Great video, thanks for sharing!',     '2025-01-21 08:00:00', 42),
(3, 1, NULL, 'Very helpful comparison.',             '2025-09-03 12:30:00', 17),
(2, 4, NULL, 'Can you make a part 2?',               '2025-05-12 19:45:00', 9),
(1, 1, 1,    'Thank you, glad you liked it!',        '2025-01-21 10:15:00', 5),
(3, 3, 2,    'Agree, the battery test was useful.',  '2025-09-04 07:20:00', 2);


-- =====================================================
-- 14. Subscription_Plans
-- =====================================================
CREATE TABLE Subscription_Plans (
    plan_id               SERIAL PRIMARY KEY,
    service_name          VARCHAR(100),
    plan_name             VARCHAR(100),
    monthly_price_decimal NUMERIC(10,2),
    features_list         TEXT
);

INSERT INTO Subscription_Plans (service_name, plan_name, monthly_price_decimal, features_list) VALUES
('YouTube Premium', 'Individual',     13.99, 'Ad-free, background play, downloads'),
('YouTube Premium', 'Family',         22.99, 'Individual features for up to 5 members'),
('Google One',      'Basic 100 GB',    1.99, '100 GB storage'),
('Google One',      'Standard 200 GB', 2.99, '200 GB storage'),
('Google One',      'Premium 2 TB',    9.99, '2 TB storage, VPN');


-- =====================================================
-- 15. Subscriptions
-- =====================================================
CREATE TABLE Subscriptions (
    subscription_id   SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    channel_id        INT,
    service_name      VARCHAR(100),
    plan_id           INT NOT NULL,
    start_date        DATE,
    end_date          DATE,
    next_billing_date DATE,
    status            VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (channel_id) REFERENCES YouTube_Channels(channel_id),
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id)
);

INSERT INTO Subscriptions (user_id, channel_id, service_name, plan_id, start_date, end_date, next_billing_date, status) VALUES
(1, NULL, 'YouTube Premium', 1, '2025-01-10', NULL,         '2026-12-10', 'active'),
(2, NULL, 'Google One',      3, '2025-03-01', NULL,         '2026-12-01', 'active'),
(3, 1,    'YouTube Premium', 2, '2025-06-15', '2026-06-15', NULL,         'cancelled'),
(4, NULL, 'Google One',      5, '2024-11-20', '2025-11-20', NULL,         'expired'),
(5, NULL, 'Google One',      4, '2026-02-01', NULL,         '2026-12-01', 'active');


-- =====================================================
-- 16. Payment_Methods
-- =====================================================
CREATE TABLE Payment_Methods (
    user_payment_method_id SERIAL PRIMARY KEY,
    user_id                INT NOT NULL,
    card_type              VARCHAR(30),
    last_four_digits       CHAR(4),
    billing_name           VARCHAR(150),
    expiration_date        DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Payment_Methods (user_id, card_type, last_four_digits, billing_name, expiration_date) VALUES
(1, 'Visa',       '4417', 'Dilnoza Karimova', '2028-05-31'),
(2, 'Humo',       '2290', 'Jasur Yusupov',    '2027-09-30'),
(3, 'Mastercard', '8836', 'John Smith',       '2027-02-28'),
(4, 'Uzcard',     '1054', 'Olga Petrova',     '2029-01-31'),
(5, 'Visa',       '7761', 'Emma Brown',       '2028-11-30');


-- =====================================================
-- 17. Payments
-- =====================================================
CREATE TABLE Payments (
    payment_id             SERIAL PRIMARY KEY,
    user_id                INT NOT NULL,
    subscription_id        INT,
    user_payment_method_id INT,
    payment_amount_decimal NUMERIC(12,2),
    currency_code          CHAR(3),
    payment_date           TIMESTAMP DEFAULT NOW(),
    payment_method_type    VARCHAR(30),
    payment_transaction_id VARCHAR(100) UNIQUE,
    payment_status         VARCHAR(20),
    billing_address        TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (subscription_id) REFERENCES Subscriptions(subscription_id),
    FOREIGN KEY (user_payment_method_id) REFERENCES Payment_Methods(user_payment_method_id)
);

INSERT INTO Payments (user_id, subscription_id, user_payment_method_id, payment_amount_decimal, currency_code, payment_date, payment_method_type, payment_transaction_id, payment_status, billing_address) VALUES
(1, 1, 1, 13.99, 'USD', '2026-11-10 10:05:00', 'Visa',       'TXN-00000001', 'success',  'Street 12, Samarkand'),
(2, 2, 2,  1.99, 'USD', '2026-11-01 08:30:00', 'Humo',       'TXN-00000002', 'success',  'Street 45, Tashkent'),
(3, 3, 3, 22.99, 'USD', '2026-05-15 14:10:00', 'Mastercard', 'TXN-00000003', 'success',  'Street 7, Bukhara'),
(4, 4, 4,  9.99, 'USD', '2025-10-20 09:00:00', 'Uzcard',     'TXN-00000004', 'refunded', 'Street 101, Fergana'),
(5, 5, 5,  2.99, 'USD', '2026-11-01 12:00:00', 'Visa',       'TXN-00000005', 'failed',   'Street 3, Khiva');


-- =====================================================
-- 18. Ad_Campaigns
-- =====================================================
CREATE TABLE Ad_Campaigns (
    campaign_id       SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    campaign_name     VARCHAR(150),
    budget_decimal    NUMERIC(12,2),
    start_date        DATE,
    end_date          DATE,
    total_clicks      INT DEFAULT 0,
    total_impressions INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Ad_Campaigns (user_id, campaign_name, budget_decimal, start_date, end_date, total_clicks, total_impressions) VALUES
(1, 'Summer Sale',      1500.00, '2026-06-01', '2026-08-31', 8420,  310000),
(2, 'Back to School',   2500.00, '2026-08-15', '2026-09-30', 12950, 540000),
(3, 'New Year Promo',    800.00, '2026-12-15', '2027-01-10', 0,     0),
(4, 'Product Launch',  10000.00, '2026-09-01', '2026-11-30', 45300, 1850000),
(5, 'Brand Awareness',  3200.00, '2026-10-01', '2026-12-31', 6100,  720000);
