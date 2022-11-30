library(dplyr)

impfung <- read.csv("..\\data\\Aktuell_Deutschland_Bundeslaender_COVID-19-Impfungen.csv")

impfugen_reduzed <- data.frame(impfung$Impfdatum, impfung$Anzahl)

impfugen_sum <- impfugen_reduzed %>% 
  group_by_if(is.numeric %>% Negate) %>%
  summarize_all(sum)


csv_only_number <- data.frame(csv$Datum,csv$Altersgruppe,csv$X7T_Hospitalisierung_Faelle,csv$X7T_Hospitalisierung_Inzidenz,csv$Bundesland_Id)

xyz <- filter(csv_only_number ,grepl('00\\+', csv_only_number$csv.Altersgruppe))

final_csv <- xyz %>% filter(xyz$csv.Bundesland_Id == 0)

library(data.table)
setDT(final_csv)
setDT(impfugen_sum)

final_data <- merge(final_csv,impfugen_sum, by.x = "csv.Datum" ,by.y = "impfung.Impfdatum")

final_final_data <- data.frame(final_data$csv.X7T_Hospitalisierung_Faelle, final_data$csv.X7T_Hospitalisierung_Inzidenz,final_data$impfung.Anzahl)
