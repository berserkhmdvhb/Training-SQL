# Aggregation

## Revising Aggregations - The Count Function  
  
Query a count of the number of cities in CITY having a Population larger than 100 000. 
  
***Input Format***  
The CITY table is described as follows:   
  
![img](https://s3.amazonaws.com/hr-challenge-images/8137/1449729804-f21d187d0f-CITY.jpg)  


```sql
SELECT COUNT(DISTINCT(name)) FROM city WHERE population > 100000;
``` 
  
  
## Revising Aggregations - The Sum Function  
  
Query the total population of all cities in CITY where District is California.   
  
```sql
SELECT SUM(population) FROM city WHERE district LIKE "California";
``` 
  
## Revising Aggregations - Averages  
  
Query the average population of all cities in CITY where District is California.   
  
  
```sql
SELECT AVG(population) FROM city WHERE district LIKE "California";
``` 
  
## Average Population  
  
Query the average population for all cities in CITY, rounded down to the nearest integer.  
  
```sql
SELECT ROUND(AVG(population)) FROM city;
``` 
  
## Japan Population  
  
Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.  
  
```sql
SELECT SUM(population) FROM city WHERE countrycode LIKE "JPN"
``` 
  
## Population Density Difference  
  
Query the difference between the maximum and minimum populations in CITY.  
  
```sql
SELECT MAX(population) - MIN(population) FROM city;
``` 
  
## The Blunder  
  
Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's 0 key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeroes removed), and the actual average salary.  
Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries), and round it up to the next integer.  
  
***Input Format***  
The EMPLOYEES table is described as follows:  
  
![img](https://s3.amazonaws.com/hr-challenge-images/12893/1443817108-adc2235c81-1.png)  
  
***Note:*** Salary is measured in dollars per month and its value is < 10^5.  

```sql
SELECT CEIL(AVG(salary) - AVG(REPLACE(salary, '0', ''))) FROM employees;
``` 

  
## Top Earners  
  
We define an employee's total earnings to be their monthly salary*months worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2-space-separated integers.  
  
***Input Format***  
The Employee table containing employee data for a company is described as follows:   
  
![img](https://s3.amazonaws.com/hr-challenge-images/19629/1458557872-4396838885-ScreenShot2016-03-21at4.27.13PM.png)  
  
where employee_id is an employee's ID number, name is their name, months is the total number of months they've been working for the company, and salary is the their monthly salary.  
  
```sql
SELECT tbl.maxearn, COUNT(tbl.maxearn) FROM (SELECT MAX(salary * months) AS maxearn FROM employee GROUP BY employee_id) AS tbl GROUP BY tbl.maxearn ORDER BY tbl.maxearn DESC LIMIT 1;
``` 
  
## Weather Observation Station 2  
  
Query the following two values from the STATION table:  
The sum of all values in LAT_N rounded to a scale of 2 decimal places.  
The sum of all values in LONG_W rounded to a scale of 2 decimal places.  
  
***Input Format***  
The STATION table is described as follows:  
  
![img](https://s3.amazonaws.com/hr-challenge-images/9336/1449345840-5f0a551030-Station.jpg)  
  
where LAT_N is the northern latitude and LONG_W is the western longitude.  
  
```sql
SELECT ROUND(SUM(lat_n), 2),ROUND(SUM(long_w), 2) FROM station;
``` 
  
  
## Weather Observation Station 13  
  
Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. Truncate your answer to 4 decimal places.  
  
```sql
SELECT ROUND(SUM(lat_n),4) FROM station WHERE lat_n BETWEEN 38.7880 AND 137.2345;
``` 
  
## Weather Observation Station 14  
  
Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.

```sql
SELECT ROUND(MAX(lat_n),4) FROM station WHERE lat_n < 137.2345;
``` 
  
  
## Weather Observation Station 15  
  
Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345. Round your answer to 4 decimal places.  
  
```sql
SELECT ROUND(long_w,4) FROM station WHERE lat_n IN (SELECT MAX(lat_n) FROM station WHERE lat_n < 137.2345);
``` 
  
  
## Weather Observation Station 16  
  
Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. Round your answer to 4 decimal places.  
  
```sql
SELECT ROUND(MIN(lat_n),4) FROM station WHERE lat_n > 38.7780;
``` 
  
## Weather Observation Station 17  
  
Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7780. Round your answer to 4 decimal places.  
  
```sql
SELECT ROUND(long_w,4) FROM station WHERE lat_n IN (SELECT MIN(lat_n) FROM station WHERE lat_n > 38.7780);
``` 
  
## Weather Observation Station 18  
  
Consider $P_1(a,c)$ and $P_2(b,d)$ to be two points on a 2D plane.   
$a$ happens to equal the minimum value in Northern Latitude (LAT_N in STATION).  
$b$ happens to equal the minimum value in Western Longitude (LONG_W in STATION).  
$c$ happens to equal the maximum value in Northern Latitude (LAT_N in STATION).  
$d$ happens to equal the maximum value in Western Longitude (LONG_W in STATION).  
  
Query the [Manhattan Distance](https://xlinux.nist.gov/dads/HTML/manhattanDistance.html) between points P1 and P2 and round it to a scale of 4 decimal places.  
  
```sql
SELECT ROUND(ABS(tbl.a - tbl.c) + ABS(tbl.b- tbl.d),4) FROM (SELECT MIN(lat_n) AS a, MIN(long_w) AS b, MAX(lat_n) AS c, MAX(long_w) AS d FROM station) AS tbl;
``` 
  
  
  
## Weather Observation Station 19  
  
Consider $P_1(a,c)$ and $P_2(b,d)$ to be two points on a 2D plane.   
$(a,b)$ - the respective minimum and maximum values of Northern Latitude (LAT_N)  
$(c,d)$ - the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.  
  
Query the [Euclidean Distance](https://en.wikipedia.org/wiki/Euclidean_distance) between points $P_1$ and $P_2$ and format your answer to display 4 decimal digits.  
  
```sql
SELECT ROUND(SQRT(POWER(tbl.a - tbl.c,2) + POWER(tbl.b- tbl.d,2)),4) FROM (SELECT MIN(lat_n) AS a, MIN(long_w) AS b, MAX(lat_n) AS c, MAX(long_w) AS d FROM station) AS tbl;
``` 

## Weather Observation Station 20

A [median](https://en.wikipedia.org/wiki/Median) is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (`LAT_N`) from `STATION` and round your answer to  decimal places.

***Input Format***  
The `STATION` table is described as follows:   
  
![img](https://s3.amazonaws.com/hr-challenge-images/9336/1449345840-5f0a551030-Station.jpg)  

where `LAT_N` is the northern latitude and LONG_W is the western longitude

  
```sql
WITH cte AS(
SELECT *, ROW_NUMBER() OVER (ORDER BY LAT_N) as rn
FROM STATION)

SELECT ROUND(LAT_N,4)
FROM cte 
WHERE rn = ROUND((SELECT MAX(rn) FROM cte)/2, 2)
``` 
  
