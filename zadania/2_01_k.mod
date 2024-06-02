option solver cplex; 
reset;               

# Parametry
set produkt; # Zbiór produktów
set skladnik; # Zbiór składników odżywczych
param popyt; # Wielkość popytu na paszę
param limit_produkt{produkt}; # Maksymalna ilość dostępna dla każdego produktu
param cena{produkt}; # Cena jednostkowa każdego produktu
param zawartosc{produkt, skladnik};	# Zawartość składników odżywczych w każdym produkcie
param limit_dolny{skladnik}; # Dolne ograniczenia zawartości składników w paszy
param limit_gorny{skladnik}; # Górne ograniczenia zawartości składników w paszy

# Zmienna decyzyjna - Ilość każdego produktu użytego w paszy (w kg)
var ilosc_produktow{i in produkt} >= 0;

# Funkcja celu - Minimalizacja kosztu paszy
minimize Koszt: sum{i in produkt} ilosc_produktow[i] * cena[i];

# Ograniczenia
# Zapewnia, że ilość każdego produktu użytego w paszy nie przekracza jego maksymalnej dostępnej ilości.
o_zakup{i in produkt}: ilosc_produktow[i] <= limit_produkt[i]; 
# Całkowita ilość użytych produktów, która musi być równa popytowi
o_popyt: sum{i in produkt} ilosc_produktow[i] = popyt;
# Ograniczenia limitu  - Gwarantują, że zawartość każdego składnika odżywczego w paszy znajduje się w odpowiednich granicach dolnych i górnych.
o_limit_dolny{j in skladnik}:sum{i in produkt} ilosc_produktow[i] * zawartosc[i,j] >= limit_dolny[j] * popyt; 
o_limit_gorny{j in skladnik}:sum{i in produkt} ilosc_produktow[i] * zawartosc[i,j] <= limit_gorny[j] * popyt;

data;
param popyt := 10000;
param: produkt: cena, limit_produkt :=  'Kukurydza' 0.2 6000 'Ziemniaki'0.12 10000 'Soja' 0.24 4000 'Maczka rybna' 0.12 5000;
param: skladnik: limit_dolny, limit_gorny := 'Witaminy' 6 10 'Białko' 6 1000000 'Sole mineralne' 7 1000000 'Tłuszcz' 0 8;
param zawartosc: 'Witaminy' 'Białko' 'Sole mineralne' 'Tłuszcz' := 'Kukurydza' 8 6 10 4 'Ziemniaki' 10 5 12 8 'Soja' 6 10 6 6 'Maczka rybna' 8 6 6 9;

solve;
display ilosc_produktow, Koszt;
end;