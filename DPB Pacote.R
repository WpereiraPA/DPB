install.packages(c("devtools", "usethis", "roxygen2", "FrF2", "BsMD"))
library(usethis)

use_mit_license("Wanderley Xavier Pereira")
use_roxygen_md()
use_readme_md()
use_git()

#Adicione dependências do pacote
use_package("FrF2")
use_package("BsMD")
usethis::create_package("C:/Users/Wanderley/DOE/DPB")

usethis::use_description()

dados <- read_clipboard_dpb()
head(dados)
str(dados)

resultado <- dpb_report(
  dados,
  response = "Rendimento",
  ylim = c(60, 80)
)

