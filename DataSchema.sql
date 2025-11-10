-- Фізична схема реляційної бази даних SportLife-Assistant (PostgreSQL)

CREATE TABLE user_accounts (
    user_email VARCHAR(100) PRIMARY KEY,
    user_password VARCHAR(100) NOT NULL
    CHECK (LENGTH(user_password) >= 8),
    registration_date DATE NOT NULL
);

CREATE TABLE enthusiasts (
    enthusiast_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    age INT CHECK (age > 0),
    favorite_sports TEXT,
    user_email VARCHAR(100)
    REFERENCES user_accounts (user_email)
    ON DELETE CASCADE
);

CREATE TABLE sport_types (
    sport_type_id SERIAL PRIMARY KEY,
    sport_name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50),
    popularity INT
        CHECK (popularity BETWEEN 1 AND 100)
);

CREATE TABLE sport_rules (
    rule_id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    difficulty_level VARCHAR(20)
        CHECK (difficulty_level IN ('легкий', 'середній', 'складний')),
    updated_at DATE,
    sport_type_id INT
        REFERENCES sport_types (sport_type_id)
        ON DELETE CASCADE
);

CREATE TABLE illustrations (
    illustration_id SERIAL PRIMARY KEY,
    image_url VARCHAR(255)
        CHECK (image_url ~* '^https?://'),
    image_type VARCHAR(50),
    description TEXT,
    rule_id INT
        REFERENCES sport_rules (rule_id)
        ON DELETE CASCADE
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    building VARCHAR(10),
    apartment VARCHAR(10),
    entrance_number INT,
    floor INT,
    enthusiast_id INT
        REFERENCES enthusiasts (enthusiast_id)
        ON DELETE CASCADE
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) UNIQUE NOT NULL,
    rating FLOAT CHECK (rating BETWEEN 0 AND 5),
    contact_info VARCHAR(100),
    delivery_time VARCHAR(50)
);

CREATE TABLE water_types (
    water_type_id SERIAL PRIMARY KEY,
    water_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    category VARCHAR(50),
    supplier_id INT
        REFERENCES suppliers (supplier_id)
        ON DELETE SET NULL
);

CREATE TABLE water_volumes (
    volume_id SERIAL PRIMARY KEY,
    volume_value FLOAT CHECK (volume_value > 0),
    unit VARCHAR(10)
        CHECK (unit IN ('л', 'мл'))
);

CREATE TABLE water_orders (
    order_number VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    delivery_time VARCHAR(20),
    quantity INT CHECK (quantity > 0),
    total_amount FLOAT CHECK (total_amount > 0),
    status VARCHAR(50),
    enthusiast_id INT
        REFERENCES enthusiasts (enthusiast_id)
        ON DELETE CASCADE,
    address_id INT
        REFERENCES addresses (address_id)
        ON DELETE CASCADE,
    water_type_id INT
        REFERENCES water_types (water_type_id)
        ON DELETE SET NULL,
    volume_id INT
        REFERENCES water_volumes (volume_id)
        ON DELETE SET NULL,
    supplier_id INT
        REFERENCES suppliers (supplier_id)
        ON DELETE SET NULL
);

CREATE TABLE sport_events (
    event_id SERIAL PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    start_date DATE,
    location VARCHAR(100),
    status VARCHAR(30)
);

CREATE TABLE chat_rooms (
    chat_id SERIAL PRIMARY KEY,
    chat_name VARCHAR(100) UNIQUE NOT NULL,
    participant_count INT DEFAULT 0,
    creation_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE,
    event_id INT
        REFERENCES sport_events (event_id)
        ON DELETE CASCADE
);

CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    enthusiast_id INT
        REFERENCES enthusiasts (enthusiast_id)
        ON DELETE CASCADE,
    chat_id INT
        REFERENCES chat_rooms (chat_id)
        ON DELETE CASCADE
);
