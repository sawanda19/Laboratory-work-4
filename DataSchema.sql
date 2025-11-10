-- Фізична схема реляційної бази даних SportLife-Assistant (PostgreSQL)

CREATE TABLE users (
    email VARCHAR(100) PRIMARY KEY,
    password VARCHAR(100) NOT NULL CHECK (LENGTH(password) >= 8),
    registration_date DATE NOT NULL
);

CREATE TABLE enthusiasts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age > 0),
    favorite_sports TEXT,
    user_email VARCHAR(100) REFERENCES users(email) ON DELETE CASCADE
);

CREATE TABLE sport_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50),
    popularity INT CHECK (popularity BETWEEN 1 AND 100)
);

CREATE TABLE sport_rules (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('легкий','середній','складний')),
    updated_at DATE,
    sport_type_id INT REFERENCES sport_types(id) ON DELETE CASCADE
);

CREATE TABLE illustrations (
    id SERIAL PRIMARY KEY,
    url VARCHAR(255) CHECK (url ~* '^https?://'),
    type VARCHAR(50),
    description TEXT,
    rule_id INT REFERENCES sport_rules(id) ON DELETE CASCADE
);

CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    building VARCHAR(10),
    apartment VARCHAR(10),
    entrance INT,
    floor INT,
    user_id INT REFERENCES enthusiasts(id) ON DELETE CASCADE
);

CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    rating FLOAT CHECK (rating BETWEEN 0 AND 5),
    contact_info VARCHAR(100),
    delivery_time VARCHAR(50)
);

CREATE TABLE water_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    category VARCHAR(50),
    supplier_id INT REFERENCES suppliers(id) ON DELETE SET NULL
);

CREATE TABLE water_volumes (
    id SERIAL PRIMARY KEY,
    value FLOAT CHECK (value > 0),
    unit VARCHAR(10) CHECK (unit IN ('л','мл'))
);

CREATE TABLE water_orders (
    order_number VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    delivery_time VARCHAR(20),
    quantity INT CHECK (quantity > 0),
    total_amount FLOAT CHECK (total_amount > 0),
    status VARCHAR(50),
    user_id INT REFERENCES enthusiasts(id) ON DELETE CASCADE,
    address_id INT REFERENCES addresses(id) ON DELETE CASCADE,
    water_type_id INT REFERENCES water_types(id) ON DELETE SET NULL,
    volume_id INT REFERENCES water_volumes(id) ON DELETE SET NULL,
    supplier_id INT REFERENCES suppliers(id) ON DELETE SET NULL
);

CREATE TABLE sport_events (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE,
    location VARCHAR(100),
    status VARCHAR(30)
);

CREATE TABLE chat_rooms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    participant_count INT DEFAULT 0,
    creation_date DATE DEFAULT CURRENT_DATE,
    active BOOLEAN DEFAULT TRUE,
    event_id INT REFERENCES sport_events(id) ON DELETE CASCADE
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    user_id INT REFERENCES enthusiasts(id) ON DELETE CASCADE,
    chat_id INT REFERENCES chat_rooms(id) ON DELETE CASCADE
);
