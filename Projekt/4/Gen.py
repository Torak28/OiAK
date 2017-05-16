beta = 4
K1 = 0
K2 = 0
K3 = 0
K4 = 0
K5 = 0
mini = -10
maxi = 60
iterator = 0
open("wynik.txt", 'w').close()
for n in range(beta, 10):
    for k in range(mini, maxi):
        rns = [(pow(2,n))-k,(pow(2,n))+k,(pow(2,n))+1,(pow(2,n))-1,(pow(2,n+beta))]
        for k1   in range(mini, maxi):
            if(rns[0] != 0):
                k11 = rns[1] % rns[0]
                k12 = rns[2] % rns[0]
                k13 = rns[3] % rns[0]
                k14 = rns[4] % rns[0]
                wynik1 = (k1 * k11 * k12 * k13 * k14) % rns[0]

                if(wynik1 == 1):
                    K1 = k1
                    #print "1"
                    for k2 in range(mini, maxi):
                        k21 = rns[0] % rns[1]
                        k22 = rns[2] % rns[1]
                        k23 = rns[3] % rns[1]
                        k24 = rns[4] % rns[1]
                        wynik2 = (k2 * k21 * k22 * k23 * k24) % rns[1]

                        if(wynik2 == 1):
                            K2 = k2
                            #print "2"
                            for k3 in range(mini, maxi):
                                k31 = rns[0] % rns[2]
                                k32 = rns[1] % rns[2]
                                k33 = rns[3] % rns[2]
                                k34 = rns[4] % rns[2]
                                wynik3 = (k3 * k31 * k32 * k33 * k34) % rns[2]

                                if(wynik3 == 1):
                                    K3 = k3
                                    #print "3"
                                    for k4 in range(mini, maxi):
                                        k41 = rns[0] % rns[3]
                                        k42 = rns[1] % rns[3]
                                        k43 = rns[2] % rns[3]
                                        k44 = rns[4] % rns[3]
                                        wynik4 = (k4 * k41 * k42 * k43 * k44) % rns[3]

                                        if(wynik4 == 1):
                                            K4 = k4
                                            #print "4"
                                            for k5 in range(mini, maxi):
                                                k51 = rns[0] % rns[4]
                                                k52 = rns[1] % rns[4]
                                                k53 = rns[2] % rns[4]
                                                k54 = rns[3] % rns[4]
                                                wynik5 = (k5 * k51 * k52 * k53 * k54) % rns[4]

                                                if(wynik5 == 1):
                                                    K5 = k5
                                                    iterator += 1
                                                    set = [2, 2, 2, 2, 3]
                                                    m = [rns[1] * rns[2] * rns[3] * rns[4],
                                                         rns[0] * rns[2] * rns[3] * rns[4],
                                                         rns[0] * rns[1] * rns[3] * rns[4],
                                                         rns[0] * rns[1] * rns[2] * rns[4],
                                                         rns[0] * rns[1] * rns[2] * rns[3]]
                                                    X = (K1 * set[0] * m[0] +
                                                         K2 * set[1] * m[1] +
                                                         K3 * set[2] * m[2] +
                                                         K4 * set[3] * m[3] +
                                                         K5 * set[4] * m[4]) % (rns[0] * rns[1] * rns[2] * rns[3] * rns[4])
                                                    target = open("wynik.txt", 'a')
                                                    output = "{0} : \nrns: {1}\nset: {2}\nk1: {3} k2: {4} k3: {5} k4: {6} k5: {7}\n" \
                                                             "m: {8}\nX: {9}\nn: {10}\nk: {11}\n-------------\n".format(iterator, rns, set, K1, K2, K3, K4, K5, m, X, n, k)
                                                    target.write(output)
                                                    target.close()


# 16 :
# rns: [11, 5, 9, 7, 128]
# set: [2, 2, 2, 2, 3]
# k1: -2 k2: -6 k3: 2 k4: 26 k5: 57
# m: [40320, 88704, 49280, 63360, 3465]
# X: 197507
# n: 3
# k: -3