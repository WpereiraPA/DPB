Ferramentas para Planejamento Plackett-Burman no R

O DPB é um pacote desenvolvido para simplificar a análise de experimentos do tipo Plackett-Burman, permitindo que estudantes e profissionais realizem análises estatísticas completas com poucos comandos.

Ele automatiza:

✔ geração da matriz experimental
✔ ajuste do modelo linear
✔ ANOVA automática
✔ cálculo de efeitos dos fatores
✔ coeficientes e teste F
✔ R² do modelo
✔ gráfico de efeitos principais
✔ gráfico de Pareto com limite 

Objetivo

Reduzir a complexidade da análise estatística em planejamentos fatoriais, permitindo que alunos se concentrem na interpretação dos resultados, e não na programação.

Instalação

Instale diretamente do GitHub:
R
install.packages("remotes")
remotes::install_github("WpereiraPA/DPB")

Carregue o pacote:
R
library(DPB)

Fluxo de uso
Ler dados copiados do Excel
R
dados <- read_clipboard_dpb()
A planilha deve conter:

fatores codificados em -1 e +1
coluna resposta (ex: Rendimento)

Gerar a matriz Plackett-Burman (opcional)
R
pb_matrix(nruns = 12, nfactors = 7)

Executar análise completa
R
dpb_report(dados, "Rendimento", 7.71)
Onde:

"Rendimento" → nome da variável resposta

7.71 → valor crítico F tabelado (nível de significância adotado)
Resultados gerados automaticamente

Após executar dpb_report(), o pacote produz:

✔ ANOVA do modelo

Identifica fatores significativos.

✔ Coeficientes e efeitos

Magnitude e direção da influência de cada fator.

✔ R² do modelo

Qualidade do ajuste estatístico.

✔ Gráfico de efeitos principais

Visualização da influência dos fatores.

✔ Gráfico de Pareto (estilo Minitab)

Efeitos padronizados com linha de significância.

Exemplo prático
R
library(DPB)

dados <- read_clipboard_dpb()

dpb_report(dados, "Rendimento", 7.71)

Quando usar o DPB?

Use este pacote quando desejar:

✔ triagem rápida de fatores
✔ reduzir número de experimentos
✔ identificar variáveis críticas
✔ ensinar DOE de forma prática
✔ automatizar análises repetitivas
Aplicações educacionais

O DPB foi pensado para:

cursos de Estatística Aplicada

Engenharia e otimização de processos
disciplinas de Planejamento de Experimentos
ensino prático de DOE com software
Requisitos

O pacote utiliza:
FrF2
BsMD
(instalados automaticamente como dependências)

 Autor: 
 Wanderley Xavier Pereira
 
 Licença
 MIT License - Uso Livre para fins acadêmicos e profissionais
