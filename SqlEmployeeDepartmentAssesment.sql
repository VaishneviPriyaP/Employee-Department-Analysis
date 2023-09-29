select * from [dbo].[Department_SQL P2];
select * from [dbo].[Employee_SQL P2];

--Q1 --

--Imported as import flat file

--Q2 --
/* Write the query to Select first letter of First and Lastname in Upper case and all other in Lower case */

select Upper(SubString(FirstName, 1, 1)) + Lower(Substring(FirstName, 2, 100)) as NewFirstName,
	   Upper(SubString(Lastname, 1, 1)) + Lower(Substring(Lastname, 2, 100)) as NewLastName
from [dbo].[Employee_SQL P2]

---Q2 ends ---------------------------------------------------------------------------------------------------

--Q3 --
/* Find out the Employees which are not assigned to any dept and are on Bench */

select e.EID, e.FirstName, e.Lastname, e.Department
from [dbo].[Employee_SQL P2] as e
join [dbo].[Department_SQL P2] as d
on e.Department = d.Dept_Name
where d.Dept_Name = 'Bench'

--Q3 ends----------------------------------------------------------------------------------------------------------

--Q4 --
/* Write a query to give the output - Dept ID, Dept Name and the count of the employees working in them. 
Make sure to cover all the departments even if employees are not assigned in them */

select d.Dept_ID,d.Dept_Name, COUNT(e.eid) as Emp_Count_Per_Dept 
from [dbo].[Employee_SQL P2] as e
join [dbo].[Department_SQL P2] as d
on e.Department = d.Dept_Name
group by d.Dept_ID,d.Dept_Name

--Q4 ends----------------------------------------------------------------------------------------------------------

--Q5 --
/* Find out how many duplicate employees we have based on their same first name and Lastnames - Use Row Number */

WITH
Duplicate_Emp_Names 
AS
(
SELECT firstname, lastname,ROW_NUMBER() OVER (PARTITION BY firstname, lastname order by eid) AS occurrence
FROM [dbo].[Employee_SQL P2] 
)
SELECT *
FROM Duplicate_Emp_Names
WHERE occurrence > 1

--Q5 ends----------------------------------------------------------------------------------------------------------

-- Q6 --
/* Write a query that gives us 2 additional fields - Month of Joining and Year
of Joining along with the columns of the Employee Table */

select * , MONTH(JoiningDate) as Joining_Month , YEAR(JoiningDate) as Joining_Year
from [dbo].[Employee_SQL P2];

--Q6 ends-------------------------------------------------------------------------------------------------------

--Q7 ---
/* Write an optimal query to give the count of the employees where the name starts with - 'AS' and which has 'SAP' 
in between of the name anywhere*/

select count(*) as no_of_match_Emp
from [dbo].[Employee_SQL P2]
where FirstName like 'AS%' and FirstName like '%SAP%'

--Q7 ends -----------------------------------------------------------------------------------------------------

--Q8 --
/* Write an query to find the count of employees which joined in the range of May 2003 to June 2009*/

select COUNT(*) as Emp_Count_AsPer_JoinDate 
from [dbo].[Employee_SQL P2]
where month(JoiningDate) between '05' and '06' and
      YEAR(JoiningDate) between '2003' and '2009'

--Q8 ends-----------------------------------------------------------------------------------------------------------

--Q9 --
/* Find all the records where the Lastname Or Email is Null and Replace it by 'No record Found'.*/

select EID,FirstName,( case when lastname='null' then 'No record Found' else lastname end) as NewLastName,
	   (case when Email='null' then 'No record Found' else Email end) as NewEmail, 
	   Salary,Department,gender,JoiningDate
from [dbo].[Employee_SQL P2];
--Q9 ends------------------------------------------------------------------------------------------------------

--Q10 --
/* Write a query to find the number of Joining's Year and Month wise and order them by lowest to highest numbers */

select count (*) as Count_Emp,MONTH(joiningDate) as Month,YEAR(joiningDate) as Year 
from [dbo].[Employee_SQL P2]
group by MONTH(joiningDate),YEAR(joiningDate)
order by count (*) asc
--Q10 ends---------------------------------------------------------------------------------------------------------

--Q11 --
/* Delete the duplicate entries from the table using Temp Table */

WITH
Duplicate_Emp_Names 
AS
(
SELECT firstname, lastname,ROW_NUMBER() OVER (PARTITION BY firstname, lastname order by eid) AS occurrence
FROM [dbo].[Employee_SQL P2] 
)
delete 
FROM      Duplicate_Emp_Names
WHERE     occurrence > 1

-- 847 rows were affected
--Q11 ends------------------------------------------------------------------------------------------------------------

-- Q12 --
/* Write a query to find all the departments in a company, their average salary per employee in that dept and their 
total salary for the employees falling under that dept*/

select d.Dept_ID, d.Dept_Name, AVG(salary) as Dept_Avg_Sal , SUM(salary) as Dept_Total_Sal
from [dbo].[Department_SQL P2] as d
join [dbo].[Employee_SQL P2] as e
on d.Dept_Name = e.Department
group by d.Dept_Name, d.Dept_ID;

--Q12 ends----------------------------------------------------------------------------------------------------------

--Q13 --
/* Find the Minimum and Maximum salary per department wise? Confirm your result with the data.*/

select d.Dept_ID, d.Dept_Name, MIN(Salary) as Dept_Min_Sal , Max(salary) as Dept_Max_Sal
from [dbo].[Department_SQL P2] as d
join [dbo].[Employee_SQL P2] as e
on d.Dept_Name = e.Department
group by d.Dept_Name, d.Dept_ID;

--Q13 ends---------------------------------------------------------------------------------------------------------

--Q14 --
/* Update all the Male employees with Female and Female with Male in one update query*/

update [dbo].[Employee_SQL P2]
set gender = ( case when gender = 'M' then 'F'
					when gender = 'F' then 'M'
			   end)

--Q14 ends-----------------------------------------------------------------------------------------------------------

-- Q15 --
/* Write a query to Update the Department Name in Employee Table with Department ID in Department Table*/

update [dbo].[Employee_SQL P2]
set Department = d.Dept_ID
from [dbo].[Employee_SQL P2] e, [dbo].[Department_SQL P2] d
where e.Department = d.Dept_Name

--Q15 ends---------------------------------------------------------------------------------------------------------

--Q16 --
/* What is the purpose of writing - SET NOCOUNT ON in the procedure? */

SET NOCOUNT ON – We can specify this set statement at the beginning of the statement. Once we enable it,
we do not get the number of affected rows in the output ( under the messages tab)

--Q16 ends---------------------------------------------------------------------------------------------------------

--Q17 --
/* What is the difference between Union and Union all?*/

* UNION will select all the distinct records from all queries by removing any duplicates. 
The performance of this operator is slightly lower than the other operator because it has to 
check for the duplicates (which is a time-consuming process)

*UNIONALL command will select all the rows (including duplicate records) from all queries.

--Q17 ends--------------------------------------------------------------------------------------------------------

--Q18 -- 
/* How many types of temporary tables do we have and what is the difference between them?*/

There are 2 types of Temporary Tables: 
	1)Local Temporary Table : A Local Temp Table is available only for the session that has created it.
	It is automatically dropped (deleted) when the connection that has created it, is closed.
	To create Local Temporary Table Single “#” is used as the prefix of a table name.

	2)Global Temporary Table : Global Temporary Tables are visible to all connections and 
	Dropped when the last connection referencing the table is closed. To create a Global Temporary Table, 
	add the “##” symbol before the table name.Global Table Name must have an Unique Table Name.
	There will be no random Numbers suffixed at the end of the Table Name.
--Q18 ends-------------------------------------------------------------------------------------------------------------

-- Q19 --
/* Write down any 3 system tables*/

sys.sysschobjs
sys.sysbinobjs
sys.sysclsobjs

--Q19 ends---------------------------------------------------------------------------------------

