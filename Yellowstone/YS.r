{
  rm(list=ls()); options(show.error.locations = TRUE);  
  library(package=ggplot2);
  library(package=ggrepel);   # for the overlapping text on scatterplots
  library(package=gridExtra); # to put multiple plots on one canvas
  theme_set(theme_classic()); # sets the default theme of all ggplots
  # centers the title for all ggplots (it modifies the default theme) 
  theme_update(plot.title = element_text(hjust = 0.5));
  
  # remove rows using skip
  # remove columns using [], could do -1 to just remove column one
  salmonCorRep = read.csv("SCA_LKT_98_18_WN_sv_logistic.cor", sep="",
                          skip=1, stringsAsFactors=FALSE, header=TRUE,
                          strip.white = TRUE)[,2:4];
  salmonDataList = read.delim("SCA_LKT_98_18_WN_sv_logistic.rep",
                              stringsAsFactors=FALSE, header=FALSE);
  pointRep = read.delim("sr_point.rep",
                        stringsAsFactors=FALSE, header=FALSE);
  
  # Mapping bettwen report and list:
  # [1] 
  # [2] Ffull: Annual fully selected gillnet F estimates
  # [3] N: Total abundance at start of year
  # [4] endN: Total Abundance at end of season
  # [5]
  # [6]
  # [7] bio_pop: Total Biomass
  # [8]
  # [9]
  # [10] s0: Early life survival (delay by 2 years)
  
  # exract the one string column from the list
  salmonData = salmonDataList[[1]];  
  
  # trim extra white space and the beginning and end of each row of data
  for(i in 1:length(salmonData))
  {
    salmonData[i] = trimws(salmonData[i], which="both");
  }

  ##### The first four lines are info about the rest of the document 

  # break up the second line into: initial year, final year, survey year
  yearData = unlist(strsplit(salmonData[2], split="\\s+")); # split data by whitespace
  yearData = as.numeric(yearData);                  # cast data as numeric
  yearInit = yearData[1];
  yearEnd = yearData[2];
  yearSurvey = yearData[3];
  numYears = yearEnd-yearInit+1;  # number of years in the data
  
  # break up the forth line into: first age, last age
  ageData = unlist(strsplit(salmonData[4], split="\\s+")); # split data by whitespace
  ageData = as.numeric(ageData);                     # cast data as numeric
  ageFirst = ageData[1];
  ageLast = ageData[2];
  
  # odd lines are headers, even lines are numeric data
  # create a matrix to hold all the numeric data 
  data = matrix(nrow=(length(salmonData)-4)/2, ncol=numYears);
  
  # the column headers will be set to the odd-line headers
  columnDesc = c();
  
  # go through the remaining rows in the salmon data
  for(i in 5:length(salmonData))
  {
    # even line -- this is numeric data
    if(i%%2 == 0)  
    {
      # take data out of the list and split data by whitespace -- 
      #  data is separated by an unknown number of spaces: "\\s+" 
      numData = unlist(strsplit(salmonData[i], split="\\s+"));
      
      for(j in 1:length(numData))
      {
        # add numeric salmon data to the matrix
        data[(i-4)/2, j] = as.numeric(numData[j]);
      }
    }
    else # odd line -- this is a header
    {
      header = salmonData[i];
      
      # add column header to corresponding numeric data 
      columnDesc[((i-4)/2)+1] = header;
    }
  }
  # shift the last row (early life survival) two columns over
  data[nrow(data), 3:ncol(data)] = data[nrow(data), 1:(ncol(data)-2)];
  data[nrow(data), 1:2] = NA; 
  
  rownames(data) = columnDesc;
  colnames(data) = as.numeric(yearInit:yearEnd);
  
  # Information use in plots is created here because some of this information
  # is used in the writeup
  # it needs to come before the write-up
  
  # For Figure 2: Supression Gilnetting F(ishing Mortality)
  Ffull = which(salmonCorRep$name == "Ffull");
  gilnet = as.numeric(data[2,]);
  gilnet_SE = salmonCorRep[Ffull, "std.dev"];
  gilnet_CI = 1.96*gilnet_SE;
  
  p2 = ggplot() +
    geom_line(mapping=aes(x=yearInit:yearEnd, 
                          y=gilnet)) +
    geom_line(mapping=aes(x=yearInit:yearEnd, 
                          y=gilnet + gilnet_CI),
              color="red",
              linetype = "dashed") +
    geom_line(mapping=aes(x=yearInit:yearEnd, 
                          y=gilnet - gilnet_CI),
              color="red",
              linetype = "dashed") + 
    scale_x_continuous(breaks=yearInit:yearEnd) +
    scale_y_continuous(breaks=seq(from=0, to=max(gilnet+gilnet_CI+0.2),
                                  by=0.2)) +
    labs(x="Year",
         y="F",
         title="Supression Gillnetting F") +
    theme(axis.text.x=element_text(angle=90, vjust=0.5));
  
  # For Figure 3: age2PlusAbundance
  N = which(salmonCorRep$name == "N");
  abundance = as.numeric(data[3,])/1000;
  abundance_SE = salmonCorRep[N, "std.dev"]/1000;
  abundance_CI = 1.96*abundance_SE;
  
  p3 = ggplot() +
    geom_line(mapping=aes(x=yearInit:yearEnd,
                          y=abundance)) + 
    geom_line(mapping=aes(x=yearInit:yearEnd,
                          y=abundance + abundance_CI),
              color="red",
              linetype = "dashed") + 
    geom_line(mapping=aes(x=yearInit:yearEnd,
                          y=abundance - abundance_CI),
              color="red",
              linetype = "dashed") + 
    scale_x_continuous(breaks=yearInit:yearEnd) +
    labs(x="Year",
         y="Abundance (thousands)",
         title="Age 2+ Abundance") +
    theme(axis.text.x=element_text(angle=90, vjust=0.5));
  
  # For Figure 4: age2PlusBiomass
  bio_pop = which(salmonCorRep$name == "bio_pop");
  biomass = as.numeric(data[7,])/1000;
  biomass_SE = salmonCorRep[bio_pop, "std.dev"]/1000;
  biomass_CI = 1.96*biomass_SE;
  
  p4 = ggplot() +
    geom_line(mapping=aes(x=yearInit:yearEnd,
                          y=biomass)) + 
    geom_line(mapping=aes(x=yearInit:yearEnd,
                          y=biomass + biomass_CI),
              color="red",
              linetype = "dashed") + 
    geom_line(mapping=aes(x=yearInit:yearEnd,
                          y=biomass - biomass_CI),
              color="red",
              linetype = "dashed") + 
    scale_x_continuous(breaks=yearInit:yearEnd) +
    labs(x="Year", 
         y="Biomass (thousands of kg)",
         title="Age 2+ Biomass") +
    theme(axis.text.x=element_text(angle=90, vjust=0.5));
  
  # For Figure 5: age2Aundance ~ Eggs Produced
  age2Abundance = as.numeric(data[9,])/1000;
  eggsProduced = as.numeric(data[8,])/1000000;
  
  p5 = ggplot() +
    geom_point(mapping=aes(x=eggsProduced[1:(numYears-2)],
                           y=age2Abundance[3:numYears])) + 
    # geom_text_repel handles the overlapping points/labels
    geom_text_repel(mapping=aes(x=eggsProduced[1:(numYears-2)],
                                y=age2Abundance[3:numYears],
                                label=yearInit:(yearEnd-2)),
                    nudge_x=1,
                    segment.color = "blue") + 
    labs(x="Eggs Produced (millions)", 
         y="Age 2 Abundance (thousands)");
  
  # For Figure 6
  alphaCorrected = as.numeric(unlist(pointRep)[8]);
  beta = as.numeric(unlist(pointRep)[6]);
  eggs = seq(from=1, to=600, by=1);
  age2Abund = alphaCorrected*(eggs*1e6)*exp(-beta*(eggs*1e6));
  
  ## Predicted Pre-Recruitment
  # The prediction equation is
  # Age 2 abundance  = AC*Eggs*exp(-beta*Eggs)
  # Where eggs go from 0 to 600 million.
  p6a = ggplot() +
    geom_point(mapping=aes(x=eggsProduced[1:(numYears-2)],
                           y=age2Abundance[3:numYears])) + 
    geom_text_repel(mapping=aes(x=eggsProduced[1:(numYears-2)],
                                y=age2Abundance[3:numYears],
                                label=substr(yearInit:(yearEnd-2),3 ,4)),
                    size = 2,
                    segment.color = "blue") + 
    geom_line(mapping=aes(x=eggs, y=age2Abund/1000), col="red") +
    scale_y_continuous(breaks=scales::pretty_breaks(n = 10)) +
    labs(x="Eggs Produced (millions)", 
         y="Age 2 Abundance (thousands)",
         title="Predicted Stock-Recruitment\nRelationship");
  
  # Plot of early life survival (ratio of predicted age-2 abundance versus eggs) plotted against eggs.  
  # The dashed vertical lines reference the minimum and maximum number of eggs
  # found in the .rep file.  The red dashed horizontal lines are reference
  # lines indicating early life survival values of:
  #   0.0025, 0.013425, and 0.015385.  
  p6b = ggplot() +
    geom_line(mapping=aes(x=eggs,
                          y=age2Abund/(eggs*1e6))) + 
    geom_vline(xintercept=max(eggsProduced), 
               linetype="dotted", color="blue", size=1) +
    geom_vline(xintercept=min(eggsProduced), 
               linetype="dotted", color="blue", size=1) +
    geom_hline(yintercept=c(0.0025, 0.013425, 0.015385), 
               linetype="dashed", color="red", size=0.7) +
    scale_y_continuous(breaks=scales::pretty_breaks(n = 10)) +
    labs(x="Eggs Produced (millions)", 
         y="Pre-Recruit Survival",
         title="Predicted Pre-Recruitment\nSurvival");
  
  # Will be outputted in the RMD file
  # plot(p2);
  # plot(p3);
  # plot(p4);
  # plot(p5);
  # grid.arrange(p6a, p6b, ncol=2);
}