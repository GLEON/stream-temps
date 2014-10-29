library(plyr)

#'@title Seasonal, cross-site Sen's slope
#'@description
#'This outputs all paired-value slopes for a seasonal/cross-site Sen's
#'slope estimator. To get the slope, calculate the median value of all 
#'paired-value slopes. 
#'
#'
#'@param times Numeric vector of times (year for example)
#'@param data Numeric vector of observation values
#'@param season_i Numeric vector of season identifiers (example: week number)
#'@param sites_i Optional numeric of site identifiers (can be numeric or string)
#'
#'@import plyr
#'@export
sens_seasonal_site = function(times, data, season_i, sites_i){
  
  if(missing(sites_i)){
    warning("assuming only one site")
    sites_i = rep(1, length(season_i))
  }

  all_df = data.frame(times, data, season_i, sites_i)
  
  
  output = ddply(all_df, c('sites_i', 'season_i'), function(df){
    data = df$data
    times = df$times
    
    if(length(data)==2){
      perm.i = matrix(c(1,2))
      #return((data[1]-data[2])/(times[1]-times[2]))
    }else{
      perm.i = combn(1:length(data),2)
    }
    
    
    #perm1 = data[perm.i[1,],]
    #perm2 = data[perm.i[2,],]
    starts = apply(matrix(times[c(perm.i[1,], perm.i[2,])], ncol=2), 1, min)
    ends   = apply(matrix(times[c(perm.i[1,], perm.i[2,])], ncol=2), 1, max)
    dts    = abs(times[perm.i[1,]] - times[perm.i[2,]])
    
    slopes = (data[perm.i[1,]]-data[perm.i[2,]])/(times[perm.i[1,]] - times[perm.i[2,]])
    
    return(data.frame(slopes, start=starts, end=ends, dt=diff(range(times)), n.obs=length(times)))
    
  })
  
  return(output)
}