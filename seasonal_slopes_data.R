#seasonal_slopes_data

source('sens_seasonal.R')

sites = Sys.glob('E:/NWIS_data/*.tsv')

tmp = data.frame()

for(i in 1:length(sites)){

  data = read.table(sites[i], skip=25)
  
  data$date = as.POSIXct(data$V3)
  data$year = as.POSIXlt(data$date)$year + 1900
  data$yday = as.POSIXlt(data$date)$yday
  
  tmp = rbind(tmp, 
              sens_seasonal_site(times=data$year, data=data$V4, season_i=data$yday, sites_i = data$V2))
  cat(i, nrow(tmp), '\n')
}


site_is = unique(tmp$sites_i)

for(i in 1:length(site_is)){
  png(paste0("E:/NWIS_data/figs/noseason_", site_is[i], '.png'), res=300, width=2400, height=1200)
  boxplot(tmp[tmp$sites_i==site_is[i],]$slopes, ylim=c(-0.5,0.5))
  abline(0,0, lwd=2)
  
  dev.off()
}


site_is = unique(tmp$sites_i)

for(i in 1:length(site_is)){
  png(paste0("E:/NWIS_data/figs/", site_is[i], '.png'), res=300, width=2400, height=1200)
  boxplot(slopes~season_i, tmp[tmp$sites_i==site_is[i],], ylim=c(-0.5,0.5))
  abline(0,0, lwd=2)
  
  dev.off()
}

png(paste0("E:/NWIS_data/figs/all_sites", '.png'), res=300, width=2400, height=1200)
boxplot(tmp[tmp$sites_i==site_is[i],]$slopes, ylim=c(-0.5,0.5))
abline(0,0, lwd=2)

dev.off()


