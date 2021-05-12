#!/bin/bash
# We wszystkich plikach w katalogu ‘groovies’ zamień $HEADER$ na /temat/
sed -i 's|\$HEADER\$|/temat/|g' groovies/*

# We wszystkich plikach w katalogu ‘groovies’ po każdej linijce z 'class' dodać '  String marker = '/!@$%/''
sed -i '/^class/a\ \ String marker = '\''/!@$%/'\' groovies/*

# We wszystkich plikach w katalogu ‘groovies’ usuń linijki zawierające frazę 'Help docs:'
sed -i '/Help docs:/d' groovies/*
