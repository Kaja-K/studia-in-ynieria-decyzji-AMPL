option solver cplex;
reset;

# Deklaracja parametrów
set Benzyny; 								# Zbiór typów benzyn
set Podprodukty; 							# Zbiór poproduktów
param min_oktany_podproduktow{Podprodukty};	# Minimalne liczby oktanowe dla poszczególnych poproduktów
param cena_benzyny{Benzyny}; 				# Cena jednostkowa benzyny
param popyt_benzyny{Benzyny};				# Dzienny popyt na benzynę
param min_oktany_benzyny{Benzyny}; 			# Minimalne liczby oktanowe dla poszczególnych benzyn
param podaz_ropy;							# Dzienna podaż ropy
param limit_krakowania;						# Limit przetwarzania w procesie krakowania

# Zmienna decyzyjna - Ilość podproduktów j-tego w benzynie i-tej
var podprodukty_w_benzynie{Benzyny, Podprodukty} >= 0;

# Funkcja celu - Maksymalizacja całkowitego zysku
maximize zysk: sum{i in Benzyny, j in Podprodukty} cena_benzyny[i] * podprodukty_w_benzynie[i, j];

# Ograniczenia

# Sprzedaży benzyny - suma ilości każdego podproduktu j w benzynie i nie przekracza popytu na tę benzynę
o_sprzedaz{i in Benzyny}: sum{j in Podprodukty} podprodukty_w_benzynie[i, j] <= popyt_benzyny[i];	

# Technologiczne - suma iloczynów liczby oktanowej każdego podproduktu j w benzynie i musi być większa lub równa liczbie oktanowej danej benzyny pomnożonej przez sumę ilości każdego podproduktu j w tej benzynie
o_technologia{i in Benzyny}: sum{j in Podprodukty} min_oktany_podproduktow[j] * podprodukty_w_benzynie[i, j] >= min_oktany_benzyny[i] * sum{j in Podprodukty} podprodukty_w_benzynie[i, j];	

# Krakowania - dwukrotność ilości podproduktu ON98 w każdej benzynie nie przekracza limitu krakowania
o_krakowania: 2 * sum{i in Benzyny} podprodukty_w_benzynie[i, "ON98"] <= limit_krakowania;	

# Destylacja - pięciokrotność ilości podproduktu ON82 oraz dwukrotność ilości podproduktu ON98 w każdej benzynie nie przekracza podaży benzyny
o_destylacja: 5 * (sum{i in Benzyny} podprodukty_w_benzynie[i, "ON82"] + 2 * sum{i in Benzyny} podprodukty_w_benzynie[i, "ON98"]) <= podaz_ropy;

data;
set Podprodukty := ON82 ON98;
param min_oktany_podproduktow:= ON82 82 ON98 98;
param podaz_ropy := 1500000;
param limit_krakowania := 200000;
param: Benzyny: 	cena_benzyny		popyt_benzyny		min_oktany_benzyny:=
		normalna		6.7					50000					87
		premium			7.2					30000					89
		super			8.1					40000					92;

solve;
display zysk, podprodukty_w_benzynie;
# Wynik: zysk = 875000
#ilosc_podproduktow 
#	normalna ON82   34375
#	normalna ON98   15625
#	premium  ON82   16875
#	premium  ON98   13125
#	super    ON82   15000
#	super    ON98   25000

end;