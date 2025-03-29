USE HD_DrivingSchool
GO

If (object_id('dbo.ExamTemp') is not null) DROP TABLE dbo.ExamTemp;
CREATE TABLE dbo.ExamTemp(examID varchar(9), date DATE, isPassed varchar(5), type varchar(15), category varchar(5), student_pesel varchar(11));
go

BULK INSERT dbo.ExamTemp
    FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2024\2020-2024\exams.csv' /*2023 -> 2024*/
    WITH (
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        FIRSTROW = 2,
        CODEPAGE = '65001'
    );
IF (OBJECT_ID('vETLDimExamTakeData') IS NOT NULL) 
    DROP VIEW vETLDimExamTakeData;
GO

/* If dates were real then lesson date should be between entry and expiry date of SCD2 dimensions*/
CREATE VIEW vETLDimExamTakeData AS
SELECT 
    db2.ID_Date as ID_Date,
    db1.ID_Student as ID_Student,
    db3.ID_Exam as examID,
    db4.ID_Junk as ID_Junk
FROM dbo.ExamTemp as exam_csv
LEFT JOIN HD_DrivingSchool.dbo.Student as db1 ON exam_csv.student_pesel = db1.PESEL_Student AND db1.IsCurrent = 1
LEFT JOIN HD_DrivingSchool.dbo.Date as db2 on exam_csv.date = db2.Date
LEFT JOIN HD_DrivingSchool.dbo.Exam as db3 on exam_csv.category = db3.Category AND exam_csv.type = db3.Type
LEFT JOIN HD_DrivingSchool.dbo.Junk as db4 on exam_csv.isPassed = db4.IsPassed
GO

MERGE INTO ExamTake AS ET
USING vETLDimExamTakeData AS S
    ON ET.ID_Date = S.ID_Date
    AND ET.ID_Exam = S.examID
    AND ET.ID_Junk = S.ID_Junk
	/*
	AND ET.ID_Student = S.ID_Student
	*/
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (ID_Date, ID_Student, ID_Exam, ID_Junk)
        VALUES (S.ID_Date, S.ID_Student, S.examID, S.ID_Junk);


DROP VIEW vETLDimExamTakeData;
DROP TABLE dbo.ExamTemp;