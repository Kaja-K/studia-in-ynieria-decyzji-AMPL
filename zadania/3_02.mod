option solver cplex;
reset;

# Parametry
set Zboze; 				# Zbiór zbóż
param cena{Zboze}; 		# Cena za tonę zbóż
param popyt{Zboze}; 	# Popyt na dane zboże
param praca{Zboze}; 	# Wymagany czas pracy na hektarze dla danego zboża
param wydajnosc{Zboze}; # Wydajność zboża na hektarze
param rozmiar_pola; 	# Rozmiar pola w hektarach
param limit_pracy;	 	# Limit czasu pracy

# Zmienna decyzyjna - Ilość obsianych hektarów dla każdego zboża
var ilosc_hektarow{Zboze} >= 0;

# Funkcja celu - Maksymalizacja całkowitego zysku
maximize zysk: sum{z in Zboze} cena[z] * wydajnosc[z] * ilosc_hektarow[z];

# Ograniczenia
o_pracy: sum{z in Zboze} praca[z] * ilosc_hektarow[z] <= limit_pracy; 	# Czasu pracy
o_popyt{z in Zboze}: ilosc_hektarow[z] * wydajnosc[z] <= popyt[z]; 		# Ilości sprzedanego zbóż
o_pole: sum{i in Zboze} ilosc_hektarow[i] <= rozmiar_pola; 				# Rozmiaru obsianego pola

data;
param rozmiar_pola := 100;
param limit_pracy := 1400;
param: Zboze: popyt cena wydajnosc praca := 
	"Zyto" 		560   300 	10 		12
	"Pszenica" 	480   500 	8 		20
	"Kukurydza" 500   400 	5 		7
	"Owies" 	600     0 	7 		10;
		
solve;
display zysk, ilosc_hektarow;
display ilosc_hektarow.down, ilosc_hektarow.up, ilosc_hektarow.current;
# Wynik: zysk = 320615
# ilosc_hektarow
# 	Kukurydza  	11.6923
#   Owies   	0
#   Pszenica  	32.3077
#   Zyto  		56

end;