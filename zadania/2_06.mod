option solver cplex;
reset;

# Parametry
set miasto; 							# Liczba miast
set spalarnia; 							# Liczba spalarni
set wysypisko; 							# Liczba wysypisk
param odpady{miasto};			 		# Ilość odpadów w każdym z miast
param limit_spalania{spalarnia}; 		# Limit spalania w każdej z spalarni
param koszt_spalania{spalarnia}; 		# Koszt spalania w każdej z spalarni
param wsp_spalania; 					# Współczynnik spalania odpadów
param limit_wysypiska{wysypisko}; 		# Limit ilości odpadów składowanych w każdym z wysypisk
param koszt_transportu; 				# Koszt transportu jednej tony odpadów
param odleglosc_1{miasto, spalarnia}; 	# Odległość między miastami a spalarniami
param odleglosc_2{spalarnia, wysypisko};# Odległość między spalarniami a wysypiskami

# Zmienne decyzyjne
var ilosc_odpadow{miasto, spalarnia} >= 0; 	# Ilość ton odpadów przewieziona z miasta i do spalarni j
var ilosc_popiolu{spalarnia, wysypisko} >= 0; # Ilość ton popiołu przewieziona ze spalarni j do wysypiska k

# Funkcja celu - minimalizacja całkowitego kosztu
minimize Koszt: sum{i in miasto, j in spalarnia} koszt_transportu * odleglosc_1[i,j] * ilosc_odpadow[i,j] 
                + sum{i in miasto, j in spalarnia} koszt_spalania[j] * ilosc_odpadow[i,j]
                + sum{j in spalarnia, k in wysypisko} koszt_transportu * odleglosc_2[j,k] * ilosc_popiolu[j,k]; 

# Ograniczenia
o_limit_odpady{i in miasto}: sum{j in spalarnia} ilosc_odpadow[i,j] = odpady[i]; 										# Określa, że ilość odpadów w każdym z miast musi być równa ilości odpadów wyprodukowanych w tym mieście.
o_limit_spalarnia{j in spalarnia}: sum{i in miasto} ilosc_odpadow[i,j] <= limit_spalania[j]; 							# Nakłada limit na ilość odpadów, które mogą być spalane w każdej z spalarni.
o_limit_wysypiska{k in wysypisko}: sum{j in spalarnia} ilosc_popiolu[j,k] <= limit_wysypiska[k]; 						# Określa limit ilości popiołu, który może być składowany w każdym z wysypisk.
o_spalanie{j in spalarnia}: sum{i in miasto} ilosc_odpadow[i,j] * wsp_spalania = sum{k in wysypisko} ilosc_popiolu[j,k];# Wymusza, że ilość popiołu wytwarzana w każdej spalarni musi być równa ilości odpadów, które zostały spalone.

data;
param wsp_spalania := 0.3; 
param koszt_transportu := 3; 
param: miasto: odpady:= 							'Miasto-1' 		1500
                        							'Miasto-2' 		1400;
param: spalarnia: limit_spalania, koszt_spalania:= 	'Spalarnia-A' 	1500 	40
                                                   	'Spalarnia-B' 	1500 	30;
param: wysypisko: limit_wysypiska:= 				'Wysypisko-1' 	500
                                    				'Wysypisko-2' 	500;
param odleglosc_1: 'Spalarnia-A' 'Spalarnia-B':=	'Miasto-1' 		30 		5
                    								'Miasto-2' 		36 		42;
param odleglosc_2: 'Wysypisko-1' 'Wysypisko-2':=	'Spalarnia-A' 	5 8
                    								'Spalarnia-B' 	9 6;
solve;
display ilosc_odpadow, ilosc_popiolu, Koszt;
end;