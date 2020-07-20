# ## **** Summary of some of the structure Charlie uses in his code ***
# Source (instead of Run) your code -- forces you to structure it better
# copy line: Control-Shift-D (Command-Shift-D on Mac)
# comment out lines: Control-Shift-C (Command-Shift-C on Mac)
# { } -- fixes an obscure if-else bug in R
# = instead of <-: they do the same thing and = is standard in all programming languages
# Semicolons: explicitly tells R this is an end-of-common -- good for debugging
# 85 characters or less/line:
#        Tools -> Global Options -> Code -> Display -> Margin Column = 85
# Reference file: for code that gets repeated in multiple scripts
#        For instance: a customized GGPlot theme

{
  # execute the lines of code from reference.r 
  source(file="scripts/reference.r");   
  
  # read in CSV file and save the content to packageData
  classData = read.csv(file="data/grepData.csv",
                       stringsAsFactor=FALSE);   # not needed as of R 4.0
  
  classData2 = classData;  # create copy so we can see the changes
  
  # look for patterns in the values:  | means or
  # both isJune and is July are looking for values that has one of four combinations of characters
  isJune  = grep(pattern = "6/|6-|Jun|jun", x=classData2$date);
  isJuly  = grep(pattern = "7/|7-|Jul|jul", x=classData2$date);

  # Create column called month -- assign values of June and July based on grep above
  classData2$month[isJune] = "June";      classData2$month[isJuly] = "July";
  
  # Replace all non-numeric values with "" (i.e., remove them)
  # Note: often easier to exclude (using ^) than include
  windValues = gsub(pattern = "[^0123456789]", replacement="", 
                    x=classData2$windspeed);
  windValues2 = as.numeric(windValues);    # make the vector numeric (this is NOT automatic)
  classData2$windSpedValues = windValues2; # assign vector to a new column
  
  ## **Assignment**
  # 1) Find which rows in the temp column are Celsius (no unit means Fahrenheit)
  # 2) Extract the number from every row using gsub()
  #       Make sure to keep signs and decimals
  # 3) Create a numeric vector from the extracted numbers
  # 4) Create three numeric columns: 
  #       - Fahrenheit (F) temperatures
  #       - Celsius (C) temperatures 
  #       - Kelvin (K) temperatures
  #               F->C: C = (5/9)*(F-32)
  #               C->F: F = (9/5)*F +32
  #               C->K: K = C + 273 
  #               F->K: K = (5/9)*(F-32) + 273
  # 5) Add file to applications folder in your GitHub project
  
  # PDF that is all about Grep -- gets kind of advanced, though
  # https://rstudio.com/wp-content/uploads/2016/09/RegExCheatsheet.pdf
  
  
  ##### Hard example: extracting the day from the dates column 
  getDay1 = gsub(pattern = "[a-zA-Z0-9]*-", replacement="", 
                x=classData$date);
  getDay2 = gsub(pattern = "[a-zA-Z0-9]*/", replacement="", 
                x=getDay1);
  getDay3 = gsub(pattern = "[a-zA-Z]*", replacement="", 
                x=getDay2); 
  getDay4 = as.numeric(getDay3);
  
  # same as above in 1 step
  getDayAll = as.numeric(gsub(pattern = "[a-zA-Z0-9]*[-/]|[a-zA-Z]*", replacement="", 
                           x=classData$date));
}
  
  
