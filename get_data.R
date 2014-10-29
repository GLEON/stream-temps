library(dataRetrieval)

#download.file(constructNWISURL("06934500","00010","1980-10-01","2015-09-30", 
#                               service="dv", format='tsv'), 'test.tsv')
#tmp = read.table('test.tsv', skip=24, sep='\t')

#plot(as.POSIXct(tmp$V3), tmp$V4)


state_codes = c('AL','AZ','AR','CA','CO','CT','DE','FL','GA','ID','IL','IN','IA',
'KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM',
'NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA',
'WV','WI','WY')


all_sites = data.frame()

for(i in 1:length(state_codes)){
  all_sites = rbind(all_sites, 
                    getNWISSites(stateCd=state_codes[i], parameterCd="00010", period='P960W', hasDataTypeCd='iv'))
  cat(i,'\n')
}

write.table(all_sites,'all_sites_conus.tsv', sep='\t', row.names=FALSE)

all_sites = read.table('all_sites_conus.tsv', sep='\t', header=TRUE)
data_path = 'E:/NWIS_data'



for(i in 1:nrow(all_sites)){
  nwis_url = constructNWISURL(all_sites$site_no[i],"00010","1950-10-01","2015-09-30", 
                  service="dv", format='tsv')
  dest = paste0(data_path, '/iv/', all_sites$site_no[i], '.tsv')
  tryCatch({
    
  download.file(nwis_url, dest)
  }, 
  error=function(e){unlink(dest)})
}


