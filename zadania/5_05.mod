option solver cplex;
reset;

# Parametry
set wierzcholki; # Zbiór wierzchołków
set krawedzie within wierzcholki cross wierzcholki; # Zbiór krawędzi
param n:= card(wierzcholki); # Liczba wierzchołków

# Zmienna decyzyjna - Binarna 1 jeśli wierzchołek i należy do kliki, 0 w przeciwnym razie
var klika{wierzcholki} binary; 

# Funkcja celu - Maksymalizacja rozmiaru kliki
maximize rozmiar_klika: sum{pw in wierzcholki} klika[pw];

# Ograniczenie - Każda para wierzchołków w klice musi być połączona krawędzią (znajomość między nimi)
o_istnienie_kliki{(pw,kw) in wierzcholki cross wierzcholki: pw < kw}: klika[pw] + klika[kw] <= 1 + (if (pw, kw) in krawedzie then 1 else 0) * klika[pw] * klika[kw];

data;
set wierzcholki := 1 2 3 4 5 6 7 8;
set krawedzie := (1,2) (1,3) (1,4) (2,3) (2,4) (2,6) (2,8) (3,4) (3,5) (4,5) (4,7) (5,7) (5,8) (6,7);

solve;
display rozmiar_klika, klika;
end;