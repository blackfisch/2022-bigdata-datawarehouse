csv <- read.csv("..\\data\\Aktuell_Deutschland_COVID-19-Hospitalisierungen.csv");

berechne_maximum <- function(){
  max(csv$X7T_Hospitalisierung_Faelle)
}

berechne_maximum()
