-- T1

BULK INSERT Student
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2023\2020-2023\students.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

BULK INSERT Instructor
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2023\2020-2023\instructors.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

BULK INSERT Course
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2023\2020-2023\courses.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

BULK INSERT Driving_lesson
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2023\2020-2023\lessons.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);