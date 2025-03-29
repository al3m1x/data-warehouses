SELECT * FROM Time;
SELECT * FROM Date;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Exam;
SELECT * FROM Junk;
SELECT * FROM DrivingLesson;
SELECT * FROM ExamTake;

SELECT * FROM Course
WHERE CourseNumber = 100880889;

SELECT * FROM Student
WHERE PESEL_Student = 20030958275;

SELECT * FROM Instructor
WHERE PESEL_Instructor = 10060284857;

SELECT * FROM DrivingLesson
WHERE ID_Instructor = 1;

SELECT * FROM DrivingLesson
WHERE ID_Instructor = 1001;