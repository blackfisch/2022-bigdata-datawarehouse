hosp_data <- read.csv("data/Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv")
impf_df <- read.csv("data/Aktuell_Deutschland_Bundeslaender_COVID-19-Impfungen.csv")
inzidenz_df <- read.csv("data/COVID-19-Faelle_7-Tage-Inzidenz_Deutschland.csv")
final_data <- 0

install_needed_package <- function() {
  install.packages("corrplot")
  install.packages("magrittr")
}

extrem_wert_analyse <- function() {
  
   hosp_data <- filter(
    hosp_data,
    grepl("00\\+", hosp_data$Altersgruppe)
  )
  
  print(max(hosp_data$X7T_Hospitalisierung_Faelle))
  print(min(hosp_data$X7T_Hospitalisierung_Faelle))


  plot(as.Date(hosp_data$Datum),hosp_data$X7T_Hospitalisierung_Faelle, type = "l", lty = 1, lwd = 1)


  csv_only_number_inzidenz <- data.frame(
    inzidenz_df$Meldedatum,
    inzidenz_df$Altersgruppe,
    inzidenz_df$Inzidenz_7.Tage
  )

   xyz2 <<- filter(
    csv_only_number_inzidenz,
    grepl("00\\+", csv_only_number_inzidenz$inzidenz_df.Altersgruppe)
  )

  plot(as.Date(xyz2$inzidenz_df.Meldedatum),xyz2$inzidenz_df.Inzidenz_7.Tage, type = "l", lty = 1, lwd = 1)
}

plote_korrelationsmatrix <- function() {
  library(corrplot)
  library(magrittr)
  library(dplyr)

  impfugen_reduzed <- data.frame(impf_df$Impfdatum, impf_df$Anzahl)

  impfugen_sum <- impfugen_reduzed %>%
    group_by_if(is.numeric %>%
      Negate()) %>%
    summarize_all(sum)


  csv_only_number <- data.frame(
    hosp_data$Datum,
    hosp_data$Altersgruppe,
    hosp_data$X7T_Hospitalisierung_Faelle,
    hosp_data$X7T_Hospitalisierung_Inzidenz,
    hosp_data$Bundesland_Id
  )
  
  xyz <- filter(
    csv_only_number,
    grepl("00\\+", csv_only_number$hosp_data.Altersgruppe)
  )

  final_csv <- xyz %>% filter(xyz$hosp_data.Bundesland_Id == 0)

  library(data.table)
  setDT(final_csv)
  setDT(impfugen_sum)

  final_data <<- merge(
    final_csv,
    impfugen_sum,
    by.x = "hosp_data.Datum",
    by.y = "impf_df.Impfdatum"
  )

  data_corona <- data.frame(
    final_data$hosp_data.X7T_Hospitalisierung_Faelle,
    final_data$hosp_data.X7T_Hospitalisierung_Inzidenz,
    final_data$impf_df.Anzahl
  )

  m <- cor(data_corona)
  corrplot(m, method = "color")
}


system.time(extrem_wert_analyse())
system.time(plote_korrelationsmatrix())

