--Lists names and addresses of all participants who have registered for more than 2 hours.

SELECT P.Part_Fname, P.Part_Lname, P.Part_City, P.Part_State 
FROM Participant P
JOIN PartRes PR on P.Part_ID = PR.Part_ID
JOIN Reservation R on PR.Res_ID = R.Res_ID
GROUP BY P.Part_ID, P.Part_Fname, P.Part_Lname, P.Part_City, P.Part_State 
HAVING COUNT (DISTINCT R.TOUR_ID) > 2;

--Lists date and departure time for all tours that go to Golden X wreck using subquery

SELECT T.Tour_Date, T.Tour_DepartureTime
FROM Tour T
WHERE T.Site_ID = (SELECT S.Site_ID FROM Site S WHERE S.Site_Name = 'Golden X');

--Listing reservation date, tour date, participant cost and gear cost.

SELECT R.Res_Date AS reservation_date, T.Tour_Date AS tour_date, R.Res_PartCost AS participation_cost, R. Res_GearCost as gear_cost
FROM Reservation R
JOIN Tour T ON R.Tour_ID = T.Tour_ID

--List tours scheduled for July 2012 and date of reservations for tour including those without reservations

SELECT T.Tour_ID, T.Tour_Date AS Tour_Date, R.Res_Date AS Reservation_Date
FROM Tour T
LEFT JOIN Reservation R ON T.Tour_ID = R.Tour_ID
WHERE YEAR(T.Tour_Date) = 2012 AND MONTH (T.Tour_Date) = 7;

--Listing departure date and time for tours whos participants are not from Nebraska
SELECT T.Tour_Date, T.Tour_DepartureTime
FROM Tour T
WHERE NOT EXISTS(SELECT 1 FROM Participant P JOIN PartRes PR ON P.Part_ID = PR.Part_ID WHERE PR.Res_ID = T.Tour_ID AND P.Part_State = 'NE');

--Listing site name, skill level, and name of boat for each tour departing on July 24th, 2012

SELECT S.Site_Name, S.Site_SkillLevel, B.Boat_Name
FROM Tour T
JOIN Site S ON T.Site_ID = S.Site_ID
JOIN Boat B ON T.Boat_ID = B.Boat_ID
Where T.Tour_Date = '2012-07-24';

--Listing all boats that have been used on tours to all sites at 100 ft or greater

SELECT B.Boat_ID, B.Boat_Name
FROM Boat B
WHERE NOT EXISTS(SELECT S.Site_ID FROM Site S WHERE S.Site_Depth >=100 AND S.Site_ID NOT IN(
SELECT T.Site_ID FROM Tour T WHERE T.Boat_ID = B.Boat_ID));

--Creating view that shows each site and date number of tours to site to date

CREATE VIEW CountSiteTours 
AS 
SELECT T.Site_ID, T.Tour_Date, COUNT (T.Tour_ID) AS TourCount
FROM Tour T
Group BY T.Site_ID, T.Tour_Date;

--Listing participant and site visited for anyone who's been on a tour in July 2012

SELECT P.Part_Fname as Participant_first_name, P.Part_Lname as Participant_last_name, S.Site_Name
From Participant P
JOIN PartRes PR ON P.Part_ID = PR.Part_ID
JOIN Reservation R ON PR.Res_ID = R.Res_ID
JOIN Tour T ON R.Tour_ID = T.Tour_ID
JOIN Site S ON T.Site_ID = S.Site_ID
WHERE YEAR(T.Tour_Date) = 2012 AND MONTH (T.Tour_Date) = 7;

--List sites at same skill level with lower base costs

SELECT S1.Site_Name AS site_1, S1.Site_BaseCost AS cost_1, S2.Site_Name AS site_2, S2.Site_BaseCost AS cost_2, S1.Site_SkillLevel AS skill_level
FROM Site S1
JOIN Site S2 ON S1.Site_SkillLevel = S2.Site_SkillLevel
WHERE S1.Site_BaseCost < S2.Site_BaseCost AND S1.Site_ID < S2.Site_ID;

--Calculate total cost for each reservation

SELECT Res_ID, Res_PartCost, Res_GearCost, COALESCE(Res_PartCost, 0) + COALESCE(Res_GearCost, 0) AS TotalCost
From Reservation;

--Listing departure date and site name of tours with more than seven participants or total of more than $230 in reservation participant cost

--Tours with more than seven partiipants
SELECT T.Tour_Date, S.Site_Name
FROM Tour T
JOIN Site S ON T.Site_ID = S.Site_ID
JOIN Reservation R ON T.Tour_ID = R.Tour_ID
JOIN PartRes PR ON R.Res_ID = PR.RES_ID
GROUP BY T.Tour_Date, S.Site_Name
HAVING COUNT(PR.Part_ID) > 7

UNION

--Tours with a total reservation cost of more than $230
SELECT T.Tour_Date, S.Site_Name
FROM Tour T
JOIN Site S ON T.Site_ID = S.Site_ID
JOIN Reservation R ON T.Tour_ID = R.Tour_ID
GROUP BY T.Tour_Date, S.Site_Name
HAVING SUM(R.RES_PartCost) > 230;

--Listing names and capacity of boats that have been used on tours to a site in Giant Kelp Forests

SELECT B.Boat_Name, B.Boat_Capacity
FROM Boat B
WHERE B.Boat_ID IN(SELECT DISTINCT T.Boat_ID FROM Tour T 
WHERE T.Site_ID IN (SELECT S.Site_ID FROM SITE S 
WHERE S.Site_Area = 'Giant Kelp Forests'));

--Listing name of each site name, base cost, and description of cost

SELECT Site_Name, Site_BaseCost,
	CASE
	WHEN Site_BaseCost < 25 THEN 'Inexpensive' WHEN Site_BaseCost BETWEEN 25 AND 40 THEN 'Moderate' WHEN Site_BaseCost >40 THEN 'Expensive'
	ELSE 'Unknown'
	END AS CostDescription FROM Site

--Listing boat name, tour id, date, departure time of most recent tour for each boat

WITH ToursRanked AS (SELECT B.Boat_ID, T.TOUR_ID, T.Tour_Date, T.Tour_DepartureTime, ROW_NUMBER() OVER (PARTITION BY B.Boat_ID ORDER BY T.Tour_Date DESC) As RowNum
FROM Boat B
JOIN Tour T ON B.Boat_ID = T.Boat_ID)
SELECT B.Boat_Name, RT.Tour_ID, RT.Tour_Date, RT.Tour_DepartureTime
FROM Boat B
JOIN ToursRanked RT ON B.Boat_ID = RT.Boat_ID
WHERE RT.RowNum = 1;

--Listing pairs of dive sites that are same depth

SELECT S1.Site_Name AS first_site, S2.Site_Name AS second_site, s1.Site_Depth AS depth
FROM Site S1
JOIN Site S2 ON S1. Site_Depth = S2.Site_Depth
WHERE S1.Site_ID < S2.Site_ID

--Listing name of each participant who made reservation on tour to site over 95 ft in depth

SELECT P.Part_Fname AS participant_first_name, P.Part_Lname as participant_last_name, S.Site_Name, S.Site_Depth
FROM Participant P
JOIN PartRes PR ON P.Part_ID = PR.Part_ID 
JOIN Reservation R ON PR.Res_ID = R.RES_ID 
JOIN Tour T ON R.Tour_ID = T.Tour_ID 
JOIN Site S ON T.Site_ID = S.Site_ID
WHERE S.Site_Depth > 95;

--Listing site, departure date, and boat name for each tour in Wreck Alley and including tours that havent had a boat assigned

SELECT S.Site_Name, T.Tour_Date, B.Boat_Name
From Site S
JOIN Tour T ON S.Site_ID = T.Site_ID
LEFT JOIN Boat B ON T.Boat_ID = B.Boat_ID
WHERE S.Site_Area = 'Wreck Alley';

--Listing names of all participants who registered for tour to Golden X

SELECT Part_Fname AS participant_first_name, Part_Lname AS participant_last_name
From Participant
WHERE Part_ID IN(SELECT Part_ID FROM PartRes
WHERE Res_ID IN(SELECT Res_ID FROM Reservation
WHERE Tour_ID IN(SELECT Tour_ID FROM Tour
WHERE Site_ID =(SELECT Site_ID FROM Site
WHERE Site_Name = 'Golden X'))));

--Listing names of sites visited by more than two large tours

SELECT S.Site_Name, COUNT(DISTINCT T.Tour_ID) AS TourCountLarge
FROM Site S
JOIN Tour T ON S.Site_ID = T.Site_ID
JOIN (SELECT TInner.Tour_ID FROM Tour TInner
JOIN Reservation RInner ON TInner.Tour_ID = RInner.Tour_ID
JOIN PartRes PRInner ON RInner.Res_ID = PRInner.Res_ID
GROUP BY TInner.Tour_ID HAVING COUNT(DISTINCT PRInner.Part_ID) > 10) AS LargeTours ON T.Tour_ID = LargeTours.Tour_ID
Group BY S.Site_Name HAVING COUNT(DISTINCT T.Tour_ID) > 2;










