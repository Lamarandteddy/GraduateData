--Lists name, city, state of each participant
SELECT PART_FNAME, PART_LNAME PART_CITY, PART_STATE
FROM PARTICIPANT

--Lists names of all sites located in 'Cozumel Reef'
SELECT SITE_NAME
FROM SITE
WHERE SITE_AREA = 'Cozumel Reef';

--Lists name and base cost of each site with base cost less than $30 and principal interest of 'Marine Life'
SELECT SITE_NAME
FROM SITE
WHERE SITE_BASECOST <30 AND SITE_INTEREST = 'Marine Life';

--Lists minimum, maximum, and average depth of sites in 'Wreck Alley'
SELECT MIN(SITE_DEPTH) AS MINIMUM, MAX(SITE_DEPTH) AS MAXIMUM, AVG(SITE_DEPTH) AS AVERAGE 
FROM SITE
WHERE SITE_AREA= 'Wreck Alley';

--Lists total number of sites at each skill level
SELECT SITE_SKILLLEVEL, COUNT(*) AS [Total number of sites]
FROM SITE
GROUP BY SITE_SKILLLEVEL;

--Lists name and depth of site with greatest depth
SELECT TOP 1 SITE_NAME, SITE_DEPTH
FROM SITE
ORDER BY SITE_DEPTH DESC;

--Lists names of sites not visited by tours during July 2012
SELECT SITE_NAME
FROM SITE
WHERE NOT EXISTS(
SELECT 1
FROM TOUR
WHERE SITE_ID = TOUR_ID
AND YEAR (TOUR_DATE) = 2012
AND MONTH (TOUR_DATE) = 7
);

--Lists names of each site with 'Experienced' skill level but with 'Mild' current
SELECT SITE_NAME
FROM SITE
WHERE SITE_SKILLLEVEL = 'Experienced' AND SITE_CURRENT = 'Mild';

--Lists names of site with above average base cost
SELECT SITE_NAME
FROM SITE
WHERE SITE_BASECOST > (SELECT AVG(SITE_BASECOST) FROM SITE);

--Lists names of sites to which no tours were scheduled in July 2012 but with different operation
SELECT SITE_NAME
FROM SITE
WHERE SITE_NAME NOT IN (
	SELECT CONCAT(SITE_ID, TOUR_DATE)
	FROM TOUR
	WHERE YEAR (TOUR_DATE) = 2012 AND MONTH (TOUR_DATE) = 7);