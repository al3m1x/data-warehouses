USE HD_DrivingSchool
GO

IF (OBJECT_ID('vETLDimStudentData') IS NOT NULL) 
    DROP VIEW vETLDimStudentData;
GO

CREATE VIEW vETLDimStudentData AS
SELECT 
    [pesel],
    [name],
    [surname],
    DATEDIFF(YEAR, [date_of_birth], GETDATE()) AS Age
FROM Drive_By.dbo.Student;
GO

DECLARE @CurrentDateTime DATETIME;
SET @CurrentDateTime = GETDATE();

MERGE INTO Student AS S
USING ( 
    SELECT 
        pesel AS PESEL_Student, 
        name AS Name, 
        surname AS Surname, 
        CASE 
            WHEN Age BETWEEN 15 AND 20 THEN '15-20'
            WHEN Age BETWEEN 21 AND 25 THEN '21-25'
			WHEN Age BETWEEN 26 AND 30 THEN '26-30'
			WHEN Age BETWEEN 31 AND 35 THEN '31-35'
			WHEN Age BETWEEN 36 AND 40 THEN '36-40'
			WHEN Age BETWEEN 41 AND 45 THEN '41-45'
			WHEN Age BETWEEN 46 AND 50 THEN '46-50'
			WHEN Age BETWEEN 51 AND 55 THEN '51-55'
			WHEN Age BETWEEN 56 AND 60 THEN '56-60'
			WHEN Age BETWEEN 61 AND 65 THEN '61-65'
			WHEN Age BETWEEN 66 AND 70 THEN '66-70'
			WHEN Age BETWEEN 71 AND 75 THEN '71-75'
			WHEN Age BETWEEN 76 AND 80 THEN '76-80'
			WHEN Age BETWEEN 81 AND 100 THEN '81-100'
        END AS AgeCategory
    FROM vETLDimStudentData
) AS T
    ON S.PESEL_Student = T.PESEL_Student AND S.IsCurrent = 1
WHEN MATCHED AND (
        S.Name <> T.Name OR
        S.Surname <> T.Surname OR 
        S.AgeCategory <> T.AgeCategory
    ) THEN
    UPDATE SET 
        S.IsCurrent = 0,
		S.ExpiryDate = @CurrentDateTime
WHEN NOT MATCHED BY TARGET THEN
    INSERT 
    VALUES (T.PESEL_Student, T.Name, T.Surname, T.AgeCategory, @CurrentDateTime, NULL, 1)
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE SET 
        S.IsCurrent = 0;
GO

DECLARE @CurrentDateTime DATETIME;
SET @CurrentDateTime = GETDATE();
INSERT INTO Student (PESEL_Student, Name, Surname, AgeCategory, EntryDate, ExpiryDate, IsCurrent)
SELECT 
    T.pesel,
    T.name,
    T.surname,
	CASE 
        WHEN Age BETWEEN 15 AND 20 THEN '15-20'
        WHEN Age BETWEEN 21 AND 25 THEN '21-25'
		WHEN Age BETWEEN 26 AND 30 THEN '26-30'
		WHEN Age BETWEEN 31 AND 35 THEN '31-35'
		WHEN Age BETWEEN 36 AND 40 THEN '36-40'
		WHEN Age BETWEEN 41 AND 45 THEN '41-45'
		WHEN Age BETWEEN 46 AND 50 THEN '46-50'
		WHEN Age BETWEEN 51 AND 55 THEN '51-55'
		WHEN Age BETWEEN 56 AND 60 THEN '56-60'
		WHEN Age BETWEEN 61 AND 65 THEN '61-65'
		WHEN Age BETWEEN 66 AND 70 THEN '66-70'
		WHEN Age BETWEEN 71 AND 75 THEN '71-75'
		WHEN Age BETWEEN 76 AND 80 THEN '76-80'
		WHEN Age BETWEEN 81 AND 100 THEN '81-100'
    END AS AgeCategory,
	@CurrentDateTime,
    NULL,
    1
FROM vETLDimStudentData AS T
EXCEPT
SELECT 
    S.PESEL_Student,
    S.Name,
    S.Surname,
	S.AgeCategory,
	@CurrentDateTime,
    NULL,
    1
FROM Student AS S
WHERE S.IsCurrent = 1;

DROP VIEW vETLDimStudentData;
GO