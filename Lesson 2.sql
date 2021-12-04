/****************************************************************************
************************   T R A N S A C T - S Q L   ************************
*****************************************************************************
*****  Lesson II  ******              DDL            ************************
****************************************************************************/
--DDL
----DATABASE
CREATE DATABASE ITVDNdb -- создание базы данных с параметрами по-умолчанию

ALTER DATABASE ITVDNdb
COLLATE Cyrillic_General_CI_AS -- параметры сортировки дл€ базы данных по умолчанию
/*
CaseSensitivity
CI определ€ет нечувствительность к регистру, CS определ€ет чувствительность к регистру.

AccentSensitivity
AI означает, что диакритические знаки игнорируютс€, AS означает, что они учитываютс€.
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
(N'јлександр',N'ћакедонский','(012)3456789','alex@imperium.com'),
(N'ƒиоген',N'—инопский',NULL,'sinop@pithos.com')
-- даем разрешение на добавление/изменение IDENTITY значени€
SET IDENTITY_INSERT Students ON
INSERT INTO Students 
(Id, FirstName, LastName, Phone, EMail)
	VALUES
		(3, NULL, N'—емирамида', '(012)3456788', 'assyria@imperium.com')
-- запрещаем добавление/изменение IDENTITY значени€
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
/*»нструкци€ TRUNCATE TABLE €вл€етс€ более быстрой версией инструкции DELETE без предложени€ WHERE. 
Ёта инструкци€ удал€ет все строки таблицы более быстро, чем инструкци€ DELETE, поскольку она удал€ет 
содержимое постранично, тогда как инструкци€ DELETE делает это построчно. »нструкци€ TRUNCATE TABLE 
€вл€етс€ расширением Transact-SQL стандарта SQL. ≈ще одним важным отличием этой инструкции €вл€етс€ то, 
что она сбрасывает индекс столбца, дл€ которого указано свойство автоинкремента IDENTITY.
*/
TRUNCATE TABLE Students
TRUNCATE TABLE StudentPhones
----OUTPUT
/*ѕредложение OUTPUT дает возможность получить информацию по строкам, которые были добавлены, удалены 
или изменены в результате выполнени€ DML команд INSERT, DELETE, UPDATE и MERGE. –езультаты выполненных 
операций соответствующих инструкций предложение OUTPUT выводит в таблицах inserted и deleted.
*/
INSERT Students (FirstName, LastName, Phone, EMail)
OUTPUT inserted.*
	VALUES
		(N'јлександр', N'ћакедонский', '(012)3456789', 'alex@imperium.com'),
		(N'ƒиоген', N'—инопский', NULL, 'sinop@pithos.com'),
		(NULL, N'—емирамида', '(012)3456788', 'assyria@imperium.com')

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