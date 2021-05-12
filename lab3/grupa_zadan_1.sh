#!/usr/bin/env bash

#+2.0
# Znajdź w pliku access_log zapytania, które mają frazę "denied" w linku
awk '$7 ~ /denied/' access_log

# Znajdź w pliku access_log zapytania typu POST
awk '$6 == "\"POST"' access_log

# Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
awk '$1 == "64.242.88.10"' access_log

# Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
awk '$1~/[^0-9.]/ && $1~/\./' access_log

# Znajdź w pliku access_log unikalne zapytania typu DELETE
awk '$6 == "\"DELETE"' access_log | sort | uniq

# Znajdź unikalnych 10 adresów IP w access_log"
awk '$1 !~ /[^0-9.]/{ print $1 }' access_log | sort | uniq | head -n 10
