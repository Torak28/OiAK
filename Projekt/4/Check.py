from math import floor

R = [2, 2, 2, 2, 3]
RNS = [11, 5, 9, 7, 128]

k = [-2, -6, 2, 26, 57]
m_daszek = [40320, 88704, 49280, 63360, 3465]
# Wyliczone na pdst. RNS
# gp > m1 = 5*9*7*128
# %62 = 40320
# gp > m2 = 11*9*7*128
# %63 = 88704
# gp > m3 = 11*5*7*128
# %64 = 49280
# gp > m4 = 11*5*9*128
# %65 = 63360
# gp > m5 = 11*5*9*7
# %66 = 3465
V = [32989, 53222, 10951, 45257, 1543]
# Wyliczone na pdst. m
# gp > Om1 = Mod((m1)^(-1),11)
# %67 = Mod(9, 11)
# gp > Om2 = Mod((m2)^(-1),5)
# %68 = Mod(3, 5)
# gp > Om3 = Mod((m3)^(-1),9)
# %69 = Mod(2, 9)
# gp > Om4 = Mod((m4)^(-1),7)
# %70 = Mod(5, 7)
# gp > Om5 = Mod((m5)^(-1),128)
# %71 = Mod(57, 128)

# I Odwrotnosci multipilikatywnej
# gp > V1 = floor(9 * m1 / 11)
# %76 = 32989
# gp > V2 = floor(3 * m2 / 5)
# %77 = 53222
# gp > V3 = floor(2 * m3 / 9)
# %78 = 10951
# gp > V4 = floor(5 * m4 / 7)
# %79 = 45257
# gp > V5 = 5floor(7 * m5 / 128)
# %80 = 1543

prawa = V[0] * R[0] + V[1] * R[1] +\
        V[2] * R[2] + V[3] * R[3] +\
        V[4] * R[4]

m1 = 11

X = 197507
# gp > chinese(Mod(2,11),(chinese(Mod(2,5),chinese(Mod(2,9),chinese(Mod(2,7),Mod(3,128))))))
# %98 = Mod(197507, 443520)

lewa = floor(X / m1)

print "lewa: ", lewa
print "prawa:", prawa % m1

set = [X % RNS[0],
       X % RNS[1],
       X % RNS[2],
       X % RNS[3],
       X % RNS[4]]

print "set:", set

if lewa == prawa:
    print "TRUE"
else:
    print "NOPE"