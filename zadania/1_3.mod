# Czyszcenie pamięci AMPL
reset;

# Parametry
param cena_I := 8;          # Cena kotletu typu I ($/kg)
param cena_II := 6;         # Cena kotletu typu II ($/kg)
param max_I := 50;          # Maksymalna ilość kotletów typu I (kg)
param max_II := 30;         # Maksymalna ilość kotletów typu II (kg)
param sklad_bialy1 := 3;    # Skład mięsa białego w indyku typu 1 (kg/biała sztuka indyka)
param sklad_ciemny1 := 2;   # Skład mięsa ciemnego w indyku typu 1 (kg/ciemna sztuka indyka)
param sklad_bialy2 := 1.5;  # Skład mięsa białego w indyku typu 2 (kg/biała sztuka indyka)
param sklad_ciemny2 := 4;   # Skład mięsa ciemnego w indyku typu 2 (kg/ciemna sztuka indyka)

# Zmienne decyzyjne
var x1 >= 0;   # Ilość indyków typu 1
var x2 >= 0;   # Ilość indyków typu 2
var y1 >= 0;   # Ilość kotletów typu I
var y2 >= 0;   # Ilość kotletów typu II

# Funkcja celu do zmaxymalizowania
maximize Zysk:
    cena_I * y1 + cena_II * y2 - (10 * x1 + 8 * x2);

# Ograniczenia
subject to
Ograniczenie_max_I: y1 <= max_I;
Ograniczenie_max_II: y2 <= max_II;
Ograniczenie_bialy: sklad_bialy1 * x1 + sklad_bialy2 * x2 >= 0.7 * (y1 + y2);
Ograniczenie_ciemny: sklad_ciemny1 * x1 + sklad_ciemny2 * x2 >= 0.5 * (y1 + y2);

# Rozwiązanie
solve;

# Wyświetlenie wyników
display x1, x2, y1, y2, Zysk;


end;

# Wynik: x1 = 18.2222, x2 = 0.888889, y1 = 50, y2 = 30, Zysk = 390.667