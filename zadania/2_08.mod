option solver cplex;
reset;

# Parametry
set benzyny; # Zbiór typów benzyn
set podprodukty; # Zbiór poproduktów
param min_oktany_podproduktow{podprodukty};	# Minimalne liczby oktanowe dla poszczególnych poproduktów
param cena_benzyny{benzyny}; # Cena jednostkowa benzyny
param popyt_benzyny{benzyny}; # Dzienny popyt na benzynę
param min_oktany_benzyny{benzyny}; # Minimalne liczby oktanowe dla poszczególnych benzyn
param podaz_ropy; # Dzienna podaż ropy
param limit_krakowania; # Limit przetwarzania w procesie krakowania

# Zmienna decyzyjna - Ilość podproduktów j-tego w benzynie i-tej
var ilosc_podproduktow{benzyny, podprodukty} >= 0;

# Funkcja celu - Maksymalizacja całkowitego zysku
maximize zysk: sum{i in benzyny, j in podprodukty} cena_benzyny[i] * ilosc_podproduktow[i, j];

# Ograniczenia
# Suma ilości każdego podproduktu w danej benzynie nie może przekroczyć dziennego popytu na tę benzynę.
o_sprzedaz{i in benzyny}: sum{j in podprodukty} ilosc_podproduktow[i, j] <= popyt_benzyny[i];
# Suma iloczynów liczby oktanowej każdego podproduktu w danej benzynie musi być większa lub równa minimalnej liczbie oktanowej tej benzyny pomnożonej przez sumę ilości każdego podproduktu w tej benzynie.
o_technologia{i in benzyny}: sum{j in podprodukty} min_oktany_podproduktow[j] * ilosc_podproduktow[i, j] >= min_oktany_benzyny[i] * sum{j in podprodukty} ilosc_podproduktow[i, j];
# Dwukrotność ilości podproduktu ON98 w każdej benzynie nie może przekroczyć limitu procesu krakowania.
o_krakowania: 2 * sum{i in benzyny} ilosc_podproduktow[i, "ON98"] <= limit_krakowania;
# Pięciokrotność ilości podproduktu ON82 oraz dwukrotność ilości podproduktu ON98 w każdej benzynie nie może przekroczyć dziennego zapotrzebowania na ropę.
o_destylacja: 5 * (sum{i in benzyny} ilosc_podproduktow[i, "ON82"] + 2 * sum{i in benzyny} ilosc_podproduktow[i, "ON98"]) <= podaz_ropy;

data;
set podprodukty := ON82 ON98;
param podaz_ropy := 1500000;
param limit_krakowania := 200000;
param min_oktany_podproduktow:= ON82 82 ON98 98;
param: benzyny: cena_benzyny popyt_benzyny min_oktany_benzyny:= normalna 6.7 50000 87 premium 7.2 30000 89 super 8.1 40000 92;

solve;
display zysk, ilosc_podproduktow;
end;