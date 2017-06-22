def FA(A, B, C):
    Cu = 0
    Su = 0
    if(A == 0 and B == 0 and C == 0):
        Cu = 0
        Su = 0
    elif(A == 0 and B == 0 and C == 1):
        Cu = 0
        Su = 1
    elif (A == 0 and B == 1 and C == 0):
        Cu = 0
        Su = 1
    elif (A == 0 and B == 1 and C == 1):
        Cu = 1
        Su = 0
    elif (A == 1 and B == 0 and C == 0):
        Cu = 0
        Su = 1
    elif (A == 1 and B == 0 and C == 1):
        Cu = 1
        Su = 0
    elif (A == 1 and B == 1 and C == 0):
        Cu = 1
        Su = 0
    elif (A == 1 and B == 1 and C == 1):
        Cu = 1
        Su = 1
    return Su, Cu

def CSA(l1, l2, l3):
    wynikS = []
    wynikC = []
    przeniesienie = 0
    wynikC.append(0)
    for i in range (15, -1, -1):
        wS,wC = FA(l1[i], l2[i], l3[i])
        wynikS.append(wS)
        wynikC.append(wC)
    wynikC.reverse()
    wynikS.reverse()
    if(wynikC[0] == 1):
        przeniesienie = 1
    wynikC.pop(0)
    return wynikS, wynikC, przeniesienie

def KC(i):
    wynik = [int(i) for i in str(bin(i * 2551))[2:]]
    wynik.reverse()
    roznica = 16 - len(wynik)
    if(roznica != 0):
        for i in range(0,roznica):
            wynik.append(0)
    wynik.reverse()
    return wynik

def CSAtree(l1,l2,l3,l4,l5):
    s1, c1, p1 = CSA(l1,l2,l3)
    print "CSA1:\nS1:",s1,"\nC1:",c1,"\np1:",p1,"\n"
    s2, c2, p2 = CSA(s1,c1,l4)
    print "CSA2:\nS2:", s2, "\nC2:", c2, "\np2:", p2, "\n"
    s3, c3, p3 = CSA(s2,c2,l5)
    print "CSA3:\nS3:", s3, "\nC3:", c3, "\np3:", p3, "\n"
    p = p1 + p2 + p3
    print "P po calosci:",p,"\n"
    kc = KC(p)
    print "Kc:",kc,"\n"
    return s3,c3,kc

def KSA(l1,l2):
    print "KSA_in:\nl1:",l1,"\nl2:",l2,"\n"
    liczba1 = str(l1).replace(",","").replace("[","").replace("]","").replace(" ","")
    liczba2 = str(l2).replace(",","").replace("[","").replace("]","").replace(" ","")
    wartosc1 = int(liczba1, 2)
    wartosc2 = int(liczba2, 2)
    wynik = wartosc1 + wartosc2
    print "KSA_out:\nwynik:", [int(i) for i in str(bin(wynik))[2:]], "\n"
    return [int(i) for i in str(bin(wynik))[2:]]

def uklad(l1,l2,l3,l4,l5):
    s3,c3,kc = CSAtree(l1,l2,l3,l4,l5)
    S, C, P = CSA(s3,c3,kc)
    S.reverse()
    C.reverse()
    S.append(0)
    C.append(P)
    S.reverse()
    C.reverse()
    wynik = KSA(S,C)
    return int(str(wynik).replace(",","").replace("[","").replace("]","").replace(" ",""),2),str(wynik).replace(",","").replace("[","").replace("]","").replace(" ",""), len(str(wynik).replace(",","").replace("[","").replace("]","").replace(" ",""))

def GenBin(l1):
    wynik = [int(i) for i in str(bin(l1))[2:]]
    wynik.reverse()
    roznica = 16 - len(wynik)
    if (roznica != 0):
        for i in range(0, roznica):
            wynik.append(0)
    wynik.reverse()
    return wynik

def GenV():
    for i1 in range(0,256):
        print i1
        for i2 in range(0,15):
            for i3 in range(0,17):
                for i4 in range(0,13):
                    for i5 in range(0,19):
                        v1 = GenBin(i1*14024 % 62985)
                        v3 = GenBin(i2*58786 % 62985)
                        v2 = GenBin(i3*59280 % 62985)
                        v4 = GenBin(i4*43605 % 62985)
                        v5 = GenBin(i5*13260 % 62985)
                        norm, bin, len = uklad(v1,v2,v3,v4,v5)
                        if(len >= 18):
                            print "Dziesietnie:", norm, "\nBinarnie:", bin, "\nDlugosc:", len, "\nBaza: <",i1,i2,i3,i4,i5,">\n"

v1 = GenBin(82 * 14024 % 62985)
v3 = GenBin(2 * 58786 % 62985)
v2 = GenBin(6 * 59280 % 62985)
v4 = GenBin(4 * 43605 % 62985)
v5 = GenBin(7 * 13260 % 62985)
print "v1:",v1,"\nv2:",v2,"\nv3:",v3,"\nv4:",v4,"\nv5:",v5,"\n"
norm, bin, len = uklad(v1,v2,v3,v4,v5)
print "Dziesietnie:", norm, "\nBinarnie:", bin, "\nDlugosc:", len, "\nBaza: <82,2,6,4,7>\n"
