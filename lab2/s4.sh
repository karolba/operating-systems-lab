#!/bin/bash

# +0.5 Stwórz plik środowiskowy, który:
# sprawia, że prompt:
# - pokazuje na jakiej gałęzi Git'a jestem
# - jako znak zachęty używa %
# - wypisuje obecną datę i godzinę
# - jest kolorowy
# Oraz:
# zawiera zmienne środowiskowe, które pozwalają uruchamiać skrypty wcześniejsze bez "./"
# (dla leniwych: przyjmijmy, że uruchamiamy 'source .env')
# (dla nieleniwych: przyjmijmy, że to source wywołujemy w dowolnym miejscu)

_prompt_branch_name() {
    if branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
        printf ' \e[1m%s\e[0m\n' '['"$branch"']'
    fi
}

PS1='\e[1;34m\h\e[0m@\e[1;36m\u\e[0m$(_prompt_branch_name) (\e[0;95m$(date)\e[0m) \W \e[1m%\e[0m '

# zawiera zmienne środowiskowe, które pozwalają uruchamiać skrypty wcześniejsze bez "./"
export PATH=".:$PATH"


