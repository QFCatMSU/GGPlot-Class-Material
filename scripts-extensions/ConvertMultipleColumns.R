{
  source( file="scripts/reference.R" ); 
  weatherData = read.csv( file="data/LansingNOAA2016.csv", 
                          stringsAsFactors = FALSE );
  
  convertToCelsius = function(col)
  {
    convertedCol = c();
    for(i in 1:length(col))
    {
      convertedCol[i] = (5/9) * (col[i]-32);
    }
    return(convertedCol);
  }
  
  maxTempC = convertToCelsius(weatherData$maxTemp);              
  minTempC = convertToCelsius(weatherData$minTemp);              
  avgTempC = convertToCelsius(weatherData$avgTemp);
  
  
# Note: the function could be simplified to:
#     convertToCelsius = function(col)
#     {
#       convertedCol = (5/9) * (col-32);
#       return(convertedCol);
#     } 
# because R 
}