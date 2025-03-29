USE HD_DrivingSchool
GO

IF (OBJECT_ID('vETLDimInstructorData') IS NOT NULL) 
    DROP VIEW vETLDimInstructorData;
GO

CREATE VIEW vETLDimInstructorData AS
SELECT 
    instructor_pesel AS PESEL,
    name AS Name,
    surname AS Surname,
    DATEDIFF(YEAR, date_of_birth, GETDATE()) AS Age,
    DATEDIFF(YEAR, date_of_hiring, GETDATE()) AS ExperienceYears,
    CASE 
        WHEN date_of_firing IS NULL THEN 'Employed'
        ELSE 'Fired'
    END AS EmploymentState
FROM Drive_By.dbo.Instructor;
GO


DECLARE @CurrentDateTime DATETIME;
SET @CurrentDateTime = GETDATE();
MERGE INTO Instructor AS S
USING (
    SELECT 
        PESEL,
        Name,
        Surname,
        CASE 
            WHEN Age BETWEEN 20 AND 25 THEN '21-25'
			WHEN Age BETWEEN 26 AND 30 THEN '26-30'
			WHEN Age BETWEEN 31 AND 35 THEN '31-35'
			WHEN Age BETWEEN 36 AND 40 THEN '36-40'
			WHEN Age BETWEEN 41 AND 45 THEN '41-45'
			WHEN Age BETWEEN 46 AND 50 THEN '46-50'
			WHEN Age BETWEEN 51 AND 55 THEN '51-55'
			WHEN Age BETWEEN 56 AND 60 THEN '56-60'
			WHEN Age BETWEEN 61 AND 65 THEN '61-65'
			WHEN Age BETWEEN 66 AND 70 THEN '66-70'
        END AS AgeCategory,
        CASE 
            WHEN ExperienceYears < 4 THEN 'Beginner'
            WHEN ExperienceYears BETWEEN 4 AND 11 THEN 'Intermediate'
            ELSE 'Veteran'
        END AS WorkExperience,
        EmploymentState
    FROM vETLDimInstructorData
) AS T
ON S.PESEL_Instructor = T.PESEL AND S.IsCurrent = 1
WHEN MATCHED AND (
        S.Name <> T.Name OR
        S.Surname <> T.Surname OR
        S.WorkExperience <> T.WorkExperience OR
        S.EmploymentState <> T.EmploymentState
    ) THEN
    UPDATE SET 
        S.IsCurrent = 0,
		S.ExpiryDate = @CurrentDateTime
WHEN NOT MATCHED BY TARGET THEN
    INSERT 
    VALUES (T.PESEL, T.Name, T.Surname, T.AgeCategory, T.WorkExperience, T.EmploymentState, @CurrentDateTime, NULL, 1)
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE SET 
        S.IsCurrent = 0;
GO

DECLARE @CurrentDateTime DATETIME;
SET @CurrentDateTime = GETDATE();
INSERT INTO Instructor(PESEL_Instructor, Name, Surname, AgeCategory, WorkExperience, EmploymentState, EntryDate, ExpiryDate, IsCurrent)
SELECT 
    T.PESEL,
    T.name,
    T.surname,
	CASE 
        WHEN Age BETWEEN 20 AND 25 THEN '21-25'
		WHEN Age BETWEEN 26 AND 30 THEN '26-30'
		WHEN Age BETWEEN 31 AND 35 THEN '31-35'
		WHEN Age BETWEEN 36 AND 40 THEN '36-40'
		WHEN Age BETWEEN 41 AND 45 THEN '41-45'
		WHEN Age BETWEEN 46 AND 50 THEN '46-50'
		WHEN Age BETWEEN 51 AND 55 THEN '51-55'
		WHEN Age BETWEEN 56 AND 60 THEN '56-60'
		WHEN Age BETWEEN 61 AND 65 THEN '61-65'
		WHEN Age BETWEEN 66 AND 70 THEN '66-70'
    END AS AgeCategory,
    CASE 
        WHEN ExperienceYears < 4 THEN 'Beginner'
        WHEN ExperienceYears BETWEEN 4 AND 11 THEN 'Intermediate'
        ELSE 'Veteran'
    END AS WorkExperience,
    EmploymentState,
	@CurrentDateTime,
    NULL,
    1
FROM vETLDimInstructorData AS T
EXCEPT
SELECT 
    S.PESEL_Instructor,
    S.Name,
    S.Surname,
	S.AgeCategory,
	S.WorkExperience,
	S.EmploymentState,
	@CurrentDateTime,
    NULL,
    1
FROM Instructor AS S
WHERE S.IsCurrent = 1;

DROP VIEW vETLDimInstructorData;
GO
