/****************************************************************************
************************   T R A N S A C T - S Q L   ************************
*****************************************************************************
*****  Lesson III  *****            SELECT           ************************
****************************************************************************/

-- DISTINCT - ������� ���������� ����� (��� ����������)
SELECT DISTINCT Department FROM Employees
-- TOP - ������� ��������� ����� �����
SELECT TOP 10 * FROM Employees

SELECT TOP 25 PERCENT * FROM Employees
-- ORDER BY - ����������
SELECT * FROM Employees
ORDER BY LName

SELECT * FROM Employees
ORDER BY LName, FName

SELECT * FROM Employees
ORDER BY BirthDate

SELECT * FROM Employees
ORDER BY BirthDate DESC

SELECT * FROM Employees
ORDER BY 7, 3 -- �������� ������� �������� (� �� ��������)

-- WITH TIES - ��� ��������� �����, ��������������� ��������� � ��������� ������
SELECT TOP 30 WITH TIES Fname, LName, Salary FROM Employees
ORDER BY Salary DESC

-- SELECT ... INTO ... - ��������� ���������� ������� � ����� �������
SELECT Id, LName, FName, Salary
INTO EmpSalaries
FROM Employees

/****************************************************************************
************************   T R A N S A C T - S Q L   ************************
*****************************************************************************
*****  Lesson III  *****            SELECT           ************************
****************************************************************************/

-- WHERE - ������� ������� �����

--1. ���������� ������ � ������� �������� ���������
SELECT * FROM Employees
WHERE Salary = 10000

SELECT * FROM Employees
WHERE Department = 'sales'
-- ��������� ��������� (=, <> ��� !=, >, <, >=, <=, !<, !>)
--2. ���������� ����� � �������������� ��������� ���������
SELECT * FROM Employees
WHERE BirthDate > '19900101'

SELECT * FROM Employees
WHERE BirthDate !> '19900101'
-- ���������� ��������� (ALL, AND, ANY, BETWEEN, EXISTS, IN, LIKE, NOT, OR, SOME)
--3. ���������� �����, ������� ������ ������������� ���������� ��������
SELECT * FROM Employees
WHERE Department = 'sales' AND Salary >= 6000

--4. ���������� �����, ��������������� ������ �� ���������� �������
SELECT * FROM Employees
WHERE Department = 'sales' OR Department = 'supply'

SELECT * FROM Employees
--WHERE Department = 'sales' OR Department = 'supply' AND Salary >= 6000 -- not correct
WHERE Salary >= 6000 AND (Department = 'sales' OR Department = 'supply' )

--5. IN - ���������� �����, ����������� � ������ ��������
SELECT * FROM Employees
WHERE Department IN ('sales', 'supply', 'logistics')
-- ALL, ANY | SOME, EXISTS - ��. ����������

--6. BETWEEN - ���������� �����, ���������� ��������, ������������� ����� ����� ����������
SELECT * FROM Employees
WHERE BirthDate > '19900101' AND BirthDate < '19930101'

SELECT * FROM Employees
WHERE BirthDate BETWEEN '19900101' AND '19930101'

--7. -- LIKE - ���������� �����, ���������� �������� ��� ����� ������
SELECT * FROM Employees
WHERE Department LIKE 'sales'
-- Wildcard Characters - �������������� ������� (%, _, [], [^])
SELECT * FROM Employees
WHERE Phone LIKE '063%' -- ����� ���������� ����� ��������

SELECT * FROM Employees
WHERE Id LIKE '_2'-- ���� ����� ������

SELECT * FROM Employees
WHERE Id LIKE '[2,4]2' -- ������ ���������� ��������

SELECT * FROM Employees
WHERE Id LIKE '[2-5]2' -- �������� ���������� ��������

SELECT * FROM Employees
WHERE Id LIKE '[^2-5]2' -- ��������� ���������� ��������(��� �����)
--ESCAPE - ��������������

--8. ��������� � NULL
SELECT * FROM Employees
WHERE Salary IS NULL

SELECT * FROM Employees
WHERE Salary IS NOT NULL

SELECT * FROM Employees
WHERE Salary IN (4000, 7000, NULL) -- NULL �� �������

SELECT * FROM Employees
WHERE Salary IN (4000, 7000)
OR Salary IS NULL

/****************************************************************************
************************   T R A N S A C T - S Q L   ************************
*****************************************************************************
*****  Lesson III  *****            SELECT           ************************
****************************************************************************/

-- ��������� CASE 
-- 1) ������� ��������� CASE
SELECT Id, Lname, Salary,
CASE
WHEN Salary >= 8000 THEN 'chief'
WHEN Salary >= 5000 THEN 'manager'
WHEN Salary IS NULL THEN 'unknown'
ELSE 'worker'
END AS Position,

CASE
WHEN Salary >= 8000 THEN 'chief'
WHEN Salary >= 5000 THEN 'manager'
WHEN Salary IS NULL THEN 'unknown'

END AS Position2
FROM Employees
-- 2) ��������� ��������� CASE 
SELECT Id, Lname, Department, Salary,

CASE Department								--CASE
WHEN 'ADMINISTRATION & SUPPORT' THEN '100%'	--    WHEN Department = 'ADMINISTRATION & SUPPORT' THEN '100%'
WHEN 'LAW' THEN '80%'
WHEN 'FINANCE & ACCOUNTING' THEN '70%'
ELSE '10%'
END AS [Bonus%],

Salary/100 *
CASE Department										
	WHEN 'ADMINISTRATION & SUPPORT' THEN 100     
	WHEN 'LAW' THEN 80				
	WHEN 'FINANCE & ACCOUNTING' THEN 70
	ELSE 10
END AS Bonus,

(Salary/100 *
CASE Department										
	WHEN 'ADMINISTRATION & SUPPORT' THEN 100     
	WHEN 'LAW' THEN 80				
	WHEN 'FINANCE & ACCOUNTING' THEN 70
	ELSE 10
END) + Salary AS [Bonus & Salary]
FROM Employees


-- IIF (������� � SQL Server 2012)
SELECT Id, Lname, Department, Salary,
IIF(Salary >= 6000, 'manager', 'worker') AS Position
-- CASE WHEN Salary >= 6000 THEN 'manager' ELSE 'woker'
FROM Employees

ALTER TABLE Employees
ADD Gender bit

UPDATE Employees
SET Gender = IIF(Id > 50, 1,0)

SELECT Id, Lname,
IIF(Gender = 0, 'woman', 'man') AS Gender
FROM Employees

-- GROUP BY
SELECT Department, Gender FROM Employees

GROUP BY Department, Gender

SELECT DISTINCT Department, Gender FROM Employees
-- HAVING
SELECT Department FROM Employees

GROUP BY Department
HAVING Department LIKE 'L%'
