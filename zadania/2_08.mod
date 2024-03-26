option solver cplex;
reset;

# Deklaracja parametrów
param maks_popyt_82_normalna >= 0;      # Maksymalny popyt na benzynę 82 w typie normalna
param maks_popyt_98_normalna >= 0;      # Maksymalny popyt na benzynę 98 w typie normalna
param maks_popyt_82_premium >= 0;       # Maksymalny popyt na benzynę 82 w typie premium
param maks_popyt_98_premium >= 0;       # Maksymalny popyt na benzynę 98 w typie premium
param maks_popyt_82_super >= 0;         # Maksymalny popyt na benzynę 82 w typie super
param maks_popyt_98_super >= 0;         # Maksymalny popyt na benzynę 98 w typie super
param cena_82;                          # Cena benzyny 82
param cena_98;                          # Cena benzyny 98
param minimalne_zuzycie_82_normalna;    # Minimalne zużycie benzyny 82 w typie normalna
param minimalne_zuzycie_98_normalna;    # Minimalne zużycie benzyny 98 w typie normalna
param minimalne_zuzycie_82_premium;     # Minimalne zużycie benzyny 82 w typie premium
param minimalne_zuzycie_98_premium;     # Minimalne zużycie benzyny 98 w typie premium
param minimalne_zuzycie_82_super;       # Minimalne zużycie benzyny 82 w typie super
param minimalne_zuzycie_98_super;       # Minimalne zużycie benzyny 98 w typie super
param maks_dzienny_popyt;               # Maksymalny dzienny popyt na benzynę
param maks_przetwarzania_98;            # Maksymalna ilość benzyny 98 do przetworzenia

# Zmienne decyzyjne
var x_82{1..3} >= 0;    # Ilość 82 w danym typie benzyny
var x_98{1..3} >= 0;    # Ilość 98 w danym typie benzyny

# Funkcja celu - maksymalizacja całkowitego zysku
maximize zysk: cena_82 * (x_82[1] + x_98[1]) + cena_82 * (x_82[2] + x_98[2]) + cena_82 * (x_82[3] + x_98[3]);

# Ograniczenia
subject to 
o_popyt87: x_82[1] + x_98[1] <= maks_popyt_82_normalna + maks_popyt_98_normalna; 					# Popyt 87
o_popyt89: x_82[2] + x_98[2] <= maks_popyt_82_premium + maks_popyt_98_premium;	 					# Popyt 89 
o_popyt92: x_82[3] + x_98[3] <= maks_popyt_82_super + maks_popyt_98_super;							# Popyt 92
o_min87: (82 * x_82[1] + 98 * x_98[1]) >= 87 * (x_82[1] + x_98[1]);									# Minimalna 87
o_min89: (82 * x_82[2] + 98 * x_98[2]) >= 89 * (x_82[2] + x_98[2]);									# Minimalna 89		
o_min92: (82 * x_82[3] + 98 * x_98[3]) >= 92 * (x_82[3] + x_98[3]);									# Minimalna 92
o_dz: 5 * (x_82[1] + x_82[2] + x_82[3]) + 10 * (x_98[1] + x_98[2] + x_98[3]) <= maks_dzienny_popyt; # Mksymalnie w dniu
o_przetwarzania: 2 * (x_98[1] + x_98[2] + x_98[3]) <= maks_przetwarzania_98;						# Maks przetwarzanie

data;
param maks_popyt_82_normalna := 50000;      
param maks_popyt_98_normalna := 50000;    
param maks_popyt_82_premium := 30000;  
param maks_popyt_98_premium := 30000;  
param maks_popyt_82_super := 40000;
param maks_popyt_98_super := 40000;  
param cena_82 := 6.7;             
param cena_98 := 9.2;
param minimalne_zuzycie_82_normalna := 87; 
param minimalne_zuzycie_98_normalna := 87;
param minimalne_zuzycie_82_premium := 89; 
param minimalne_zuzycie_98_premium := 89; 
param minimalne_zuzycie_82_super := 92; 
param minimalne_zuzycie_98_super := 92;
param maks_dzienny_popyt := 1500000; 
param maks_przetwarzania_98 := 200000;

solve;

display x_82,x_98, zysk;
# Wynik::    x_82      x_98  
#		1   68750     31250
#		2   33750     26250
#		3   19038.5   31730.8

# Zysk = 1412150

end;


