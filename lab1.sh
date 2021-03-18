#!/bin/bash

shopt -s nullglob # nie iterujemy po pustych katalogach
shopt -s dotglob # iteracja i rozszerzanie * też po plikach zaczynających się od "."

# +0.5 - napisać skrypt, który pobiera 3 argumenty: SOURCE_DIR, RM_LIST, TARGET_DIR o wartościach domyślnych: lab_uno, lab_uno /2remove, bakap
SOURCE_DIR="${1:-lab_uno}"
RM_LIST="${2:-lab_uno/2remove}"
TARGET_DIR="${3:-bakap}"

# +0.5 - jeżeli TARGET_DIR nie istnieje, to go tworzymy
mkdir -p -- "$TARGET_DIR"
# jeżeli w zadaniu chodzi o wykorzystanie ifa a nie o użycie opcji -p, to można to zapisać też jako:
#if ! [[ -e "$TARGET_DIR" ]]; then
#   mkdir "$TARGET_DIR"
#fi

# +1.0 – iterujemy się po zawartości pliku RM_LIST i tylko jeżeli plik o takiej nazwie występuje w katalogu SOURCE_DIR, to go usuwamy
while read -r file; do
    [[ -e $SOURCE_DIR/$file ]] && rm -f -- "$SOURCE_DIR/$file"
done < "$RM_LIST"

for file in "$SOURCE_DIR"/*; do
    if [[ -d $file ]]; then
        # +0.5 – jeżeli jakiegoś pliku nie ma na liście, ale jest katalogiem, to kopiujemy go do TARGET_DIR z zawartością
        cp -r -- "$file" "$TARGET_DIR"
    elif [[ -f $file ]]; then
        # +0.5 – jeżeli jakiegoś pliku nie ma na liście, ale jest plikiem regularny, to przenosimy go do TARGET_DIR
        mv -- "$file" "$TARGET_DIR"
    fi
done

# +1.0  – jeżeli po zakończeniu operacji są jeszcze jakieś pliki w katalogu SOURCE_DIR to:
remaining=$(ls -1A "$SOURCE_DIR" | wc -l)
((remaining > 0)) && echo 'Jeszcze coś zostało'
((remaining >= 2)) && echo 'Zostały conajmniej 2 pliki'
((remaining > 4)) && echo 'Zostało więcej niż 4 pliki'
((remaining <= 4 && remaining > 2)) && echo 'coś piszemy'
((remaining == 0)) && echo 'tu był Kononowicz'

# +0.5 – wszystkie pliki w katalogu TARGET_DIR muszą mieć odebrane prawa do edycji
#w poleceniu nie jest napisane czy chodzi o pliki też w podkatalogach, przyjąłem że tak:
find "$TARGET_DIR" -type f -exec chmod -w '{}' '+'

# +0.5 – po wszystkich spakuj katalog TARGET_DIR i nazwij bakap_DATA.zip, gdzie DATA to dzień uruchomienia skryptu w formacie RRRR-MM-DD
zip -r "bakap_$(date +%F).zip" "$TARGET_DIR"
