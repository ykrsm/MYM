SET sql_mode='';
DROP DATABASE IF EXISTS Housing_Lookup;
CREATE DATABASE Housing_Lookup;
USE Housing_Lookup; 
DROP TABLE IF EXISTS RealEstateCompany;
CREATE TABLE RealEstateCompany(
        phoneNumber VARCHAR(20),
        agencyName VARCHAR(30),
        agencyID INT NOT NULL AUTO_INCREMENT,
        PRIMARY KEY(agencyID)
);


DROP TABLE IF EXISTS Agent;
CREATE TABLE Agent (
        agentName VARCHAR(30),
        agencyID INT,
        agentID INT AUTO_INCREMENT,
        FOREIGN KEY(agencyID) REFERENCES RealEstateCompany(agencyID),
        PRIMARY KEY(agentID)
);


DROP TABLE IF EXISTS User;
CREATE TABLE User(
        userName VARCHAR(30),
        phoneNumber VARCHAR(20),
        income INT,
        agentID INT,
        userID INT AUTO_INCREMENT,
        FOREIGN KEY(agentID) REFERENCES Agent(agentID),
        PRIMARY KEY(userID)
);


DROP TABLE IF EXISTS House;
CREATE TABLE House(
        houseType VARCHAR(10),
        street VARCHAR(30),
        city VARCHAR(30),
        state VARCHAR(20),
        year INT,
        cost INT,
        bedroomCount INT,
        bathroomCount INT,
        squareFeet DOUBLE,
        agentID INT,
        houseID INT AUTO_INCREMENT,
        FOREIGN KEY(agentID) REFERENCES Agent(agentID),
        PRIMARY KEY(houseID)
);


DROP TABLE IF EXISTS Appointments;
CREATE TABLE Appointments(
        userID INT,
        agentID INT,
        houseID INT,
        date_time DATETIME,
        updatedAt TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
        appointmentID INT AUTO_INCREMENT,
        FOREIGN KEY(agentID) REFERENCES Agent(agentID),
        FOREIGN KEY(userID) REFERENCES User(userID),
        PRIMARY KEY(appointmentID)
);

DROP TABLE IF EXISTS Archive;
CREATE TABLE Archive(
        userID INT,
        agentID INT,
        houseID INT,
        date_time DATETIME,
        updatedAt TIMESTAMP NOT NULL,
        appointmentID INT NOT NULL,
        PRIMARY KEY(appointmentID)
);

DROP PROCEDURE IF EXISTS archiveInactiveAppointments;
DELIMITER //
CREATE PROCEDURE archiveInactiveAppointments(IN cutoff VARCHAR(50))
BEGIN
        # Insert Appointment data to Archive relation
        INSERT INTO Archive (userID, agentID, houseID, date_time, updatedAt, appointmentID)
                # Find appointments that has not been after cutoff date
                SELECT userID, agentID, houseID, date_time, updatedAt, appointmentID
                FROM Appointments
                WHERE updatedAt < cutoff;
        # Delete archived appointments tuples
        DELETE
        FROM Appointments
        WHERE updatedAt < cutoff;
END//
DELIMITER ;

LOAD DATA LOCAL INFILE '/Users/yk/Code/CS157A/project/mysql/RealEstateCompany.txt' INTO TABLE RealEstateCompany;
LOAD DATA LOCAL INFILE '/Users/yk/Code/CS157A/project/mysql/Agent.txt' INTO TABLE Agent;
LOAD DATA LOCAL INFILE '/Users/yk/Code/CS157A/project/mysql/User.txt' INTO TABLE User;
LOAD DATA LOCAL INFILE '/Users/yk/Code/CS157A/project/mysql/House.txt' INTO TABLE House;
LOAD DATA LOCAL INFILE '/Users/yk/Code/CS157A/project/mysql/Appointments.txt' INTO TABLE Appointments;