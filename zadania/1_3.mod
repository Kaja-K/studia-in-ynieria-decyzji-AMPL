# Czyszcenie pamięci AMPL
reset;

# Zmienne decyzyjne
var x1 >= 0;   # Ilość indyków typu 1
var x2 >= 0;   # Ilość indyków typu 2
var y1 >= 0;   # Ilość kotletów typu I
var y2 >= 0;   # Ilość kotletów typu II

# Funkcja celu do zmaxymalizowania
maximize Zysk:
    8 * y1 + 6 * y2 - (10 * x1 + 8 * x2);

# Ograniczenia
subject to
O_max_I: y1 <= 50;
O_max_II: y2 <= 30;
O_bialy: 3 * x1 + 1.5 * x2 >= 0.7 * (y1 + y2);
O_ciemny: 2 * x1 + 4 * x2 >= 0.5 * (y1 + y2);

# Rozwiązanie
solve;

# Wyświetlenie wyników
display x1, x2, y1, y2, Zysk;


end;

# Wynik: x1 = 18.2222, x2 = 0.888889, y1 = 50, y2 = 30, Zysk = 390.667