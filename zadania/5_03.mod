option solver cplex;
reset;

# Parametry
set Czynnosci; 										# Zbiór wszystkich czynności   N
param CzasTrwania{Czynnosci}; 						# Czas trwania każdej czynności   t{N};
param KosztSkrócenia{Czynnosci} >= 0; 				# Koszt skrócenia każdej czynności   c{N};
param CzasMin{Czynnosci} >= 0; 						# Minimalny czas trwania każdej czynności  tmin{N}
param MaxCzas; 										# Zadany maksymalny czas trwania projektu  T;
set precedencja within Czynnosci cross Czynnosci; 	# Relacja precedencji

# Zmienna decyzyjna - Liczba jednostek czasu, o które należy skrócić czas trwania każdej czynności
var SkrtCzasu{Czynnosci} >= 0;
var SkrtIlości{Czynnosci} >= 0;

# Funkcja celu - Minimalizacja kosztu całkowitego skrócenia projektu
minimize KosztSkróceniaRazem: sum {i in Czynnosci} KosztSkrócenia[i] * SkrtCzasu[i];

#Ogranioczenia
c1{(i,j) in precedencja}: SkrtIlości[j]>=SkrtIlości[i]+CzasTrwania[i]-SkrtCzasu[i];
c2{i in Czynnosci}: SkrtIlości[i]+KosztSkrócenia[i]-SkrtCzasu[i]<=MaxCzas;
c3{i in Czynnosci}: KosztSkrócenia[i]-SkrtCzasu[i]>=CzasMin[i];

# Dane
data;
set Czynnosci := A B C D E F G;
param CzasTrwania := A 2 B 4 C 5 D 6 E 3 F 4 G 4;
param KosztSkrócenia := A 1 B 2 C 1 D 2 E 5 F 4 G 1;
param CzasMin := A 1 B 2 C 3 D 1 E 1 F 2 G 3;
param MaxCzas := 50;
set precedencja :=(A, B) (A, C) (B, D) (C, E) (C, F) (D, F) (E, G) (F, G);

solve;
display KosztSkróceniaRazem, SkrtCzasu, SkrtIlości;
# Wynik:  KosztSkróceniaRazem = 0
# SkrtCzasu SkrtIlości 
# A      0          0
# B      0          0
# C      0          0
# D      0          0
# E      0          0
# F      0          0
# G      0          0

end;
