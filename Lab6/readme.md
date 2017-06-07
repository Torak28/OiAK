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

### Control Word

Idea Control worda to ustawienie precyzji obliczeń i sposobu zaokrąglania.

Precyzje określają bity 8 i 9. '00' oznacza Pojedynczą,'10' Podwójną, a '11' Rozszerzoną:

```
Zaczynam z: 1111 1111 1111 1111 = 65535

	Chce pojedyncza precyzje, czyli 1111 1100 1111 1111
	Robie teraz AND mojej liczby z 0xFcFF i otrzymuje: 1111 1100 1111 1111
	Brawo

Zaczynam z: 1111 0011 1111 1111 = 62463

	Chce pojedyncza precyzje, czyli 1111 0000 1111 1111
	Robie teraz AND mojej liczby z 0xFcFF i otrzymuje: 1111 0000 1111 1111
	Brawo

Zaczynam z: 1111 1111 1111 1111 = 65535

	Chce podwójną precyzję, czyli 1111 1110 1111 1111
	Robie teraz AND mojej liczby z 0xFcFF i otrzymuje: 1111 1100 1111 1111
	Robie XOR wyniku z 0x200 i otrzymuje 1111 1110 1111 1111
	Brawo

Zaczynam z: 1111 0011 1111 1111 = 62463

	Chce podwójną precyzje, czyli 1111 0010 1111 1111
	Robie teraz AND mojej liczby z 0xFcFF i otrzymuje: 1111 0000 1111 1111
	Robie XOR wyniku z 0x200 i otrzymuje 1111 0010 1111 1111
	Brawo
```	
	
Tryb zaokrąglania ustala się w 10 i 11 bicie. I tak '00' to nearest even, '01' to w dół, '10' to w górę, a '11' to do zera
```
Zaczynam z: 1111 1111 1111 1111 = 65535

	Chce zaokraglenie do najblizszej, czyli 1111 0011 1111 1111
	Robie teraz AND mojej liczby z 0xF3FF i otrzymuje: 1111 0011 1111 1111
	Brawo

	Chce zaokraglenie do zera, czyli 1111 1111 1111 1111
	Robie teraz OR mojej liczby z 0x0C00 i otrzymuje: 1111 0011 1111 1111
	Brawo

	Chce zaokraglenie do góry, czyli 1111 1011 1111 1111
	Robie teraz OR mojej liczby z 0x0800   i otrzymuje: 1111 1111 1111 1111(ten Or ma racje bytu jak jest inne zaokraglenie niz zero)
	Robie teraz ANDw yniku z 0xFBFF i otrzymuje: 1111 1011 1111 1111
	Brawo

	Chce zaokraglenie do dołu, czyli 1111 0111 1111 1111
	Robie teraz OR mojej liczby z 0x0400   i otrzymuje: 1111 1111 1111 1111(ten Or ma racje bytu jak jest inne zaokraglenie niz zero)
	Robie teraz AND wyniku z 0xF7FF i otrzymuje: 1111 0111 1111 1111
	Brawo
```



