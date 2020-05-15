##############################################################################################
# R code to prepare turtle.txt and lat.txt data into correct format for WinBUGs
# Code is for running the final model (i.e. quadratic predictor for latitude and 1 variance component
# for the beach intercept
########################################################################################

# NOTE: 
# I've centred latitude around its mean, while the other predictors I've used median. Can't remember
# my reasoning for doing this now(!), but it doesn't make any difference to results. Centering just helps with running of 
# WinBUGs model. In the same way for the year covariate, 1993 was the mean year in the previous analysis (data til 2007).
# For this analysis, we may as well keep with this 



#data<- read.csv("H:\Dc_data_1979_2008_for_model.csv")  # obtain turtle data.
data<- read.csv("data/Dc_data_1979_2008_for_model.csv")  # obtain turtle data.

data <- na.omit(data)   # TE added

lat1<- unique(data$lat)  # obtains all the unique latitude values, call it lat1
latc<- lat1-mean(lat1)   # create a new variable called latc that is the centred lat1
latc2<- latc^2           # create a new variable called latc2  - latc squared

med_dist<-median(data$distance) # Compute median length of beach surveyed (km). (in previous analysis it was 5.55)
med_dw<- median(data$days.week) # Compute median number of days per week surveyed  (in previous analysis it was 7)
med_dy<- median(data$days.year) # Compute median number of days per year surveyed (in previous analysis it was 143)

data$distance_c<- data$distance-med_dist  # centre length of beach surveyed around median value
data$days.week_c<- data$days.week-med_dw  # centre days per week surveyed 
data$days.year_c<- (data$days.year-med_dy)
data$yearcov<-data$year-1994 # centre year around 1994 (mean of years 1979:2008)

nbeach<-length(unique(data$ID))  # number of beaches in analysis (in previous analysis it was nbeach)
N<- nrow(data) #  number of records in data set (in previous analysis it was 1256)


X<- cbind(data$distance_c,
          data$days.week_c,
          data$days.year_c)  # forms a matrix of 3 columns - 1 for each effort predictor, each row is a record

# TE: this transposing makes no sense... the output has three columns, not 3 rows. 
#X<- t(X)   # transposes matrix so there are 3 rows - 1 for each effort predictor and the number of columns matches number of records
		# this is necessary for organising this data for WinBUGs analysis

# dput(list(N=as.numeric(N),
#           nbeach=as.numeric(nbeach),
#           count=as.numeric(data$nests),
#           beach=as.numeric(data$ID),
#           yearc=data$yearcov,
#           X=X,
#           latc=round(latc,3),
#           latc2=round(latc2,3)),
#      file="h:/winbugsdata.txt")   # saves data to file called winbugsdata.txt

dput(list(N=as.numeric(N),
          nbeach=as.numeric(nbeach),
          count=as.numeric(data$nests),
          beach=as.numeric(data$ID),
          yearc=data$yearcov,
          X=X,
          latc=round(latc,3),
          latc2=round(latc2,3)),
     file="data/winbugsdata_new.txt")   # saves data to file called winbugsdata.txt


