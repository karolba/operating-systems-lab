#!/bin/bash

# +0.5 - Napisać skrypt, który w zadanym katalogu (1. parametr) usunie wszystkie uszkodzone dowiązania symboliczne, a ich nazwy wpisze do pliku (2. parametr), wraz z dzisiejszą datą w formacie ISO 8601.

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

{
    find "$1" -xtype l -maxdepth 1 -delete -print 
    date +'%Y-%m-%d'
} >> "$2"
