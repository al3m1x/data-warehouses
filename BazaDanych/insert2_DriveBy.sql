USE Drive_By
GO

CREATE TABLE TempStudent (
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
	pesel CHAR(11) PRIMARY KEY,
    date_of_birth DATE NOT NULL
);
GO

CREATE TABLE TempInstructor (
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_hiring DATE NOT NULL,
    date_of_firing DATE DEFAULT NULL,
	instructor_pesel CHAR(11) PRIMARY KEY
);
GO

CREATE TABLE TempCourse (
    course_id CHAR(9) PRIMARY KEY,
	category CHAR(5) NOT NULL,
    start_date DATE NOT NULL,
    finish_date DATE DEFAULT NULL,
    pesel CHAR(11),
    FOREIGN KEY (pesel) REFERENCES Student(pesel)
);
GO

CREATE TABLE TempDriving_lesson (
    lesson_id CHAR(9) PRIMARY KEY,
	course_id CHAR(9),
    lesson_date DATETIME NOT NULL,
    duration INT CHECK (duration BETWEEN 0 AND 600),
    instructor_pesel CHAR(11),
	lesson_hour INT CHECK (lesson_hour BETWEEN 0 AND 24)
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (instructor_pesel) REFERENCES Instructor(instructor_pesel)
);
GO

BULK INSERT TempStudent
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2024\2020-2024\students.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

MERGE Student AS Target
USING TempStudent AS Source
ON Target.pesel = Source.pesel
WHEN MATCHED THEN
    UPDATE SET 
        Target.name = Source.name,
        Target.surname = Source.surname,
        Target.date_of_birth = Source.date_of_birth
WHEN NOT MATCHED BY TARGET THEN
    INSERT (name, surname, pesel, date_of_birth)
    VALUES (Source.name, Source.surname, Source.pesel, Source.date_of_birth);

DROP TABLE IF EXISTS TempStudent;

BULK INSERT TempInstructor
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2024\2020-2024\instructors.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

MERGE Instructor AS Target
USING TempInstructor AS Source
ON Target.instructor_pesel = Source.instructor_pesel
WHEN MATCHED THEN
    UPDATE SET 
        Target.name = Source.name,
        Target.surname = Source.surname,
        Target.date_of_birth = Source.date_of_birth,
        Target.date_of_hiring = Source.date_of_hiring,
        Target.date_of_firing = Source.date_of_firing
WHEN NOT MATCHED BY TARGET THEN
    INSERT (name, surname, date_of_birth, date_of_hiring, date_of_firing, instructor_pesel)
    VALUES (Source.name, Source.surname, Source.date_of_birth, Source.date_of_hiring, Source.date_of_firing, Source.instructor_pesel);

DROP TABLE IF EXISTS TempInstructor;

BULK INSERT TempCourse
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2024\2020-2024\courses.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

MERGE Course AS Target
USING TempCourse AS Source
ON Target.course_id = Source.course_id
WHEN MATCHED THEN
    UPDATE SET 
        Target.category = Source.category,
        Target.start_date = Source.start_date,
        Target.finish_date = Source.finish_date,
        Target.pesel = Source.pesel
WHEN NOT MATCHED BY TARGET THEN
    INSERT (course_id, category, start_date, finish_date, pesel)
    VALUES (Source.course_id, Source.category, Source.start_date, Source.finish_date, Source.pesel);

DROP TABLE IF EXISTS TempCourse;

BULK INSERT TempDriving_lesson
FROM 'E:\@@@@ SEMESTR 5 @@@@\Hurtownie Danych\T-SQL ETL\2020-2024\2020-2024\lessons.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2,
    CODEPAGE = '65001'
);

MERGE Driving_lesson AS Target
USING TempDriving_lesson AS Source
ON Target.lesson_id = Source.lesson_id
WHEN MATCHED THEN
    UPDATE SET 
        Target.course_id = Source.course_id,
        Target.lesson_date = Source.lesson_date,
        Target.duration = Source.duration,
        Target.instructor_pesel = Source.instructor_pesel,
        Target.lesson_hour = Source.lesson_hour
WHEN NOT MATCHED BY TARGET THEN
    INSERT (lesson_id, course_id, lesson_date, duration, instructor_pesel, lesson_hour)
    VALUES (Source.lesson_id, Source.course_id, Source.lesson_date, Source.duration, Source.instructor_pesel, Source.lesson_hour);

DROP TABLE IF EXISTS TempDriving_lesson;

UPDATE Course
SET category = 'E'
WHERE course_id = 100880889;

UPDATE Student
SET surname = 'NoweNazwisko'
WHERE pesel = '20030958275';

UPDATE Instructor
SET surname = 'NoweNazwisko2'
WHERE instructor_pesel = '10060284857';

