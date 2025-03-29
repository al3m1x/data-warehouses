USE Drive_By;
GO

CREATE TABLE Student (
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
	pesel CHAR(11) PRIMARY KEY,
    date_of_birth DATE NOT NULL
);
GO

CREATE TABLE Instructor (
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_hiring DATE NOT NULL,
    date_of_firing DATE DEFAULT NULL,
	instructor_pesel CHAR(11) PRIMARY KEY
);
GO

CREATE TABLE Course (
    course_id CHAR(9) PRIMARY KEY,
	category CHAR(5) NOT NULL,
    start_date DATE NOT NULL,
    finish_date DATE DEFAULT NULL,
    pesel CHAR(11),
    FOREIGN KEY (pesel) REFERENCES Student(pesel)
);
GO

CREATE TABLE Driving_lesson (
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