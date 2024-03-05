# Czyszcenie pamięci AMPL
reset;

# Definicja zmiennych decyzyjnych
var x >= 0, <= 20;  # Liczba telewizorów 27 calowych
var y >= 0, <= 40;  # Liczba telewizorów 20 calowych

# Funkcja celu do zmaxymalizowania
maximize Zysk: 120*x + 80*y;

# Ograniczenia
subject to 
O_27cal: x <= 20;        		 	# Ograniczenie sprzedaży telewizorów 27 calowych
O_20cal: y <= 40;         			# Ograniczenie sprzedaży telewizorów 20 calowych
Godziny: 20*x + 10*y <= 500;  		# Ograniczenie dostępnych godzin roboczych

solve;

# Wyświetlenie wyników
display x, y, Zysk;

end;

# Wynik: x = 5, y = 40, Zysk = 3800
