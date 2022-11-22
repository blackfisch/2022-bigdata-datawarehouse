csv <- read.csv("..\\data\\Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv");

install_needed_package <- function(){
  install.packages("corrplot")
}

berechne_maximum <- function(){
  max(csv$X7T_Hospitalisierung_Faelle)
}

plote_korrelationsmatrix <- function() {
  library(corrplot)
  
  #dates <- as.Date((csv$Datum))
  
  #csv_only_number <- data.frame(dates,csv$X7T_Hospitalisierung_Faelle,csv$X7T_Hospitalisierung_Inzidenz,csv$Bundesland_Id)
  csv_only_number <- data.frame(csv$X7T_Hospitalisierung_Faelle,csv$X7T_Hospitalisierung_Inzidenz,csv$Bundesland_Id)
  #print(typeof(dates))
  M <- cor(csv_only_number)
  corrplot(M, method="color")
}

berechne_maximum()
plote_korrelationsmatrix()