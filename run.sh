#!/bin/bash

# 1. Usar os links RAW (diretos) do GitHub
launcher_fc2="https://raw.githubusercontent.com/JeversonDiasSilva/jackson/main/Fightcade%20By%20JCGAMESCLASSICOS.sh"
launcher_wine="https://raw.githubusercontent.com/JeversonDiasSilva/jackson/main/wine"

# Variável para facilitar o caminho longo do Fightcade
caminho_fc="/userdata/system/.dev/apps/Fightcade/dep/rom/fightcade/Fightcade By JCGAMESCLASSICOS.sh"

# 2. Fazendo o backup (isso estava correto, só usei a variável para ficar mais limpo)
mv "$caminho_fc" "${caminho_fc}.bkp"

# 3. Ordem corrigida do wget: wget -q -O "destino" "URL"
wget -q -O "$caminho_fc" "$launcher_fc2"
wget -q -O "/usr/bin/wine" "$launcher_wine"

# 4. Aplicando permissão de execução (chmod) com os caminhos corretos
chmod +x "$caminho_fc"
chmod +x "/usr/bin/wine"

# 5. Salvando o overlay do Batocera
batocera-save-overlay 250
