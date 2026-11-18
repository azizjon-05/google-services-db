
Google Services Database (PostgreSQL)
18 tables: Users, Search, Calendar, Contacts, Location,
Drive, Gmail, YouTube, Subscriptions, Payments, Ads
All data in this project is synthetic.

-- 1. Core table
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

-- 2. Search, Calendar, Contacts, Location
CREATE TABLE Search_History (
    search_entry_id   SERIAL PRIMARY KEY,
    user_id           INT NOT NULL,
    search_query_text TEXT,
    timestamp         TIMESTAMP DEFAULT NOW(),
    result_count      INT,
    clicks_on_results INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

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

CREATE TABLE Contacts (
    contact_entry_id SERIAL PRIMARY KEY,
    user_id          INT NOT NULL,
    contact_user_id  INT,
    name             VARCHAR(150),
    primary_email    VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (contact_user_id) REFERENCES Users(user_id)
);

CREATE TABLE Location_History (
    location_entry_id     SERIAL PRIMARY KEY,
    user_id               INT NOT NULL,
    latitude_decimal      NUMERIC(9,6),
    longitude_decimal     NUMERIC(9,6),
    timestamp             TIMESTAMP DEFAULT NOW(),
    accuracy_radius_meters INT,
    place_name            VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 3. Drive
CREATE TABLE Drive (
    user_id             INT PRIMARY KEY,
    total_storage_quota_bytes BIGINT,
    storage_used_bytes  BIGINT,
    account_type        VARCHAR(30),
    last_synced_at      TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

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

CREATE TABLE Drive_Permissions (
    file_permission_id SERIAL PRIMARY KEY,
    file_id            INT NOT NULL,
    user_id            INT NOT NULL,
    permission_type    VARCHAR(10),
    granted_date       TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (file_id) REFERENCES Drive_Files(file_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 4. Gmail (Gmail_Conversations must be created before Gmail_Emails)
CREATE TABLE Gmail_Conversations (
    conversation_id   SERIAL PRIMARY KEY,
    start_date        TIMESTAMP,
    last_message_date TIMESTAMP
);

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

-- 5. YouTube
CREATE TABLE YouTube_Channels (
    channel_id       SERIAL PRIMARY KEY,
    user_id          INT NOT NULL,
    channel_name     VARCHAR(150),
    description      TEXT,
    subscriber_count INT DEFAULT 0,
    creation_date    TIMESTAMP DEFAULT NOW(),
    profile_image_url TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

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

-- 6. Subscriptions and payments
CREATE TABLE Subscription_Plans (
    plan_id               SERIAL PRIMARY KEY,
    service_name          VARCHAR(100),
    plan_name             VARCHAR(100),
    monthly_price_decimal NUMERIC(10,2),
    features_list         TEXT
);

CREATE TABLE Subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id         INT NOT NULL,
    channel_id      INT,
    service_name    VARCHAR(100),
    plan_id         INT NOT NULL,
    start_date      DATE,
    end_date        DATE,
    next_billing_date DATE,
    status          VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (channel_id) REFERENCES YouTube_Channels(channel_id),
    FOREIGN KEY (plan_id) REFERENCES Subscription_Plans(plan_id)
);

CREATE TABLE Payment_Methods (
    user_payment_method_id SERIAL PRIMARY KEY,
    user_id         INT NOT NULL,
    card_type       VARCHAR(30),
    last_four_digits CHAR(4),
    billing_name    VARCHAR(150),
    expiration_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

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

-- 7. Advertising
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
