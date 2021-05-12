# Zadanie dla chętnich: napisz jednolinijkowca, któy klonuje (robi echo) repozytoria z ludzie.csv, po SSH, do katalogow imie_nazwisko (malymi literami).
# Zwróccie uwagę, że niektóre repozytoria mają '.git' inne nie, to trzeba zunifikować! (dam za to +0.5)
tr -d '\r' < ludzie.csv | awk -F, 'NR>1 {gsub(" ", "_", $1); sub(".git$", "", $3); print "clone", $3, tolower($1)}' | xargs -n1 -d$'\n' echo git
