option solver cplex; 
reset;               

# Parametry
set produkty; # Zbiór produktów
set skladniki_odzywcze; # Zbiór składników odżywczych
param popyt; # Wielkość popytu na paszę
param limit_produkt{produkty}; # Maksymalna ilość dostępna dla każdego produktu
param cena{produkty}; # Cena jednostkowa każdego produktu
param zawartosc{produkty, skladniki_odzywcze}; # Zawartość składników odżywczych w każdym produkcie
param limit_dolny{skladniki_odzywcze}; # Dolne ograniczenia zawartości składników w paszy
param limit_gorny{skladniki_odzywcze}; # Górne ograniczenia zawartości składników w paszy

# Zmienna decyzyjna - Ilość każdego produktu użytego w paszy (w kg)
var ilosc_produktow{p in produkty} >= 0;

# Funkcja celu - Minimalizacja kosztu paszy
minimize koszt: sum{p in produkty} ilosc_produktow[p] * cena[p];

# Ograniczenia
# Zapewnia, że ilość każdego produktu użytego w paszy nie przekracza jego maksymalnej dostępnej ilości.
o_zakup{p in produkty}: ilosc_produktow[p] <= limit_produkt[p]; 
# Całkowita ilość użytych produktów, która musi być równa popytowi
o_popyt: sum{p in produkty} ilosc_produktow[p] = popyt;
# Ograniczenia limitu - Gwarantują, że zawartość każdego składnika odżywczego w paszy znajduje się w odpowiednich granicach dolnych i górnych.
o_limit_dolny{s in skladniki_odzywcze}: sum{p in produkty} ilosc_produktow[p] * zawartosc[p, s] >= limit_dolny[s] * popyt; 
o_limit_gorny{s in skladniki_odzywcze}: sum{p in produkty} ilosc_produktow[p] * zawartosc[p, s] <= limit_gorny[s] * popyt;

data;
param popyt := 10000;
param: produkty: cena, limit_produkt :=  
    'Kukurydza' 0.2 6000 
    'Ziemniaki' 0.12 10000 
    'Soja' 0.24 4000 
    'Maczka rybna' 0.12 5000;
param: skladniki_odzywcze: limit_dolny, limit_gorny := 
    'Witaminy' 6 10 
    'Białko' 6 1000000 
    'Sole mineralne' 7 1000000 
    'Tłuszcz' 0 8;
param zawartosc: 'Witaminy' 'Białko' 'Sole mineralne' 'Tłuszcz' := 
    'Kukurydza' 8 6 10 4 
    'Ziemniaki' 10 5 12 8 
    'Soja' 6 10 6 6 
    'Maczka rybna' 8 6 6 9;

solve;
display ilosc_produktow, koszt;
end;