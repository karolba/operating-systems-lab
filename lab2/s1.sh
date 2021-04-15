#!/bin/bash

set -eu
shopt -s nullglob

#  3.0: Napisać skrypt, który przyjmuje 2 parametry – 2 ścieżki do katalogów.
#  Z zadanego katalogu nr 1 wypisać wszystkie pliki po kolei, wraz z informacją:
#  - czy jest to katalog
#  - czy jest to dowiązanie symboliczne
#  - czy plik regularny.
#  Następnie (lub równolegle) utworzyć w katalogu nr 2 dowiązania symboliczne do każdego pliku regularnego i katalogu z katalogu nr 1, dodając "_ln" przed rozszerzeniem i zmieni nazwę na pisanę WIELKIMI literami, np. magic_file.txt -> MAGIC_FILE_ln.txt

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <dir1> <dir2>" >&2
    exit 1
fi

if ! [[ -d $1 ]]; then
    echo "Directory '$1' does not exist"
    exit 2
fi

if ! [[ -d $2 ]]; then
    echo "Directory '$2' does not exist"
    exit 3
fi

for f in "$1"/*; do
    if [[ -d $f ]]; then
        echo "Directory: $f"
    elif [[ -L $f ]]; then
        echo "Symlink: $f"
    elif [[ -f $f ]]; then
        echo "Regular file: $f"
    fi
    
    ext_part="${f##*.}"
    no_ext="${f%.*}"

    no_ext_upper="${no_ext^^}"

    if [[ $ext_part ]]; then
        ln -s "${no_ext_upper}_ln.${ext_part}" "$2/"
    else
        ln -s "${no_ext_upper}_ln" "$2/"
    fi
done
