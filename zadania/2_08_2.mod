option solver cplex;
reset;

# Deklaracja parametrów
set Benzyny; 							# Zbior benzyn
set podprodukty; 						# Zbior poproduktow
param oktany_podproduktow{podprodukty};	# Liczba oktanowa dla poszczególnych poproduktów
param cena{Benzyny}; 					# Cena benzyny
param popyt{Benzyny};					# Popyt na benzynę
param liczba_oktanowa{Benzyny}; 		# Liczba oktanowa benzyny
param podaz_benzyny;					# Podaż benzyny
param limit_krakowania;					# Limit krakowania

# Zmienna decyzyjna - Ilość poproduktów j-tego w benzynie i-tej
var ilosc_podproduktow{Benzyny,podprodukty} >=0;

# Funkcja celu - maksymalizacja całkowitego zysku
maximize zysk: sum{i in Benzyny, j in podprodukty} cena[i]*ilosc_podproduktow[i,j];

# Ograniczenia

# Ograniczenie sprzedaży benzyny - suma ilości każdego poproduktu j w benzynie i nie przekracza popytu na tę benzynę
o_sprzedaz{i in Benzyny}: sum{j in podprodukty} ilosc_podproduktow[i,j] <= popyt[i];

# Ograniczenie technologiczne - suma iloczynów liczby oktanowej każdego poproduktu j w benzynie i musi być większa lub równa liczbie oktanowej danej benzyny pomnożonej przez sumę ilości każdego poproduktu j w tej benzynie
o_technologia{i in Benzyny}: sum{j in podprodukty}oktany_podproduktow[j]*ilosc_podproduktow[i,j]>= 
								liczba_oktanowa[i]*sum{j in podprodukty} ilosc_podproduktow[i,j];

# Ograniczenie krakowania - dwukrotność ilości poproduktu ON98 w każdej benzynie nie przekracza limitu krakowania
o_krakowania:2*sum{i in Benzyny}ilosc_podproduktow[i,"ON98"]<=limit_krakowania;

# Ograniczenie destylacji - pięciokrotność ilości poproduktu ON82 oraz dwukrotność ilości poproduktu ON98 w każdej benzynie nie przekracza podaży benzyny
o_destylacja:5*(sum{i in Benzyny}ilosc_podproduktow[i,"ON82"]+2*sum{i in Benzyny}ilosc_podproduktow[i,"ON98"])<= podaz_benzyny;

data;
set podprodukty:= ON82 ON98;
param oktany_podproduktow:= ON82 82 ON98 98;
param: Benzyny: 	cena		popyt		liczba_oktanowa:=
		normalna	6.7			50000		87
		premium		7.2			30000		89
		super		8.1			40000		92;
param podaz_benzyny:= 1500000;
param limit_krakowania:= 200000;

solve;

display zysk,ilosc_podproduktow;
# Wynik: zysk = 875000
#ilosc_podproduktow :=
#	normalna ON82   34375
#	normalna ON98   15625
#	premium  ON82   16875
#	premium  ON98   13125
#	super    ON82   15000
#	super    ON98   25000

end;

