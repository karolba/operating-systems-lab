#!/bin/bash

# Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą.
# Wyniki zapisz na standardowe wyjście błędów.
awk -F, 'NR > 1 && $1 % 2' yolo.csv >/dev/stderr

# Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 lub $9.99.
# Nie wazne czy milionów, czy miliardów (tylko nazwisko i wartość).
# Wyniki zapisz na standardowe wyjście błędów
awk -F, 'NR>1 && $7~/^\$[259].99[^0-9]/ { print $3, $7 }' yolo.csv >/dev/stderr

# Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim oktecie ma po jednej cyfrze.
# Wyniki zapisz na standardowe wyjście błędów
awk -F, 'NR>1 && $6 ~ /^[0-9]\.[0-9]\./ { print $6 }' yolo.csv > /dev/stderr
