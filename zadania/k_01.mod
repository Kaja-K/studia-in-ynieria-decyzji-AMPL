# Użycie solvera CPLEX do optymalizacji
option solver cplex;
reset;

# Parametry
set pasza;  # Zbiór typów paszy
param cena_paszy{pasza};  # Cena sprzedaży każdej jednostki paszy
set skladnik;  # Zbiór typów składników
param cena_skladnika{skladnik};  # Cena zakupu każdej jednostki składnika
param limit{skladnik};  # Maksymalna dostępna ilość każdego składnika
param wymagania{pasza, skladnik};  # Proporcje składników wymagane do produkcji jednostki każdej paszy

# Zmienne Decyzyjne
# Ilość produkowanej paszy każdego typu
var ilosc_paszy{i in pasza} >= 0;  
# Ilość zużywanego każdego składnika
var ilosc_skladnika{i in skladnik} >= 0;  

# Funkcja celu: maksymalizacja zysku. Zysk = (przychód ze sprzedaży paszy) - (koszt zakupu składników)
maximize zysk: (sum {i in pasza} ilosc_paszy[i] * cena_paszy[i]) - (sum {j in skladnik} ilosc_skladnika[j] * cena_skladnika[j]);

# Ograniczenia
# Suma ilości paszy musi być równa sumie ilości składników
o_skladnikow: sum {p in pasza} ilosc_paszy[p] = sum {s in skladnik} ilosc_skladnika[s];
# Ograniczenie dotyczące maksymalnej ilości dostępnych składników
o_limit {s in skladnik}: ilosc_skladnika[s] <= limit[s];
# Ograniczenie dotyczące proporcji składników w paszy
o_wymagania_paszy {s in skladnik}: ilosc_skladnika[s] >= sum {p in pasza} ilosc_paszy[p] * wymagania[p, s];

data;
set pasza := "Typ A" "Typ B";
param cena_paszy :=
    "Typ A" 1300
    "Typ B" 1500;
set skladnik := "Typ S1" "Typ S2";
param: cena_skladnika limit :=
    "Typ S1" 500 1000
    "Typ S2" 400 800;
param wymagania: "Typ S1" "Typ S2" :=
    "Typ A" 0 0.8
    "Typ B" 0.6 0;

solve;
display zysk, ilosc_paszy, ilosc_skladnika;
end;