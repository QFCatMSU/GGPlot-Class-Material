# if you want the same "random" numbers each time you run the script
# remove this line if you don't care
set.seed(8765);

numRows = 20;  # 28800
numCols = 14;  
numPicks = 4;  # 280

myDF = data.frame(matrix(0, nrow = numRows, ncol = numCols));

for(i in 1:numCols)
{
  randomIndex=sample(1:numRows, size=numPicks, replace = FALSE);
  myDF[randomIndex, i] = 5;
}