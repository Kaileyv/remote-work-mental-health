-- DATA CLEANING
# 1 - Remove Duplicates
# 2 - Standardize Data
# 3 - Null/Blank Values
# 4 - Remove Columns

SELECT * FROM remote_mental;

# create staging table
CREATE TABLE remote_mental1
LIKE remote_mental;

# insert data from original table into staging table 
INSERT remote_mental1
SELECT * FROM remote_mental;

SELECT * FROM remote_mental1;


-- 1. Remove Duplicates 
# create row_num col to identify duplicate rows
# create cte to see if any row_num > 1, indicating duplicate rows
WITH duplicate_row_cte AS
(
	SELECT *, ROW_NUMBER() OVER(PARTITION BY Employee_ID, Age, Gender, Job_Role, Industry, Years_of_Experience, 
	Work_Location, Hours_Worked_Per_Week, Number_of_Virtual_Meetings, Work_Life_Balance_Rating, Stress_Level,
	Mental_Health_Condition, Access_to_Mental_Health_Resources, Productivity_Change, Social_Isolation_Rating,
	Satisfaction_With_Remote_Work, Company_Support_for_Remote_Work, Physical_Activity, Sleep_Quality, Region) AS row_num
	FROM remote_mental1
)
SELECT * FROM duplicate_row_cte
WHERE row_num > 1;
# output: no duplicate rows!


-- 2. Standardize Data
# review every column to see if any outstanding issues 
SELECT DISTINCT Region
FROM remote_mental1
ORDER BY Region;
# output: no outstanding issues!


-- 3. Null/Blank Values
SELECT DISTINCT Mental_Health_Condition
FROM remote_mental1;
# output: no null/blank values!


-- 4. Remove Columns
# no unnecessary columns to remove!


-- EXPLORATORY DATA ANALYSIS

SELECT DISTINCT Job_Role
FROM remote_mental1
ORDER BY Job_Role;

SELECT *
FROM remote_mental1;

#0 what percentage of remote workers have mental health conditions?
# 75.5% of remote workers have mental health conditions, globally
WITH remote_mental_count AS (
SELECT COUNT(Mental_Health_Condition) Count, Work_Location
FROM remote_mental1
WHERE Mental_Health_Condition != 'None' AND Work_Location = 'Remote'
GROUP BY Work_Location
),
remote_mental_total AS (
	SELECT COUNT(Mental_Health_Condition) AS Total, Work_Location
	FROM remote_mental1
    WHERE Work_Location = 'Remote'
	GROUP BY Work_Location
)
SELECT Count, Total, Count/Total percent
FROM remote_mental_count
JOIN remote_mental_total
	ON remote_mental_count.Work_Location = remote_mental_total.Work_Location
GROUP BY remote_mental_count.Work_Location;


#1 Count how many people experience each mental health condition, pretty evenly distributed
SELECT COUNT(Mental_Health_Condition), Mental_Health_Condition
FROM remote_mental1
WHERE Mental_Health_Condition != 'None'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition) DESC;

#2 Count of mental health conditions for each age
WITH age_cte AS (
SELECT COUNT(Mental_Health_Condition), Age, Mental_Health_Condition
FROM remote_mental1
WHERE Mental_Health_Condition != 'None'
GROUP BY Age, Mental_Health_Condition
ORDER BY Age
)
SELECT SUM(`COUNT(Mental_Health_Condition)`) AS Mental_Health_Condition_Count, Age
FROM age_cte
GROUP BY Age
ORDER BY Age;

#3 Count of mental health conditions for each region
WITH cte AS (
	SELECT COUNT(Mental_Health_Condition), Region, Mental_Health_Condition
	FROM remote_mental1
	WHERE Mental_Health_Condition != 'None'
	GROUP BY Region, Mental_Health_Condition
	ORDER BY Region
)
SELECT SUM(`COUNT(Mental_Health_Condition)`) AS Mental_Health_Condition_Count, Region FROM cte
GROUP BY Region
ORDER BY SUM(`COUNT(Mental_Health_Condition)`);

#3a Percentage of each region with mental health conditions
WITH region_count AS (
SELECT COUNT(Mental_Health_Condition), Region, Mental_Health_Condition
FROM remote_mental1
WHERE Mental_Health_Condition != 'None'
GROUP BY Region, Mental_Health_Condition
ORDER BY Region
),
region_total AS (
	SELECT COUNT(Mental_Health_Condition) AS total, Region
	FROM remote_mental1
	GROUP BY Region
)
SELECT SUM(`COUNT(Mental_Health_Condition)`) count, region_total.total total, SUM(`COUNT(Mental_Health_Condition)`)/region_total.total percent, region_total.Region
FROM region_count
JOIN region_total
	ON region_count.Region = region_total.Region
GROUP BY Region
ORDER BY percent;

#3b count of mental health conditions for work location types in Asia (region with largest percentage of mental health conditions)
SELECT Work_Location, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Region = 'Asia' AND Mental_Health_Condition != 'None'
GROUP BY Work_Location
ORDER BY COUNT(Mental_Health_Condition);

#3c Percentage of remote workers with mental health conditions per region
# Europe has the largest % of remote workers with mental health conditions
# North America has the smallest % of remote workers with mental health conditions
WITH region_count AS (
SELECT COUNT(Mental_Health_Condition), Region, Mental_Health_Condition
FROM remote_mental1
WHERE Mental_Health_Condition != 'None' AND Work_Location = 'Remote'
GROUP BY Region, Mental_Health_Condition
ORDER BY Region
),
region_total AS (
	SELECT COUNT(Mental_Health_Condition) AS total, Region
	FROM remote_mental1
    WHERE Work_Location = 'Remote'
	GROUP BY Region
)
SELECT SUM(`COUNT(Mental_Health_Condition)`) count, region_total.total total, SUM(`COUNT(Mental_Health_Condition)`)/region_total.total percent, region_total.Region
FROM region_count
JOIN region_total
	ON region_count.Region = region_total.Region
GROUP BY Region
ORDER BY percent;

#3d count of mental health conditions for remote work, grouped by region
# Asia has largest count of remote workers with mental health conditions
# North America has smallest count of remote workers with mental health conditions
SELECT Region, COUNT(Mental_Health_Condition) FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None'
GROUP BY Region
ORDER BY COUNT(Mental_Health_Condition);

#3e count of mental health conditions for remote work in Europe, grouped by industry
# Europe has the largest % of remote workers with mental health conditions
# Manufacturing has the most mental health conditions (IT has largest % of people with mental health conditions in remote work overall)
# Finance has the least mental health conditions
SELECT Industry, COUNT(Mental_Health_Condition) FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None' AND Region = 'Europe'
GROUP BY Industry
ORDER BY COUNT(Mental_Health_Condition);

#3f count of mental health conditions for remote work in North America, grouped by industry
# North America has the smallest % of remote workers with mental health conditions
# Finance has the most mental health conditions (Finance has smallest % of people with mental health conditions in remote work overall)
# Consulting has the least mental health conditions
SELECT Industry, COUNT(Mental_Health_Condition) FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None' AND Region = 'North America'
GROUP BY Industry
ORDER BY COUNT(Mental_Health_Condition);

#3g count of mental health conditions for remote work in Europe, grouped by job roles
# Europe has the largest % of remote workers with mental health conditions
# Data Scientist has the most mental health conditions (Data Science has largest % of people with mental health conditions in remote work overall)
# Marketing has the least mental health conditions
SELECT Job_Role, COUNT(Mental_Health_Condition) FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None' AND Region = 'Europe'
GROUP BY Job_Role
ORDER BY COUNT(Mental_Health_Condition);

#3h count of mental health conditions for remote work in North America, grouped by job roles
# North America has the least mental health conditions for remote work
# HR has the most mental health conditions 
# Marketing has the least mental health conditions (Marketing has smallest % of people with mental health conditions in remote work overall)
SELECT Job_Role, COUNT(Mental_Health_Condition) FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None' AND Region = 'North America'
GROUP BY Job_Role
ORDER BY COUNT(Mental_Health_Condition);

#4a Count of mental health conditions, avg work balance rating, and avg hours worked per week for each work location type
WITH loc_cte AS (
SELECT Work_Location, AVG(Work_Life_Balance_Rating), AVG(Hours_Worked_Per_Week), COUNT(Mental_Health_Condition), Mental_Health_Condition
FROM remote_mental1
WHERE Mental_Health_Condition != 'None'
GROUP BY Work_Location, Mental_Health_Condition
ORDER BY Work_Location
)
SELECT SUM(`COUNT(Mental_Health_Condition)`), Work_Location, AVG(`AVG(Work_Life_Balance_Rating)`), AVG(`AVG(Hours_Worked_Per_Week)`) FROM loc_cte
GROUP BY Work_Location;

#4b satisfaction regarding remote work, about 1660 for each category
SELECT Satisfaction_with_Remote_Work, COUNT(Satisfaction_with_Remote_Work) FROM remote_mental1
GROUP BY Satisfaction_with_Remote_Work;

#5 percentage of mental health conditions for each gender group, about 75% for each group
WITH gender_cte AS (
SELECT COUNT(Mental_Health_Condition), Gender, Mental_Health_Condition
FROM remote_mental1
WHERE Mental_Health_Condition != 'None'
GROUP BY Gender, Mental_Health_Condition
ORDER BY Gender
),
gender_total AS (
	SELECT COUNT(Mental_Health_Condition) AS total, Gender
	FROM remote_mental1
	GROUP BY Gender
)
SELECT SUM(`COUNT(Mental_Health_Condition)`)/gender_total.total, gender_total.Gender
FROM gender_cte
JOIN gender_total
	ON gender_cte.Gender = gender_total.Gender
GROUP BY Gender;

#6 count of mental health conditions for remote workers
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition), AVG(Work_Life_Balance_Rating), Work_Location
FROM remote_mental1
WHERE Work_Location = 'Remote'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition);

SELECT * FROM remote_mental1;

#7 REMOTE + ANXIETY(#1 mental health condition for remote workers)
#7a INDUSTRY with most and least number of people who work remote with anxiety
SELECT Industry, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Anxiety' AND Work_Location = 'Remote'
GROUP BY Industry
ORDER BY COUNT(Job_Role) ASC;
# most - Retail
# least - Healthcare

#7b JOB ROLES with most and least number of people who work remote with anxiety
SELECT Job_Role, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Anxiety' AND Work_Location = 'Remote'
GROUP BY Job_Role
ORDER BY COUNT(Job_Role) ASC;
# most - Sales
# least - Marketing


#8 REMOTE + BURNOUT(#2 mental health condition for remote workers)
#8a INDUSTRY with most and least number of people who work remote with burnout
SELECT Industry, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Burnout' AND Work_Location = 'Remote'
GROUP BY Industry
ORDER BY COUNT(Job_Role) DESC;
# most - Finance
# least - Consulting

#8b JOB ROLES with most and least number of people who work remote with burnout
SELECT Job_Role, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Burnout' AND Work_Location = 'Remote'
GROUP BY Job_Role
ORDER BY COUNT(Job_Role) ASC;
# most - Data Scientist
# least - Sales

#9 REMOTE + DEPRESSION (#3 mental health condition for remote workers)
#9a INDUSTRY with most and least number of people who work remote with depression
SELECT Industry, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Depression' AND Work_Location = 'Remote'
GROUP BY Industry
ORDER BY COUNT(Job_Role) DESC;
# most - Healthcare
# least - Finance

#9b JOB ROLES with most and least number of people who work remote with depression
SELECT Job_Role, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Depression' AND Work_Location = 'Remote'
GROUP BY Job_Role
ORDER BY COUNT(Job_Role) ASC;
# most - HR
# least - Marketing/Sales


#10 REMOTE + NONE
#10a INDUSTRY with most and least number of people who work remote with no mental health conditions
SELECT Industry, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'None' AND Work_Location = 'Remote'
GROUP BY Industry
ORDER BY COUNT(Job_Role) DESC;
# most - Finance
# least - IT

#10b JOB ROLES with most and least number of people who work remote with no mental health conditions
SELECT Job_Role, COUNT(Job_Role)
FROM remote_mental1
WHERE Mental_Health_Condition = 'None' AND Work_Location = 'Remote'
GROUP BY Job_Role
ORDER BY COUNT(Job_Role) ASC;
# most - Marketing
# least - Data Scientist

#11a remote + industry - count mental health conditions for remote workers, grouped by industry
# highest count - retail
# lowest count - consulting
SELECT industry, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None'
GROUP BY industry
ORDER BY COUNT(Mental_Health_Condition);

#11b remote + job roles - count mental health conditions for remote workers, grouped by job roles
# highest count - data scientist
# lowest count - marketing
SELECT Job_Role, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None'
GROUP BY Job_Role
ORDER BY COUNT(Mental_Health_Condition);


#12a percentage of each industry with mental health conditions (remote)
WITH total_cte AS (
	SELECT Industry, COUNT(Mental_Health_Condition) AS total
	FROM remote_mental1
    WHERE Work_Location = 'Remote'
    GROUP BY Industry
),
count_cte AS (
	SELECT Industry, COUNT(Mental_Health_Condition) AS count
	FROM remote_mental1
	WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None'
    GROUP BY Industry
)
SELECT total_cte.Industry, count_cte.count count, total_cte.total total, count_cte.count/total_cte.total AS condition_percent
FROM total_cte JOIN count_cte
	ON total_cte.Industry = count_cte.Industry
ORDER BY condition_percent DESC;
# largest % - IT
# smallest % - Finance
# despite retail having highest count of mental health conditions, IT has largest % of mental health conditions for overall remote workers


#12b percentage of each job role with mental health conditions (remote)
WITH total_cte AS (
	SELECT Job_Role, COUNT(Mental_Health_Condition) AS total
	FROM remote_mental1
    WHERE Work_Location = 'Remote'
    GROUP BY Job_Role
),
count_cte AS (
	SELECT Job_Role, COUNT(Mental_Health_Condition) AS count
	FROM remote_mental1
	WHERE Work_Location = 'Remote' AND Mental_Health_Condition != 'None'
    GROUP BY Job_Role
)
SELECT total_cte.Job_Role, count_cte.count count, total_cte.total total, count_cte.count/total_cte.total AS condition_percent
FROM total_cte JOIN count_cte
	ON total_cte.Job_Role = count_cte.Job_Role
ORDER BY condition_percent DESC;
# largest % - Data Scientist
# smallest % - Marketing
# data scientist has highest count and largest % of mental health conditions for overall remote workers
# marketing has lowest count and smallest % of mental health conditions for overall remote workers


#13 compare people who experience each mental health condition across work location types
SELECT Work_Location, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Anxiety'
GROUP BY Work_Location;

SELECT Work_Location, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Burnout'
GROUP BY Work_Location;

SELECT Work_Location, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Mental_Health_Condition = 'Depression'
GROUP BY Work_Location;

SELECT * FROM remote_mental1;

#14 Count of mental conditions across gender groups for remote work, pretty evenly distributed
SELECT Gender, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition = 'Depression'
GROUP BY Gender;

SELECT Gender, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition = 'Anxiety'
GROUP BY Gender;

SELECT Gender, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location = 'Remote' AND Mental_Health_Condition = 'Burnout'
GROUP BY Gender;


#15 REMOTE + DATA SCIENTIST (JOB ROLE WITH LARGEST % OF PEOPLE WITH MENTAL HEALTH CONDITIONS)
#15a count of people with mental health conditions who work remote as data scientist
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Data Scientist'
GROUP BY  Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition);

#15b count of each gender group for people who work remotely as data scientist and who have burnout
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Data Scientist' AND Mental_Health_Condition='Burnout'
GROUP BY Gender
ORDER BY COUNT(Gender);

#15c seems there is no correlation between mental health condition vs avg hours worked per week, work life balance rating, social isolation rating, company support for remote work
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition), AVG(Hours_Worked_Per_Week), AVG(Work_Life_Balance_Rating), AVG(Social_Isolation_Rating), AVG(Company_Support_for_Remote_Work)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Data Scientist'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition) DESC;

#15d count of each gender group for people who work remotely as data scientist and who have no mental health conditions
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Data Scientist' AND Mental_Health_Condition='None'
GROUP BY Gender
ORDER BY COUNT(Gender);


#16 REMOTE + MARKETING (JOB ROLE WITH SMALLEST % OF PEOPLE WITH MENTAL HEALTH CONDITIONS)
#16a count of people with mental health conditions who work remote in marketing
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Marketing'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition);

#16b count of each gender group for people who work remotely in marketing and who have no mental health conditions
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Marketing' AND Mental_Health_Condition='None'
GROUP BY Gender
ORDER BY COUNT(Gender);

#16c seems there may be a correlation with mental health condition vs avg hours worked per week
# seems there is no correlation between mental health condition vs work life balance rating, social isolation rating, company support for remote work
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition), AVG(Hours_Worked_Per_Week), AVG(Work_Life_Balance_Rating), AVG(Social_Isolation_Rating), AVG(Company_Support_for_Remote_Work)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Marketing'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition) DESC;

#16d count of each gender group for people who work remotely in marketing and who has anxiety (least number of people in remote+marketing)
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Job_Role='Marketing' AND Mental_Health_Condition='Anxiety'
GROUP BY Gender
ORDER BY COUNT(Gender);


#17 REMOTE + IT (INDUSTRY WITH LARGEST % OF PEOPLE WITH MENTAL HEALTH CONDITIONS)
#17a count of people with mental health conditions who work remote in IT
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='IT'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition);
# #1 mental health condition - anxiety
# #4 mental health condition - none

#17b count of each gender group for people who work remotely in IT and who have anxiety
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='IT' AND Mental_Health_Condition='Anxiety'
GROUP BY Gender
ORDER BY COUNT(Gender);

#17c seems there is no correlation between mental health condition vs avg hours worked per week, work life balance rating, social isolation rating, company support for remote work
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition), AVG(Hours_Worked_Per_Week), AVG(Work_Life_Balance_Rating), AVG(Social_Isolation_Rating), AVG(Company_Support_for_Remote_Work)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='IT'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition) DESC;

#17d count of each gender group for people who work remotely in IT and who have no mental health conditions
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='IT' AND Mental_Health_Condition='None'
GROUP BY Gender
ORDER BY COUNT(Gender);


#18 REMOTE + FINANCE (INDUSTRY WITH SMALLEST % OF PEOPLE WITH MENTAL HEALTH CONDITIONS)
#18a count of people with mental health conditions who work remote in finance
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='Finance'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition);
# #1 mental health condition - none
# #4 mental health condition - depression

#18b count of each gender group for people who work remotely in finance and who have no mental health conditions
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='Finance' AND Mental_Health_Condition='None'
GROUP BY Gender
ORDER BY COUNT(Gender);

#18c seems there is no correlation between mental health condition vs hours worked per week, work life balance rating, social isolation rating, company support for remote work
SELECT Mental_Health_Condition, COUNT(Mental_Health_Condition), AVG(Hours_Worked_Per_Week), AVG(Work_Life_Balance_Rating), AVG(Social_Isolation_Rating), AVG(Company_Support_for_Remote_Work)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='Finance'
GROUP BY Mental_Health_Condition
ORDER BY COUNT(Mental_Health_Condition) DESC;

#18d count of each gender group for people who work remotely in finance and who has depression (least number of people in remote+finance)
SELECT Gender, COUNT(Gender)
FROM remote_mental1
WHERE Work_Location='Remote' AND Industry='Finance' AND Mental_Health_Condition='Depression'
GROUP BY Gender
ORDER BY COUNT(Gender);
