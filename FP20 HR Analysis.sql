--Looking Into the Data

SELECT *
FROM PortfolioProject.dbo.Dataset$

--DATA ANALYSIS

-- How diverse is the workforce in terms of gender, ethnicity, and age?
--In terms of gender

SELECT Gender, Gender_count, 
	CAST((Gender_count * 100.0) / SUM(Gender_count) OVER () AS DECIMAL(10, 2)) AS Gender_percentage
FROM
(SELECT Gender, COUNT(Gender) AS Gender_count
FROM PortfolioProject.dbo.Dataset$
GROUP BY Gender) Sub
ORDER BY Gender

--In terms of ethnicity
SELECT Ethnicity, Ethnic_group, 
	CAST((Ethnic_group * 100.0) / SUM(Ethnic_group) OVER () AS DECIMAL(10, 2)) AS Percentage_Ethnic_group
FROM
(SELECT Ethnicity, COUNT(Ethnicity) AS Ethnic_group
FROM PortfolioProject.dbo.Dataset$
GROUP BY Ethnicity) Sub
ORDER BY Ethnic_group DESC


--In terms of Age
SELECT Age_Group, Count_group, 
	CAST((Count_group * 100.0) / SUM(Count_group) OVER () AS DECIMAL(10, 2)) AS Age_Group_percentage
FROM
	(SELECT Age_Group, COUNT(Age_Group) AS Count_group
	FROM
		(SELECT *,
		CASE WHEN Age >= 25 AND Age < 41 THEN '25 to 40'
		WHEN Age >= 41 AND Age < 51 THEN '41 to 50'
		ELSE '51 to 65' END AS Age_Group
		FROM PortfolioProject.dbo.Dataset$) 
		Sub
		GROUP BY Age_Group) 
	Sub
ORDER BY Age_Group

-- 51.8% of the workforce are females while 48.2% are males. 
-- Asians make up 40.40% of the workforce which is the largest,
-- Blacks are the smallest with 7.40%, others include Caucasian (27.10%) and Latino (25.10%).
-- 38.4% of the total workforce are between the ages of 25 to 40, 28.3% are between 41 to 50 while 33.3% are between 51 to 65

-- How about the geographic distribution of the workforce

SELECT Country, COUNT([Employee ID]) AS No_of_Employees
FROM
PortfolioProject.dbo.Dataset$
GROUP BY Country
ORDER BY No_of_Employees

SELECT City, Country, COUNT ([Employee ID]) AS No_of_Employees
FROM
PortfolioProject.dbo.Dataset$
GROUP BY City, Country
ORDER BY No_of_Employees DESC

--What is the employee retention rate trend yearly

SELECT COUNT(*)
FROM
PortfolioProject.dbo.Dataset$


SELECT Hire_Date, SUM(Active_Employees) Yearly_Active_Employees
FROM 
		(SELECT (DATEPART(year, [Hire Date])) AS Hire_Date, COUNT(*) AS Active_Employees
		FROM PortfolioProject.dbo.Dataset$
		WHERE [Exit Date] = ''
		GROUP BY [Hire Date]) sub
GROUP BY Hire_Date
ORDER BY Hire_Date 



SELECT Business_Year, SUM(NO_of_Employees) AS Yearly_Employees
FROM
		(SELECT (DATEPART(year, [Hire Date])) AS Business_Year, COUNT([Hire Date]) AS NO_of_Employees
		FROM PortfolioProject.dbo.Dataset$
		GROUP BY [Hire Date]) sub
GROUP BY Business_Year
ORDER BY Business_Year DESC


SELECT sub4.Business_Year, sub4.Yearly_Employees, sub2.Yearly_Active_Employees,
(sub2.Yearly_Active_Employees * 100)  / sub4.Yearly_Employees  AS Retention_Rate_in_Percent
FROM
	((SELECT Hire_Date, SUM(Active_Employees) Yearly_Active_Employees
	FROM 
			(SELECT (DATEPART(year, [Hire Date])) AS Hire_Date, COUNT(*) AS Active_Employees
			FROM PortfolioProject.dbo.Dataset$
			WHERE [Exit Date] = ''
			GROUP BY [Hire Date]) sub
	GROUP BY Hire_Date) sub2
JOIN 
	(SELECT Business_Year, SUM(NO_of_Employees) AS Yearly_Employees
	FROM
			(SELECT (DATEPART(year, [Hire Date])) AS Business_Year, COUNT([Hire Date]) AS NO_of_Employees
			FROM PortfolioProject.dbo.Dataset$
			GROUP BY [Hire Date]) sub3
	GROUP BY Business_Year) sub4
ON sub4.Business_Year = sub2.Hire_Date)

GROUP BY sub4.Business_Year, sub4.Yearly_Employees, sub2.Yearly_Active_Employees
ORDER BY sub4.Business_Year DESC

/* There were 81 active employees at the end of 2021
   Active Employees per year include;
   2017 - 61 employees (94% retention rate)
   2018 - 63 employees (90% retention rate)
   2019 - 60 employees (88% retention rate)
   2020 - 60 employees (92% retention rate)
   2021 - 81 employees (87% retention rate)
*/

-- What is the employee retention rate in terms of Gender, Ethnicity and Age

-- In terms of gender

SELECT sub2.Gender, sub2.NO_of_Employees, sub.Active_Employees,
(sub.Active_Employees * 100)  / sub2.NO_of_Employees  AS Retention_Rate_in_Percent
FROM
	((SELECT Gender, COUNT(*) AS Active_Employees
			FROM PortfolioProject.dbo.Dataset$
			WHERE [Exit Date] = ''
			GROUP BY Gender) sub
JOIN 
	(SELECT Gender, COUNT(*) AS NO_of_Employees
	FROM PortfolioProject.dbo.Dataset$
	GROUP BY Gender) sub2
ON sub2.Gender = sub.Gender)

GROUP BY sub2.Gender, sub2.NO_of_Employees, sub.Active_Employees
ORDER BY sub2.Gender

-- In terms of Ethnicity

SELECT sub2.Ethnicity, sub2.NO_of_Employees, sub.Active_Employees,
(sub.Active_Employees * 100)  / sub2.NO_of_Employees  AS Retention_Rate_in_Percent
FROM
	((SELECT Ethnicity, COUNT(*) AS Active_Employees
			FROM PortfolioProject.dbo.Dataset$
			WHERE [Exit Date] = ''
			GROUP BY Ethnicity) sub
JOIN 
	(SELECT Ethnicity, COUNT(*) AS NO_of_Employees
	FROM PortfolioProject.dbo.Dataset$
	GROUP BY Ethnicity) sub2
ON sub2.Ethnicity = sub.Ethnicity)

GROUP BY sub2.Ethnicity, sub2.NO_of_Employees, sub.Active_Employees
ORDER BY Retention_Rate_in_Percent DESC

-- In terms of Age

SELECT Sub4.Age_Group, Sub4.No_of_Employees, Sub1.Active_Employees,
(Sub1.Active_Employees * 100)  / Sub4.No_of_Employees  AS Retention_Rate_in_Percent
FROM
	((SELECT Age_Group, COUNT(*) AS Active_Employees
	FROM
		(SELECT *,
		CASE WHEN Age >= 25 AND Age < 41 THEN '25 to 40'
		WHEN Age >= 41 AND Age < 51 THEN '41 to 50'
		ELSE '51 to 65' END AS Age_Group
		FROM PortfolioProject.dbo.Dataset$) 
		Sub
		WHERE [Exit Date] = ''
		GROUP BY Age_Group) 
	Sub1
JOIN
	(SELECT Age_Group, COUNT(*) AS No_of_Employees
	FROM
		(SELECT *,
		CASE WHEN Age >= 25 AND Age < 41 THEN '25 to 40'
		WHEN Age >= 41 AND Age < 51 THEN '41 to 50'
		ELSE '51 to 65' END AS Age_Group
		FROM PortfolioProject.dbo.Dataset$) 
		Sub3
		GROUP BY Age_Group)
		Sub4
ON Sub1.Age_Group = Sub4.Age_Group)

GROUP BY Sub4.Age_Group, Sub4.No_of_Employees, Sub1.Active_Employees
ORDER BY Retention_Rate_in_Percent

-- Which business unit had the highest and lowest employee retention rate?

SELECT *
FROM PortfolioProject.dbo.Dataset$

SELECT sub2.[Business Unit], sub2.NO_of_Employees, sub.Active_Employees,
(sub.Active_Employees * 100)  / sub2.NO_of_Employees  AS Retention_Rate_in_Percent
FROM
	((SELECT [Business Unit], COUNT(*) AS Active_Employees
			FROM PortfolioProject.dbo.Dataset$
			WHERE [Exit Date] = ''
			GROUP BY [Business Unit]) sub
JOIN 
	(SELECT [Business Unit], COUNT(*) AS NO_of_Employees
	FROM PortfolioProject.dbo.Dataset$
	GROUP BY [Business Unit]) sub2
ON sub2.[Business Unit] = sub.[Business Unit])

GROUP BY sub2.[Business Unit], sub2.NO_of_Employees, sub.Active_Employees
ORDER BY Retention_Rate_in_Percent DESC

-- The 'Strategy' business unit had the highest retention rate (100%) while the 'Research and Development' unit had the lowest (88%)

--Which business unit and department paid the most and least bonuses annualy


SELECT DATEPART(year, [Hire Date]) AS Business_Year, [Business Unit] AS Business_Unit, SUM([Bonus %]) AS BONUS
FROM PortfolioProject.dbo.Dataset$
WHERE [Business Unit] = 'Corporate'
GROUP BY [Business Unit], [Hire Date]
	
-- What is the employee turnover rate (eg monthly, quarterly, annually) since 2017?

-- ANNUALLY

SELECT Sub3.Hire_Date, Sub1.Active_Employees, Sub3.Total_Employees,
((Sub3.Total_Employees - Sub1.Active_Employees) * 100) / ((Sub3.Total_Employees + Sub1.Active_Employees) / 2) AS Turnover_Rate
FROM
	(SELECT Hire_Date, SUM(Active_Employees) AS Active_Employees
	FROM
		(SELECT DATEPART(year,[Hire Date]) AS Hire_Date, COUNT(*) AS Active_Employees
		FROM PortfolioProject.dbo.Dataset$
		WHERE [Exit Date] = ''
		GROUP BY [Hire Date]) Sub
	GROUP BY Hire_Date
	) Sub1
JOIN
	(SELECT Hire_Date, SUM(Employees) AS Total_Employees
	FROM
		(SELECT DATEPART(year,[Hire Date]) AS Hire_Date, COUNT(*) AS Employees
		FROM PortfolioProject.dbo.Dataset$
		GROUP BY [Hire Date]) Sub2
	GROUP BY Hire_Date
	) Sub3
ON Sub1.Hire_Date = Sub3.Hire_Date
WHERE Sub3.Hire_Date >= 2017
GROUP BY Sub3.Hire_Date, Sub1.Active_Employees, Sub3.Total_Employees
ORDER BY Sub3.Hire_Date DESC

-- QUARTERLY
SELECT Sub3.Hire_Date, Sub1.Active_Employees, Sub3.Total_Employees,
((Sub3.Total_Employees - Sub1.Active_Employees) * 100) / ((Sub3.Total_Employees + Sub1.Active_Employees) / 2) AS Turnover_Rate
FROM
	(SELECT Hire_Date, SUM(Active_Employees) AS Active_Employees
	FROM
		(SELECT DATEPART(QUARTER,[Hire Date]) AS Hire_Date, COUNT(*) AS Active_Employees
		FROM PortfolioProject.dbo.Dataset$
		WHERE [Exit Date] = '' AND [Hire Date] >= 2017
		GROUP BY [Hire Date]) Sub
	
	GROUP BY Hire_Date
	) Sub1
JOIN
	(SELECT Hire_Date, SUM(Employees) AS Total_Employees
	FROM
		(SELECT DATEPART(QUARTER,[Hire Date]) AS Hire_Date, COUNT(*) AS Employees
		FROM PortfolioProject.dbo.Dataset$
		WHERE [Hire Date] >= 2017
		GROUP BY [Hire Date]) Sub2
	GROUP BY Hire_Date
	) Sub3
ON Sub1.Hire_Date = Sub3.Hire_Date
WHERE Sub3.Hire_Date >= 2017
GROUP BY Sub3.Hire_Date, Sub1.Active_Employees, Sub3.Total_Employees
ORDER BY Sub3.Hire_Date DESC


SELECT DATEPART(QUARTER, Hire_Date) AS QQuarter, Turnover_Rate
FROM

	(SELECT Sub3.Hire_Date, Sub1.Active_Employees, Sub3.Total_Employees,
	((Sub3.Total_Employees - Sub1.Active_Employees) * 100) / ((Sub3.Total_Employees + Sub1.Active_Employees) / 2) AS Turnover_Rate
	FROM
		(SELECT Hire_Date, SUM(Active_Employees) AS Active_Employees
		FROM
			(SELECT DATEPART(year,[Hire Date]) AS Hire_Date, COUNT(*) AS Active_Employees
			FROM PortfolioProject.dbo.Dataset$
			WHERE [Exit Date] = ''
			GROUP BY [Hire Date]) Sub
		GROUP BY Hire_Date
		) Sub1
	JOIN
		(SELECT Hire_Date, SUM(Employees) AS Total_Employees
		FROM
			(SELECT DATEPART(year,[Hire Date]) AS Hire_Date, COUNT(*) AS Employees
			FROM PortfolioProject.dbo.Dataset$
			GROUP BY [Hire Date]) Sub2
		GROUP BY Hire_Date
		) Sub3
	ON Sub1.Hire_Date = Sub3.Hire_Date
	WHERE Sub3.Hire_Date >= 2017
	GROUP BY Sub3.Hire_Date, Sub1.Active_Employees, Sub3.Total_Employees) sub4

GROUP BY Hire_Date, Turnover_Rate