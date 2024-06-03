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

# Zmienna decyzyjna - Ilość podproduktów p-tego w benzynie b-tej
var ilosc_podproduktow{benzyny, podprodukty} >= 0;

# Funkcja celu - Maksymalizacja całkowitego zysku
maximize zysk: sum{b in benzyny, p in podprodukty} cena_benzyny[b] * ilosc_podproduktow[b, p];

# Ograniczenia
# Suma ilości każdego podproduktu w danej benzynie nie może przekroczyć dziennego popytu na tę benzynę.
o_sprzedaz{b in benzyny}: sum{p in podprodukty} ilosc_podproduktow[b, p] <= popyt_benzyny[b];
# Suma iloczynów liczby oktanowej każdego podproduktu w danej benzynie musi być większa lub równa minimalnej liczbie oktanowej tej benzyny pomnożonej przez sumę ilości każdego podproduktu w tej benzynie.
o_technologia{b in benzyny}: sum{p in podprodukty} min_oktany_podproduktow[p] * ilosc_podproduktow[b, p] >= min_oktany_benzyny[b] * sum{p in podprodukty} ilosc_podproduktow[b, p];
# Dwukrotność ilości podproduktu ON98 w każdej benzynie nie może przekroczyć limitu procesu krakowania.
o_krakowania: 2 * sum{b in benzyny} ilosc_podproduktow[b, "ON98"] <= limit_krakowania;
# Pięciokrotność ilości podproduktu ON82 oraz dwukrotność ilości podproduktu ON98 w każdej benzynie nie może przekroczyć dziennego zapotrzebowania na ropę.
o_destylacja: 5 * (sum{b in benzyny} ilosc_podproduktow[b, "ON82"] + 2 * sum{b in benzyny} ilosc_podproduktow[b, "ON98"]) <= podaz_ropy;

data;
set podprodukty := ON82 ON98;
param podaz_ropy := 1500000;
param limit_krakowania := 200000;
param min_oktany_podproduktow:= ON82 82 ON98 98;
param: benzyny: cena_benzyny popyt_benzyny min_oktany_benzyny:= normalna 6.7 50000 87 premium 7.2 30000 89 super 8.1 40000 92;

solve;
display zysk, ilosc_podproduktow;
end;