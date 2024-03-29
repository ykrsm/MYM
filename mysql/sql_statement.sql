#1. Create new home, real estate agency, agent, and user.
INSERT INTO RealEstateCompany
        (phoneNumber, agencyName)
        VALUES
        ('(222) 681-9973', 'New Agency');

#2. Modify the existed agent, user, house, and appointment.
UPDATE User
SET userName = 'Updated name'
WHERE userID = 1;

#3. Find agents who can introduce houses that value less than a certain price.
SELECT *
FROM Agent
WHERE agentID IN (
        SELECT agentID
        FROM House
        WHERE cost < 2000
);

#4. Find user who have certain income. [ADMIN]
SELECT userName
FROM User
WHERE User.income BETWEEN 2000 and 3000

# DONE 5. Find addresses of houses that have X bed X bathrooms.
SELECT street, city, state
FROM House 
WHERE bedroomCount = 2
        and bathroomCount = 2;

#6. Find agents who have clients that make over 50K per year.
SELECT Agent.agentID, Agent.agentName, Agent.phoneNumber, User.userName, User.income, User.phoneNumber
FROM Agent, User
WHERE Agent.agentID = User.agentID AND User.income*12 > 50000;

#7. Find the price of houses that belongs to Agency A DO in Agency class
SELECT *
FROM House
WHERE House.agentID IN (
        SELECT agentID
        FROM Agent
        WHERE Agent.agencyID IN (
                SELECT agencyID
                FROM RealEstateCompany
                WHERE RealEstateCompany.agencyName = 'East West Commercial Real Esta' 
        )
);

#8. Delete user, agent, appointment
DELETE FROM User
WHERE userName = 'Luke Mahoney';

#9. Find agency that has houses located in city A. [User]
SELECT *
FROM RealEstateCompany
WHERE agencyID IN (
	SELECT agencyID
	FROM Agent LEFT JOIN House
	ON Agent.agentID = House.agentID
	WHERE city = 'San Francisco'
);

#10. Find agency that has agents who can show houses built before some year. [User]
SELECT *
FROM RealEstateCompany
WHERE agencyID IN (
        SELECT agencyID
        FROM Agent
        WHERE agentID IN (
                SELECT agentID
                FROM House
                WHERE year < 2000
        )
);

#11. Determine if a user can afford a home (check if income is 2x monthly cost). [User]
SELECT houseType, street, city, state, cost, bedroomCount, bathroomCount, squarefeet
FROM House, User
WHERE user.userid = 10 AND income >= 2*house.cost;

#12. Find available/booked appointments. [User/Admin]
SELECT *
FROM Appointments
Where agentID = 8;

#13. Look up my current booked appointments. [User]
SELECT *
FROM Appointments A
WHERE EXISTS (
        SELECT *
        FROM User
        WHERE User.userID = A.userID
                AND User.userID = 2
);

#14. List all the appointment of agents who belong to a certain agency. [User]
SELECT *
FROM Appointments
WHERE agentID IN (
        SELECT agentID
        FROM Agent
        WHERE agencyID IN (
                SELECT agencyID
                FROM RealEstateCompany
                WHERE agencyName = 'Michael Agency'
        )
);

#15. Find houses that has more than certain number of people who are interested [User]
SELECT *
FROM House h
WHERE EXISTS (
	SELECT houseID, COUNT(userName) AS count
	FROM Appointments
	WHERE h.houseID = Appointments.houseID
	GROUP BY houseID
	HAVING count >= 1
)
