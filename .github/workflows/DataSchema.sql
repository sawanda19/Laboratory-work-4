-- Modified Physical Schema for SportLife-Assistant (PostgreSQL)

CREATE TABLE Users (
    email VARCHAR(100) PRIMARY KEY,
    password VARCHAR(100) NOT NULL CHECK (LENGTH(password) >= 8),
    registration_date DATE NOT NULL
);

CREATE TABLE Enthusiasts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age > 0),
    favorite_sports TEXT,
    email VARCHAR(100) REFERENCES Users(email)
);

CREATE TABLE SportTypes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    category VARCHAR(50),
    popularity INT CHECK (popularity BETWEEN 1 AND 100)
);

CREATE TABLE SportRules (
    id SERIAL PRIMARY KEY,
    explanation_text TEXT NOT NULL,
    difficulty_level VARCHAR(20) CHECK (difficulty_level IN ('easy','medium','hard')),
    update_date DATE,
    sport_type_id INT REFERENCES SportTypes(id)
);

CREATE TABLE Illustrations (
    id SERIAL PRIMARY KEY,
    url VARCHAR(255) CHECK (url ~* '^https?://'),
    type VARCHAR(50),
    description TEXT,
    rule_id INT REFERENCES SportRules(id)
);

CREATE TABLE Addresses (
    id SERIAL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    building VARCHAR(10),
    apartment VARCHAR(10),
    entrance INT,
    floor INT,
    user_id INT REFERENCES Enthusiasts(id)
);

CREATE TABLE Suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    rating FLOAT CHECK (rating BETWEEN 0 AND 5),
    contact_info VARCHAR(100) CHECK (contact_info ~* '^[A-Za-z0-9@._+-]+$'),
    delivery_time VARCHAR(50)
);

CREATE TABLE WaterTypes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    description TEXT,
    category VARCHAR(50),
    supplier_id INT REFERENCES Suppliers(id)
);

CREATE TABLE WaterVolumes (
    id SERIAL PRIMARY KEY,
    value FLOAT CHECK (value > 0),
    unit VARCHAR(10) CHECK (unit IN ('l','ml'))
);

CREATE TABLE WaterOrders (
    order_number VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    delivery_time VARCHAR(20),
    quantity INT CHECK (quantity > 0),
    total_amount FLOAT CHECK (total_amount > 0),
    status VARCHAR(50),
    user_id INT REFERENCES Enthusiasts(id),
    address_id INT REFERENCES Addresses(id),
    water_type_id INT REFERENCES WaterTypes(id),
    volume_id INT REFERENCES WaterVolumes(id),
    supplier_id INT REFERENCES Suppliers(id)
);

CREATE TABLE SportEvents (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE,
    location VARCHAR(100),
    status VARCHAR(30)
);

CREATE TABLE ChatRooms (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    participants_count INT DEFAULT 0,
    creation_date DATE,
    active BOOLEAN DEFAULT TRUE,
    event_id INT REFERENCES SportEvents(id)
);

CREATE TABLE Messages (
    id SERIAL PRIMARY KEY,
    text TEXT NOT NULL,
    send_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read BOOLEAN DEFAULT FALSE,
    user_id INT REFERENCES Enthusiasts(id),
    chat_id INT REFERENCES ChatRooms(id)
);
