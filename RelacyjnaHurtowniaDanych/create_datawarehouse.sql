USE HD_DrivingSchool
GO

CREATE TABLE Time (
    ID_Time INT IDENTITY(1,1) PRIMARY KEY,
    Hour TINYINT CHECK (Hour BETWEEN 0 AND 23),
    TimeOfDay VARCHAR(20)
);
GO

CREATE TABLE Date (
    ID_Date INT IDENTITY(1,1) PRIMARY KEY,
    Date DATE NOT NULL,
    Year INT CHECK (Year BETWEEN 1000 AND 9999),
    Month VARCHAR(10),
    MonthNo TINYINT,
    DayOfWeek VARCHAR(10),
    Season VARCHAR(10)
);
GO

CREATE TABLE Instructor (
    ID_Instructor INT IDENTITY(1,1) PRIMARY KEY,
    PESEL_Instructor CHAR(11),
    Name VARCHAR(20) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    AgeCategory VARCHAR(10),
    WorkExperience VARCHAR(20),
    EmploymentState VARCHAR(20),
	EntryDate datetime not null,
	ExpiryDate datetime,
    IsCurrent BIT
);
GO

CREATE TABLE Course (
    ID_Course INT IDENTITY(1,1) PRIMARY KEY,
    CourseNumber CHAR(9),
    Category CHAR(5) NOT NULL,
    CourseState VARCHAR(20),
	EntryDate datetime not null,
	ExpiryDate datetime,
    IsCurrent BIT
);
GO

CREATE TABLE Student (
    ID_Student INT IDENTITY(1,1) PRIMARY KEY,
    PESEL_Student CHAR(11),
    Name VARCHAR(20) NOT NULL,
    Surname VARCHAR(20) NOT NULL,
    AgeCategory VARCHAR(10),
	EntryDate datetime not null,
	ExpiryDate datetime,
    IsCurrent BIT
);
GO

CREATE TABLE Exam (
    ID_Exam INT IDENTITY(1,1) PRIMARY KEY,
    Category VARCHAR(5),
    Type VARCHAR(10)
);
GO

CREATE TABLE Junk (
    ID_Junk INT IDENTITY(1,1) PRIMARY KEY,
    IsPassed BIT
);
GO

CREATE TABLE DrivingLesson (
    ID_Lesson INT IDENTITY(1,1) PRIMARY KEY,
    ID_Date INT,
    ID_Time INT,
    ID_Instructor INT,
    ID_Course INT,
    ID_Student INT,
    PriceForHour DECIMAL(10, 2),
    Duration INT CHECK (Duration > 0),
    FOREIGN KEY (ID_Date) REFERENCES Date(ID_Date),
    FOREIGN KEY (ID_Time) REFERENCES Time(ID_Time),
    FOREIGN KEY (ID_Instructor) REFERENCES Instructor(ID_Instructor),
    FOREIGN KEY (ID_Course) REFERENCES Course(ID_Course),
    FOREIGN KEY (ID_Student) REFERENCES Student(ID_Student)
);
GO

CREATE TABLE ExamTake (
    ID_ExamTake INT IDENTITY(1,1) PRIMARY KEY,
    ID_Date INT,
    ID_Student INT,
    ID_Exam INT,
    ID_Junk INT,
    FOREIGN KEY (ID_Date) REFERENCES Date(ID_Date),
    FOREIGN KEY (ID_Student) REFERENCES Student(ID_Student),
    FOREIGN KEY (ID_Exam) REFERENCES Exam(ID_Exam),
    FOREIGN KEY (ID_Junk) REFERENCES Junk(ID_Junk)
);
GO