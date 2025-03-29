USE HD_DrivingSchool
GO

DECLARE @StartHour INT = 6;
DECLARE @EndHour INT = 20;

DECLARE @CurrentHour INT = @StartHour;

WHILE @CurrentHour <= @EndHour
BEGIN
    INSERT INTO Time
    (
        [Hour], 
        [TimeOfDay]
    )
    VALUES
    (
        @CurrentHour,  
        CASE 
            WHEN @CurrentHour BETWEEN 6 AND 8 THEN '6-9'
            WHEN @CurrentHour BETWEEN 9 AND 11 THEN '9-12'
            WHEN @CurrentHour BETWEEN 12 AND 14 THEN '12-15'
            WHEN @CurrentHour BETWEEN 15 AND 17 THEN '15-18'
            WHEN @CurrentHour BETWEEN 18 AND 20 THEN '18-21'
            ELSE 'Other'
        END
    );

    SET @CurrentHour = @CurrentHour + 1;
END
GO
