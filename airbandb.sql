USE Air_bandb;

-- CREATE TABLE Users (
--     userID INT AUTO_INCREMENT PRIMARY KEY,
--     userName VARCHAR(255) NOT NULL,
--     email VARCHAR(255) NOT NULL UNIQUE,
--     password VARCHAR(255) NOT NULL,
--     createDate TIMESTAMP
-- );

-- CREATE TABLE Properties (
--     propertyID INT AUTO_INCREMENT PRIMARY KEY,
--     userID INT,
--     title VARCHAR(255) NOT NULL,
--     description TEXT,
--     address VARCHAR(255),
--     pricePerNight DECIMAL(10, 2),
--     createDate TIMESTAMP,
--     FOREIGN KEY (userID) REFERENCES Users(userID)
-- );

-- CREATE TABLE Bookings (
--     bookingID INT AUTO_INCREMENT PRIMARY KEY,
--     propertyID INT,
--     userID INT,
--     checkInDate DATE,
--     checkOutDate DATE,
--     totalPrice DECIMAL(10, 2),
--     bookingDate TIMESTAMP,
--     FOREIGN KEY (propertyID) REFERENCES Properties(propertyID),
--     FOREIGN KEY (userID) REFERENCES Users(userID)
-- );

-- CREATE TABLE Reviews (
--     reviewID INT AUTO_INCREMENT PRIMARY KEY,
--     propertyID INT,
--     userID INT,
--     rating INT,
--     comment TEXT,
--     reviewDate TIMESTAMP,
--     FOREIGN KEY (propertyID) REFERENCES Properties(propertyID),
--     FOREIGN KEY (userID) REFERENCES Users(userID)
-- );

-- CREATE TABLE Messages (
--     messageID INT AUTO_INCREMENT PRIMARY KEY,
--     senderID INT,
--     receiverID INT,
--     messageText TEXT,
--     sendDate TIMESTAMP,
--     FOREIGN KEY (senderID) REFERENCES Users(userID),
--     FOREIGN KEY (receiverID) REFERENCES Users(userID)
-- );