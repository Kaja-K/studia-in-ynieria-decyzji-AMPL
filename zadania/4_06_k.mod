option solver cplex;
reset;

# Parametry
param paczki;								# Liczba paczek
param zasieg;								# Zasięg czujnika
set Paczki within 1..paczki cross 1..paczki;# Paczki mają dwie współrzędne - wiersz i kolumnę

# Zmienna decyzyjna - binarna macierz reprezentująca obecność kamery na danej paczce
var kamery {1..paczki, 1..paczki} binary;

# Funkcja celu - Minimalizacja liczby kamer
minimize liczba_kamer: sum{i in 1..paczki, j in 1..paczki} kamery[i,j];

# Ograniczenia
# Wymusza, że niektóre pola nie mogą zawierać kamer. 
o_paczki_bez_kamery{(i,j) in Paczki}: kamery[i,j] = 0;  	

# Gwarantuje, że każda paczka jest obserwowana przez co najmniej jedną kamerę. Suma obserwacji poziomych i pionowych dla każdej paczki musi być co najmniej równa 1.			
o_czy_paczka_obserwowana{(k,l) in Paczki}: 	
# Sumuje wartości zmiennych binarnych kamery dla wszystkich pól w zasięgu poziomym (wiersz k) paczki o współrzędnych (k,l). Zakres sumowania jest ograniczony do wartości 
# 	od max(l-zasieg,1) do min(l+zasieg,paczki), co oznacza, że suma uwzględnia pola od l - zasieg do l + zasieg, ale nie wychodzi poza granice paczek.							
sum{j in max(l-zasieg,1)..min(l+zasieg,paczki)} kamery[k,j] +  		
# Sumuje wartości zmiennych binarnych kamery dla wszystkich pól w zasięgu pionowym (kolumna l) paczki o współrzędnych (k,l). Zakres sumowania jest ograniczony do wartości 
# 	od max(k-zasieg,1) do min(k+zasieg,paczki), co oznacza, że suma uwzględnia pola od k - zasieg do k + zasieg, ale nie wychodzi poza granice paczek.	
sum{j in max(k-zasieg,1)..min(k+zasieg,paczki)} kamery[j,l] >= 1; 	

data;
param paczki := 10;
param zasieg := 4;
set Paczki := 2 4 1 6 4 7 2 7 1 3 4 4 2 9 8 3 9 5 5 1 8 10 7 7;

solve;
for{i in 1..paczki}{for{j in 1..paczki} printf "%s", if kamery[i,j]==1 then " c " else if (i,j) in Paczki then  " P " else " . "; printf "\n";}
end;