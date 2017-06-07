# Zmienny przecinek

### Idea

 * 8 80-bitowych rejestrów zmiennoprzecinkowych
 * 3 16-bitowe rejestry kontrolne(control word, status word i tag word)
 * Całość połączona w stos

Rozkaz **fld** wpisuje liczbę do *ST(0)* a ta która się tam znajdowała wcześniej przechodzi dalej na *ST(1)*. Analogicznie wykonane jest pobieranie wartości.

### Rozkazy

| Rozkaz | Opis |
| --- | --- |
| fld REJESTR_ST | Ładuje zawartość innego podanego rejestru ST do ST(0) i przesuwa numerację wszystkich rejestrów, włącznie z tym z którego pobierana jest wartość, w górę |
| fldl ZMIENNA/ADRES | Podobnie jak poprzednio jednak ładowany jest float lub double z pamięci określonej przez etykietę zmiennej lub adres w rejestrze (wtedy mnemonik rejestru należy umieścić w nawiasie) |
| fld1 | Do ST(0) ładowana jest stała 1.0, a pozostałe rejestry są „przesuwane” |
| fldz | Do ST(0) ładowana jest stała 0.0, a pozostałe rejestry są „przesuwane” |
| fldpi | Do ST(0) ładowana jestliczba PI (3.1415926), a pozostałe rejestry są „przesuwane” |
| fst REJESTR_ST | Wartość z rejestru ST(0) jest umieszczana w innym rejestrze ST. Numeracja rejestrów nie ulega zmianie |
| fstp REJESTR_ST lub nic | Wartość z rejestru ST(0) jest kopiowana do innego podanego rejestru lub tracona, następnie wszystkie rejestry zmieniają swoją numerację (1->0, 2->1 itd.) |
| fstpl ZMIENNA/ADRES | Wartość z rejestru ST(0) kopiowana jest do zmiennej lub do pamięci pod adres sprecyzowany w innym rejestrze ogólnego przeznaczenia podanym w nawiasie. Numeracja rejestrów zmienia się jak poprzednio |
| fxch REJESTR_ST | Zawartości rejestru ST(0) i innego podanego jako operand rozkazu są wymieniane |
| fabs | Oblicza wartość bezwzględną z liczby w ST(0) i zapisuje ją do ST(0) |
| fadd CEL, ŹRÓDŁO | Dodaje zawartość ŹRÓDŁO do CEL i zapisuje wynik do CEL. ŹRÓDŁO i CEL to mnemoniki rejestrów ST |
| faddl ZMIENNA/ADRES | Dodaje do ST(0), liczbę z pamięci |
| fsub CEL, ŹRÓDŁO | Odejmuje zawartość ŹRÓDŁO od CEL i zapisuje wynik do CEL. ŹRÓDŁO i CEL to mnemoniki rejestrów ST |
| fsubl ZMIENNA/ADRES | Odejmuje liczbę z pamięci od ST(0) |
| fmul CEL, ŹRÓDŁO | Mnoży zawartość CEL przez ŹRÓDŁO i zapisuje wynik do CEL. ŹRÓDŁO i CEL to mnemoniki rejestrów ST |
| fmull ZMIENNA/ADRES | Mnoży zawartość ST(0) przez liczbę z pamięci |
| fdiv CEL, ŹRÓDŁO | Dzieli zawartość CEL przez ŹRÓDŁO i zapisuje wynik do CEL. ŹRÓDŁO i CEL to mnemoniki rejestrów ST |
| fdivl |ZMIENNA/ADRES 	Dzieli zawartość ST(0) przez liczbę z pamięci |
| fsqrt | Oblicza pierwiastek z liczby zapisanej w ST(0) i zapisuje wynik do ST(0) |

xd



