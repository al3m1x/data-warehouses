USE HD_DrivingSchool
GO

DECLARE @StartDate DATE = '2020-01-01';
DECLARE @EndDate DATE = '2024-12-31';

DECLARE @CurrentDate DATE = @StartDate;

WHILE @CurrentDate <= @EndDate
BEGIN
    INSERT INTO Date
    (
        [Date], 
        [Year], 
        [Month], 
        [MonthNo], 
        [DayOfWeek], 
        [Season]
    )
    VALUES
    (
        @CurrentDate,  
        CAST(YEAR(@CurrentDate) AS VARCHAR(4)),
        DATENAME(MONTH, @CurrentDate),
        MONTH(@CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        CASE 
            WHEN (MONTH(@CurrentDate) = 12 AND DAY(@CurrentDate) >= 21) OR
                 (MONTH(@CurrentDate) = 1) OR
                 (MONTH(@CurrentDate) = 2) OR
                 (MONTH(@CurrentDate) = 3 AND DAY(@CurrentDate) <= 19) THEN 'Winter'
            WHEN (MONTH(@CurrentDate) = 3 AND DAY(@CurrentDate) >= 20) OR
                 (MONTH(@CurrentDate) = 4) OR
                 (MONTH(@CurrentDate) = 5) OR
                 (MONTH(@CurrentDate) = 6 AND DAY(@CurrentDate) <= 20) THEN 'Spring'
            WHEN (MONTH(@CurrentDate) = 6 AND DAY(@CurrentDate) >= 21) OR
                 (MONTH(@CurrentDate) = 7) OR
                 (MONTH(@CurrentDate) = 8) OR
                 (MONTH(@CurrentDate) = 9 AND DAY(@CurrentDate) <= 21) THEN 'Summer'
            WHEN (MONTH(@CurrentDate) = 9 AND DAY(@CurrentDate) >= 22) OR
                 (MONTH(@CurrentDate) = 10) OR
                 (MONTH(@CurrentDate) = 11) OR
                 (MONTH(@CurrentDate) = 12 AND DAY(@CurrentDate) <= 20) THEN 'Autumn'
            ELSE 'Error'
        END
    );

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END
GO
