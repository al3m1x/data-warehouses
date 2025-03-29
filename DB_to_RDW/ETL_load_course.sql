USE HD_DrivingSchool
GO


IF (OBJECT_ID('vETLDimCourseData') IS NOT NULL) 
    DROP VIEW vETLDimCourseData;
GO

CREATE VIEW vETLDimCourseData AS
SELECT 
    course_id as CourseNumber,
    category as Category,
    CASE 
        WHEN finish_date IS NULL THEN 'InProgress'
        ELSE 'Finished'
    END AS CourseState
FROM Drive_By.dbo.Course;
GO

DECLARE @CurrentDateTime DATETIME;
SET @CurrentDateTime = GETDATE();

MERGE INTO Course AS S
USING (
    SELECT 
        CourseNumber,
        Category,
        CourseState
    FROM vETLDimCourseData
) AS T
ON S.CourseNumber = T.CourseNumber AND S.IsCurrent = 1
WHEN MATCHED AND (
        S.Category <> T.Category OR
        S.CourseState <> T.CourseState
    ) THEN
    UPDATE SET 
        S.IsCurrent = 0,
		S.ExpiryDate = @CurrentDateTime
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CourseNumber, Category, CourseState, EntryDate, ExpiryDate, IsCurrent)
    VALUES (T.CourseNumber, T.Category, T.CourseState, @CurrentDateTime, NULL, 1)
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE SET 
        S.IsCurrent = 0;
GO


DECLARE @CurrentDateTime DATETIME;
SET @CurrentDateTime = GETDATE();
INSERT INTO Course (CourseNumber, Category, CourseState, EntryDate, ExpiryDate, IsCurrent)
SELECT 
    T.CourseNumber,
    T.Category,
    T.CourseState,
    @CurrentDateTime,
    NULL,
    1
FROM vETLDimCourseData AS T
EXCEPT
SELECT 
    S.CourseNumber,
    S.Category,
    S.CourseState,
    @CurrentDateTime,
    NULL,
    1
FROM Course AS S
WHERE S.IsCurrent = 1;

DROP VIEW vETLDimCourseData;
GO