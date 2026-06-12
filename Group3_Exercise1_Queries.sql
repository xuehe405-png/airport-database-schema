USE mydb;

-- 1. Query 
SELECT 
    A.Name AS Airline_Name, F.Route AS Flight_Route, T.Origin AS Trip_Origin,
    T.Destination AS Trip_Destination, B.SeatNumber AS Seat_Number, B.Class AS Booking_Class, -- Added column to include the class
    FB.Rating AS Customer_Rating, FB.Comment AS Feedback_Comment
FROM 
    Feedback FB
JOIN 
    Booking B ON FB.Booking_ID = B.Booking_ID
JOIN 
    Trip T ON B.Trip_ID = T.Trip_ID
JOIN 
    Flight F ON T.Trip_ID = F.Trip_ID
JOIN 
    Airline A ON F.Airline_ID = A.Airline_ID
WHERE 
    FB.Rating IS NOT NULL
ORDER BY 
    FB.Rating DESC, FB.Date DESC;
    


-- 2 Query
SELECT 
    SC.SecurityCounter_ID,
    SC.Location AS Counter_Location,
    T.Terminal_Building AS Terminal_Name,
    SP.Shift_Time AS Shift,
    AVG(B.Weight) AS Average_Baggage_Weight,
    COUNT(DISTINCT CASE 
        WHEN BSP.Baggage_ID IN (
            SELECT BSP2.Baggage_ID
            FROM Baggage_SecurityPersonal BSP2
            GROUP BY BSP2.Baggage_ID
            HAVING COUNT(DISTINCT BSP2.Security_Employee_ID) > 1
        ) THEN BSP.Baggage_ID 
        ELSE NULL 
    END) AS Bags_Inspected_By_More_Than_One,
    (
        SELECT 
            SP2.Name
        FROM 
            Security_Personal SP2
        JOIN 
            Baggage_SecurityPersonal BSP2 ON SP2.Security_Employee_ID = BSP2.Security_Employee_ID
        JOIN 
            Baggage B2 ON BSP2.Baggage_ID = B2.Baggage_ID
        WHERE 
            SP2.SecurityCounter_ID = SC.SecurityCounter_ID 
            AND SP2.Shift_Time = SP.Shift_Time
        ORDER BY 
            B2.Weight DESC
        LIMIT 1
    ) AS `Largest Bag Inspected By`
FROM 
    Security_Counter SC
JOIN 
    Terminal T ON SC.Terminal_ID = T.Terminal_ID
LEFT JOIN 
    Security_Personal SP ON SC.SecurityCounter_ID = SP.SecurityCounter_ID
LEFT JOIN 
    Baggage_SecurityPersonal BSP ON SP.Security_Employee_ID = BSP.Security_Employee_ID
LEFT JOIN 
    Baggage B ON BSP.Baggage_ID = B.Baggage_ID
WHERE 
    SP.Shift_Time IN ('00:00-12:00', '12:00-00:00') -- Include valid shifts only
GROUP BY 
    SC.SecurityCounter_ID, 
    SC.Location, 
    T.Terminal_Building, 
    SP.Shift_Time
ORDER BY 
    T.Terminal_Building, SC.SecurityCounter_ID, SP.Shift_Time;

    
    

-- 3 Query
    SELECT
    F.Flight_ID,
    F.Route AS Flight_Route,
    A.Name AS Airline_Name,
    AC.Model AS Aircraft_Model,
    AC.Capacity AS Aircraft_Capacity,
    COUNT(B.Booking_ID) AS Total_Passengers,
    (AC.Capacity - COUNT(B.Booking_ID)) AS Seats_Left,
    FC.Number_of_Participants AS Flight_Crew_Size,
    F.DepartureTime
FROM
    Flight F
JOIN 
    Airline A ON F.Airline_ID = A.Airline_ID
JOIN 
    Aircraft AC ON A.Airline_ID = AC.Airline_ID
LEFT JOIN 
    Booking B ON F.Trip_ID = B.Trip_ID -- Use Trip_ID to join Flight and Booking
LEFT JOIN 
    FlightCrew FC ON A.Airline_ID = FC.Airline_ID -- Join with FlightCrew table using Airline_ID
GROUP BY
    F.Flight_ID, F.Route, A.Name, AC.Model, AC.Capacity, FC.Number_of_Participants, F.DepartureTime
ORDER BY
    F.DepartureTime ASC; -- Sort by departure time in ascending order
