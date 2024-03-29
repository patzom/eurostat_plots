library(eurostat)
library(dplyr)
library(plyr)

names <- c("pov_th", "pov", "quants", "qsr", "gini", 
           "inc", "hlth", "pov_reg")
codes <- c("ilc_li01", "ilc_li02", "ilc_di01", "ilc_di11", "ilc_di12", 
           "ilc_di03", "ilc_lk11", "ilc_li41")

data <- lapply(codes, get_eurostat, stringsAsFactors = FALSE)
names(data) <- names

list2env(data, .GlobalEnv)


#get inflation data 

infl <- get_eurostat(id = "prc_hicp_aind")

infl <- infl %>% filter(coicop == "CP00" &
                          unit == "INX_A_AVG" &
                          time > "2003-01-01")

infl$time <- format(infl$time, format="%Y")

colnames(infl)[colnames(infl) == "values"] <- "CPI"

inc$time <- format(inc$time, format = "%Y")

inc$unit <- colnames(inc$unit)

colnames(infl)[1] <- "infl_unit"


###left_join and dplyr logic to keep tbl_df
inc <- left_join(infl, inc, by = c("geo" = "geo", "time" = "time"))

inc <- mutate(inc, realinc = values * 100 / CPI)



# save data ---------------------------------------------------------------

eurostat_data <- list(pov_th, pov, quants, qsr, gini, inc, hlth, pov_reg)

dir.create("./data")

save(eurostat_data, file='./data/eurostat_data.rda', compress = 'xz')
