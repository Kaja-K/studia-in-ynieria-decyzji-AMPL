option solver cplex;
reset;

# Zdefiniowanie parametrów
param opcje>0 integer;  	# Liczba dostępnych opcji rolniczych
param koszt{1..opcje};  	# Koszt jednostkowy produktu
param wartość{1..opcje};  	# Wartość produkowanego produktu na hektarze
param godziny{1..opcje};  	# Liczba godzin pracy potrzebnych do produkcji jednostki produktu
param produkt{1..opcje};  	# Dostępna ilość produktu
param pole_limit;  			# Limit powierzchni pola
param godz_limit;  			# Limit dostępnych godzin pracy

# Definicja zmiennych decyzyjnych - Ilość hektarów przeznaczonych na produkcję każdego z produktów
var hektary{i in 1..opcje} >=0, <= produkt[i]/wartość[i];  

# Funkcja celu do zmaksymalizowania zysku z uwzględnieniem kosztów i godzin pracy
maximize zysk: sum{i in 1..opcje} koszt[i]*wartość[i]*hektary[i] - sum{i in 1..opcje} godziny[i]*wartość[i]*hektary[i];  

# Ograniczenia 
subject to 
o_pole: sum {i in 1..opcje} hektary[i] <= pole_limit;  			# Ilość wykorzystanej powierzchni pola
o_godz: sum{i in 1..opcje} hektary[i]*godziny[i] <= godz_limit;	# Godziny pracy

# Przypisanie wartości parametrów
data;
param opcje := 3;  						
param koszt := 1 30 2 50 3 40; 	
param wartość := 1 10 2 8 3 5;  	
param godziny := 1 12 2 20 3 7;  	
param produkt := 1 560 2 480 3 500; 
param godz_limit := 1400;  		
param pole_limit := 100;  

solve;
display hektary, zysk; 
# Wynik: 1 = 0, 2 = 53.8462, 3 = 46.1538, Profit = 20538.5

end;
