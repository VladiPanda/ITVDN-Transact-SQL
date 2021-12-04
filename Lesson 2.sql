/****************************************************************************
************************   T R A N S A C T - S Q L   ************************
*****************************************************************************
*****  Lesson II  ******              DDL            ************************
****************************************************************************/
--DDL
----DATABASE
CREATE DATABASE ITVDNdb -- �������� ���� ������ � ����������� ��-���������

ALTER DATABASE ITVDNdb
COLLATE Cyrillic_General_CI_AS -- ��������� ���������� ��� ���� ������ �� ���������
/*
CaseSensitivity
CI ���������� ������������������ � ��������, CS ���������� ���������������� � ��������.

AccentSensitivity
AI ��������, ��� �������������� ����� ������������, AS ��������, ��� ��� �����������.
*/
DROP DATABASE ITVDNdb

----TABLE
CREATE DATABASE ITVDNdb
COLLATE Cyrillic_General_CI_AS

USE ITVDNdb
---- CTRL + K, X  - snippets
CREATE TABLE Students
(
    id int NOT NULL IDENTITY,
    FirstName nvarchar(20),
	LastName nvarchar(20),
	Phone char(12),
	Email varchar(20)
)

ALTER TABLE Students
ALTER COLUMN LastName nvarchar(30) NOT NULL

ALTER TABLE Students
ADD MiddleName nvarchar(30) -- NOT NULL

ALTER TABLE Students
DROP COLUMN MiddleName

--DML
----INSERT #1
INSERT INTO Students
(FirstName, LastName, Phone, Email)
VALUES
(N'���������',N'�����������','(012)3456789','alex@imperium.com'),
(N'������',N'���������',NULL,'sinop@pithos.com')
-- ���� ���������� �� ����������/��������� IDENTITY ��������
SET IDENTITY_INSERT Students ON
INSERT INTO Students 
(Id, FirstName, LastName, Phone, EMail)
	VALUES
		(3, NULL, N'����������', '(012)3456788', 'assyria@imperium.com')
-- ��������� ����������/��������� IDENTITY ��������
SET IDENTITY_INSERT Students OFF
----SELECT
SELECT * FROM Students

SELECT LastName, Email FROM Students
Where Id = 1
----INSERT #2
CREATE TABLE dbo.StudentPhones
(
   Id int,
   LastName nvarchar(20),
   PhoneNumber char(12)
);

INSERT StudentPhones
SELECT Id, LastName, Phone from Students
----UPDATE
--#1
UPDATE Students
SET Phone = NULL
WHERE Id = 1
	--WHERE Id = 1
--#2
UPDATE Students
SET Phone = sp.PhoneNumber
FROM Students s
JOIN StudentPhones sp ON s.id = sp.Id
----DELETE
DELETE Students
WHERE Id = 1
--WHERE Id = 1

----TRUNCATE (DDL)
/*���������� TRUNCATE TABLE �������� ����� ������� ������� ���������� DELETE ��� ����������� WHERE. 
��� ���������� ������� ��� ������ ������� ����� ������, ��� ���������� DELETE, ��������� ��� ������� 
���������� �����������, ����� ��� ���������� DELETE ������ ��� ���������. ���������� TRUNCATE TABLE 
�������� ����������� Transact-SQL ��������� SQL. ��� ����� ������ �������� ���� ���������� �������� ��, 
��� ��� ���������� ������ �������, ��� �������� ������� �������� �������������� IDENTITY.
*/
TRUNCATE TABLE Students
TRUNCATE TABLE StudentPhones
----OUTPUT
/*����������� OUTPUT ���� ����������� �������� ���������� �� �������, ������� ���� ���������, ������� 
��� �������� � ���������� ���������� DML ������ INSERT, DELETE, UPDATE � MERGE. ���������� ����������� 
�������� ��������������� ���������� ����������� OUTPUT ������� � �������� inserted � deleted.
*/
INSERT Students (FirstName, LastName, Phone, EMail)
OUTPUT inserted.*
	VALUES
		(N'���������', N'�����������', '(012)3456789', 'alex@imperium.com'),
		(N'������', N'���������', NULL, 'sinop@pithos.com'),
		(NULL, N'����������', '(012)3456788', 'assyria@imperium.com')

		DELETE Students
		OUTPUT deleted.Id, deleted.LastName
		WHERE Id = 1

		UPDATE Students
		SET Phone = '(012)3456789'
		OUTPUT inserted.Id, inserted.LastName, inserted.Phone AS [new phone], deleted.Phone "old phone"
		WHERE Id = 2

		DELETE Students
		OUTPUT deleted.Id, deleted.LastName, deleted.Phone INTO StudentPhones

-- table variable

DECLARE @deleteTable table (Id int, LastName nvarchar(20)

DELETE StudentPhones
OUTPUT deleted.Id, deleted.LastName, deleted.Phone INTO @deleteTable
SELECT * FROM @deleteTable