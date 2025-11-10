-- Фізична схема реляційної бази даних SportLife-Assistant (PostgreSQL)

CREATE TABLE Users (
    email VARCHAR(100) PRIMARY KEY,
    пароль VARCHAR(100) NOT NULL CHECK (LENGTH(пароль) >= 8),
    дата_реєстрації DATE NOT NULL
);

CREATE TABLE Enthusiasts (
    id SERIAL PRIMARY KEY,
    ім_я VARCHAR(50) NOT NULL,
    вік INT CHECK (вік > 0),
    улюблені_види_спорту TEXT,
    email VARCHAR(100) REFERENCES Users(email)
);

CREATE TABLE SportTypes (
    id SERIAL PRIMARY KEY,
    назва VARCHAR(100) UNIQUE,
    категорія VARCHAR(50),
    популярність INT CHECK (популярність BETWEEN 1 AND 100)
);

CREATE TABLE SportRules (
    id SERIAL PRIMARY KEY,
    текст_пояснення TEXT NOT NULL,
    рівень_складності VARCHAR(20) CHECK (рівень_складності IN ('легкий','середній','складний')),
    дата_оновлення DATE,
    sport_type_id INT REFERENCES SportTypes(id)
);

CREATE TABLE Illustrations (
    id SERIAL PRIMARY KEY,
    URL VARCHAR(255) CHECK (URL ~* '^https?://'),
    тип VARCHAR(50),
    опис TEXT,
    rule_id INT REFERENCES SportRules(id)
);

CREATE TABLE Addresses (
    id SERIAL PRIMARY KEY,
    місто VARCHAR(50) NOT NULL,
    вулиця VARCHAR(50) NOT NULL,
    будинок VARCHAR(10),
    квартира VARCHAR(10),
    підїзд INT,
    поверх INT,
    user_id INT REFERENCES Enthusiasts(id)
);

CREATE TABLE Suppliers (
    id SERIAL PRIMARY KEY,
    назва VARCHAR(100) UNIQUE,
    рейтинг FLOAT CHECK (рейтинг BETWEEN 0 AND 5),
    контактна_інформація VARCHAR(100) CHECK (контактна_інформація ~* '^[A-Za-z0-9@._+-]+$'),
    час_доставки VARCHAR(50)
);

CREATE TABLE WaterTypes (
    id SERIAL PRIMARY KEY,
    назва VARCHAR(50) UNIQUE,
    опис TEXT,
    категорія VARCHAR(50),
    supplier_id INT REFERENCES Suppliers(id)
);

CREATE TABLE WaterVolumes (
    id SERIAL PRIMARY KEY,
    значення FLOAT CHECK (значення > 0),
    одиниця_виміру VARCHAR(10) CHECK (одиниця_виміру IN ('л','мл'))
);

CREATE TABLE WaterOrders (
    номер_замовлення VARCHAR(50) PRIMARY KEY,
    дата_замовлення DATE,
    час_доставки VARCHAR(20),
    кількість INT CHECK (кількість > 0),
    загальна_сума FLOAT CHECK (загальна_сума > 0),
    статус VARCHAR(50),
    user_id INT REFERENCES Enthusiasts(id),
    address_id INT REFERENCES Addresses(id),
    water_type_id INT REFERENCES WaterTypes(id),
    volume_id INT REFERENCES WaterVolumes(id),
    supplier_id INT REFERENCES Suppliers(id)
);

CREATE TABLE SportEvents (
    id SERIAL PRIMARY KEY,
    назва VARCHAR(100) NOT NULL,
    дата_початку DATE,
    місце_проведення VARCHAR(100),
    статус VARCHAR(30)
);

CREATE TABLE ChatRooms (
    id SERIAL PRIMARY KEY,
    назва VARCHAR(100) UNIQUE,
    кількість_учасників INT DEFAULT 0,
    дата_створення DATE,
    активна BOOLEAN DEFAULT TRUE,
    event_id INT REFERENCES SportEvents(id)
);

CREATE TABLE Messages (
    id SERIAL PRIMARY KEY,
    текст TEXT NOT NULL,
    час_відправки TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    прочитано BOOLEAN DEFAULT FALSE,
    user_id INT REFERENCES Enthusiasts(id),
    chat_id INT REFERENCES ChatRooms(id)
);
