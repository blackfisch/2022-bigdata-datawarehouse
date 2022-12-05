csv <- read.csv("data/Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv")
csv_impfung <- read.csv("data/Aktuell_Deutschland_Impfquoten_COVID-19.csv")
final_data <- 0

install_needed_package <- function() {
  install.packages("corrplot")
  install.packages("magrittr")
}

extrem_wert_analyse <- function() {
  print(max(csv$X7T_Hospitalisierung_Faelle))
  print(min(csv$X7T_Hospitalisierung_Faelle))
}

prepare_data <- function() {
  print("test")
  library(dplyr)

  impfung <- read.csv(
    "data/Aktuell_Deutschland_Bundeslaender_COVID-19-Impfungen.csv"
  )

  impfugen_reduzed <- data.frame(impfung$Impfdatum, impfung$Anzahl)

  impfugen_sum <- impfugen_reduzed %>%
    group_by_if(is.numeric %>%
      Negate()) %>%
    summarize_all(sum)


  csv_only_number <- data.frame(
    csv$Datum,
    csv$Altersgruppe,
    csv$X7T_Hospitalisierung_Faelle,
    csv$X7T_Hospitalisierung_Inzidenz,
    csv$Bundesland_Id
  )

  xyz <- filter(
    csv_only_number,
    grepl("00\\+", csv_only_number$csv.Altersgruppe)
  )

  final_csv <- xyz %>% filter(xyz$csv.Bundesland_Id == 0)

  library(data.table)
  setDT(final_csv)
  setDT(impfugen_sum)

  final_data <<- merge(
    final_csv,
    impfugen_sum,
    by.x = "csv.Datum",
    by.y = "impfung.Impfdatum"
  )

  final_final_data <- data.frame(
    final_data$csv.X7T_Hospitalisierung_Faelle,
    final_data$csv.X7T_Hospitalisierung_Inzidenz,
    final_data$impfung.Anzahl
  )
  return(final_final_data)
}



plote_korrelationsmatrix <- function() {
  library(corrplot)
  library(magrittr)
  library(dplyr)

  m <- cor(data_corona)
  corrplot(m, method = "color")
}

prediction <- function() {
  fit <- lm(
    csv.X7T_Hospitalisierung_Faelle ~ as.Date(c(csv.Datum)),
    data = final_data
  )
  new_data <- data.frame(csv.Datum = as.Date(c("2022-11-1", "2022-11-30")))
  predict(fit, new_data, interval = "confidence")
}

extrem_wert_analyse()
data_corona <- prepare_data()
plote_korrelationsmatrix()
prediction()
