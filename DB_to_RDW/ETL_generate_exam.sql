USE HD_DrivingSchool
GO

DECLARE @Categories TABLE (Category VARCHAR(5));
INSERT INTO @Categories (Category)
VALUES
('A'), ('B'), ('C'), ('D'), ('E'), ('AM'), ('B1');

INSERT INTO Exam
(
    [Category],
    [Type]
)
SELECT Category, 'Practice' FROM @Categories
UNION ALL
SELECT Category, 'Theory' FROM @Categories;
GO
