{
  # execute the lines of code from reference.r
  source(file="scripts/reference.r")
  
  # read in CSV file and save the content to packageData
  classData = read.csv(file="data/grepData.csv",
                       stringsAsFactor=FALSE);   # not needed as of R 4.0
  
  # look for patterns in the values:  | means or
  #  so isJune is looking for any value that has one of the four combinations of characters
  isJune  = grep(pattern = "6/|6-|Jun|jun", x=classData$date);
  isJuly  = grep(pattern = "7/|7-|Jul|jul", x=classData$date);

  # Create column called month -- assign values of June and July based on grep above
  classData$month[isJune] = "June";
  classData$month[isJuly] = "July";
  
  # Replace all non-numeric values with "" (i.e., remove them)
  # Note: often easier to exclude (using ^) than include
  windValues = gsub(pattern = "[^0123456789]", replacement="", 
                    x=classData$windspeed);
  windValues = as.numeric(windValues);   # make the vector numeric (this is NOT automatic)
  classData$windSpedValues = windValues; # assign vector to a new column
  
  
  ## Assignment
  # 1) Find which rows in the temps column are Celsius (no unit means Fahrenheit)
  # 2) Extract the number from every row -- paid heed to signs and decimals
  # 3) Create a numeric vector from the extracted numbers
  # 4) Create a numeric temperature column in the data frame where all values are Fahrenheit
  #     formula: F = (9/5) * C + 32
  isCelsius  = grep(pattern = "c|C", x=classData$temp);

  tempData = gsub(pattern = "[^0123456789.-]", replacement="", 
                    x=classData$temp);
  tempData2 = as.numeric(tempData);

  tempDataFahr = tempData2;
  
  tempDataFahr[isCelsius] = (9/5) * tempDataFahr[isCelsius] + 32;
  classData$FahrTemps = tempDataFahr;
  
  ## Change all to Celsius:
  celsiusTemps = (5/9)*(tempDataFahr-32);
  
  ## Now change to Kelvin:
  classData$KelvinTemps = celsiusTemps + 273;
}
  
  
