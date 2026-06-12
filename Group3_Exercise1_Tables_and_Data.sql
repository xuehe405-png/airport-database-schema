DROP DATABASE IF EXISTS mydb;
CREATE DATABASE mydb;
USE mydb;


-- Create the Terminal table
CREATE TABLE Terminal (
    Terminal_ID INT PRIMARY KEY,          -- Primary Key for Terminal
    Terminal_Building VARCHAR(255) NOT NULL,  -- Building for the terminal
    Security INT NOT NULL                 -- security of the terminal
);

-- Create the Gate table
CREATE TABLE Gate (
    Gate_ID INT PRIMARY KEY,              -- Primary Key for Gate
    Location VARCHAR(255) NOT NULL,       -- Location of the gate
    Status VARCHAR(50) NOT NULL,          -- Status of the gate (e.g., Open, Closed)
    Capacity INT NOT NULL,                -- Capacity of the gate
    Terminal_ID INT NOT NULL,             -- Foreign Key referencing Terminal table
    FOREIGN KEY (Terminal_ID) REFERENCES Terminal(Terminal_ID) -- Relationship to Terminal
);

-- Create the Airline table
CREATE TABLE Airline (
    Airline_ID INT PRIMARY KEY,           -- Primary Key for Airline
    Name VARCHAR(255) NOT NULL,           -- Name of the airline
    Number_of_Aircrafts INT NOT NULL,     -- Total number of aircrafts operated
    Gate_ID INT,                          -- Foreign Key referencing Gate table
    FOREIGN KEY (Gate_ID) REFERENCES Gate(Gate_ID) -- Relationship to Gate
);

-- Create the Aircraft table
CREATE TABLE Aircraft (
    Aircraft_ID INT PRIMARY KEY,         -- Primary Key for Aircraft
    Model VARCHAR(255) NOT NULL,         -- Aircraft model
    Status VARCHAR(50) NOT NULL,         -- Status of the aircraft (e.g., Active, Maintenance)
    Capacity INT NOT NULL,               -- Aircraft capacity
    Airline_ID INT NOT NULL,             -- Foreign Key referencing Airline table
    FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID) -- Relationship to Airline
);


-- Create the FlightCrew table
CREATE TABLE FlightCrew (
    Crew_ID INT PRIMARY KEY,             -- Primary Key for FlightCrew
    Number_of_Participants INT NOT NULL, -- Number of participants in the crew
    Airline_ID INT NOT NULL,             -- Foreign Key referencing the Airline table
    FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID) -- Relationship to Airline
);

-- Create the Pilot table
CREATE TABLE Pilot (
    Pilot_ID INT PRIMARY KEY,            -- Primary Key for Pilot
    Name VARCHAR(255) NOT NULL,          -- Name of the pilot
    Crew_ID INT NOT NULL,                -- Foreign Key referencing the FlightCrew table
    FOREIGN KEY (Crew_ID) REFERENCES FlightCrew(Crew_ID) -- Relationship to FlightCrew
);


-- Create the Customer table
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,         -- Primary Key for Customer
    Email VARCHAR(255) NOT NULL,         -- Email address
    Passport_Number VARCHAR(50) NOT NULL, -- Passport number
    Gender CHAR(1) NOT NULL,             -- Gender (e.g., M/F)
    Date_of_Birth DATE NOT NULL,         -- Date of birth
    Name VARCHAR(255) NOT NULL           -- Name of the customer
);

-- Create the Trip table
CREATE TABLE Trip (
    Trip_ID INT PRIMARY KEY,             -- Unique trip ID
    Origin VARCHAR(255) NOT NULL,        -- Origin of the trip
    Destination VARCHAR(255) NOT NULL    -- Destination of the trip
);


-- Create the Flight table
CREATE TABLE Flight (
    Flight_ID INT PRIMARY KEY,           -- Primary Key for Flight
    Route VARCHAR(255) NOT NULL,         -- Description of the flight route
    DepartureTime DATETIME NOT NULL,     -- Scheduled departure time
    ArrivalTime DATETIME NOT NULL,       -- Scheduled arrival time
    Airline_ID INT NOT NULL,             -- Foreign Key referencing the Airline table
    Trip_ID INT NOT NULL,                -- Foreign Key referencing the Trip table
    FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID), -- Relationship to Airline
    FOREIGN KEY (Trip_ID) REFERENCES Trip(Trip_ID)           -- Relationship to Trip
);


-- Create the Check_In_Counter table
CREATE TABLE Check_In_Counter (
    Counter_ID INT PRIMARY KEY,           -- Primary Key for Check-In Counter
    Location VARCHAR(255) NOT NULL,       -- Location of the counter
    Status VARCHAR(50) NOT NULL,          -- Status of the counter (e.g., Available, Busy)
    Terminal_ID INT NOT NULL,             -- Foreign Key referencing Terminal
    FOREIGN KEY (Terminal_ID) REFERENCES Terminal(Terminal_ID) -- Relationship to Terminal
);


-- Create the Check_In_Personal table
CREATE TABLE Check_In_Personal (
    Employee_ID INT PRIMARY KEY,          -- Primary Key for Check-In Employee
    Name VARCHAR(255) NOT NULL,           -- Name of the employee
    Role VARCHAR(100) NOT NULL,           -- Role of the employee
    Shift_Time VARCHAR(50) NOT NULL,      -- Shift time of the employee
    Counter_ID INT NOT NULL,              -- Foreign Key referencing Check_In_Counter
    FOREIGN KEY (Counter_ID) REFERENCES Check_In_Counter(Counter_ID) -- Relationship to Check-In Counter
);

-- Create the Booking table
CREATE TABLE Booking (
    Booking_ID INT PRIMARY KEY,          -- Primary Key for Booking
    Status VARCHAR(100) NOT NULL,        -- Booking status (e.g., Confirmed, Pending)
    Class VARCHAR(50) NOT NULL,          -- Booking class (e.g., Economy, Business)
    Date DATE NOT NULL,                  -- Booking date
    SeatNumber VARCHAR(10) NOT NULL,     -- Seat assigned to the customer
    Trip_ID INT NOT NULL,                -- Foreign Key referencing Trip table
    Customer_ID INT NOT NULL,            -- Foreign Key referencing Customer table
    Employee_ID INT,             -- Foreign Key referencing Check_In_Personal table
    FOREIGN KEY (Trip_ID) REFERENCES Trip(Trip_ID), -- Relationship to Trip
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID), -- Relationship to Customer
    FOREIGN KEY (Employee_ID) REFERENCES Check_In_Personal(Employee_ID) -- Relationship to Check-In Personal
);


-- Create the Feedback table
CREATE TABLE Feedback (
    Feedback_ID INT PRIMARY KEY,         -- Primary Key for Feedback
    Booking_ID INT UNIQUE NOT NULL,      -- Foreign Key referencing Booking table (one-to-one relationship)
    Customer_ID INT,                     -- Nullable Foreign Key referencing Customer table
    Rating INT ,                 -- Rating given by the customer
    Date DATE NOT NULL,                  -- Date of the feedback
    Comment TEXT,                        -- Optional comment
    FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID), -- Relationship to Booking
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) -- Zero-to-One Relationship to Customer
);

-- Create the Security_Counter table
CREATE TABLE Security_Counter (
    SecurityCounter_ID INT PRIMARY KEY,   -- Primary Key for Security Counter
    Location VARCHAR(255) NOT NULL,       -- Location of the counter
    Status VARCHAR(50) NOT NULL,          -- Status of the counter (e.g., Operational, Maintenance)
    Capacity INT NOT NULL,                -- Capacity of the counter
    Terminal_ID INT NOT NULL,             -- Foreign Key referencing Terminal
    FOREIGN KEY (Terminal_ID) REFERENCES Terminal(Terminal_ID) -- Relationship to Terminal
);

-- Create the Security_Personal table
CREATE TABLE Security_Personal (
    Security_Employee_ID INT PRIMARY KEY,          -- Primary Key for Security Employee
    Name VARCHAR(255) NOT NULL,           -- Name of the employee
    Role VARCHAR(100) NOT NULL,           -- Role of the employee
    Shift_Time VARCHAR(50) NOT NULL,      -- Shift time of the employee
    SecurityCounter_ID INT NOT NULL,      -- Foreign Key referencing Security_Counter
    FOREIGN KEY (SecurityCounter_ID) REFERENCES Security_Counter(SecurityCounter_ID) -- Relationship to Security Counter
);

-- Baggage table with Booking reference
CREATE TABLE Baggage (
    Baggage_ID INT PRIMARY KEY,          -- Primary Key for Baggage
    Weight DECIMAL(10, 2) NOT NULL,      -- Weight of the baggage
    Luggage_Type VARCHAR(50) NOT NULL,   -- Type of luggage (e.g., Checked, Carry-on)
    Baggage_Cargo VARCHAR(255),          -- Additional cargo details
    Customer_ID INT NOT NULL,            -- Foreign Key referencing Customer table
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) -- Relationship to Customer
);


CREATE TABLE Baggage_SecurityPersonal (
    Baggage_ID INT NOT NULL,                  -- Foreign Key referencing Baggage
    Security_Employee_ID INT NOT NULL,                 -- Foreign Key referencing Security_Personal
    Inspection_Date DATE NOT NULL,            -- Additional attribute: Date of inspection
    Notes TEXT,                               -- Additional notes (optional)
    PRIMARY KEY (Baggage_ID, Security_Employee_ID),    -- Composite Primary Key
    FOREIGN KEY (Baggage_ID) REFERENCES Baggage(Baggage_ID), -- Relationship to Baggage
    FOREIGN KEY (Security_Employee_ID) REFERENCES Security_Personal(Security_Employee_ID) -- Relationship to Security_Personal
);





INSERT INTO Terminal (Terminal_ID, Terminal_Building, Security)
VALUES
(1, 'Terminal 1 - International', 30), -- High security for international operations
(2, 'Terminal 2 - Domestic', 10);      -- Medium security for domestic operations


INSERT INTO Gate (Gate_ID, Location, Status, Capacity, Terminal_ID)
VALUES
(1, 'Gate 1A', 'Open', 200, 1),  -- International gate
(2, 'Gate 1B', 'Open', 180, 1),  -- International gate
(3, 'Gate 1C', 'Closed', 220, 1),-- International gate
(4, 'Gate 1D', 'Open', 250, 1),  -- International gate
(5, 'Gate 1E', 'Open', 240, 1),  -- International gate
(6, 'Gate 1F', 'Closed', 300, 1),-- International gate
(7, 'Gate 1G', 'Open', 210, 1),  -- International gate
(8, 'Gate 2A', 'Open', 150, 2),  -- Domestic gate
(9, 'Gate 2B', 'Open', 120, 2),  -- Domestic gate
(10, 'Gate 2C', 'Closed', 180, 2);-- Domestic gate


INSERT INTO Airline (Airline_ID, Name, Number_of_Aircrafts, Gate_ID)
VALUES
-- International gates (Gate_ID 1 to 7)
(1, 'Turkish Airlines', 50, 1),         -- Operates at Gate 1A
(2, 'Emirates', 60, 1),                -- Operates at Gate 1A
(3, 'British Airways', 40, 2),         -- Operates at Gate 1B
(4, 'Qatar Airways', 55, 2),           -- Operates at Gate 1B
(5, 'Singapore Airlines', 35, 3),      -- Operates at Gate 1C
(6, 'Air France', 50, 3),              -- Operates at Gate 1C
(7, 'Lufthansa', 45, 4),               -- Operates at Gate 1D
(8, 'Cathay Pacific', 30, 4),          -- Operates at Gate 1D
(9, 'KLM Royal Dutch Airlines', 25, 5),-- Operates at Gate 1E
(10, 'Etihad Airways', 40, 5),         -- Operates at Gate 1E
(11, 'Swiss International Air Lines', 20, 6), -- Operates at Gate 1F
(12, 'Japan Airlines', 30, 6),         -- Operates at Gate 1F
(13, 'Thai Airways', 28, 7),           -- Operates at Gate 1G
(14, 'Delta Airlines', 35, 7),         -- Operates at Gate 1G
(15, 'Germanwings', 20, 8),            -- Operates at Gate 2A
(16, 'Eurowings', 25, 9),              -- Operates at Gate 2B
(17, 'Air Berlin', 18, 10);            -- Operates at Gate 2C



INSERT INTO Aircraft (Aircraft_ID, Model, Status, Capacity, Airline_ID)
VALUES
-- International airlines (2-5 aircraft per airline)
(1, 'Boeing 777', 'Active', 396, 1),          -- Turkish Airlines
(2, 'Airbus A330', 'Active', 277, 1),         -- Turkish Airlines
(3, 'Boeing 737', 'Active', 215, 1),          -- Turkish Airlines
(4, 'Airbus A380', 'Active', 853, 2),         -- Emirates
(5, 'Boeing 787 Dreamliner', 'Active', 296, 2), -- Emirates
(6, 'Boeing 747', 'Maintenance', 416, 2),     -- Emirates
(7, 'Airbus A350', 'Active', 350, 3),         -- British Airways
(8, 'Boeing 787', 'Active', 296, 3),          -- British Airways
(9, 'Boeing 777', 'Active', 396, 4),          -- Qatar Airways
(10, 'Airbus A320', 'Maintenance', 180, 4),   -- Qatar Airways
(11, 'Airbus A380', 'Active', 853, 4),        -- Qatar Airways
(12, 'Boeing 777', 'Active', 396, 5),         -- Singapore Airlines
(13, 'Boeing 787', 'Active', 296, 5),         -- Singapore Airlines
(14, 'Airbus A320', 'Active', 180, 6),        -- Air France
(15, 'Boeing 737', 'Maintenance', 215, 6),    -- Air France
(16, 'Airbus A320', 'Active', 180, 7),        -- Lufthansa
(17, 'Boeing 737', 'Active', 215, 7),         -- Lufthansa
(18, 'Airbus A350', 'Active', 350, 8),        -- Cathay Pacific
(19, 'Boeing 747', 'Active', 416, 8),         -- Cathay Pacific
(20, 'Boeing 737', 'Active', 215, 9),         -- KLM Royal Dutch Airlines
(21, 'Airbus A320', 'Maintenance', 180, 9),   -- KLM Royal Dutch Airlines
(22, 'Boeing 777', 'Active', 396, 10),        -- Etihad Airways
(23, 'Airbus A350', 'Active', 350, 10),       -- Etihad Airways
(24, 'Boeing 737', 'Active', 215, 11),        -- Swiss International Air Lines
(25, 'Airbus A320', 'Active', 180, 11),       -- Swiss International Air Lines
(26, 'Boeing 787', 'Maintenance', 296, 12),   -- Japan Airlines
(27, 'Airbus A350', 'Active', 350, 12),       -- Japan Airlines
(28, 'Boeing 777', 'Active', 396, 13),        -- Thai Airways
(29, 'Airbus A330', 'Active', 277, 13),       -- Thai Airways
(30, 'Boeing 737', 'Active', 215, 14),        -- Delta Airlines
(31, 'Airbus A320', 'Active', 180, 14),       -- Delta Airlines
(32, 'Airbus A320', 'Active', 180, 15),       -- Germanwings
(33, 'Boeing 737', 'Maintenance', 215, 15),  -- Germanwings
(34, 'Airbus A320', 'Active', 180, 16),       -- Eurowings
(35, 'Boeing 737', 'Active', 215, 16),       -- Eurowings
(36, 'Airbus A319', 'Active', 160, 17),       -- Air Berlin
(37, 'Bombardier CRJ700', 'Active', 78, 17); -- Air Berlin


INSERT INTO FlightCrew (Crew_ID, Number_of_Participants, Airline_ID)
VALUES
-- International airlines (6-10 crew members)
(1, 10, 1),  -- Turkish Airlines
(2, 8, 2),   -- Emirates
(3, 7, 3),   -- British Airways
(4, 9, 4),   -- Qatar Airways
(5, 10, 5),  -- Singapore Airlines
(6, 8, 6),   -- Air France
(7, 7, 7),   -- Lufthansa
(8, 9, 8),   -- Cathay Pacific
(9, 10, 9),  -- KLM Royal Dutch Airlines
(10, 8, 10), -- Etihad Airways
(11, 6, 11), -- Swiss International Air Lines
(12, 7, 12), -- Japan Airlines
(13, 8, 13), -- Thai Airways
(14, 9, 14), -- Delta Airlines
(15, 6, 15), -- Germanwings
(16, 8, 16), -- Eurowings
(17, 7, 17); -- Air Berlin


INSERT INTO Customer (Customer_ID, Email, Passport_Number, Gender, Date_of_Birth, Name)
VALUES
(1, 'john.doe@example.com', 'A12345678', 'M', '1985-06-15', 'John Doe'),
(2, 'jane.smith@example.com', 'B98765432', 'F', '1990-11-20', 'Jane Smith'),
(3, 'mark.lee@example.com', 'C65478921', 'M', '1987-03-05', 'Mark Lee'),
(4, 'alice.brown@example.com', 'D87654321', 'F', '1995-12-10', 'Alice Brown'),
(5, 'david.white@example.com', 'E23456789', 'M', '1993-08-22', 'David White'),
(6, 'sophia.green@example.com', 'F76543210', 'F', '1988-02-14', 'Sophia Green'),
(7, 'chris.black@example.com', 'G34567890', 'M', '1992-01-30', 'Chris Black'),
(8, 'emma.davis@example.com', 'H56789012', 'F', '1996-05-25', 'Emma Davis'),
(9, 'james.wilson@example.com', 'I45678901', 'M', '1989-07-18', 'James Wilson'),
(10, 'olivia.harris@example.com', 'J67890123', 'F', '1994-09-03', 'Olivia Harris'),
(11, 'logan.martin@example.com', 'K78965432', 'M', '1991-04-12', 'Logan Martin'),
(12, 'mia.jackson@example.com', 'L45632178', 'F', '1993-07-25', 'Mia Jackson'),
(13, 'lucas.moore@example.com', 'M12398745', 'M', '1988-11-08', 'Lucas Moore'),
(14, 'sophie.evans@example.com', 'N98712345', 'F', '1995-03-19', 'Sophie Evans'),
(15, 'noah.taylor@example.com', 'O65498712', 'M', '1990-09-15', 'Noah Taylor');


INSERT INTO Pilot (Pilot_ID, Name, Crew_ID)
VALUES
(1, 'John Smith', 1),   -- Global Airlines (Crew 1)
(2, 'Alex Brown', 1),   -- Global Airlines (Crew 1)
(3, 'Jane Doe', 2),     -- Turkish Airlines (Crew 2)
(4, 'Emily Davis', 2),  -- Turkish Airlines (Crew 2)
(5, 'Mark Lee', 3),     -- Emirates (Crew 3)
(6, 'Sarah Miller', 3), -- Emirates (Crew 3)
(7, 'Alice Brown', 4),  -- Lufthansa (Crew 4)
(8, 'Michael Clark', 4),-- Lufthansa (Crew 4)
(9, 'David White', 5),  -- Delta Airlines (Crew 5)
(10, 'Olivia Taylor', 5),-- Delta Airlines (Crew 5)
(11, 'Sophia Green', 6),-- Air France (Crew 6)
(12, 'Ethan Moore', 6), -- Air France (Crew 6)
(13, 'Chris Black', 7), -- Qatar Airways (Crew 7)
(14, 'Mia Rodriguez', 7),-- Qatar Airways (Crew 7)
(15, 'Emma Davis', 8),  -- British Airways (Crew 8)
(16, 'Logan Wilson', 8),-- British Airways (Crew 8)
(17, 'James Wilson', 9),-- KLM (Crew 9)
(18, 'Ava Thomas', 9),  -- KLM (Crew 9)
(19, 'Olivia Harris', 10),-- Etihad Airways (Crew 10)
(20, 'Liam Hall', 10);  -- Etihad Airways (Crew 10)


INSERT INTO Trip (Trip_ID, Origin, Destination)
VALUES
(1, 'Hannover', 'New York'),         -- International trip
(2, 'Hannover', 'Tokyo'),            -- International trip
(3, 'Hannover', 'Dubai'),            -- International trip
(4, 'Hannover', 'Paris'),            -- International trip
(5, 'Hannover', 'Berlin'),           -- Domestic trip
(6, 'Munich', 'Hannover'),           -- Domestic trip
(7, 'Istanbul', 'Hannover'),         -- International trip
(8, 'Johannesburg', 'Hannover'),     -- International trip
(9, 'Hannover', 'Sydney'),           -- International trip
(10, 'Hannover', 'Cairo');           -- International trip



INSERT INTO Flight (Flight_ID, Route, DepartureTime, ArrivalTime, Airline_ID, Trip_ID)
VALUES
-- Trip 1: Hannover to New York (Direct)
(1, 'HAJ-JFK', '2025-01-01 08:00:00', '2025-01-01 18:00:00', 1, 1),

-- Trip 2: Hannover to Tokyo (Via Istanbul)
(2, 'HAJ-IST', '2025-01-02 09:00:00', '2025-01-02 12:00:00', 2, 2),
(3, 'IST-TYO', '2025-01-02 15:00:00', '2025-01-03 10:00:00', 2, 2),

-- Trip 3: Hannover to Dubai (Direct)
(4, 'HAJ-DXB', '2025-01-03 14:00:00', '2025-01-03 20:00:00', 3, 3),

-- Trip 4: Hannover to Paris (Direct)
(5, 'HAJ-CDG', '2025-01-04 08:00:00', '2025-01-04 10:30:00', 4, 4),

-- Trip 5: Hannover to Berlin (Direct)
(6, 'HAJ-BER', '2025-01-05 09:00:00', '2025-01-05 10:15:00', 5, 5),

-- Trip 6: Munich to Hannover (Direct)
(7, 'MUC-HAJ', '2025-01-06 12:00:00', '2025-01-06 13:30:00', 6, 6),

-- Trip 7: Istanbul to Hannover (Direct)
(8, 'IST-HAJ', '2025-01-07 15:00:00', '2025-01-07 18:00:00', 7, 7),

-- Trip 8: Johannesburg to Hannover (Via Addis Ababa)
(9, 'JNB-ADD', '2025-01-08 06:00:00', '2025-01-08 12:00:00', 8, 8),
(10, 'ADD-HAJ', '2025-01-08 14:00:00', '2025-01-08 20:00:00', 8, 8),

-- Trip 9: Hannover to Sydney (Via Singapore)
(11, 'HAJ-SIN', '2025-01-09 07:00:00', '2025-01-09 18:00:00', 9, 9),
(12, 'SIN-SYD', '2025-01-10 08:00:00', '2025-01-10 20:00:00', 9, 9),

-- Trip 10: Hannover to Cairo (Direct)
(13, 'HAJ-CAI', '2025-01-11 09:00:00', '2025-01-11 13:00:00', 10, 10);




INSERT INTO Check_In_Counter (Counter_ID, Location, Status, Terminal_ID)
VALUES
-- International Check-In Counters
(1, 'Zone A - International', 'Available', 1),
(2, 'Zone B - International', 'Busy', 1),
(3, 'Zone C - International', 'Available', 1),
(4, 'Zone D - International', 'Busy', 1),
(5, 'Zone E - International', 'Available', 1),
(6, 'Zone F - International', 'Busy', 1),
(7, 'Zone G - International', 'Available', 1),
(8, 'Zone H - International', 'Busy', 1),
(9, 'Zone A - Domestic', 'Available', 2),
(10, 'Zone B - Domestic', 'Busy', 2),
(11, 'Zone C - Domestic', 'Available', 2);




INSERT INTO Check_In_Personal (Employee_ID, Name, Role, Shift_Time, Counter_ID)
VALUES
(1, 'Alice Johnson', 'Supervisor', '06:00-12:00', 1),
(2, 'Bob Smith', 'Assistant', '12:00-18:00', 1),
(3, 'Charlie Davis', 'Supervisor', '06:00-12:00', 2),
(4, 'Diana Taylor', 'Assistant', '12:00-18:00', 2),
(5, 'Edward Miller', 'Supervisor', '18:00-00:00', 3),
(6, 'Fiona Wilson', 'Assistant', '00:00-06:00', 3),
(7, 'George Brown', 'Supervisor', '18:00-00:00', 4),
(8, 'Hannah Jones', 'Assistant', '00:00-06:00', 4),
(9, 'Ian Clark', 'Supervisor', '06:00-12:00', 5),
(10, 'Jessica Moore', 'Assistant', '12:00-18:00', 5),
(11, 'Kevin White', 'Supervisor', '18:00-00:00', 6),
(12, 'Laura Hall', 'Assistant', '00:00-06:00', 6),
(13, 'Michael Harris', 'Supervisor', '06:00-12:00', 7),
(14, 'Nancy Lee', 'Assistant', '12:00-18:00', 7),
(15, 'Oliver Adams', 'Supervisor', '18:00-00:00', 8),
(16, 'Patricia Johnson', 'Assistant', '00:00-06:00', 8),
(17, 'Quincy Parker', 'Supervisor', '06:00-12:00', 9),
(18, 'Rebecca Evans', 'Assistant', '12:00-18:00', 9),
(19, 'Samuel Walker', 'Supervisor', '18:00-00:00', 10),
(20, 'Tina Hill', 'Assistant', '00:00-06:00', 10),
(21, 'Uma Carter', 'Supervisor', '06:00-12:00', 11),
(22, 'Victor Price', 'Assistant', '12:00-18:00', 11);


INSERT INTO Booking (Booking_ID, Status, Class, Date, SeatNumber, Trip_ID, Customer_ID, Employee_ID)
VALUES
-- Customer 1 traveling on Trip 1 (NYC-LON) with two flights
(1, 'Confirmed', 'Economy', '2025-01-01', '1A', 1, 1, 1),
(2, 'Confirmed', 'Economy', '2025-01-01', '2A', 1, 1, 1),

-- Customer 2 traveling on Trip 2 (PAR-TYO) with two flights
(3, 'Confirmed', 'Business', '2025-01-02', '3B', 2, 2, 2),
(4, 'Confirmed', 'Business', '2025-01-02', '4B', 2, 2, 2),

-- Customer 3 traveling on Trip 3 (MUM-DXB) with one flight
(5, 'Confirmed', 'Economy', '2025-01-03', '5C', 3, 3, 3),

-- Customer 4 traveling on Trip 4 (SYD-SIN) with three flights
(6, 'Confirmed', 'Economy', '2025-01-04', '6D', 4, 4, 4),
(7, 'Confirmed', 'Economy', '2025-01-04', '7D', 4, 4, 4),
(8, 'Confirmed', 'Economy', '2025-01-04', '8D', 4, 4, 4),

-- Customer 5 traveling on Trip 5 (LAX-MEX) with one flight
(9, 'Confirmed', 'Business', '2025-01-05', '9E', 5, 5, 5),

-- Customer 6 traveling on Trip 6 (ROM-CAI) with two flights
(10, 'Confirmed', 'Economy', '2025-01-06', '10F', 6, 6, 6),
(11, 'Confirmed', 'Economy', '2025-01-06', '11F', 6, 6, 6),

-- Customer 7 traveling on Trip 7 (PEK-ICN) with one flight
(12, 'Cancelled', 'Economy', '2025-01-07', '12G', 7, 7, 7),

-- Customer 8 traveling on Trip 8 (JNB-NBO) with two flights
(13, 'Confirmed', 'Economy', '2025-01-08', '13H', 8, 8, 8),
(14, 'Confirmed', 'Economy', '2025-01-08', '14H', 8, 8, 8),

-- Customer 9 traveling on Trip 9 (SVO-BKK) with one flight
(15, 'Confirmed', 'Business', '2025-01-09', '15I', 9, 9, 9),

-- Customer 10 traveling on Trip 10 (YYZ-EZE) with three flights
(16, 'Pending', 'Economy', '2025-01-10', '16J', 10, 10, 10),
(17, 'Pending', 'Economy', '2025-01-10', '17J', 10, 10, 10),
(18, 'Pending', 'Economy', '2025-01-10', '18J', 10, 10, 10),

-- Customer 11 traveling on Trip 1 (NYC-LON) with one flight
(19, 'Confirmed', 'Economy', '2025-01-11', '19A', 1, 11, 1),

-- Customer 12 traveling on Trip 2 (PAR-TYO) with one flight
(20, 'Confirmed', 'Business', '2025-01-12', '20B', 2, 12, 2),

-- Customer 13 traveling on Trip 3 (MUM-DXB) with one flight
(21, 'Confirmed', 'Economy', '2025-01-13', '21C', 3, 13, 3),

-- Customer 14 traveling on Trip 4 (SYD-SIN) with one flight
(22, 'Confirmed', 'Economy', '2025-01-14', '22D', 4, 14, 4),

-- Customer 15 traveling on Trip 5 (LAX-MEX) with one flight
(23, 'Confirmed', 'Business', '2025-01-15', '23E', 5, 15, 5);



INSERT INTO Feedback (Feedback_ID, Booking_ID, Customer_ID, Rating, Date, Comment)
VALUES
(1, 1, 1, 5, '2025-01-02', 'Excellent service, very smooth experience.'), -- John Doe
(2, 2, 2, 4, '2025-01-03', 'Good experience, but could improve meal quality.'), -- Jane Smith
(3, 3, 3, 3, '2025-01-04', 'Average experience, flight was delayed.'), -- Mark Lee
(4, 4, NULL, 5, '2025-01-05', 'Great service, friendly staff!'), -- Anonymous feedback
(5, 5, NULL, 2, '2025-01-06', 'Business class was cramped for the price.'), -- Anonymous feedback
(6, 6, 6, 1, '2025-01-07', 'Lost luggage, poor resolution by the airline.'), -- Sophia Green
(7, 7, NULL, 4, '2025-01-08', 'Comfortable seats, staff were helpful.'), -- Anonymous feedback
(8, 8, 8, 5, '2025-01-09', 'Flight was on time, very pleasant trip.'), -- Emma Davis
(9, 9, 9, 3, '2025-01-10', 'Decent flight, but seat comfort needs improvement.'), -- James Wilson
(10, 10, NULL, 4, '2025-01-11', 'Smooth check-in process and great flight.'), -- Anonymous feedback
(11, 11, 11, 5, '2025-01-12', 'Highly recommended. Great crew!'), -- Michael Adams
(12, 12, NULL, 2, '2025-01-13', 'Flight cancelled, but refund process was smooth.'), -- Anonymous feedback
(13, 13, 13, 4, '2025-01-14', 'Enjoyed the food and entertainment options.'), -- Chris Evans
(14, 14, NULL, 3, '2025-01-15', 'Check-in was quick, but the flight was delayed.'), -- Anonymous feedback
(15, 15, 15, 5, '2025-01-16', 'Amazing experience, will definitely fly again.'); -- Liam Carter

INSERT INTO Security_Counter (SecurityCounter_ID, Location, Status, Capacity, Terminal_ID)
VALUES
-- Terminal 1 (International)
(1, 'Zone A', 'Operational', 300, 1),
(2, 'Zone B', 'Under Maintenance', 250, 1),
(3, 'Zone C', 'Operational', 280, 1),

-- Terminal 2 (Domestic)
(4, 'Zone A', 'Operational', 150, 2),
(5, 'Zone B', 'Operational', 140, 2);


INSERT INTO Security_Personal (Security_Employee_ID, Name, Role, Shift_Time, SecurityCounter_ID)
VALUES
-- Employees for SecurityCounter_ID 1 (Terminal 1 - International, Zone A)
(1, 'Paul Robinson', 'Inspector', '00:00-12:00', 1),
(2, 'Anna Foster', 'Inspector', '00:00-12:00', 1),
(3, 'Chris Taylor', 'Computer Operator', '00:00-12:00', 1),
(4, 'David White', 'Inspector', '12:00-00:00', 1),
(5, 'Laura Hall', 'Inspector', '12:00-00:00', 1),
(6, 'Emma Davis', 'Computer Operator', '12:00-00:00', 1),

-- Employees for SecurityCounter_ID 2 (Terminal 1 - International, Zone B)
(7, 'Brian Graham', 'Inspector', '00:00-12:00', 2),
(8, 'Oliver Adams', 'Inspector', '00:00-12:00', 2),
(9, 'Sophia Green', 'Computer Operator', '00:00-12:00', 2),
(10, 'James Wilson', 'Inspector', '12:00-00:00', 2),
(11, 'Hannah Jones', 'Inspector', '12:00-00:00', 2),
(12, 'Ethan Clark', 'Computer Operator', '12:00-00:00', 2),

-- Employees for SecurityCounter_ID 3 (Terminal 1 - International, Zone C)
(13, 'Isabella Brown', 'Inspector', '00:00-12:00', 3),
(14, 'Michael Harris', 'Inspector', '00:00-12:00', 3),
(15, 'Victor Price', 'Computer Operator', '00:00-12:00', 3),
(16, 'Sophia Evans', 'Inspector', '12:00-00:00', 3),
(17, 'George Brown', 'Inspector', '12:00-00:00', 3),
(18, 'Anna Thompson', 'Computer Operator', '12:00-00:00', 3),

-- Employees for SecurityCounter_ID 4 (Terminal 2 - Domestic, Zone A)
(19, 'John Carter', 'Inspector', '00:00-12:00', 4),
(20, 'Amy Brown', 'Inspector', '00:00-12:00', 4),
(21, 'Liam Parker', 'Computer Operator', '00:00-12:00', 4),
(22, 'Emily Davis', 'Inspector', '12:00-00:00', 4),
(23, 'Noah Black', 'Inspector', '12:00-00:00', 4),
(24, 'Sophia Wilson', 'Computer Operator', '12:00-00:00', 4),

-- Employees for SecurityCounter_ID 5 (Terminal 2 - Domestic, Zone B)
(25, 'Mia Johnson', 'Inspector', '00:00-12:00', 5),
(26, 'Henry Scott', 'Inspector', '00:00-12:00', 5),
(27, 'Ella Brown', 'Computer Operator', '00:00-12:00', 5),
(28, 'Jack Harris', 'Inspector', '12:00-00:00', 5),
(29, 'Lucy White', 'Inspector', '12:00-00:00', 5),
(30, 'Oliver Taylor', 'Computer Operator', '12:00-00:00', 5);



INSERT INTO Baggage (Baggage_ID, Weight, Luggage_Type, Baggage_Cargo, Customer_ID)
VALUES
-- Baggage for Customer 1 (2 items)
(1, 23.50, 'Checked', 'Fragile - Electronics', 1),
(2, 7.20, 'Carry-on', NULL, 1),

-- Baggage for Customer 2 (3 items)
(3, 25.00, 'Checked', 'Oversized', 2),
(4, 8.50, 'Carry-on', NULL, 2),
(5, 6.80, 'Carry-on', 'Small Backpack', 2),

-- Baggage for Customer 3 (1 item)
(6, 22.00, 'Checked', NULL, 3),

-- Baggage for Customer 4 (2 items)
(7, 18.30, 'Checked', 'Sports Equipment', 4),
(8, 7.50, 'Carry-on', NULL, 4),

-- Baggage for Customer 5 (1 item)
(9, 20.00, 'Checked', 'Fragile - Glassware', 5),

-- Baggage for Customer 6 (3 items)
(10, 24.50, 'Checked', NULL, 6),
(11, 8.20, 'Carry-on', NULL, 6),
(12, 5.90, 'Carry-on', 'Laptop Bag', 6),

-- Baggage for Customer 7 (2 items)
(13, 15.00, 'Checked', 'Fragile - Electronics', 7),
(14, 7.80, 'Carry-on', NULL, 7),

-- Baggage for Customer 8 (3 items)
(15, 21.70, 'Checked', 'Oversized', 8),
(16, 8.50, 'Carry-on', NULL, 8),
(17, 5.50, 'Carry-on', 'Handbag', 8),

-- Baggage for Customer 9 (1 item)
(18, 19.90, 'Checked', NULL, 9),

-- Baggage for Customer 10 (2 items)
(19, 23.80, 'Checked', 'Fragile - Electronics', 10),
(20, 8.20, 'Carry-on', NULL, 10),

-- Baggage for Customer 11 (1 item)
(21, 22.50, 'Checked', 'Heavy Tools', 11),

-- Baggage for Customer 12 (3 items)
(22, 17.00, 'Checked', 'Sports Equipment', 12),
(23, 7.50, 'Carry-on', NULL, 12),
(24, 6.20, 'Carry-on', 'Camera Bag', 12),

-- Baggage for Customer 13 (2 items)
(25, 20.30, 'Checked', 'Fragile - Electronics', 13),
(26, 5.90, 'Carry-on', NULL, 13),

-- Baggage for Customer 14 (1 item)
(27, 18.70, 'Checked', NULL, 14),

-- Baggage for Customer 15 (3 items)
(28, 25.00, 'Checked', 'Oversized', 15),
(29, 10.00, 'Carry-on', NULL, 15),
(30, 6.70, 'Carry-on', 'Small Bag', 15);




INSERT INTO Baggage_SecurityPersonal (Baggage_ID, Security_Employee_ID, Inspection_Date, Notes)
VALUES
-- Inspections for Baggage 1
(1, 1, '2025-01-01', 'No issues found'),
(1, 2, '2025-01-01', 'Double-checked electronics'),

-- Inspections for Baggage 2
(2, 3, '2025-01-01', 'Approved for carry-on'),

-- Inspections for Baggage 3
(3, 4, '2025-01-02', 'Oversized baggage inspected and cleared'),
(3, 5, '2025-01-02', 'Additional security clearance performed'),

-- Inspections for Baggage 4
(4, 6, '2025-01-02', 'Carry-on approved without issues'),

-- Inspections for Baggage 5
(5, 7, '2025-01-03', 'Glassware inspected and marked fragile'),
(5, 8, '2025-01-03', 'Extra handling required'),

-- Inspections for Baggage 6
(6, 9, '2025-01-03', 'Routine inspection completed'),

-- Inspections for Baggage 7
(7, 10, '2025-01-04', 'Sports equipment inspected for safety'),
(7, 11, '2025-01-04', 'Additional check for oversized items'),

-- Inspections for Baggage 8
(8, 12, '2025-01-04', 'Approved for carry-on'),

-- Inspections for Baggage 9
(9, 13, '2025-01-05', 'No issues found'),

-- Inspections for Baggage 10
(10, 14, '2025-01-05', 'Routine check completed'),
(10, 15, '2025-01-05', 'Additional check for special handling'),

-- Inspections for Baggage 11
(11, 16, '2025-01-06', 'Electronics inspected and cleared'),

-- Inspections for Baggage 12
(12, 17, '2025-01-06', 'Laptop bag inspected and approved'),

-- Inspections for Baggage 13
(13, 18, '2025-01-07', 'Electronics inspected for safety'),
(13, 19, '2025-01-07', 'Approved after additional inspection'),

-- Inspections for Baggage 14
(14, 20, '2025-01-07', 'Carry-on approved'),

-- Inspections for Baggage 15
(15, 21, '2025-01-08', 'Oversized item inspected and cleared'),
(15, 22, '2025-01-08', 'Routine check completed'),

-- Inspections for Baggage 16
(16, 23, '2025-01-08', 'Carry-on approved without issues'),

-- Inspections for Baggage 17
(17, 24, '2025-01-09', 'Handbag inspected and cleared'),

-- Inspections for Baggage 18
(18, 25, '2025-01-09', 'Routine check completed'),

-- Inspections for Baggage 19
(19, 26, '2025-01-10', 'Electronics inspected and cleared'),

-- Inspections for Baggage 20
(20, 27, '2025-01-10', 'Routine check completed'),

-- Inspections for Baggage 21
(21, 28, '2025-01-11', 'Heavy tools inspected for safety'),

-- Inspections for Baggage 22
(22, 29, '2025-01-11', 'Sports equipment inspected and cleared'),
(22, 30, '2025-01-11', 'Additional safety check'),

-- Inspections for Baggage 23
(23, 1, '2025-01-12', 'Routine check completed'),

-- Inspections for Baggage 24
(24, 2, '2025-01-12', 'Camera bag inspected for sensitive items'),

-- Inspections for Baggage 25
(25, 3, '2025-01-13', 'Electronics inspected for safety'),
(25, 4, '2025-01-13', 'No issues found'),

-- Inspections for Baggage 26
(26, 5, '2025-01-13', 'Routine inspection completed'),

-- Inspections for Baggage 27
(27, 6, '2025-01-14', 'No issues found'),

-- Inspections for Baggage 28
(28, 7, '2025-01-14', 'Oversized item inspected and cleared'),
(28, 8, '2025-01-14', 'Additional handling recommended'),

-- Inspections for Baggage 29
(29, 9, '2025-01-15', 'Carry-on approved'),

-- Inspections for Baggage 30
(30, 10, '2025-01-15', 'Routine check completed without issues');
