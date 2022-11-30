csv <- read.csv("..\\data\\Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv");
csv_impfung <- read.csv("..\\data\\Aktuell_Deutschland_Impfquoten_COVID-19.csv");

install_needed_package <- function(){
  install.packages("corrplot")
  install.packages("magrittr")
}

extrem_wert_analyse <- function(){
  print(max(csv$X7T_Hospitalisierung_Faelle))
  print(min(csv$X7T_Hospitalisierung_Faelle))
}

prepare_data <- function(){
  print("test")
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
  return(final_final_data)
}

plote_korrelationsmatrix <- function() {
  library(corrplot)
  library(magrittr)
  library(dplyr)
  
  csv_only_number <- data.frame(csv$Datum,csv$Altersgruppe,csv$X7T_Hospitalisierung_Faelle,csv$X7T_Hospitalisierung_Inzidenz,csv$Bundesland_Id)
  
  csv_only_number_a <- filter(csv_only_number ,grepl('00\\+', csv_only_number$csv.Altersgruppe))
  
  csv_only_number_b <- data.frame(csv_only_number_a$csv.X7T_Hospitalisierung_Faelle,csv_only_number_a$csv.X7T_Hospitalisierung_Inzidenz,csv_only_number_a$csv.Bundesland_Id)
  M <- cor(final_final_data)
  corrplot(M, method="color")
}

extrem_wert_analyse()
final_final_data <- prepare_data()
plote_korrelationsmatrix()

