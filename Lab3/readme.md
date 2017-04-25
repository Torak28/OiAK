# Lab 3

### Makefile
+ **make HexToBin** ostatnia wersja jaka zrobilem
+ **make v1** pierwszy etap dla zadanej liczby, litery bez sprawdzania pokazuje jego binarke
+ **make v2** drugi etap sprawdzam czy dane liczby sa w zakresie i je zamieniam na binarke, problem jest taki ze wynik przechowuje odwrotnie i powinnienem go obrocic


1. Dostaje od użytkownika jakiś ciąg znaków o nieznanej długości
2. wyławiam z niego liczby od 0-9 i A-F i wrzucam do pamięci
3. Zamieniam na binarkę i trzymam w 8 bitowych miejscach w pamięci
4. Całość wkładam do RAX. Przez całość mam na myśli 8 8 bitowych liczb
5. Mnoże razy dwa i pamiętając o przeniesieniu wypisuje wynik

   **ProTip:** tzn co do pkt 3 to z bitu znaku bierzesz 4 bity i upychasz w buforze
i ja na koniec dodalem rax do rax

