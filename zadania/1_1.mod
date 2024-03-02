# Czyszcenie pamięci AMPL
reset;

# Definicja zmiennych decyzyjnych
var x >= 0, <= 20;  # Liczba telewizorów 27 calowych
var y >= 0, <= 40;  # Liczba telewizorów 20 calowych

# Funkcja celu do zmaxymalizowania
maximize Profit: 120*x + 80*y;

# Ograniczenia
subject to 
Limit27: x <= 20;        		 	# Ograniczenie sprzedaży telewizorów 27 calowych
Limit20: y <= 40;         			# Ograniczenie sprzedaży telewizorów 20 calowych
LaborHours: 20*x + 10*y <= 500;  	# Ograniczenie dostępnych roboczogodzin

solve;

# Wyświetlenie wyników
display x, y, Profit;

end;

# Wynik: x = 5, y = 40, Profit = 3800