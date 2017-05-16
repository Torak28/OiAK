beta = 4
K1 = 0
K2 = 0
K3 = 0
for k1 in range(-20, 20):
    rns = [15,16,17]
    k11 = rns[1] % rns[0]
    k12 = rns[2] % rns[0]
    wynik1 = (k1 * k11 * k12) % rns[0]
    if(wynik1 == 1):
        K1 = k1
        for k2 in range(-20, 20):
            k21 = rns[0] % rns[1]
            k22 = rns[2] % rns[1]
            wynik2 = (k2 * k21 * k22) % rns[1]
            if (wynik2 == 1):
                K2 = k2
                for k3 in range(-20, 20):
                    k31 = rns[0] % rns[2]
                    k32 = rns[1] % rns[2]
                    wynik3 = (k3 * k31 * k32 ) % rns[2]
                    if(wynik3 == 1):
                        K3 = k3
                        print "k1:",K1,"k2:", K2,"k3:", K3
                        set = [2,2,3]
                        m = [ rns[1] * rns[2],
                              rns[0] * rns[2],
                              rns[0] * rns[1]]
                        X = (K1 * set[0] * m[0] +
                             K2 * set[1] * m[1] +
                             K3 * set[2] * m[2]) % (rns[0] * rns[1] * rns[2])
                        print "m:", m
                        print "X", X
                        print "----------"

# k1: 8 k2: -1 k3: 9
# m: [272, 255, 240]
# X 2162