#!/bin/bash

# +1.0 - Napisać skrypt, który w zadanym katalogu (jako parametr) każdemu:
# - plikowi regularnemu z rozszerzeniem .bak odbierze uprawnienia do edytowania dla właściciela i innych
# - katalogowi z rozszerzeniem .bak (bo można!) pozwoli wchodzić do środka tylko innym
# - w katalogach z rozszerzeniem .tmp pozwoli każdemu tworzyć i usuwać jego pliki
# - plikowi z rozszerzeniem .txt będą czytać tylko właściciele, edytować grupa właścicieli, wykonywać inni. Brak innych uprawnień
# - pliki regularne z rozszerzeniem .exe wykonywać będą mogli wszyscy, ale zawsze wykonają się z uprawnieniami właściciela (można przetestować na skompilowanym https://github.com/szandala/SO2/blob/master/lab2/suid.c)

set -eu
shopt -s nullglob

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <dir> <log_file>" >&2
    exit 1
fi

if ! [[ -d $1 ]]; then
    echo "Directory '$1' does not exist"
    exit 2
fi

for f in "$2"/*; do
    if [[ -f $f ]]; then
        chmod uo-w "$f"
    elif [[ -d $f && $f == *.bak ]]; then
        chmod ug-x "$f" 
        chmod o+x "$f"
    elif [[ -d $f && $f == *.tmp ]]; then
        chmod o+w "$f"
    elif [[ $f == *.txt ]]; then
        chmod 421 "$f"
    elif [[ -f $f && $f == *.txt ]]; then
        chmod +xs "$f"
    fi
done
