option solver cplex;
reset;

# Parametry
param lata;  # Liczba lat (okresów czasu)
set inw;  # Zbiór typów inwestycji
param opr{inw};  # Stopa oprocentowania dla każdego typu inwestycji
param zwr{1..lata, 2..lata, inw} default 0; # Macierz zwrotów inwestycji
param p_kasa; # Początkowa ilość pieniędzy dostępnych na inwestycje

# Zmienne Decyzyjne
# i_inw[rok, typ inwestycji] reprezentuje kwotę zainwestowaną w danym roku w dany typ inwestycji
var i_inw{1..(lata - 1), inw} >= 0;
# mamy[rok] reprezentuje ilość pieniędzy dostępnych na początku każdego roku
var mamy{2..lata} >= 0;

# Funkcja celu - Maksymalizacja ilości pieniędzy na końcu ostatniego roku
maximize kasa_koncowa: mamy[lata];

# Ograniczenia
# Zapewnia, że początkowa ilość pieniędzy jest równa sumie inwestycji dokonanych w pierwszym roku
o_poczatkowa_inwestycja: p_kasa = sum{i in inw} i_inw[1, i];
# Zapewnia, że ilość pieniędzy dostępnych na początku każdego roku (oprócz ostatniego) jest równa sumie inwestycji dokonanych w danym roku
o_ile_inwestycja {k in 2..(lata - 1)}: mamy[k] = sum{i in inw} i_inw[k, i];
# Zapewnia, że ilość pieniędzy dostępnych na początku każdego roku jest sumą zwrotów ze wszystkich inwestycji dokonanych w poprzednich latach
o_zwr_inwestycji {k in 2..lata}: mamy[k] = sum{i in inw, p in 1..(k - 1)} i_inw[p, i] * opr[i] * zwr[p, k, i];

data;
param lata := 6;
set inw := "lok1R" "lok2R" "obl3R";
param opr := "lok1R" 1.08 "lok2R" 1.17 "obl3R" 1.27;
param p_kasa = 20000;
param zwr :=
    [1, 2, "lok1R"] 1
    [2, 3, "lok1R"] 1
    [3, 4, "lok1R"] 1
    [4, 5, "lok1R"] 1
    [5, 6, "lok1R"] 1
    [1, 3, "lok2R"] 1
    [2, 4, "lok2R"] 1
    [3, 5, "lok2R"] 1
    [4, 6, "lok2R"] 1
    [3, 6, "obl3R"] 1;


solve;
display kasa_koncowa, i_inw, mamy;
end;