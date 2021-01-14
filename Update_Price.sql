--Creating temporary table with the data needed from cnfMachinesMaster
CREATE TABLE #Temp(
	LegacyShortName char(6),
	DefaultPrice numeric(18,5)
)
GO

--Inserting on the temporary table the data from a file(txt or csv)
BULK INSERT #TEMP
FROM 'D:\Normal.txt' --path example, use the path that the file is saved
WITH
 (
    FIELDTERMINATOR = ',', --field must be terminated with comma
    ROWTERMINATOR  = '0x0a', -- hexadecimal code for \n
    errorfile = 'D:\err.txt' -- Path where error logs are being saved
  )    
GO

select * from #Temp -- Select after inserting to check if all data is registered correctly on the temporary table

-- Update cnfMachinesMaster with the data obtained from temporary table
UPDATE MM 
SET MM.LegacyShortName = t.LegacyShortName , MM.DefaultPrice = t.DefaultPrice
FROM cnfMachinesMaster MM JOIN #Temp t ON MM.LegacyShortName = t.LegacyShortName 
collate SQL_Latin1_General_CP1_CI_AS
GO

-- after updating, drop the temporary table
DROP Table #Temp
GO