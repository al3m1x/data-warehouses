USE HD_DrivingSchool
GO

If (object_id('dbo.PricesTemp') is not null) DROP TABLE dbo.PricesTemp;
CREATE TABLE dbo.PricesTemp(year int, month varchar(15), category varchar(5), price_for_hour decimal(20, 10));
go

BULK INSERT dbo.PricesTemp
    FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2024\2020-2024\prices.csv'
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2,
        CODEPAGE = '65001'
    );

IF (OBJECT_ID('vETLDrivingLessonData') IS NOT NULL) 
    DROP VIEW vETLDrivingLessonData;
GO

CREATE VIEW vETLDrivingLessonData AS
SELECT 
    [Date],
    [Time],
    [InstructorID],
    [CourseID],
    [StudentID],
    [PriceForHour],
    [Duration]
FROM (SELECT 
	[Date] = DAT.ID_Date,
	[Time] = TIM.ID_Time,
	[InstructorID] = INS.ID_Instructor,
	[CourseID] = CRS2.ID_Course,
	[StudentID] = STU.ID_Student,
	[PriceForHour] = PRI.price_for_hour,
	[Duration] = ST1.[Duration]

/* If dates were real then lesson date should be between entry and expiry date of SCD2 dimensions*/
FROM Drive_By.dbo.Driving_lesson AS ST1
	LEFT JOIN Drive_By.dbo.Course as CRS ON ST1.course_id = CRS.course_id
	LEFT JOIN dbo.Course as CRS2 ON CRS.course_id = CRS2.CourseNumber  AND CRS2.IsCurrent = 1
    LEFT JOIN dbo.Student as STU ON CRS.pesel = STU.PESEL_Student AND STU.IsCurrent = 1
    LEFT JOIN dbo.Date as DAT ON ST1.lesson_date = DAT.Date
    LEFT JOIN dbo.Time as TIM ON ST1.lesson_hour = TIM.Hour
    LEFT JOIN dbo.Instructor as INS ON ST1.Instructor_pesel = INS.PESEL_Instructor  AND INS.IsCurrent = 1
    LEFT JOIN dbo.PricesTemp as PRI  ON PRI.year = DAT.Year AND PRI.month = DAT.MonthNo AND PRI.category = CRS.category
) AS x
JOIN dbo.Course ON x.CourseID = dbo.Course.ID_Course

GO	



MERGE INTO DrivingLesson AS DL
USING vETLDrivingLessonData AS S
    ON DL.ID_Date = S.Date 
    AND DL.ID_Time = S.Time
	/*
	AND DL.ID_Instructor = S.InstructorID
	AND DL.ID_Course = S.CourseID
	AND DL.ID_Student = S.StudentID
	*/
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (ID_Date, ID_Time, ID_Instructor, ID_Course, ID_Student, PriceForHour, Duration)
        VALUES (S.Date, S.Time, S.InstructorID, S.CourseID, S.StudentID, S.PriceForHour, S.Duration);

DROP VIEW vETLDrivingLessonData;
DROP TABLE dbo.PricesTemp;
GO